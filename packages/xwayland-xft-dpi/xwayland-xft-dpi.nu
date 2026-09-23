#!/usr/bin/env nu
# xwayland-satellite advertises HiDPI to X clients through XSETTINGS
# (`Xft/DPI`, `Gdk/WindowScalingFactor`), but Xft-based clients -- notably
# fcitx5's XCB candidate window -- size themselves from the `Xft.dpi` X
# resource instead. Mirror the effective output scale into that resource so
# XWayland windows render at the correct size.
def x-ready [] { (^xrdb -query | complete).exit_code == 0 }
def output-scales [] {
  match ($env.XDG_CURRENT_DESKTOP? | default "") {
    "niri" => (
      niri msg -j outputs | from json | values | each {|output| $output.logical?.scale? }
    )
    "umbriel" => (
      umbriel outputs --json | from json | where enabled | each {|output| $output.scale? }
    )
    _ => []
  } | compact
}
mut ready = false
mut tries = 0
while (not $ready) and ($tries < 600) {
  $ready = (x-ready)
  $tries = $tries + 1
  if not $ready { sleep 100ms }
}
if $ready {
  # xwayland-satellite hands every X client the smallest output scale.
  let scale = (try {
    output-scales | math min
  } catch { 1.0 })
  let dpi = (($scale * 96) | math round | into int)
  $"Xft.dpi: ($dpi)\n" | ^xrdb -merge
}
