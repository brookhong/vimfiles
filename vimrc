" find root path of my vimfiles
let $brookvim_root = expand("<sfile>:p")
if has("windows")
  let $brookvim_root = substitute($brookvim_root,"\\","\/","g")
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin
  set nobackup
endif
let $brookvim_root = substitute($brookvim_root,"\/[^\/]*$","","")
" add it into runtimepath
let &runtimepath = $brookvim_root.",".&runtimepath

set nocompatible
syntax on
set paste

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

if has("gui_mac") || has("gui_macvim")
  set guifont=Menlo:h14
endif

filetype off
call pathogen#infect() 

filetype plugin on
filetype indent on

colorscheme desert
"colorscheme desert256
set cursorline

" extended key map
let mapleader=","
nmap <silent> <leader>ev :e $brookvim_root/vimrc<CR>
nmap <silent> <leader>sv :so $brookvim_root/vimrc<CR>
nmap <silent> <leader>qa :qall!<cr>
nmap <silent> <leader>d :%s/^\(.*\)\n\1$/\1/g<CR>
nmap <silent> <leader>j :%s/\n//g<CR>
nmap <silent> <leader>c :g/^\s*$/d<CR>

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 1
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
