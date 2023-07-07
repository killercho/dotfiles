nnoremap ! :call Runpython()<cr>

func Runpython()
    let s:name = expand('%:t')
    exe ':!python ' . s:name
endfunc
