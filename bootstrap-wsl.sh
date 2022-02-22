#!/usr/bin/env bash

# 1. install essential packages
# 2. setup windows terminal profile + font

sudo apt update
sudo apt --yes full-upgrade
sudo apt --yes install zsh neovim keychain python3-pygments 
sudo apt --yes remove vim vim-tiny vim-common
sudo apt --yes autoremove

if ! command -v starship &> /dev/null; then
	sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
