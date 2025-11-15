nnoremap <leader>d :Shell python -m pydoc
setlocal omnifunc=syntaxcomplete#Complete
let b:strip_whitespace=1
compiler pylint
let &l:keywordprg='python -m pydoc'
