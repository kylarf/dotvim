" Custom omni‑completion function for tag completion with extra tag source info.
function! CustomTagComplete(findstart, base) abort
  if a:findstart
    " Get the current line and current column.
    let line = getline('.')
    let colpos = col('.')
    " Start scanning backward from one character before the cursor.
    let start = colpos - 1
    " Allow alphanumerics, underscores, dot, dash, and >.
    while start > 0 && line[start - 1] =~ '[0-9A-Za-z_\.>\-]'
      let start -= 1
    endwhile

    " Extract the token from the computed start up to the cursor position.
    let token = line[start : colpos - 1]
    " Find the last occurrence of "->" and "." in the token.
    let pos_arrow = strridx(token, '->')
    let pos_dot   = strridx(token, '.')
    " If no accessor is present, return the original start.
    if pos_arrow == -1 && pos_dot == -1
      return start
    else
      " If both are present, use the one that appears later.
      if pos_arrow > pos_dot
        return start + pos_arrow + 2
      else
        return start + pos_dot + 1
      endif
    endif
  else
    " ----------------------------
    " Process the completion items.
    "
    " Compute the last occurrence of "->" and of "." in the base.
    let pos_arrow = strridx(a:base, '->')
    let pos_dot   = strridx(a:base, '.')
    if pos_arrow != -1 || pos_dot != -1
      " If both are present, use whichever appears later.
      if pos_arrow > pos_dot
        let search_base = a:base[pos_arrow + 2:]
      else
        let search_base = a:base[pos_dot + 1:]
      endif
      " When an accessor is present, restrict completions to methods/functions.
      let only_methods = 1
    else
      let search_base = a:base
      let only_methods = 0
      " Return no completions if nothing’s typed.
      if search_base ==# ''
        return []
      endif
    endif

    " Build a very literal (nomagic) pattern from the base.
    let pattern = '^' . '\V' . escape(search_base, '\\')
    " Use Vim's taglist() to get matching tags.
    let tag_items = taglist(pattern)
    let completions = []

    for tag in tag_items
      " If in member-accessor context, filter only for methods.
      if only_methods
        if !((has_key(tag, 'kind') && (tag.kind =~? '^f$')) || has_key(tag, 'class') || has_key(tag, 'struct') || has_key(tag, 'enum'))
          continue
        endif
      endif

      " Create a dictionary for each completion item.
      let item = {}
      " 'word' will be inserted upon completion.
      let item.word = tag.name

      " keep duplicates
      let item.dup = 1

      " Try to get the tag kind (if available).
      if has_key(tag, 'kind') && tag.kind != ''
        let kind = tag.kind
      else
        let kind = ''
      endif

      " Determine the tag's source: try 'filename' (or fall back to 'file').
      if has_key(tag, 'filename') && tag.filename != ''
        let source = tag.filename
      elseif has_key(tag, 'file') && tag.file != ''
        let source = tag.file
      else
        let source = 'unknown'
      endif

      if has_key(tag, 'class') && tag.class != ''
        let source = 'in ' . tag.class . ' | ' . source
      endif

      " Set up the 'menu' key to display the kind (if any) and the source file.
      if kind != ''
        let item.menu = '[' . kind . '] ' . source
      else
        let item.menu = source
      endif

      " Add this item to the completions list.
      call add(completions, item)
    endfor

    return completions
  endif
endfunction

set completeopt=longest,menuone
let g:gutentags_resolve_symlinks = 1
