" Basic misc configuration
set nocompatible
set fileformat=unix
syntax on
set number
set incsearch
set laststatus=2
set autochdir
set clipboard=unnamed
set showcmd

" Indentation and tabstops
set autoindent
set shiftwidth=4 smarttab
set expandtab
filetype plugin indent on

" Misc keybinds
nnoremap Y y$
nnoremap <leader>o o<ESC>
nnoremap <leader>O O<ESC>
nnoremap <leader>e :Explore<CR>
nnoremap <C-W>F <C-W>vgf
nnoremap <C-W>[ <C-W>v<C-]>
nnoremap <C-W>g[ <C-W>vg]

" Ctags configuration
let g:gutentags_project_root = ['.gutctags']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_resolve_symlinks = 1
set statusline=%<%f\ %h%m%r%=%-14.(Ln\ %l/%L,\ Col\ %c%V%)\ \|\ %P\ %{gutentags#statusline('(',')')}
set tags=./.tags;,.tags
nmap <leader>t :TagbarOpenAutoClose<CR>
let g:tagbar_position = 'vertical rightbelow'


" Buffer navigation
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
nnoremap <leader>bb :ls<CR>:buffer<Space>
nnoremap <leader>bd :ls<CR>:bd<Space>

" Tab setup
nnoremap tt :tabnew<CR>
nnoremap tq :tabclose<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>

" Color scheme configuration
" if !exists("$TMUX")
"     if has('termguicolors')
"         set termguicolors
"     else
"         let g:gruvbox_termcolors=16
"     endif
" endif

set termguicolors

set background=light
let g:gruvbox_contrast_light='medium'
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" Make cursor change between normal/insert modes
if !has('nvim')
    " Change cursor shapes based on whether we are in insert mode,
    " see https://vi.stackexchange.com/questions/9131/i-cant-switch-to-cursor-in-insert-mode
    let &t_SI = "\<esc>[6 q"
    let &t_EI = "\<esc>[2 q"
    if exists('&t_SR')
        let &t_SR = "\<esc>[4 q"
    endif

    " The number of color to use
    set t_Co=256
endif

" Quickfix list settings
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <leader>m :make %<CR><CR><CR>

nnoremap <silent> <leader>f :call ToggleQuickFix()<CR>
nnoremap ]f :cnext<CR>
nnoremap [f :cprev<CR>
autocmd filetype qf wincmd J
