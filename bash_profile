source ~/.bashrc
source ~/.profile
[[ -s /Users/rseys/.nvm/nvm.sh ]] && . /Users/rseys/.nvm/nvm.sh # This loads NVM

echo 'Loading RVM from bash_profile'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
