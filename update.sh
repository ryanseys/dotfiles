#!/bin/zsh

# Copy dotfiles into their places
cp ~/.aliases aliases
cp ~/.hushlogin hushlogin
cp ~/.gitignore_global gitignore_global
cp ~/.vimrc vimrc
cp ~/.gitconfig gitconfig
cp ~/.zshrc zshrc

# Copy zsh theme into right place.
cp ~/.oh-my-zsh/themes/ryanseys.zsh-theme ryanseys.zsh-theme

HOSTNAME=`hostname`
if [[ "$HOSTNAME" = "ryan-personal-macbook" ]]; then
  # Install Ryan's personal machine
  cp ~/.gitconfig_local ./personal/gitconfig
  cp ~/.aliases_local ./personal/aliases
  cp ~/.ruby-version ./personal/ruby-version
  cp ~/.zshrc_local ./personal/zshrc
elif [[ "$HOSTNAME" == "spin" ]]; then
  # Install Spin configs
  cp ~/.gitconfig_local ./shopify/gitconfig
  cp ~/install_rubymine_on_spin.sh ./shopify/install_rubymine_on_spin.sh
  cp ~/.aliases_local ./shopify/aliases
  cp ~/.zshrc_local ./shopify/zshrc
else # TODO: Figure out hostname for Shopify Macbook
  cp ~/.gitconfig_local ./shopify/gitconfig
  cp ~/.aliases_local ./shopify/aliases
  cp ~/.gitmessage ./shopify/gitmessage
  cp ~/.zshrc_local ./shopify/zshrc
fi
