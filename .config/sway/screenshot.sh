img="$HOME/Pictures/ScreenShots/$(date '+%y%m%d_%H-%M-%S').png"
if [ "$1" == "--rect" ]; then
  grim -g "$(slurp)" $img
else
  grim $img
fi
nautilus -w $img &
