set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set vb t_vb=

nmap <c-cr> i<cr><Esc>
inoremap <S-CR> <Esc>

" to save on shifting...
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;

" increment under screen/tmux
noremap <C-=> <C-A>

" Toggle lists of various kinds
nnoremap <silent> <F8> :NERDTreeToggle<CR>
nnoremap <silent> <F7> :TagbarToggle<CR>

" Tagbar options
let g:tagbar_left = 1
let g:tagbar_autoclose = 1
let g:tagbar_compact = 1
let g:tagbar_expand = 1
let g:tagbar_iconchars = ['▸', '▾']  " Defaults are HUGE

" Stop highlighting search results. I can use N just fine, thank you
map <silent> <C-N> :se invhlsearch<CR>

" Snippets
let g:snips_author = 'Brian Hicks <brian@brianthicks.com>'
