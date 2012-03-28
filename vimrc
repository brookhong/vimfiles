" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab foldmethod=marker

" general settings {{{
set nocompatible
set grepprg=grep\ -rsnI
set nobackup " do not keep a backup file, use versions instead
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set hlsearch    "hilight searches by default
set cursorline
set guioptions-=T "disable toolbar
set guioptions-=m "disable menu 
set notimeout nottimeout
set wildmenu
set laststatus=2
set statusline=%<%f\ %h%m%r\ \[%{&ff}:%{&fenc}:%Y]\ %{getcwd()}%{(g:cscope_db_root==getcwd()&&g:has_cscope_db==1)?'*':''}\ %=%-10{(&expandtab)?'ExpandTab-'.&tabstop:'NoExpandTab'}\ %=%-10.(%l,%c%V%)\ %P
syntax on

" set number
" set paste " cause abbreviate not working under linux/terminal
" automatic change directory to current buffer
"if exists('+autochdir')
  "set autochdir
"endif
" }}}

" OS-specific {{{
" find root path of my vimfiles
let $brookvim_root = expand("<sfile>:p:h")
let g:NERDTreeDirArrows = 0
if has("win32")
  let $brookvim_root = substitute($brookvim_root,"\\","\/","g")
  let $PATH='C:\cygwin\bin;'.$PATH
  let g:launchWebBrowser=":silent ! start "
elseif has("mac")
  set guifont=Menlo:h14
  let g:NERDTreeDirArrows = 1
  let g:launchWebBrowser=":silent ! open /Applications/Google\\ Chrome.app "
elseif has("unix")
  let g:launchWebBrowser=":silent ! /opt/chrome/chrome-wrapper "
endif
" add it into runtimepath
let &runtimepath = $brookvim_root.",".&runtimepath
" }}}

" UI-specific {{{
if has("gui")
  source $VIMRUNTIME/mswin.vim
  set clipboard=unnamed
  nnoremap <C-Right> gt
  nnoremap <C-Left> gT
  nnoremap <C-Up> <C-W>k
  nnoremap <C-Down> <C-W>j
  nnoremap <S-LeftMouse> <LeftMouse>:call MyGrep(expand("<cword>"))<CR>

  let s:schemeList=["desert", "darkspectrum","desert256",
    \"ir_black","moria","slate"]
  let s:random=substitute(localtime(),'\d','&+','g')
  let s:random=eval(substitute(s:random,'\(.*\)+$','(\1)%'.len(s:schemeList),''))
  let g:myScheme=s:schemeList[s:random]
  exec "colorscheme ".s:schemeList[s:random]
