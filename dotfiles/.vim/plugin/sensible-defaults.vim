set hidden " hide open buffers in bg, so can edit multiple easily
set nowrap " stop it.
set expandtab
set backspace=indent,eol,start
set autoindent
"set copyindent
set number " duh.
set shiftround
set showmatch
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch
set scrolloff=4 " stay kind of off the edge of the screen
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set cul
set encoding=utf-8

set title

set visualbell " shut up.
set noerrorbells " no really: shut up.

if &t_Co > 2 || has("gui_running")
	syntax on
endif
