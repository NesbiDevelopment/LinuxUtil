#!/usr/bin/env sh

###########################
## My i3 install - Solus ##
###########################

# Variables and folders
CURRENT=$PWD
REQ=/tmp/i3-install/
I3GNOME=$REQ/i3-gnome/
I3THEMER=/opt/i3wm-themer/
NERDFONTS=$REQ/nerd-fonts/

mkdir -p $REQ

# Install i3
echo Installing i3..
sudo eopkg install -y i3
echo finished

# Install i3-GNOME
echo Installing i3-GNOME..
sudo git clone https://github.com/jcstr/i3-gnome.git $I3GNOME
cd $I3GNOME
make install
echo finished

# Install i3wm-themer
echo Installing i3wm-themer..
sudo git clone https://github.com/unix121/i3wm-themer.git $I3THEMER
cd $I3THEMER

echo Installing i3wm-themer Requirements..
## Requirements
sudo pip install -r requirements.txt
sudo eopkg install -y polybar rofi font-awesome-ttf nitrogen source-code-pro rxvt-unicode
### Nerd Font - ALL
# sudo -u $SUDO_USER git clone https://github.com/ryanoasis/nerd-fonts.git $NERDFONTS
cd $NERDFONTS
#sudo -u $SUDO_USER ./install.sh
echo finished 

## MAIN
echo Installing i3wm-themer basic..

# Check for non existing files
sudo -u $SUDO_USER mkdir -p /home/$SUDO_USER/.config/i3/
sudo -u $SUDO_USER mkdir -p /home/$SUDO_USER/.config/polybar/
sudo -u $SUDO_USER mkdir -p /home/$SUDO_USER/.config/nitrogen/
if [ ! -f "/home/$SUDO_USER/.config/i3/config" ]
then
    sudo -u $SUDO_USER touch "/home/$SUDO_USER/.config/i3/config"
fi

if [ ! -f "/home/$SUDO_USER/.config/polybar/config" ]
then
    sudo -u $SUDO_USER touch "/home/$SUDO_USER/.config/polybar/config"
fi

if [ ! -f "/home/$SUDO_USER/.Xresources" ]
then
    sudo -u $SUDO_USER touch "/home/$SUDO_USER/.Xresources"
fi

if [ ! -f "/home/$SUDO_USER/.config/nitrogen/bg-saved.cfg" ]
then
    sudo -u $SUDO_USER touch "/home/$SUDO_USER/.config/nitrogen/bg-saved.cfg"
fi

sudo sed -ir 's/\/v\//\/'$SUDO_USER'\//g' $I3THEMER/src/config.yaml
sudo sed -ir 's/\/USER\//\/'$SUDO_USER'\//g' $I3THEMER/src/defaults/config.yaml
sudo -u $SUDO_USER cp -r $I3THEMER/scripts/* /home/$SUDO_USER/.config/polybar/

sudo -u $SUDO_USER mkdir -p /home/$SUDO_USER/Backups
cd $I3THEMER/src


echo BackUp of existing configs
sudo -u $SUDO_USER python i3wm-themer.py --config config.yaml --backup /home/$SUDO_USER/Backups
echo finished
echo Setting default configs
sudo -u $SUDO_USER python i3wm-themer.py --config config.yaml --install defaults/
echo finished
echo finished 

## Create shortcut
SHORT=/usr/bin/i3st
echo '#!/bin/bash' >> $SHORT
echo cd $I3THEMER'src' >> $SHORT
echo 'sudo -u $SUDO_USER python i3wm-themer.py --config config.yaml --load themes/$1.json' >> $SHORT

echo Installation is finished
echo Please select a theme via:
echo i3st [theme_id]
