#!/bin/bash

echo "Installing dotfiles"

echo "Initializing submodule(s)"
git submodule update --init --recursive

source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo -e "\n\nRunning on OSX"

    echo -e "\n\nUpdating OSX settings"
    echo "=============================="
    source install/osx.sh

    echo -e "\n\nBrewing all the things"
    echo "=============================="
    source install/brew.sh
fi

echo -e "\n\nCreating vim directories"
echo "=============================="
mkdir -p ~/.vim-tmp

echo -e "\n\nConfiguring zsh as default shell"
echo "=============================="
chsh -s $(which zsh)

echo "Done."
