#!/usr/bin/env bash

cava -p "$HOME/.config/cava/waybar.conf" 2>/dev/null |
awk -F';' '
BEGIN {
    bars[0]="▁";
    bars[1]="▂";
    bars[2]="▃";
    bars[3]="▄";
    bars[4]="▅";
    bars[5]="▆";
    bars[6]="▇";
    bars[7]="█";
}
{
    output="";
    for (i=1; i<=NF; i++) {
        value=int($i);
        if (value < 0) value=0;
        if (value > 7) value=7;
        output=output bars[value];
    }
    print output;
    fflush();
}'
