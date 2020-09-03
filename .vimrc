" set compatibility and file checks ASAP
set nocompatible
filetype plugin indent on
syntax on

set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set ignorecase
set autoindent
set ruler
set showcmd
set visualbell
" uncomment next line to complete disable bell functionality
" set t_vb=
set nostartofline
" use ':' to enable selecting in visual mode
set mouse=nvh

" experiment with this a while....
set cmdheight=2

" make this the general option, see how it works; keep
" the locals below, in case we remove or change this
set foldmethod=indent
set foldcolumn=5
highlight clear foldcolumn
highlight foldcolumn ctermbg=black guibg=black

highlight Comment ctermfg=DarkGrey guifg=DarkGrey cterm=underline

" unclear whether this should be packadd or runtime, but this works....
packadd! matchit
" not sure if we want this, try for a file, learn....
runtime! macros/editexisting.vim

autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0 foldmethod=indent
autocmd FileType yaml setlocal sw=2 softtabstop=2 tabstop=2 foldmethod=indent
autocmd FileType python setlocal foldmethod=indent 


