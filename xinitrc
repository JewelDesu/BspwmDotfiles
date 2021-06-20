xsetroot -cursor_name left_ptr
compton &
sxhkd &
exec bspwm
~/.fehbd &
exec startlxde

xrdb ~/.Xresources &

betterlockscreen -u ~/Downloads.wal.fpg -b 0.6

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd
