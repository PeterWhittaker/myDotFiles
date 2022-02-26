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

" always show a status line
set laststatus=2

" wrap to the next/previous line when navigating
set whichwrap=h,l,<,>

" show tabs and trailing spaces
set listchars=tab:>-,trail:·
set list

" comment formatting
" c - format comments
" r - when editing a comment, automatically insert the comment leader after <enter>
" o - [oO] on comment line creates new comment line below/above
" q - format comments with gq
" j - automatically remove comment marker when joining comment lines
set fo=croqj
" not sure if I like autoformatting 
"set fo+=a

" show command completions?
set wildmenu
" experiment with this a while....
set cmdheight=2

" display a count of search matches
" NOTE: requires vim > 8 (?) but harmless on lower versions,
" e.g., on some of the older Linux VMs
set shortmess-=S

" highlight search results
set hlsearch
" even as we type
set incsearch

" centre search results
"set scrolloff=999

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
