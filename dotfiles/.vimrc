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
  colorscheme mustang
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
nnoremap <leader>w <C-w>s

" better yank/paste to OS clipboard
nmap <leader>y "+y
nmap <leader>Y "+Y
nmap <leader>p "+p
nmap <leader>P "+P

" Formatting for the current par or selection
vmap Q gq
nmap Q gqap

" Get out of insertmode free
inoremap jj <Esc>
inoremap jk <Esc>

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Sometimes I forget to sudo.
cmap w!! w !sudo tee % >/dev/null

set pastetoggle=<F2>