else
  nnoremap [5C gt
  nnoremap [5D gT
  nnoremap OA <C-W>k
  nnoremap OB <C-W>j

  set t_Co=256
  colorscheme desert
  highlight CursorLine  term=standout cterm=bold
  highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
  highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black 
  highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black 
  highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black
endif
" }}}

" extended key map {{{
let mapleader = ","
nnoremap ^ /\c\<<C-R><C-W>\><CR>
nnoremap <S-TAB> :call ShiftTab()<cr>
nnoremap <leader>d "_d
nnoremap <silent> <leader>ve :e $brookvim_root/vimrc<CR>
nnoremap <silent> <leader>vs :so $brookvim_root/vimrc<CR>
nnoremap <silent> <leader>qa :qall!<cr>
nnoremap <silent> <leader>qb :CtrlPBuffer<CR>
nnoremap <silent> <leader>qf :CtrlPMRU<CR>
nnoremap <silent> <leader>qx :q!<CR>
nnoremap <silent> <leader>qi [I:let nr = input("Goto: ")<Bar>exe "normal " . nr ."[\t"<CR>
nnoremap <silent> <leader>qc :e!<Esc>ggdG<CR>
nnoremap <silent> <leader>qd :Gdiff<CR>
nnoremap <silent> <leader>qs :mksession! $HOME/_session.vim<Bar>qall!<CR>
nnoremap <silent> <leader>ql :source $HOME/_session.vim<CR>
nnoremap <silent> <leader>ya :let @z=""<Bar>:let nr=input("Yank all lines with PATTERN to register Z >")<Bar>:exe ":g/".nr."/normal \"ZY\<CR\>"<CR>
nnoremap <silent> <leader>nh :let @/=""<CR>
nnoremap <silent> <leader>sh :sp <cfile><CR>
nnoremap <silent> <leader>sv :vs <cfile><CR>
nnoremap <leader>i :let nr = input("/\\c")<Bar>:exe "/\\c" . nr<CR>
nnoremap <leader>j :reg<CR>:let nr = input(">\"")<Bar>exe "normal \"" . nr ."p"<CR>
nnoremap <leader>m :marks<CR>:let nr = input(">`")<Bar>exe "normal `" . nr<CR>
nnoremap <silent> <Space>w :new<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>t :tabe<CR>
nnoremap <leader>wt :execute g:launchWebBrowser."http://dict.baidu.com/s?wd=".expand("<cword>")<CR>
nnoremap <leader>wb :execute g:launchWebBrowser."http://www.baidu.com/s?wd=".expand("<cword>")<CR>
nnoremap <leader>wl :execute g:launchWebBrowser.expand("<cWORD>")<CR>
nnoremap <leader>g :call MyGrep("<C-R><C-W>")<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
nnoremap <silent> <leader>e :call ToggleNERDTree(getcwd())<CR>
nnoremap <silent> <leader>f :tabf <cfile><CR>
vnoremap <silent> <leader>f y:tabf <C-R>"<CR>
inoremap <F5> <C-R>=strftime("%H:%M %Y/%m/%d")<CR>
inoremap <C-C> <Esc>:s/=[^=]*$//g<CR>yiW$a=<C-R>=<C-R>0<CR>
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}

" autocmds {{{
autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd FileType php        nnoremap <buffer> <leader>r :!php %<CR>
autocmd FileType python     nnoremap <buffer> <leader>r :!python %<CR>
autocmd FileType ruby       nnoremap <buffer> <leader>r :!ruby %<CR>
autocmd FileType perl       nnoremap <buffer> <leader>r :!perl %<CR>
autocmd FileType php        nnoremap <buffer> K :execute g:launchWebBrowser."http://jp.php.net/manual-lookup.php?pattern=".expand("<cword>")."&lang=zh&scope=quickref"<CR>
autocmd FileType vim        setlocal keywordprg=:help
autocmd FileType markdown   nnoremap <buffer> <leader>r :execute ':!Markdown.pl --html4tags % >'.expand('%:r').'.html'<CR>
autocmd FileType markdown,yaml   call ExpandTab(2)
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
" }}}

" custom commands {{{
com! -nargs=1 -bar H :call LHelpGrep(<q-args>)
com! -nargs=* -complete=command -bar Rx call ReadExCmd(<q-args>)
com! -nargs=? -bar L :call MyGrep(<q-args>)
com! -nargs=0 -bar HtmlImg :call HtmlImg()
com! -nargs=0 -bar Dos2Unix :%s/\r//g|set ff=unix
com! -nargs=0 -bar RmAllNL :%s/\n//g
com! -nargs=0 -bar RmDupLine :%s/^\(.*\)\n\1$/\1/g
com! -nargs=0 -bar ClearEmptyLine :g/^\s*$/d
com! -nargs=1 C execute '%s/<args>//n'
com! -range TrailBlanks :call TrailBlanks(<line1>, <line2>)
" }}}

" expandtab functions {{{
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
" }}}

" Read Ex-Command output to current buffer, for example, to read output of ls, just type -- {{{
" :Rex ls
function! ReadExCmd(exCmd)
  redi @x
  silent exec a:exCmd
  redi END
  exec "normal \"xp"
endfunction
" }}}

" MyGrep functions {{{
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
" }}}

" misc functions {{{
function! LHelpGrep(word)
  if strlen(a:word) > 0
    execute 'lhelpgrep '.a:word
    lw
  endif
endfunction
function! HtmlImg()
  %s# #\ #g
  %s#^.*\(jpg\|png\|gif\)$#<img src="file://&">#
endfunction

function! TrailBlanks(s, e)
  let l:cols = []
  exec a:s.','.a:e."g/^/call add(cols, col('$'))"
  let l:maxCol = max(cols)
  exec a:s.','.a:e."g/^/let n=l:maxCol-col('$') | exec 'normal '.n.'A '"
endfunction
" }}}

" plugins {{{
filetype off
let &runtimepath = $brookvim_root."/bundle/vundle/,".&runtimepath
call vundle#rc()
let g:bundle_dir = $brookvim_root."/bundle/"
Bundle 'gmarik/vundle'
Bundle 'actionscript.vim--Leider'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neocomplcache-snippets-complete'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'surround.vim'
Bundle 'DBGp-client'
filetype plugin indent on

" nerdtree setup
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

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 1

" ctrlp setup
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 25
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.exe$\|\.so$\|\.dll$|\.jpg$|\.png$|\.gif$|\.zip$|\.rar$|\.iso$',
      \ }
" }}}
