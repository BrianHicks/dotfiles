# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="miloshadzic"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git autojump brew bundler fabric gem git-flow github pip rvm django taskwarrior extract heroku osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:~/bin

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

export WORKON_HOME=~/Envs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
source /usr/local/bin/virtualenvwrapper.sh # virtualenvwrapper

function git(){hub "$@"}

# tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
#export EDITOR=/usr/local/bin/mvim
export EDITOR=/usr/bin/vim

# pythonbrew
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

# aliases
alias pydj='python manage.py'
alias less='less -FrX'

# taskwarrior's burndown functions are TOO BIG. Let's pipe them through less to
# change the size!
function burndown(){task burndown.daily $@ rc._forcecolor=yes | less}
function burndown.weekly(){task burndown.weekly $@ rc._forcecolor=yes | less}
function burndown.monthly(){task burndown.monthly $@ rc._forcecolor=yes | less}

# virtualenv in prompt
export VIRTUAL_ENV_DISABLE_PROMPT=true # or any non-empty value
function get_virtualenv(){
    if [[ $VIRTUAL_ENV != "" ]] then
        echo "(`basename $VIRTUAL_ENV`)"
    fi
}
function get_rvm_gemset(){
    if [[ $GEM_HOME != "" ]] then
        echo "(`basename $GEM_HOME`)"
    fi
}
export RPROMPT=$'%(?..[ %B%?%b ] )$(get_virtualenv)$(get_rvm_gemset)'

[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

#pyqt and others from brew
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# set nocorrect for certain commands
alias knife="nocorrect knife"
alias j="nocorrect j"
