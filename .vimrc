" ordered as per https://vim.fandom.com/wiki/Example_vimrc 
set nocompatible
filetype plugin indent on
syntax on

set ignorecase
set smartcase
set hlsearch
set backspace=indent,eol,start
set autoindent
"set nostartofline
set ruler
"set laststatus=2
"set confirm
set showcmd
set visualbell
"set t_vb=
set mouse=nvh
set cmdheight=2
"set number
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

highlight Comment ctermfg=DarkGrey guifg=DarkGrey cterm=underline

packadd! matchit
runtime! macros/editexisting.vim

autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType yaml setlocal sw=2 softtabstop=2 tabstop=2


