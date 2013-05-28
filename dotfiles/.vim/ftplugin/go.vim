set noexpandtab
set tabstop=4

function! Goformat()
    let regel=line(".")
    %!gofmt
    call cursor(regel, 1)
endfunction
command! Fmt call Goformat()
