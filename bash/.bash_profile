#
# ~/.bash_profile — login shells just load ~/.bashrc
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start i3 on tty1 only. Other TTYs (Ctrl+Alt+F2...) stay plain shells,
# so if X breaks you can still log in there and fix it — or run `startw`.
if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
fi
