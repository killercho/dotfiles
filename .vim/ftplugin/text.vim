"au BufWrite *

nnoremap ! :call Test()<cr>

func Test()
    echo 'TEXT FILE THIS IS'
endfunc
