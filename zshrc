. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && .  ~/.localrc

# rbenv
eval "$(rbenv init -)" # Enable shims and autocompletion 

# REPLACED BY RBENV
# rvm
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
