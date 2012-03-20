" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set nocompatible               " be iMproved
filetype off                   " required!

" find root path of my vimfiles
let $brookvim_root = expand("<sfile>:p")
set grepprg=grep\ -rsnI
let g:NERDTreeDirArrows = 0
if has("win32")
  let $brookvim_root = substitute($brookvim_root,"\\","\/","g")
  let $PATH='C:\cygwin\bin;'.$PATH
  let g:launchWebBrowser=":silent ! start "
elseif has("mac")
  set guifont=Menlo:h14
  let g:NERDTreeDirArrows = 1
  let g:launchWebBrowser=":silent ! open /Applications/Google\\ Chrome.app "
endif

if has("gui")
  source $VIMRUNTIME/mswin.vim
  set clipboard=unnamed
endif

let $brookvim_root = substitute($brookvim_root,"\/[^\/]*$","","")
" add it into runtimepath
" let &runtimepath = $brookvim_root.",".&runtimepath

let &runtimepath = $brookvim_root."/bundle/vundle/,".&runtimepath
call vundle#rc()
let g:bundle_dir = $brookvim_root."/bundle/"

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'actionscript.vim--Leider'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neocomplcache-snippets-complete'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'surround.vim'

filetype plugin indent on     " required! 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set number
set nobackup " do not keep a backup file, use versions instead
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set hlsearch    "hilight searches by default
set cursorline
set guioptions-=T "disable toolbar
set guioptions-=m "disable menu 
" set paste " cause abbreviate not working under linux/terminal

" automatic change directory to current buffer
"if exists('+autochdir')
  "set autochdir
"endif
set wildmenu
set laststatus=2
set statusline=%<%f\ %h%m%r\ \[%{&ff}:%{&fenc}:%Y]\ %{getcwd()}%{(g:cscope_db_root==getcwd()&&g:has_cscope_db==1)?'*':''}\ %=%-10{(&expandtab)?'ExpandTab-'.&tabstop:'NoExpandTab'}\ %=%-10.(%l,%c%V%)\ %P


syntax on
colorscheme desert
highlight CursorLine  term=standout cterm=bold ctermbg=lightgrey guibg=Grey40

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

function! ExpandTab(tabWidth)
  setl expandtab
  execute 'setl tabstop='.a:tabWidth
  execute 'setl shiftwidth='.a:tabWidth
  execute 'setl softtabstop='.a:tabWidth
  let @/="\t"
endfunction
let g:tabWidth = 4
function! ShiftTab()
  if &expandtab == 0
    call ExpandTab(g:tabWidth)
  else
    setl tabstop=8
    setl shiftwidth=8
    setl softtabstop=0
    setl noexpandtab
  endif
endfunction
nmap <S-TAB> :call ShiftTab()<cr>

" Read Ex-Command output to current buffer, for example, to read output of ls, just type --
" :Rex ls
function! ReadExCmd(exCmd)
  redi @x
  silent exec a:exCmd
  redi END
  exec "normal \"xp"
endfunction
com! -nargs=* -complete=command -bar Rx call ReadExCmd(<q-args>)

