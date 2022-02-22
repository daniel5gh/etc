#!/usr/bin/env bash

# 1. install essential packages
# 2. setup windows terminal profile + font

sudo apt update
sudo apt --yes full-upgrade
sudo apt --yes install zsh neovim keychain python3-pygments 
sudo apt --yes remove vim vim-tiny vim-common
sudo apt --yes autoremove

# STARSHIP

if ! command -v starship &> /dev/null; then
	sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi

# ZSH PLUGINS

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# FONT

printf "\nPlease press the install button; then close\npress a key when done\n"
font_fn="JetBrains Mono Regular Nerd Font Complete.ttf"
# create copy because fontview can't handle \\wsl$\ paths
windows_temp="$(wslvar TEMP)/$font_fn"
# this will expand to windows temp path, like /mnt/c/Users/daniel/AppData/Local/Temp
wsl_temp="$(wslpath "$windows_temp")"
cp "windows_terminal/$font_fn" "$wsl_temp"
# wslview opens file with default association, this _is_ different from fontview.exe <filename>
wslview "$windows_temp"

read -s -n 1 key

# WINDOWS TERMINAL SETTINGS

# doing this here so we don't have to call out these wsl utils from python
wsl_settings_winpath=$(wslvar LOCALAPPDATA)\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState
wsl_settings_path=$(wslpath $wsl_settings_winpath)
./update_terminal_settings.py $wsl_settings_path $wsl_settings_winpath
