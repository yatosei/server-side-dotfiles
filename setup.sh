#!/bin/sh
set -eux

# Add .bashrc_custom
DOTFILES_PATH="$HOME/dotfiles/.bashrc_custom"
ADD_BASHRC_CUSTOM='[ -f "$DOTFILES_PATH" ] && source "$DOTFILES_PATH"'

grep -qxF $ADD_BASHRC_CUSTOM ~/.bashrc || echo -e "\n$ADD_BASHRC_CUSTOM" >> ~/.bashrc
