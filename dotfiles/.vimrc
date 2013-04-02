set nocompatible

" Use vundle
filetype off " force reloading after pathogen loaded

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Let vundle manage vundle
Bundle 'gmarik/vundle'

" VUNDLES!
" Some bundles I feel are slowing vim down or I don't use - trial period
" before removal.
"Bundle "Lokaltog/vim-easymotion"
"Bundle "godlygeek/tabular"
"Bundle "majutsushi/tagbar"
"Bundle "scrooloose/nerdtree"
"Bundle "scrooloose/syntastic"
"Bundle "tpope/vim-abolish"
"Bundle "tpope/vim-fugitive"

" bundles which I actually use on a fairly regular basis.
Bundle "IndentAnything"
Bundle "Lokaltog/vim-powerline"
Bundle "airblade/vim-gitgutter"
Bundle "benmills/vimux"
Bundle "ervandew/supertab"
Bundle "fholgado/minibufexpl.vim"
Bundle "mattn/zencoding-vim"
Bundle "mileszs/ack.vim"
Bundle "scrooloose/nerdcommenter"
Bundle "sjl/vitality.vim"
Bundle "tpope/vim-eunuch"
Bundle "tpope/vim-repeat"
Bundle "tpope/vim-surround"
Bundle "tpope/vim-unimpaired"

" Syntax / highlighting / colors
Bundle "VimClojure"
Bundle "altercation/vim-colors-solarized"
Bundle "derekwyatt/vim-scala"
Bundle "digitaltoad/vim-jade"
Bundle "groenewege/vim-less"
Bundle "jnwhiteh/vim-golang"
Bundle "juvenn/mustache.vim"
Bundle "kchmck/vim-coffee-script.git"
Bundle "mutewinter/nginx.vim"
Bundle "nono/vim-handlebars"
Bundle "plasticboy/vim-markdown"
Bundle "saltstack/salt-vim"
Bundle "wavded/vim-stylus"

filetype plugin indent on

" General custom Stuff

" It's easier for me to press than \
let mapleader=","

" Edit and source ~/.vimrc
nnoremap <leader>ev :e ~/.vimrc<CR>
nnoremap <leader>sv :so ~/.vimrc<CR>

" I save often enough and use different change detection scripts. YMMV.
set nobackup
set noswapfile

" extra characters are helpful. I don't like extra characters. HULK SMASH.
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
" ... except for HTML
autocmd filetype html,xml set listchars-=tab:>.

" Colors
if &t_Co >= 256 || has("gui_running")
  colorscheme solarized
endif

" (slightly) modify some frequently used keys
nnoremap ; :
vnoremap ; :
nnoremap : ;
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <leader>w <C-w>s<C-w>j

" better yank/paste to OS clipboard
nmap <leader>y "+y
nmap <leader>Y "+Y
nmap <leader>p "+p
nmap <leader>P "+P

" Formatting for the current par or selection
vmap Q gq
nmap Q gqap

" Get out of insertmode free
" ... on the terminal
"inoremap jj <Esc>
inoremap jk <Esc>
inoremap kj <Esc>
" ... in graphical mode
inoremap <s-cr> <Esc>
vnoremap <s-cr> <Esc>

" Custom movement commands
noremap <leader>l $
noremap <leader>h ^

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Make searching better
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#making-vim-more-useful
nnoremap / /\v
vnoremap / /\v
set gdefault

" SHUT. UP. HELP.
inoremap <F1> <Esc>
nnoremap <F1> <Esc>
vnoremap <F1> <Esc>

" save on lost focus
au FocusLost * :wa

" select last pasted text (for indenting, etc)
nnoremap <leader>v V`]

" Sometimes I forget to sudo.
cmap w!! w !sudo tee % >/dev/null

" Shift-K is really annoying.
nnoremap <S-k> <nop>
vnoremap <S-k> <nop>

" Function keys
nnoremap <F7> :TagbarToggle<cr>
nnoremap <F8> :NERDTreeToggle<cr>

set pastetoggle=<F2>

" Statusline/powerline
set laststatus=2
set guifont=Menlo\ for\ Powerline
let g:Powerline_symbols='fancy'

" Remove toolbar from gui
set guioptions-=T

" I need to stop using <Esc> and use my shortcuts
inoremap <Esc> <nop>

" python-mode options
let g:pymode_doc = 0
let g:pymode_lint = 0

" zencoding
let g:user_zen_settings = {'indentation': '  '}

" tags
set tags=.git/tags

" I don't need to see .pyc or .pyo files in NERDTree
let NERDTreeIgnore = ['\.pyc$']

" Vimux mappings
nnoremap <leader>vp :VimuxPromptCommand<cr>
nnoremap <leader>vl :VimuxRunLastCommand<cr>
nnoremap <leader>vi :VimuxInspectRunner<cr>
nnoremap <leader>vq :VimuxCloseRunner<cr>
nnoremap <leader>vx :VimuxCLosePanes<cr>
nnoremap <leader>vs :VimuxInterruptRunner<cr>
nnoremap <leader>vc :VimuxClearRunnerHistory<cr>
vnoremap <LocalLeader>vs "vy :call VimuxRunCommand(@v . "\n")<CR>

" fugitive
nnoremap <leader>gs :Gstatus<cr>

let VimuxUseNearestPane = 1
let g:VimuxOrientation = "v"

" edit vimrc
nmap <leader>ec :e $MYVIMRC<CR>

" bring repeat into visual mode
vnoremap . :normal .<cr>

" turn of dang pylint
let g:syntastic_python_checker = 'flake8'
let g:syntastic_python_checker_args='--ignore=E501,E302'

" wildmode/menu
set wildmenu
set wildmode=list:longest,full

" defaults for all languages: 4 spaces, not tabs
setlocal tabstop=4
setlocal shiftwidth=4

" turn off white background in SignColumn
highlight clear SignColumn
