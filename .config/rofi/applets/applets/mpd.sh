#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

style="$($HOME/.config/rofi/applets/applets/style.sh)"

dir="$HOME/.config/rofi/applets/applets/configs/$style"
rofi_command="rofi -theme $dir/mpd.rasi"

# Gets the current status of mpd (for us to parse it later on)
# status="$(mpc status)"
status=$(python ~/.config/rofi/applets/applets/play_pause.py -f '{play_pause}')
# Defines the Play / Pause option content
if [[ $status == "playing" ]]; then
    play_pause=""
else
    play_pause=""
fi
active=""
urgent=""

# Display if repeat mode is on / off
tog_repeat=""
if [[ $status == *"repeat: on"* ]]; then
    active="-a 4"
elif [[ $status == *"repeat: off"* ]]; then
    urgent="-u 4"
else
    tog_repeat=" Parsing error"
fi

# Display if random mode is on / off
tog_random=""
if [[ $status == *"random: on"* ]]; then
    [ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ $status == *"random: off"* ]]; then
    [ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
else
    tog_random=" Parsing error"
fi
stop=""
next=""
previous=""

# Variable passed to rofi
# options="$previous\n$play_pause\n$stop\n$next"


# Get the current playing song
current=$(python ~/.config/rofi/applets/applets/play_pause.py -f '{song}')
# If mpd isn't running it will return an empty string, we don't want to display that
artist=$(python ~/.config/rofi/applets/applets/play_pause.py -f '{artist}')
album=$(python ~/.config/rofi/applets/applets/play_pause.py -f '{album}')

if [[ -z "$current" ]]; then
    current="-"
fi

options="$play_pause $current"

# Spawn the mpd menu with the "Play / Pause" entry selected by default
chosen="$(echo -e "$options" | $rofi_command -p "  $artist | $album" -dmenu -selected-row 1)"
case $chosen in
    $previous)
        # mpc -q prev && notify-send -u low -t 1800 " $(mpc current)"
        ;;
    $play_pause)
        # mpc -q toggle && notify-send -u low -t 1800 " $(mpc current)"
        ;;
    $stop)
        # mpc -q stop
        ;;
    $next)
        # mpc -q next && notify-send -u low -t 1800 " $(mpc current)"
        ;;
esac
