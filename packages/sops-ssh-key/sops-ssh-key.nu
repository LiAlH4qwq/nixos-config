# Run sops with a passphrase-protected SSH private key.
#
# sops/age reject encrypted SSH private keys, and keeping an unencrypted copy
# around is dangerous. This decrypts a copy in a private temporary directory
# (tmpfs when available), converts it to a native age identity, points
# SOPS_AGE_KEY_FILE at it, runs sops, and removes everything afterwards.
#
# The conversion is required because the `age1...` recipients in .sops.yaml are
# native X25519 keys derived from the SSH key, while sops' SSH identity support
# only handles `ssh-ed25519`/`ssh-rsa` recipient blocks.

def --wrapped main [
  --key (-k): path = "~/.ssh/id_ed25519" # Encrypted SSH private key
  ...args: string # Arguments passed to sops
] {
  let args = if (($args | length) > 0) and (($args | first) == "--") {
    $args | skip 1
  } else {
    $args
  }

  let key = ($key | path expand)
  if not ($key | path exists) {
    error make { msg: $"SSH private key not found: ($key)" }
  }

  let runtime = ($env.XDG_RUNTIME_DIR? | default "/dev/shm")
  let tmpdir = (mktemp -d -p $runtime "sops-ssh-key.XXXXXX")
  let tmpkey = ($tmpdir | path join "id_ed25519")

  try {
    cp $key $tmpkey
    ^@chmod@ 600 $tmpkey

    # ssh-keygen asks for the old passphrase on the terminal and rewrites the
    # copy with an empty one. The passphrase never enters this process.
    ^@ssh-keygen@ -q -p -N "" -f $tmpkey
    if $env.LAST_EXIT_CODE != 0 {
      error make { msg: "Failed to decrypt SSH private key (wrong passphrase?)" }
    }

    let agekey = ($tmpdir | path join "age.key")
    ^@sshToAge@ -private-key -i $tmpkey -o $agekey
    if $env.LAST_EXIT_CODE != 0 {
      error make { msg: "Failed to convert SSH private key to an age identity" }
    }
    rm -f $tmpkey
    ^@chmod@ 600 $agekey

    with-env { SOPS_AGE_KEY_FILE: $agekey } {
      ^@sops@ ...$args
    }
  } catch {|err|
    rm -rf $tmpdir
    error make { msg: $err.msg }
  }

  let code = $env.LAST_EXIT_CODE
  rm -rf $tmpdir
  exit $code
}
