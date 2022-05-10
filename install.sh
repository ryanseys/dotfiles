#!/bin/zsh

# Install Oh My Zsh
if [ -z "${ZSH}" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# if [ -n "${SPIN}" ]; then
#   ./install_rubymine_on_spin.sh
# fi

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
cp gitmessage ~/.gitmessage

# Copy zsh theme into right place.
cp ryanseys.zsh-theme ~/.oh-my-zsh/themes/

# TODO: install precommit hooks for all repositories
if [ -d "/home/spin/src/github.com/Shopify/ryanseys-test" ]; then
  mkdir /home/spin/src/github.com/Shopify/ryanseys-test/.git/hooks/precommit.d
  cp hooks/precommit /home/spin/src/github.com/Shopify/ryanseys-test/.git/hooks/
  cp -a hooks/precommit.d/ /home/spin/src/github.com/Shopify/ryanseys-test/.git/hooks/precommit.d/
fi

echo "Done installing dotfiles!"
