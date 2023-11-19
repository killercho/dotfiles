nnoremap ! :call CompileFile()<cr>

func CompileFile()
    let s:name = expand('%:t')
    exe ':!sh ' . s:name
endfunc
