#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-coffee-mode"

status() {
    if [[ -f "$STATE_FILE" ]]; then
        echo '{"text":"","tooltip":"Coffee Mode: ON — autosuspend disabled","class":"active"}'
    else
        echo '{"text":"󰒲","tooltip":"Coffee Mode: OFF — autosuspend enabled","class":"inactive"}'
    fi
}

toggle() {
    if [[ -f "$STATE_FILE" ]]; then
        # Matikan Coffee Mode
        rm -f "$STATE_FILE"

        # Jalankan kembali hypridle jika belum aktif
        if ! pgrep -x hypridle >/dev/null; then
            nohup hypridle >/dev/null 2>&1 &
        fi
    else
        # Aktifkan Coffee Mode
        touch "$STATE_FILE"

        # Matikan hypridle
        pkill -x hypridle 2>/dev/null || true
    fi

    status
}

case "$1" in
    toggle)
        toggle
        ;;
    *)
        status
        ;;
esac
