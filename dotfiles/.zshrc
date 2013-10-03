# # Path manipulations...
# #           NPM global modules       Hombrew                        Standard Issue Path                              Cabal        Homebrew python
export PATH=/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:~/bin:~/.cabal/bin:/usr/local/share/python

### START ANTIGEN ###
source ~/antigen/antigen.zsh

# Load the oh-my-zsh library.
antigen-use oh-my-zsh

antigen bundles << EOB
    # from oh-my-zsh
    command-not-found
    heroku

    # from other sources
    sharat87/autoenv
    zsh-users/zsh-completions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-syntax-highlighting
EOB

### History substring search - it'll blow your mind
# bind UP and DOWN arrow keys
for keycode in '[' '0'; do
  bindkey "^[${keycode}A" history-substring-search-up
  bindkey "^[${keycode}B" history-substring-search-down
done
unset keycode

# Theme!
antigen-theme miloshadzic

### END ANTIGEN ###

# rvm
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# aliases
alias less='less -FrX'

# taskwarrior's burndown functions are TOO BIG. Let's pipe them through less to
# change the size!
function burndown.daily(){task burndown.daily $@ rc._forcecolor=yes | less}
function burndown.weekly(){task burndown.weekly $@ rc._forcecolor=yes | less}
function burndown.monthly(){task burndown.monthly $@ rc._forcecolor=yes | less}

# virtualenv in prompt
export VIRTUAL_ENV_DISABLE_PROMPT=true # or any non-empty value
function get_virtualenv(){
    if [[ $VIRTUAL_ENV != "" ]] then
        echo "(`basename $VIRTUAL_ENV`)"
    fi
}

# RPrompt ends up looking like "[error code](virtualenv)" (plus <<< for vi mode)
export RPROMPT=$'%(?..[ %B%?%b ] )$(get_virtualenv)'

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Machine-local settings, kept out of dotfiles repo
[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# workaround for git completion breaking in homebrew
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# simple aliases
alias resetdns="sudo killall -HUP mDNSResponder"
alias dimensions="sips -g pixelWidth -g pixelHeight"
alias f="git flow feature"
alias h="git flow hotfix"
alias t="task"
alias tt="/usr/local/bin/t"  # who names a utility one letter?

export DISABLE_AUTO_TITLE=true

# go
export GOPATH=~/code/gocode

# jump
# from http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
# TODO: change to the oh-my-zsh plugin when/if it gets merged
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm -i "$MARKPATH/$1"
}
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
function _completemarks {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
eval "$(rbenv init -)"
