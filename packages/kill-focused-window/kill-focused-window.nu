def throw-unknown-wm [] { error make "Unsupported window manager!" }

def focused-pid [] {
  match ($env.XDG_CURRENT_DESKTOP? | default "") {
    "niri" => (niri msg --json focused-window | from json | get -o pid)
    "umbriel" => (umbriel windows --json | from json | where focused | get -o pid | first)
    _ => (throw-unknown-wm)
  }
}

let pid = (try { focused-pid } catch { null })
if $pid != null and $pid > 0 {
  kill --force $pid
}
