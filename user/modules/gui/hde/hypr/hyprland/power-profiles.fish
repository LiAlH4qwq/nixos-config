#!/etc/profiles/per-user/lialh4/bin/fish

set cmd "powerprofilesctl"

set cur ($cmd get)

set noti "notify-send" "-t" "1500" "Power Profiles"

if [ $cur = "power-saver" ]
    $cmd set "balanced"
    $noti "Switched to Balanced"
else if [ $cur = "balanced" ]
    $cmd set "performance"
    $noti "Switched to Performance"
else if [ $cur = "performance" ]
    $cmd set "power-saver"
    $noti "Switched to Power Save"
else
    $noti "Unknown current state: $cur"
end