# If the shell gets slow, uncomment the following `zmodload` and `zprof` at the
# bottom. Zsh will then spit out where it took the most time. Very direct way of
# figuring out where the problem is!
# zmodload zsh/zprof

typeset -U path cdpath fpath manpath

# TODO: set up fzf-tab again
# path+="$HOME/.config/zsh/plugins/fzf-tab"
# fpath+="$HOME/.config/zsh/plugins/fzf-tab"
#
# if [[ -f "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
#  source "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
# fi

HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

EDITOR=nvim
export EDITOR

# see `man zshoptions`
setopt PROMPT_SUBST # do parameter, command, and arithmetic expansion in prompts
setopt PROMPT_SP    # preserve partial lines, adding inverse-colored % after a line

EMOJI_NEUTRAL=(😃 🤓 👾 🤖 💯 🐵 🦍 🐺 🐈 🦄 🦅 🦉 🐬 🐋 🐙 🌲 🌳 🍀 🍁 🍇 🍍 🍩 🌍 🌎 🌏 🚄 🚍 🚲 🛴 🚡 🚠 🚀)
EMOJI_UNHAPPY=(😵 😲 🤡 👹 😿 💔 💢)
EMOJI_PROMPT="${EMOJI_NEUTRAL[$RANDOM % ${#EMOJI_NEUTRAL[@]}]}"
EMOJI_PROMPT_ERROR="${EMOJI_UNHAPPY[$RANDOM % ${#EMOJI_UNHAPPY[@]}]}"

PROMPT="%(?.$EMOJI_PROMPT .$EMOJI_PROMPT_ERROR [%F{red}%?%f] )%B%F{blue}%c%f%b %F{blue}»%f "
RPROMPT=

# 1password plugins
alias gh="op plugin run -- gh"
alias glab="op plugin run -- glab"

alias tw="task"
alias twui="taskwarrior-tui"
alias tw-rand="task-rand"

alias lg=lazygit

# grab Homebrew binaries if needed
if test -d /opt/homebrew/bin; then
  export PATH="$PATH:/opt/homebrew/bin"
fi

if test -d "$HOME/bin"; then
  export PATH="$PATH:$HOME/bin"
fi

# make various keybindings work
# run `bindkey` for a list of current bindings
# run `zle -al` to list all commands
bindkey "^[[3~" delete-char

## mark a binary safe without having to open it in finder to right click on it etc
alias mark-safe="xattr -dr com.apple.quarantine"

## jump to the root directory of a project
alias root='cd "$(git rev-parse --show-toplevel)"'

# fix rubocop errors automatically
function rubofix() {
   TOPLEVEL="$(git rev-parse --show-toplevel)"
   git diff --name-status origin/master \
       | grep -vE '^D' \
       | grep -E '.rb$' \
       | grep -v 'schema.rb' \
       | cut -c 3- \
       | sed "s|^|$TOPLEVEL/|g" \
       | xargs bundle exec rubocop --autocorrect
}

# TODO: set up direnv again?
# eval "$(/nix/store/439f5yi8i1akxl2669f5mam6iacisycv-direnv-2.34.0/bin/direnv hook zsh)"

# TODO: set up zsh syntax highlighting again
# source /nix/store/zxhgc5k56s58z3nm37fy8z9y897p90fk-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# ZSH_HIGHLIGHT_HIGHLIGHTERS+=()

# FZF
source <(fzf --zsh)

# Get linkerd, if it's there
if test -d ~/.linkerd2; then
  PATH="$PATH:$HOME/.linkerd2/bin"
fi

if which go > /dev/null; then
  PATH="$PATH:$(go env GOPATH)/bin"
fi

if test -f "$HOME/.cargo/env"; then
  source "$HOME/.cargo/env"
fi

export GOPRIVATE=gitlab.com/paynearme

AUTOSUGGESTIONS="/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if test -f "$AUTOSUGGESTIONS"; then
  source "$AUTOSUGGESTIONS"
fi

# Aliases for `glab`
alias glab.mr="glab mr create --push"
alias glab.ready="glab mr update --ready"

# source nvm
lazy_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
}

node() {
  lazy_nvm
  node $@
}

npm() {
  lazy_nvm
  npm $@
}

# zprof
