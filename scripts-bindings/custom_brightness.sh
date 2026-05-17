#!/bin/sh

# USAGE     ... Dynamic brightness adjustment for brightnessctl.
#
#   /$HOME/.config/sway/custom_brightness.sh 0      ... Down -20%
#   /$HOME/.config/sway/custom_brightness.sh 1      ... Up in non-linear steps

[ "$#" -ne 1 ] && exit 2

current_brightness="$(brightnessctl get)"

case $1 in
    0)
        # Down with fixed steps (20% increments).
        brightnessctl set 20%-
        ;;
    1)
        # Up with smart steps: Smaller steps at lower brightness.
        # Steps relativ:    -   -   1   10  20  40  60  80   100  [%]
        # Steps absolut:    0   1   15  152 303 ...     1212 1515 
        # Values are hardcoded for efficiency for internal laptop panel.
        case $current_brightness in
            0)
                brightnessctl set 1
                ;;
            1)
                brightnessctl set 1%
                ;;
            1515)
                exit 0
                ;;
            *)
                # ]1 - 15]
                # ]15 - 303[
                # [303 - 1212]
                # ]1212 -
                if [ "$current_brightness" -le 15 ]; then
                    brightnessctl set 10%
                elif [ "$current_brightness" -lt 303 ]; then
                    brightnessctl set 20%
                elif [ "$current_brightness" -le 1212 ]; then
                    brightnessctl set +20%
                else 
                    brightnessctl set 100%
                fi
                ;;
        esac
        ;;
    *)
        # Invalid argument
        exit 2
        ;;
esac
