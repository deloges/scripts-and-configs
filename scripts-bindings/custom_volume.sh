#!/bin/sh

# USAGE     ... Volume control using pactl and PulseAudio/PipeWire.
#
#   /$HOME/.config/sway/custom_volume.sh 0      ... Down -10%
#   /$HOME/.config/sway/custom_volume.sh 1      ... Up in non-linear steps

[ "$#" -ne 1 ] && exit 2

current_volume="$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F '[/ %]+' '/Volume:/ {print $4; exit}')"

case $1 in
    0)
        # Down with fixed steps (10% increments).
        # Steps: 100 90 80 ... 0 [%]
        pactl set-sink-volume @DEFAULT_SINK@ -10%
        ;;
    1)
        # Up with smart steps: Smaller steps at lower volume.
        # Steps: 0 1 5 10 15 20 30 40 ... 100 [%]
        case $current_volume in
            0)
                pactl set-sink-volume @DEFAULT_SINK@ 1%
                ;;
            1)
                pactl set-sink-volume @DEFAULT_SINK@ 5%
                ;;
            100)
                exit 0
                ;;
            *)
                # ]1 - 20[
                # [20 - 90]
                # ]90 - 
                if [ "$current_volume" -lt 20 ]; then
                    pactl set-sink-volume @DEFAULT_SINK@ +5%
                elif [ "$current_volume" -le 90 ]; then
                    pactl set-sink-volume @DEFAULT_SINK@ +10%
                else 
                    pactl set-sink-volume @DEFAULT_SINK@ 100%
                fi
                ;;
        esac
        ;;
    *)
        # Invalid argument
        exit 2
        ;;
esac
