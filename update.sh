#!/bin/zsh

echo "Updating common dotfiles..."

# Copy common dotfiles into their places
cp ~/.aliases aliases
cp ~/.hushlogin hushlogin
cp ~/.gitignore_global gitignore_global
cp ~/.vimrc vimrc
cp ~/.gitconfig gitconfig
cp ~/.zshrc zshrc
cp ~/.pryrc pryrc
cp ~/.ruby-version ruby-version

# Copy zsh theme into right place.
cp ~/.oh-my-zsh/themes/ryanseys.zsh-theme ryanseys.zsh-theme

HOSTNAME=`hostname`
if [[ "$HOSTNAME" = "ryan-personal-macbook" ]]; then
  echo "Updating dotfiles for Personal Macbook..."
  # Install Ryan's personal machine
  cp ~/.gitconfig_local ./personal/gitconfig
  cp ~/.aliases_local ./personal/aliases
  cp ~/.ruby-version ./personal/ruby-version
  cp ~/.zshrc_local ./personal/zshrc
elif [[ "$HOSTNAME" == "spin" ]]; then
  echo "Updating dotfiles for Spin..."
  # Install Spin configs
  cp ~/.gitconfig_local ./shopify/gitconfig
  cp ~/install_rubymine_on_spin.sh ./shopify/install_rubymine_on_spin.sh
  cp ~/.aliases_local ./shopify/aliases
  cp ~/.zshrc_local ./shopify/zshrc
elif [[ -d "/Users/ryanseys/src/github.com/Shopify/banking" ]]; then
  echo "Updating dotfiles for Shopify Macbook..."
  cp ~/.gitconfig_local ./shopify/gitconfig
  cp ~/.aliases_local ./shopify/aliases
  cp ~/.gitmessage ./shopify/gitmessage
  cp ~/.zshrc_local ./shopify/zshrc
else
  echo "Not sure what machine you are on."
fi

echo "Done updating dotfiles!"
