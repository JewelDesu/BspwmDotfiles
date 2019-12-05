xsetroot -cursor_name left_ptr
compton &
sxhkd &
exec bspwm
~/.fehbd &
# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd &


