def listen [] {
    let wm = $env.XDG_CURRENT_DESKTOP
    match $wm {
        umbriel => (umbriel subscribe windows)
        _ => (error make "Unspported window manager!")
    }
}

listen | each {|income|
    mkdir ~/.config/umbriel
    let json = $income
    let parseed = $json | from json
    let data = $parseed.data
    let isInHsr = $data | any {|window|
        let class = $window.app_id
        let title = $window.title
        $class == steam_proton and $title == 崩坏：星穹铁道
    }
    let payload = {
        input: {
            touchpad: {
                disable_while_typing: (not $isInHsr)
            }
        }
    }
    $payload | save -f ~/.config/umbriel/disable-dwt-in-hsr.toml
}