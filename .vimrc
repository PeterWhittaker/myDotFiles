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

" display a count of matched patterns - oddly, the simplest way to do
" this that works across all my platforms (so far) is to disable them S
" message - which enables display the count - by turning off turning it
" off. Note that the commented-out alternative on the line following
" works everywhere but MacOS (right now; it has vim81; most other boxes
" appear to have vim82)
set shortmess-=S
"set shortmess=

" make this the general option, see how it works; keep
" the locals below, in case we remove or change this
set foldmethod=indent
set foldcolumn=5
highlight clear foldcolumn
highlight foldcolumn ctermbg=black guibg=black

highlight Comment ctermfg=DarkGrey guifg=DarkGrey cterm=underline

map [5~ :bp
map [6~ :bn

" add Ss to search for and highlight UNIX/Linux paths
command! -nargs=1 Ss let @/ = <q-args>|set hlsearch

" this was 'packadd', but it fails with vim on RHEL 7.[78]; use runtime
runtime! matchit
" not sure if we want this, try for a file, learn....
runtime! macros/editexisting.vim

" remove all autocmds, in case .vimrc is loaded twice, e.g., buffer jumping
" except that this broke my syntax highlighting when in modifiable mode
"autocmd!
" now define our autocmds
autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0 foldmethod=indent
autocmd FileType yaml setlocal sw=2 softtabstop=2 tabstop=2 foldmethod=indent
autocmd FileType python setlocal foldmethod=indent 
autocmd FileType c setlocal foldmethod=syntax

" Disable folds in readonly mode
" this works really well
autocmd VimEnter * if !&modifiable | set nofoldenable | endif
" this is how I used to do this, but is use-case specific
"autocmd StdinReadPost * set foldmethod=manual
" another use-case specific experiment
" autocmd StdinReadPost * set nofoldenable
" hmm, I am tempted by this one too
"set foldmethod=manual
