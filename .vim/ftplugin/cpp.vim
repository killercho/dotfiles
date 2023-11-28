nnoremap ! :call CompileFileCpp()<cr>

func CompileFileCpp()
    let s:name = expand('%:t')
    exe ':!g++ ' . s:name . ' && ./a.out'
endfunc
