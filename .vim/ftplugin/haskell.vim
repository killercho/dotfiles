nnoremap ! :call Runhaskell()<cr>

func Runhaskell()
    let s:name = expand('%:t')
    exe ':!runhaskell ' . s:name
endfunc
