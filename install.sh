#!/bin/zsh

echo "Installing common dotfiles..."

# Install Oh My Zsh
if [ -z "${ZSH}" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install plugins
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ] ; then
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] ; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ] ; then
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] ; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Copy dotfiles into their places
cp aliases ~/.aliases
cp hushlogin ~/.hushlogin
cp gitignore_global ~/.gitignore_global
cp vimrc ~/.vimrc
cp gitconfig ~/.gitconfig
cp zshrc ~/.zshrc

# Copy zsh theme into right place.
cp ryanseys.zsh-theme ~/.oh-my-zsh/themes/

HOSTNAME=`hostname`

if [[ "$HOSTNAME" = "ryan-personal-macbook" ]]; then
  echo "Installing dotfiles for Personal Macbook..."
  # Install Ryan's personal machine
  cp ./personal/ruby-version ~/.ruby-version
  cp ./personal/gitconfig ~/.gitconfig_local
  cp ./personal/aliases ~/.aliases_local
  cp ./personal/zshrc ~/.zshrc_local
elif [[ "$HOSTNAME" = "spin" ]]; then
  echo "Installing dotfiles for Spin..."
  # Install Spin configs
  cp ./shopify/gitconfig ~/.gitconfig_local
  cp ./shopify/install_rubymine_on_spin.sh ~/install_rubymine_on_spin.sh
  cp ./shopify/aliases ~/.aliases_local
  cp ./shopify/zshrc ~/.zshrc_local
elif [[ -d "/Users/ryanseys/src/github.com/Shopify/banking" ]]; then
  echo "Installing dotfiles for Shopify Macbook..."
  cp ./shopify/gitconfig ~/.gitconfig_local
  cp ./shopify/aliases ~/.aliases_local
  cp ./shopify/gitmessage ~/.gitmessage
  cp ./shopify/zshrc ~/.zshrc_local
else
  echo "Not sure what machine you are on."
fi

echo "Done installing dotfiles!"
