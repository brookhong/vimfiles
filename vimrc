" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab
" find root path of my vimfiles
let $brookvim_root = expand("<sfile>:p")
if has("windows")
  let $brookvim_root = substitute($brookvim_root,"\\","\/","g")
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin
endif
let $brookvim_root = substitute($brookvim_root,"\/[^\/]*$","","")
" add it into runtimepath
let &runtimepath = $brookvim_root.",".&runtimepath

set nocompatible
syntax on
set paste

set nobackup
function! ShiftTab()
  if &expandtab == 0
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  else
    set tabstop=8
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  endif
endfunction
map <S-TAB> :call ShiftTab()<cr>

" Read Ex-Command output to current buffer, for example, to read output of ls, just type -- 
" :Rex ls
function! ReadExCmd(exCmd)
  redi @+
  silent exec a:exCmd
  redi END
  exec "normal \"+p"
endfunction 
com! -nargs=* Rex call ReadExCmd(<f-args>)

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
