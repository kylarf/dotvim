function! StripTrailingWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufWritePre * if !&binary && exists('b:strip_whitespace') && b:strip_whitespace
            \ | call StripTrailingWhitespace() | endif
