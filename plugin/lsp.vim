let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1

if executable('pylsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'configurationSources': ['flake8'],
        \ 'allowlist': ['python'],
        \ 'workspace_config': {
        \   'pylsp': {
        \     'configurationSources': ['flake8'],
        \     'plugins': {
        \       'flake8': {'enabled': v:true},
        \       'pylsp_mypy': {'enabled': v:true, 'live_mode': v:true},
        \       'pycodestyle': {'enabled': v:false},
        \       'mccabe': {'enabled': v:false},
        \       'pyflakes': {'enabled': v:false}
        \     }
        \   }
        \ },
        \ })
endif

if executable('nimlangserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'nimlangserver',
        \ 'cmd': {server_info->['nimlangserver']},
        \ 'allowlist': ['nim'],
        \ })
endif

if executable('ebnfer')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ebnfer',
        \ 'cmd': {server_info->['ebnfer']},
        \ 'allowlist': ['ebnf']
        \ })
endif


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    autocmd FileType qf nmap <buffer> [g :lprevious<CR><C-w>p
    autocmd FileType qf nmap <buffer> ]g :lnext<CR><C-w>p
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> <leader>g <plug>(lsp-document-diagnostics)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
