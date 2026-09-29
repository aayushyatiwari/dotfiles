#
# ~/.bash_profile — login shells just load ~/.bashrc
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start i3 on tty3 only (the one I log in on). Other TTYs stay plain shells,
# so if X breaks you can still log in there and fix it — or run `startw`.
if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 3 ]]; then
    exec startx
fi
