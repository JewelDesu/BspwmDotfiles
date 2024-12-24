#!/usr/bin/env sh

#-------------------------------#
# Generate current song cover   #
# ffmpeg version                #
#-------------------------------#

# Path to music directory
# MUSIC_DIR="$HOME/Music"
# Path to output cover
COVER="/tmp/cover.png"
COVER_TMP="/tmp/cover_tmp.png"
COVER_NOTIFICATION="/tmp/cover_notification.png"
# Size of cover
COVER_SIZE=297
# Size in pixel of borders to crop out
CROP_BORDER=20
# Radius or rounded borders
BORDER_RADIUS=10

ffmpeg_cover() {
    ffmpeg -loglevel 0 -y -i "$1" -vf "crop=min(in_w-$CROP_BORDER\,in_h-$CROP_BORDER):out_w,scale=-2:$COVER_SIZE" "$COVER_TMP"
}

rounded_cover() {
    magick -quiet "$COVER_TMP" \
     \( +clone  -alpha extract \
        -draw "fill black polygon 0,0 0,$BORDER_RADIUS $BORDER_RADIUS,0 fill white circle $BORDER_RADIUS,$BORDER_RADIUS $BORDER_RADIUS,0" \
        \( +clone -flip \) -compose Multiply -composite \
        \( +clone -flop \) -compose Multiply -composite \
     \) -alpha off -compose CopyOpacity -composite "$COVER"
}

fallback_find_cover() {
    MUSIC_DIR="$HOME/Music"
    file="$MUSIC_DIR/$(mpc --format %file% current)"
    album=$(dirname "$file")
    album_cover="$(find "$album" -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(covers?\|folders?\|artworks?\|fronts?\|scans?\).*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    [ -z "$album_cover" ] && album_cover="$(find "$album" -type d -exec find {} -maxdepth 1 -type f -iregex ".*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    [ -z "$album_cover" ] && album_cover="$(find "${album%/*}" -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(covers?\|folders?\|artworks?\|fronts?\|scans?\|booklets?\).*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    album_cover="$(echo "$album_cover" | grep -iv '\(back\|cd\)\.' | head -n1)"
    echo "$album_cover"
}

mpris_album_art() {
    cover=$(playerctl metadata mpris:artUrl -s | sed 's#file://##')
    [ -z "$cover" ] && cover="$(fallback_find_cover)"
    echo "$cover"
}

notification() {
    magick "$COVER" -resize 144x144 "$COVER_NOTIFICATION"
    notify-send -i "$COVER_NOTIFICATION" "$(playerctl metadata --format '{{title}} {{album}}')"
}

main() {
    [ ! -x "$(which playerctl)" ] && echo "Install playerctl and mpDris2 for this script to work."

    ffmpeg_cover "$(mpris_album_art)" && rounded_cover
    # notification
}

main
