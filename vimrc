" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set nocompatible
set number
set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch    "hilight searches by default
set cursorline
syntax on
colorscheme desert

" set paste " cause abbreviate not working under linux/terminal

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif


" find root path of my vimfiles
let $brookvim_root = expand("<sfile>:p")
if has("win32")
  let $brookvim_root = substitute($brookvim_root,"\\","\/","g")
  source $VIMRUNTIME/mswin.vim
endif
let $brookvim_root = substitute($brookvim_root,"\/[^\/]*$","","")
" add it into runtimepath
let &runtimepath = $brookvim_root.",".&runtimepath

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

if has("gui_mac") || has("gui_macvim")
  set guifont=Menlo:h14
  let g:NERDTreeDirArrows = 1
else
  let g:NERDTreeDirArrows = 0
endif

filetype off
if has('ruby') == 0
  let g:pathogen_disabled = ["command-t"]
endif
call pathogen#infect() 
filetype plugin indent on

" extended key map
let mapleader = ","
nmap <silent> <leader>ve :e $brookvim_root/vimrc<CR>
nmap <silent> <leader>vs :so $brookvim_root/vimrc<CR>
nmap <silent> <leader>qa :qall!<cr>
nmap <silent> <leader>d :%s/^\(.*\)\n\1$/\1/g<CR>
nmap <silent> <leader>j :%s/\n//g<CR>
nmap <silent> <leader>c :g/^\s*$/d<CR>
map <silent> <leader>e :NERDTreeToggle<CR>
map <silent> <leader>f :tabf <cfile><CR>
map <silent> <leader>s :sf <cfile><CR>

map <silent> <Space>q :q<CR>
map <silent> <Space>t :tabe<CR>

cabbrev lvg
      \ lvim /\<lt><C-R><C-W>\>/gj
      \ **/*<C-R>=(expand("%:e")=="" ? "" : ".".expand("%:e"))<CR>
      \ <Bar> lw
      \ <C-Left><C-Left><C-Left>
nmap <leader>g :lvg<CR>
nmap <leader>lo :lop<CR>
nmap <leader>lc :lcl<CR>

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 1
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
