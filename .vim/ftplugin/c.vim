nnoremap ! :call CompileFileC()<cr>

func CompileFileC()
    let s:name = expand('%:t')
    exe ':!gcc ' . s:name . ' && ./a.out'
endfunc