" extended key map
let mapleader = ","
nmap <leader>d "_d
nmap <silent> <leader>ve :e $brookvim_root/vimrc<CR>
nmap <silent> <leader>vs :so $brookvim_root/vimrc<CR>
nmap <silent> <leader>qa :qall!<cr>
nmap <silent> <leader>qb :CtrlPBuffer<CR>
nmap <silent> <leader>qf :CtrlPMRU<CR>
nmap <silent> <leader>qx :q!<CR>
nmap <silent> <leader>qi [I:let nr = input("Goto: ")<Bar>exe "normal " . nr ."[\t"<CR>
nmap <silent> <leader>nh :let @/=""<CR>
nmap <silent> <leader>sh :sp <cfile><CR>
nmap <silent> <leader>sv :vs <cfile><CR>
let t:NERDTreeRoot = ""
function! s:NERDTreeOpen(dir)
  if &bt == "" && expand("%") != ""
    NERDTreeFind
  else
    execute ':NERDTree '.a:dir
  endif
  let t:NERDTreeRoot = a:dir
endfunction
function! ToggleNERDTree(dir)
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && t:NERDTreeRoot == a:dir
    NERDTreeClose
  else
    call s:NERDTreeOpen(a:dir)
  endif
endfunction
nmap <silent> <leader>e :call ToggleNERDTree(getcwd())<CR>
nmap <silent> <leader>f :tabf <cfile><CR>
vmap <silent> <leader>f y:tabf <C-R>"<CR>
ino <C-C> <Esc>:s/=[^=]*$//g<CR>yiW$a=<C-R>=<C-R>0<CR>
nmap ^ /\c\<<C-R><C-W>\><CR>
set notimeout nottimeout
nmap <leader>i :let nr = input("/\\c")<Bar>:exe "/\\c" . nr<CR>
nmap <leader>j :reg<CR>:let nr = input(">\"")<Bar>exe "normal \"" . nr ."p"<CR>
ino <F5> <C-R>=strftime("%H:%M %Y/%m/%d")<CR>
noremap <silent> <Space>w :new<CR>
noremap <silent> <Space>q :q<CR>
noremap <silent> <Space>t :tabe<CR>


autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd FileType php        noremap <buffer> <leader>r :!php %<CR>
autocmd FileType python     noremap <buffer> <leader>r :!python %<CR>
autocmd FileType ruby       noremap <buffer> <leader>r :!ruby %<CR>
autocmd FileType perl       noremap <buffer> <leader>r :!perl %<CR>
autocmd FileType php        noremap <buffer> K :execute g:launchWebBrowser."http://jp.php.net/manual-lookup.php?pattern=".expand("<cword>")."&lang=zh&scope=quickref"<CR>
autocmd FileType vim        setlocal keywordprg=:help
autocmd FileType markdown   noremap <buffer> <leader>r :execute ':!Markdown.pl --html4tags % >'.expand('%:r').'.html'<CR>
autocmd FileType markdown,yaml   call ExpandTab(2)

noremap <leader>wt :execute g:launchWebBrowser."http://dict.baidu.com/s?wd=".expand("<cword>")<CR>
noremap <leader>wb :execute g:launchWebBrowser."http://www.baidu.com/s?wd=".expand("<cword>")<CR>

set cscopequickfix=s-,c-,d-,i-,t-,e-
let g:has_cscope_db = 0
let g:cscope_db_root = ""
function! CheckCscopeDB()
  let l:cwd = getcwd()
  if g:cscope_db_root != l:cwd
    let g:cscope_db_root = l:cwd
    let g:has_cscope_db = 0
    cs kill -1
    if filereadable("cscope.out")
      cs add cscope.out
      let g:has_cscope_db = 1
    endif
  endif
endfunction
function! MyGrep(word)
  let l:start = localtime()
  let @/='\<'.a:word.'\>'
  if strlen(a:word) > 0
    call CheckCscopeDB()
    if g:has_cscope_db == 1
      execute 'lcs find t '.a:word
      lw
    else
      execute 'lgrep "\<'.a:word.'\>" *'
      if len(getloclist(winnr())) > 0
        exec "normal \<C-O>"
        lw
      endif
    endif
  endif
  let l:end = localtime()
  let g:MyGrepTime = l:end - l:start
endfunction
function! ToggleLocationList()
  let l:own = winnr()
  lw
  let l:cwn = winnr()
  if(l:cwn == l:own)
    if &buftype == 'quickfix'
      lclose
    elseif len(getloclist(winnr())) > 0
      lclose
    else
      echohl WarningMsg | echo "No location list." | echohl None
    endif
  endif
endfunction

com! -nargs=? -bar L :call MyGrep(<q-args>)
nmap <leader>g :call MyGrep("<C-R><C-W>")<CR>
nmap <leader>l :call ToggleLocationList()<CR>

com! -nargs=1 C execute '%s/<args>//n'

function! LHelpGrep(word)
  if strlen(a:word) > 0
    execute 'lhelpgrep '.a:word
    lw
  endif
endfunction
com! -nargs=1 -bar H :call LHelpGrep(<q-args>)
function! HtmlImg()
  %s# #\ #g
  %s#^.*\(jpg\|png\|gif\)$#<img src="file://&">#
endfunction
com! -nargs=0 -bar HtmlImg :call HtmlImg()
com! -nargs=0 -bar Dos2Unix :%s/\r//g|set ff=unix
com! -nargs=0 -bar RmAllNL :%s/\n//g
com! -nargs=0 -bar RmDupLine :%s/^\(.*\)\n\1$/\1/g
com! -nargs=0 -bar ClearEmptyLine :g/^\s*$/d

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 1
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" ctrlp setup
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 25
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.exe$\|\.so$\|\.dll$|\.jpg$|\.png$|\.gif$|\.zip$|\.rar$|\.iso$',
      \ }
