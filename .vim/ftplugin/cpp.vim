nnoremap ! :call CompileFile()<cr>

func CompileFile()
    let s:name = expand('%:t')
    exe ':!g++ ' . s:name . ' && ./a.out'
endfunc
