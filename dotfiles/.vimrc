set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" Useful bundles
Bundle "LustyJuggler"
Bundle "ddollar/nerdcommenter"
Bundle "epeli/slimux"
Bundle "ervandew/supertab"
Bundle "jszakmeister/vim-togglecursor"
Bundle "kien/ctrlp.vim"
Bundle "mileszs/ack.vim"
Bundle "paredit.vim"
Bundle "terryma/vim-multiple-cursors"
Bundle "tpope/vim-eunuch"
Bundle "tpope/vim-fugitive.git"
Bundle "tpope/vim-surround"
Bundle "tpope/vim-unimpaired"
Bundle "tristen/vim-sparkup"

" Highlighting Bundles
Bundle "anzaika/go.vim"
Bundle "cakebaker/scss-syntax.vim"
Bundle "chriskempson/base16-vim"
Bundle "derekwyatt/vim-scala"
Bundle "digitaltoad/vim-jade"
Bundle "pangloss/vim-javascript"
Bundle "plasticboy/vim-markdown"
Bundle "python.vim"
Bundle "rdolgushin/play.vim"
Bundle "saltstack/salt-vim"
Bundle "yaml.vim"

filetype plugin indent on

" Niceities
syntax on
set number
if &t_Co >= 256 || has("gui_running")
    colorscheme base16-tomorrow

    " lustyjuggler doesn't have enough differentiation in this scheme - BOLD!
    highlight Question cterm=underline
endif

" Shortcuts
let mapleader=","
nnoremap <leader>ev :e ~/.vimrc<CR>
nnoremap ; :
vnoremap ; :
nnoremap : ;
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
inoremap kj <Esc>

" Easier window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <leader>w <C-w>s<C-w>j

" Really quick buffer jumps
nnoremap <Space> :LustyJugglePrevious<CR>
nnoremap <leader><Space> :LustyJuggler<CR>

" Ctrl-P keybindings
let g:ctrlp_map = "<C-p><C-p>"
nnoremap <C-p><C-b> :CtrlPBuffer<CR>
nnoremap <C-p><C-t> :CtrlPTag<CR>
nnoremap <C-p><C-l> :CtrlPLine<CR>

" Fugitive
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gm :Gmove 
nnoremap <leader>gd :Gremove<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>goo :Gbrowse<CR>
nnoremap <leader>goc :Gbrowse!<CR>

" vim-multiple-cursors
let g:multi_cursor_next_key="<C-n>"
let g:multi_cursor_prev_key="<C-p>"
let g:multi_cursor_skip_key="<C-x>"
let g:multi_cursor_quit_key="<Esc>"

" slimux
nnoremap <Leader>a :SlimuxShellLast<CR>
nnoremap <Leader>A :SlimuxShellPrompt<CR>
nnoremap <Leader>s :SlimuxREPLSendLine<CR>
vnoremap <Leader>s :SlimuxREPLSendSelection<CR>

" Make searching better
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#making-vim-more-useful
nnoremap / /\v
vnoremap / /\v

" Formatting for the current par or selection
vmap Q gq
nmap Q gqap

set nobackup
set noswapfile

" tags
set tags=.git/tags

" bring repeat into visual mode
vnoremap . :normal .<cr>

" wildmode/menu
set wildmenu
set wildmode=list:longest,full

" defaults for all languages: 4 spaces, not tabs
setlocal tabstop=4
setlocal shiftwidth=4

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
