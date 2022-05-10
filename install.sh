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

# Install pre-commit hooks for all repositories in Spin
if [ -d "/home/spin/src/github.com/Shopify/" ]; then
  echo "Installing pre-commit hooks for Spin repositories"
  for f in /home/spin/src/github.com/Shopify/*; do
    if [ -d "$f" ]; then
      # Runs for every directory in this directory...

      cp -fp hooks/pre-commit $f/.git/hooks/

      for hook in ./hooks/pre-commit.d/*; do
        # -p preserves the file permissions
        cp -fp $hook $f/.git/hooks/pre-commit.d/
      done
    fi
  done
fi

# Install pre-commit hooks for all repositories locally
if [ -d "/Users/ryanseys/src/github.com/Shopify/" ]; then
  echo "Installing pre-commit hooks for local repositories"
  for f in /Users/ryanseys/src/github.com/Shopify/*; do
    if [ -d "$f" ]; then
      # Runs for every directory in this directory...
      cp -fp hooks/pre-commit $f/.git/hooks/

      for hook in ./hooks/pre-commit.d/*; do
        # -p preserves the file permissions
        cp -fp $hook $f/.git/hooks/pre-commit.d/
      done
    fi
  done
fi

echo "Done installing dotfiles!"
