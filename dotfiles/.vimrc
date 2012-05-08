set nocompatible

" Use pathogen to easily modify the runtime path to include all plugins
" under the ~/.vim/bundle directory
filetype off " force reloading after pathogen loaded
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" General custom Stuff

" It's easier for me to press than \
let mapleader=","

" Edit and source ~/.vimrc
nmap <silent> <leader>ev :e ~/.vimrc<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>

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
inoremap jj <Esc>
inoremap jk <Esc>
" ... in graphical mode
inoremap <s-cr> <Esc>
vnoremap <s-cr> <Esc>

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Make searching better
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#making-vim-more-useful
nnoremap / /\v
vnoremap / /\v
set gdefault

" matching characters. Tab is easier than %. Steve Losh again.
nnoremap <tab> %
vnoremap <tab> %

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
