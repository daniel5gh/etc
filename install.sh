#!/usr/bin/env bash

# 1. symlink config files to this repo

set +e

this=$(realpath $0)
parent=$(dirname $this)

function execute {
	printf "executing: $1\n"
	$1
}

function symlink {
	execute "ln -fs ${parent}/$1 $2"
}

for fn in $(find dot_configs/ -iname \.\*); do
	symlink "$fn" "$HOME/$(basename $fn)"
done

symlink "shell-setup.sh" "$HOME/.oh-my-zsh/custom/shell-setup.zsh"
symlink "starship.zsh-theme" "$HOME/.oh-my-zsh/custom/themes"
