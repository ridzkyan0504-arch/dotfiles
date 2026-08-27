#!/bin/bash
# Generate theme colors from a static frame of the video wallpaper.
# matugen cannot read video directly, so we use one extracted frame as source.

set -eu

FRAME="$HOME/.local/share/wallpaper-frame/vagabond-frame.jpg"
VIDEO="$HOME/Downloads/Telegram Desktop/Vagabond-Swords-4K.mp4"

# Re-extract frame if missing (video changed, cache cleared, etc.)
if [ ! -f "$FRAME" ] && [ -f "$VIDEO" ]; then
    mkdir -p "$(dirname "$FRAME")"
    ffmpeg -y -v error -ss 8 -i "$VIDEO" -frames:v 1 -q:v 2 "$FRAME"
fi

[ -f "$FRAME" ] || exit 1

matugen image "$FRAME" --type scheme-content --mode dark --prefer saturation || exit 1
hyprctl reload >/dev/null 2>&1 || true
hyprctl eval "hl.animation({ leaf = 'workspaces', enabled = true, speed = 5, bezier = 'wind', style = 'slide' })" >/dev/null 2>&1 || true
pkill -USR1 kitty 2>/dev/null || true
"$HOME/.config/keyboard/set-color-keyboard.sh" >/dev/null 2>&1 &
