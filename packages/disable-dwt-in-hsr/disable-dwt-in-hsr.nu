mkdir ~/.config/umbriel
def listen [] {
    let wm = $env.XDG_CURRENT_DESKTOP
    match $wm {
        umbriel => (umbriel subscribe windows)
        _ => (error make "Unspported window manager!")
    }
}
listen | each {|income|
    $income
    | split row "\n"
    | each {|line| $line | str trim}
    | where {|line| $line != ''}
    | each {|line| try { $line | from json } catch { {} }}
    | where {|obj| 'data' in $obj}
    | each {|obj| $obj.data}
    | each {|data|
        let isInHsr = $data | any {|window|
            $window.app_id == steam_proton and $window.title == 崩坏：星穹铁道 and $window.focused == true
        }
        {
            input: {
                touchpad: {
                    disable_while_typing: (not $isInHsr)
                }
            }
        } | save -f ~/.config/umbriel/disable-dwt-in-hsr.toml
    }
    | ignore
} | ignore
