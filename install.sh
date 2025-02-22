#!/usr/bin/bash

# Set exit on failure. 
set -e
WALLPAPER_SCRIPT_PATH="~/.scripts/random_wallpaper.sh"


# TODO: Check and Install dependencies.
# I suppose I will assume that that use is running arch and has access to yay and pacman.
echo -e "\x1b[32mInstalling yay dependencies.\x1b[m"
yay -Syu 
yay -S argyllcms
echo -e "\x1b[32mInstalling pacman dependencies.\x1b[m"
sudo pacman -Syu
sudo pacman -S tmux i3-wm i3status feh cronie libpulse pipewire pipewire-pulse

echo -e "\x1b[32mCopying $(realpath scripts) to $(realpath ~/.scripts/)\x1b[m"
rsync -a -v scripts/ ~/.scripts/  

echo -e "\x1b[32mCopying $(realpath config) to $(realpath ~/.config/)\x1b[m"
rsync -a -v config/ ~/.config/  

echo -e "\x1b[32mCopying $(realpath colour_profiles/) to $(realpath ~/.config/)\x1b[m"
rsync -a -v colour_profiles/ ~/.config/colour_profiles/  

echo -e "\x1b[32m Set-up crontab with the random wallpaper task. Wallpaper directory: $WALLPAPER_DIR\x1b[m"
(crontab -l 2>/dev/null; echo "*/15 * * * * $WALLPAPER_SCRIPT_PATH") | crontab -
echo -e "\x1b[33mYour crontab has been appended to, so you may have to remove remove redundant entires if you have run this script previously.\x1b[m"
