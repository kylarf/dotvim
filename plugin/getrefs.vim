function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    if (line2byte(line_start) + column_start) > (line2byte(line_end) + column_end)
        let [line_start, column_start, line_end, column_end] = [line_end, column_end, line_start, column_start]
    endif

    let lines = getline(line_start, line_end)

    if empty(lines)
        return ''
    endif

    let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    return join(lines, "\n")
endfunction

function! GetRefs(curword)
    let l:file_dir = expand('%:p:h')
    let l:cwd = getcwd()

    try
        let l:proj_dir = gutentags#get_project_root(l:file_dir)
    catch /^Vim\%(script\)\?:E605/
        echo "Not currently in a project!"
        return
    catch
        echo "Something went wrong!"
        throw v:exception
    endtry

    let l:vg_file = fnameescape(l:proj_dir . "/.vimgrep")

    if filereadable(l:vg_file)
        let l:files = join(readfile(l:vg_file), " ")
        let l:cmd = 'vimgrep /\V' . escape(a:curword, '/\') . "/gj " . l:files
    else
        let l:cmd = 'vimgrep /\V' . escape(a:curword, '/\') . "/gj `git ls-files`"
    endif

    execute 'cd ' . fnameescape(l:proj_dir)
    execute l:cmd
    copen
    execute 'cd ' . fnameescape(l:cwd)
endfunction

function! NormalGetRefs()
    let l:curword = expand('<cword>')
    call GetRefs(l:curword)
endfunction

function! VisualGetRefs()
    let l:curword = GetVisualSelection()
    execute "normal! \<Esc>"
    call GetRefs(l:curword)
endfunction

nnoremap gr :call NormalGetRefs()<CR>
xnoremap gr :<C-u>call VisualGetRefs()<CR>
