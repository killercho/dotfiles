nnoremap ! :call CompileFile()<cr>

func CompileFile()
    let s:name = expand('%:t')
    exe ':!gcc ' . s:name . ' && ./a.out'
endfunc
