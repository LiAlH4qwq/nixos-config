def throw-unknown-wm [] { error make "Unspported window manager!" }
def init [] { match $env.XDG_CURRENT_DESKTOP {
    umbriel => (mkdir ~/.config/umbriel)
    niri => (mkdir ~/.config/niri)
    _ => (throw-unknown-wm)
} }
def listen [] { match $env.XDG_CURRENT_DESKTOP {
    umbriel => (umbriel subscribe windows)
    niri => (niri msg -j event-stream)
    _ => (throw-unknown-wm)
} }
def filter-event [] { let income = $in
match $env.XDG_CURRENT_DESKTOP {
    umbriel => ('data' in $income)
    niri => ('WindowFocusChanged' in $income)
    _ => (throw-unknown-wm)
} }
def get-windows [] { let income = $in
match $env.XDG_CURRENT_DESKTOP {
    umbriel => ($income | get data)
    niri => (niri msg -j windows | from json)
    _ => (throw-unknown-wm)
} }
def trans-window [] { let income = $in
match $env.XDG_CURRENT_DESKTOP {
    umbriel => ({
        focused: $income.focused
        class: $income.app_id
        title: $income.title
    })
    niri => ({
        focused: $income.is_focused
        class: $income.app_id
        title: $income.title
    })
    _ => (throw-unknown-wm)
} }
def write-cfg [] { let income = $in
match $env.XDG_CURRENT_DESKTOP {
    umbriel => ({
        input: {
            touchpad: {
                disable_while_typing: ($income)
            }
        }
    } | save -f ~/.config/umbriel/disable-dwt-in-hsr.toml)
    niri => (if $income { "input {\n    touchpad {\n        dwt\n        tap\n        natural-scroll\n    }\n}" } else { '' } | save -f ~/.config/niri/disable-dwt-in-hsr.kdl)
    _ => (throw-unknown-wm)
} }
init
listen | lines -s | each { try { from json } catch { {} } } | where { filter-event } | each { get-windows | each { trans-window } } | each {|windows|
    $windows | any {|window|
        $window.class == steam_proton and $window.title == 崩坏：星穹铁道 and $window.focused == true
    } | not $in
    | write-cfg
    } | ignore
