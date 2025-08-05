#!/bin/sh

turn_on_led() {
    LED_PATH="/sys/class/leds/$1"
    [ -d "$LED_PATH" ] && {
        echo none > "$LED_PATH/trigger"
        echo 1 > "$LED_PATH/brightness"
    }
}

turn_off_led() {
    LED_PATH="/sys/class/leds/$1"
    [ -d "$LED_PATH" ] && {
        echo none > "$LED_PATH/trigger"
        echo 0 > "$LED_PATH/brightness"
    }
}

set_led_blink() {
    LED_PATH="/sys/class/leds/$1"
    if [ -d "$LED_PATH" ]; then
        echo heartbeat > "$LED_PATH/trigger"
    fi
}

set_5g_led_by_snr() {
    local best_min_snr=-1
    local best_color=""
    local best_blink=0

    config_cb() { :; }

    config_5g_quality() {
        local section="$1"
        local min_snr color blink

        config_get min_snr "$section" min_snr
        config_get color "$section" color
        config_get blink "$section" blink

        if [ "$SNR" -ge "$min_snr" ] && [ "$min_snr" -gt "$best_min_snr" ]; then
            best_min_snr=$min_snr
            best_color=$color
            best_blink=$blink
        fi
    }

    . /lib/functions.sh
    config_load 5g-led
    config_foreach config_5g_quality 5g_quality

    for LED in green:5g blue:5g red:5g; do
        turn_off_led "$LED"
    done

    case "$best_color" in
        green)
            turn_on_led "green:5g"
            ;;
        blue)
            turn_on_led "blue:5g"
            ;;
        red)
            turn_on_led "red:5g"
            ;;
        yellow)
            turn_on_led "red:5g"
            turn_on_led "green:5g"
            ;;
    esac

    if [ "$best_blink" = "1" ]; then
        case "$best_color" in
            yellow)
                set_led_blink "red:5g"
                ;;
            *)
                set_led_blink "${best_color}:5g"
                ;;
        esac
    fi

    echo "5G: $best_color (SNR=$SNR)"
}


turn_on_led "green:power"

COMM=$(uci get modeminfo.settings.comm 2>/dev/null)

if [ -z "$COMM" ]; then
    echo "Modem: Not Configured"
    turn_on_led "red:phone"
    exit 1
fi

MODEM_INFO=$(sms_tool -d "$COMM" at 'AT+CSQ;+QENG="servingcell"')

if [ -z "$MODEM_INFO" ]; then
    echo "Modem: No Response"
    turn_on_led "red:phone"
else
    echo "Modem: OK"
    turn_on_led "green:phone"
fi

CSQ=$(echo "$MODEM_INFO" | grep -i '+CSQ:' | awk -F'[ ,:]+' '{print $2}')
[ -z "$CSQ" ] && CSQ=0

QENG_NR5G=$(echo "$MODEM_INFO" | grep 'NR5G-NSA')

if [ -n "$QENG_NR5G" ]; then
    NR5G_SINR=$(echo "$QENG_NR5G" | awk -F',' '{print $6}' | tr -d '"')
    if ! echo "$NR5G_SINR" | grep -qE '^[0-9]+$'; then
        SNR=0
    else
        SNR=$NR5G_SINR
    fi
else
    SNR=0
fi

echo "CSQ = $CSQ"
echo "SNR = $SNR"

for LED in \
    green:signal blue:signal red:signal \
    green:5g blue:5g red:5g \
    green:phone red:phone; do
    turn_off_led "$LED"
done

if [ -n "$MODEM_INFO" ]; then
    turn_on_led "green:phone"
    set_led_blink "red:phone"
fi

set_5g_led_by_snr

found=0
for IFACE in wwan0_1 wwan0; do
    if ip link show "$IFACE" >/dev/null 2>&1 && \
       ip route show dev "$IFACE" | grep -q '^default'; then
        found=1
        break
    fi
done

if [ "$found" -eq 1 ]; then
    turn_on_led "green:internet"
    echo "Internet: Connected"
else
    turn_off_led "red:internet"
    echo "Internet: Not Connected"
fi

for LED in green:wifi blue:wifi red:wifi; do
    turn_off_led "$LED"
done

WIFI_STATUS=$(uci get wireless.@wifi-device[0].disabled 2>/dev/null)
if [ "$WIFI_STATUS" = "1" ]; then
    echo "WiFi: Off"
else
    turn_on_led "green:wifi"
    echo "WiFi: On"
fi


if [ "$found" -eq 1 ]; then
    if [ "$CSQ" -ge 30 ]; then
        turn_on_led "green:signal"
        echo "Signal: Excellent (CSQ=$CSQ)"
    elif [ "$CSQ" -ge 20 ]; then
        turn_on_led "blue:signal"
        echo "Signal: Good (CSQ=$CSQ)"
    elif [ "$CSQ" -ge 1 ]; then
        turn_on_led "red:signal"
        turn_on_led "green:signal"
        echo "Signal: Average (CSQ=$CSQ)"
    else
        set_led_blink "red:signal"
        echo "Signal: Poor (CSQ=$CSQ)"
    fi
else
    turn_on_led "red:signal"
    echo "Signal: No Internet (CSQ=$CSQ)"
fi
