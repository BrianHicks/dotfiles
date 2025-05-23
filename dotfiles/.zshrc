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

# TODO: set up fzf again
# if [[ $options[zle] = on ]]; then
#  eval "$(/nix/store/cabxqwq1964bglm63scbjpk64v2fgh6k-fzf-0.55.0/bin/fzf --zsh)"
# fi

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

## finding files quickly

find_and_edit() {
 if git status > /dev/null; then
   SOURCE="$(git ls-files --others --cached --exclude-standard)"
 else
   SOURCE="$(find . -type f)"
 fi

 files="$(fzf --preview='bat --color=always --paging=never --style=changes {}' --select-1 --multi --query="$@" <<< "$SOURCE")"
 if [[ "$?" != "0" ]]; then return 1; fi
 $EDITOR $files
}

alias e=find_and_edit

fzf-package-widget() {
 local project_root="$(git rev-parse --show-toplevel)"
 local project_packages="$(find "$project_root" -maxdepth 3 -name 'package.json' | grep -v "${project_root}/package.json" | sed -E 's|/package.json$||g' | sed -E "s|${project_root}/(.+)|\0:\1|")"

 local package_dest="$(fzf --delimiter : --with-nth 2 <<< "$project_packages" --height 40% --reverse --scheme=path | cut -d : -f 1)"

 if test -z "$package_dest"; then
   zle redisplay
   return 0
 fi

 local package_rel="$(xargs realpath -s --relative-to "$(pwd)" "$package_dest")"

 zle push-line # clear buffer, restored on next prompt
 BUFFER="builtin cd -- ${(q)package_rel}"
 zle accept-line
 local ret=$?
 zle reset-prompt
 return $ret
}

zle -N fzf-package-widget
bindkey -M emacs '\ed' fzf-package-widget
bindkey -M vicmd '\ed' fzf-package-widget
bindkey -M viins '\ed' fzf-package-widget

## git shortcuts

checkout_branch() {
 branch="$(git branch --all | grep -v HEAD | grep -v '*' | sed 's/ //g' | fzf --preview 'git diff --color=always master...{}' --select-1 --query="$@" | sed -E 's|remotes/.+/||')"
 if [[ "$?" != "0" ]]; then return 1; fi
 git checkout "$branch"
}

alias co=checkout_branch

alias g=lazygit-window

# jumping around between projects
jump() {
   BASE="$HOME/code"
   SELECTED=$(find "$BASE" -mindepth 2 -maxdepth 2 -type d | sed "s|$BASE/||g" | fzf --tiebreak=end --select-1 --query="$1")

   if [[ "$?" != 0 ]]; then echo "cancelling!"; return 1; fi

   # TODO: make this a ZSH widget instead of just `cd`ing
   cd "$BASE/$SELECTED"
}

alias j=jump

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
       | xargs rubocop --autocorrect
}

# Every project has little utility scripts you need to run
# occasionally. `run_script` lets you get to them quickly.
#
# - If you run it without arguments, it will open a fuzzy finder for you to
#   select a script
# - If you run it with one argument, that argument will be used as your search
#   string. If the search has a single match, it will run that immediately
#   without confirming with you.
# - If you run it with more than one argument, the first argument will be
#   used as the search string and the remaining arguments will be sent to the
#   script verbatim.
#
# In any of these situations, if you quit the fuzzy finder (ctrl-c, ctrl-g,
# or esc) the script won't run anything and
#
# If you run this inside a git repo, it will offer only checked-in scripts
# below the current directory. If you run it outside of a repo, it will offer
# executable files below the current directory.
#
# TOOD: in the `git | grep`, 100755 might be too restrictive?
run_script() {
   local SCRIPTS

   if git rev-parse --show-toplevel > /dev/null; then
     SCRIPTS="$(git ls-tree -r HEAD | grep 100755 | cut -f 2)"
   else
     SCRIPTS="$(find . -perm /111 -type f)"
   fi

   if ! SELECTED="$(fzf --select-1 --query="$1" <<< "$SCRIPTS")"; then
     return 1
   fi

   "./$SELECTED" "${@:2}"
}

alias s=run_script

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
