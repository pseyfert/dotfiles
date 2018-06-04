if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && source "$f"
  done
  unset f
fi

# my keyboard layout is somewhat grown on de
setxkbmap de
xmodmap ${HOME}/.xmodmap

# automatic mounting
udiskie -Pantv &
# because copy and pasting with all the clipboards nowadays is a pain
autocutsel -fork

# load Xresources (TODO: needed?)
xrdb -load ${HOME}/.Xresources
# disable audible bell
xset -b

# Left here from debugging. The way we ended up setting up my current main
# device, the zshenv gets pulled into action first.  For porting these might
# better go here.
#
# export LC_TIME="en_DK.UTF-8"
# export LC_MESSAGES="C"
# export LANG="de_DE.UTF-8"

# adapt screen colour to position of sun in the sky
redshift &

# finally, start i3
exec /usr/bin/i3
