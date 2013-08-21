#!/bin/sh

mode=$1
shift
theme=$1
shift

if [ -z "$mode" -o -z "$theme" ]; then
    echo "usage: $0 [bootsplash|background] <theme name> [files ...]"
fi

prefix=background/$theme
[ "$mode" = "bootsplash" ] && prefix=bootsplash/data/bootsplash

for f in "$@"; do
    r=`identify -format '%wx%h' "$f"`
    d=$theme/$prefix-$r.png
    cp -af "$f" "$d"
done
