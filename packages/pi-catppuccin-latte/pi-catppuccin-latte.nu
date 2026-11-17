def --wrapped main [...args] {
  let interactive = (is-terminal --stdout)
  if $interactive {
    print -n $"\e]11;#eff1f5\a"
  }
  try {
    ^@pi@ ...$args
  } catch {|err|
    if $interactive {
      print -n "\e]111\a"
    }
    error make $err
  }
  let code = ($env.LAST_EXIT_CODE | into int)
  if $interactive {
    print -n "\e]111\a"
  }
  exit $code
}
