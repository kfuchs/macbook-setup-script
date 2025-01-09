#!/bin/bash -f

# Setup .aliases file if it does not exist.
if [ ! -f $HOME/.aliases ]; then
	touch $HOME/.aliases
	tee $HOME/.aliases >/dev/null <<'EOF'
# Custom Aliases go here

# git log diff master -> rubocop on listed files
alias gldm="git log --pretty="" --name-only master..head | sort | uniq"
alias mgdcop="gldm | tr \"\n\" \" \" | xargs rubocop -a"
alias gitcommitammend="git commit --amend --no-edit"
alias gitpushforce="git push --force"

# run rubocop on changed/unstaged files from current branch
alias gumf="git ls-files --others --modified --exclude-standard"
alias gdnam="git diff --name-only --diff-filter=AM"
alias gdcop="{ gumf & gdnam; } | xargs rubocop"

# run rspec on changed SPEC files from current branch
alias gdspec="{ gumf & gdnam; } | grep 'spec/' | xargs rspec"

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
# Color for ls
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# PHP Aliases
alias artisan='php artisan'
alias phpunit='vendor/bin/phpunit'

# Python Aliases
alias manpy='./manage.py'

# Networking Aliases
alias netip='ipconfig getifaddr en0'

# Terraform
alias tfi='terraform init -backend-config=state.conf'
alias tfp='rm -f plan.bin && terraform plan -out=plan.bin | tee plan.txt'
alias tf-dangerous-a='terraform apply plan.bin && rm -f plan.bin'

# Rails
alias rspec="bundle exec rspec"
alias rake="bundle exec rake"
alias testdb="RACK_ENV=test RAILS_ENV=test bundle exec rake -t db:test:load db:seed"

EOF

fi

# Setup .profile file if it does not exist.
if [ ! -f $HOME/.profile ]; then
	touch $HOME/.profile
	tee $HOME/.profile >/dev/null <<'EOF'

# Brew into path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.aliases, instead of adding them here directly.

if [ -f ~/.aliases ]; then
. ~/.aliases
fi

# Set pyenv to manage global python.
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH=$PATH:$HOME/bin # For various scripts
export PATH="~/.composer/vendor/bin:$PATH"

# Save history
PROMPT_COMMAND="history -a"

EOF
fi

if [ ! -f $HOME/.zshrc ]; then
	touch $HOME/.zshrc
	tee $HOME/.zshrc >/dev/null <<'EOF'

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/bin/git-completion.zsh
fpath=(~/bin $fpath)

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

autoload -Uz compinit && compinit

EOF
fi

if [ ! -f $HOME/.bash_profile ]; then
	touch $HOME/.bash_profile
	tee $HOME/.bash_profile >/dev/null <<'EOF'

source $HOME/bin/git-completion.bash

# Auto complete sudo commands
complete -cf sudo
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

EOF
fi
