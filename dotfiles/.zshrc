# Path manipulations...
#           NPM global modules       Hombrew                        Standard Issue Path                              Cabal        Homebrew python
export PATH=/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:~/bin:~/.cabal/bin:/usr/local/share/python

# pythonbrew
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
alias pb=pythonbrew

### START ANTIGEN ###
source ~/antigen/antigen.zsh

# Load the oh-my-zsh library.
antigen-use oh-my-zsh

# Bundles from default (oh-my-zsh)
antigen-bundle brew
antigen-bundle extract
antigen-bundle git
antigen-bundle git-flow
antigen-bundle osx
antigen-bundle pip
antigen-bundle taskwarrior
antigen-bundle vi-mode

# Others...
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-completions
antigen-bundle sharat87/autoenv

### History substring search - it'll blow your mind
antigen-bundle zsh-users/zsh-history-substring-search

# bind UP and DOWN arrow keys
for keycode in '[' '0'; do
  bindkey "^[${keycode}A" history-substring-search-up
  bindkey "^[${keycode}B" history-substring-search-down
done
unset keycode

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

### end history substring search

# Theme!
antigen-theme miloshadzic

# Done with antigen, apply.
antigen-apply

### END ANTIGEN ###

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# wrap git in "hub" wrapper
#function git(){hub "$@"}

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
#function get_rvm_gemset(){
    #if [[ $GEM_HOME != "" ]] then
        #echo "(`basename $GEM_HOME`)"
    #fi
#}

# RPrompt ends up looking like "[error code](virtualenv)" (plus <<< for vi mode)
#export RPROMPT=$'%(?..[ %B%?%b ] )$(get_virtualenv)$(get_rvm_gemset)$(vi_mode_prompt_info)'
export RPROMPT=$'%(?..[ %B%?%b ] )$(get_virtualenv)$(vi_mode_prompt_info)'

#pyqt and others from brew
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# set nocorrect for certain commands
alias j="nocorrect j"

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Machine-local settings, kept out of dotfiles repo
[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Vim bindings
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward

# autojump
[[ -f `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# workaround for git completion breaking in homebrew
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# simple aliases
alias resetdns="sudo killall -HUP mDNSResponder"
alias dimensions="sips -g pixelWidth -g pixelHeight"
alias f="git flow feature"
alias h="git flow hotfix"

export DISABLE_AUTO_TITLE=true

# pro cd function
pd() {
  local projDir=$(pro search $1)
  cd ${projDir}
}
