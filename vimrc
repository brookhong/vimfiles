" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab foldmethod=marker
" ff=unix

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
set statusline=%<%f\ %h%m%r\ \[%{&ff}:%{&fenc}:%Y]\ %{getcwd()}\ %=%-10{bufnr('%').((&expandtab)?'-ET'.&tabstop:'-TAB')}\ %=%-10.(%l,%c%V%)\ %P
set list
set listchars=tab:>-,trail:-
set fileformat=unix
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
  let g:cscope_cmd = 'D:/tools/vim/cscope.exe'
  let $brookvim_root = substitute($brookvim_root,"\\","\/","g")
  if $PATH !~ "\\c.cygwin.bin"
    let $PATH='C:\cygwin\bin;'.$PATH
  endif
  let g:launchWebBrowser=":silent ! start "
elseif has("mac")
  set guifont=Menlo:h14
  let g:NERDTreeDirArrows = 1
  let g:launchWebBrowser=":silent ! open /Applications/Google\\ Chrome.app "
  let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
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

  let s:schemeList=["desert", "darkspectrum","desert256","moria"]
  let s:random=substitute(localtime(),'\d','&+','g')
  let s:random=eval(substitute(s:random,'\(.*\)+$','(\1)%'.len(s:schemeList),''))
  let g:myScheme=s:schemeList[s:random]
  exec "colorscheme ".s:schemeList[s:random]
else
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
nnoremap <S-TAB> :call <SID>ExpandTab(0)<cr>
inoremap <S-TAB> <C-O>:call <SID>ExpandTab(0)<cr>
nnoremap <leader>d "_d
nnoremap Y y$
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
nnoremap <silent> <leader>sl :let &list=!&list<CR>
nnoremap <silent> <leader>t :Tlist<CR>
nnoremap <leader>i :let nr = input("/\\c")<Bar>:exe "/\\c" . nr<CR>
nnoremap <leader>j :reg<CR>:let nr = input(">\"")<Bar>exe "normal \"" . nr ."p"<CR>
nnoremap <leader>m :marks<CR>:let nr = input(">`")<Bar>exe "normal `" . nr<CR>
nnoremap <silent> <space>w :new<CR>
nnoremap <silent> <space>v :vnew<CR>
nnoremap <silent> <space>q :q<CR>
nnoremap <silent> <space>t :tabe<CR>
nnoremap <silent> <leader>, :call <SID>ReadExCmd(1, "topleft 20", "!sdcv -n --data-dir /mnt/d/tools/sdcv/stardict-oxford-gb-formated-2.4.2/ ".expand("<cword>"))<CR>
nnoremap <silent> <space>, :call <SID>CloseConsole()<CR>
nnoremap <leader>wt :execute 'Translate '.expand("<cword>")<CR>
nnoremap <leader>wb :execute g:launchWebBrowser."http://www.baidu.com/s?wd=".expand("<cword>")<CR>
nnoremap <leader>wl :execute g:launchWebBrowser.expand("<cWORD>")<CR>
nnoremap <leader>g :call <SID>MyGrep("<C-R><C-W>")<CR>
nnoremap <silent> <leader>e :call <SID>ToggleNERDTree(getcwd())<CR>
nnoremap <silent> <space>f :tabf <cfile><CR>
vnoremap <silent> <space>f y:tabf <C-R>"<CR>
inoremap <F5> <C-R>=strftime("%H:%M %Y/%m/%d")<CR>
inoremap <C-C> <Esc>:s/=[^=]*$//g<CR>yiW$a=<C-R>=<C-R>0<CR>
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}

" autocmds {{{
autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd BufRead,BufNewFile *.json set filetype=javascript
autocmd FileType php        nnoremap <buffer> <leader>r :!php %<CR>
autocmd FileType python     nnoremap <buffer> <leader>r :!python %<CR>
autocmd FileType ruby       nnoremap <buffer> <leader>r :!ruby %<CR>
autocmd FileType perl       nnoremap <buffer> <leader>r :!perl %<CR>
autocmd FileType html       nnoremap <buffer> <leader>r :execute g:launchWebBrowser.expand("%")<CR>
autocmd FileType php        nnoremap <buffer> K :execute g:launchWebBrowser."http://jp.php.net/manual-lookup.php?pattern=".expand("<cword>")."&lang=zh&scope=quickref"<CR>
autocmd FileType vim        setlocal keywordprg=:help
autocmd FileType markdown   nnoremap <buffer> <leader>r :execute ':!Markdown.pl --html4tags % >'.expand('%:r').'.html'<CR>
autocmd FileType markdown,yaml   call <SID>ExpandTab(2)
autocmd BufReadPost * if &buftype=='quickfix' | setlocal statusline=%q%{(exists('w:quickfix_title'))?'-'.(w:quickfix_title):''}\ %=%-10.(%l,%c%V%) | endif
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
autocmd CmdwinEnter * map <buffer> <F5> <CR>q:

autocmd BufEnter * if &buftype=="nofile" && winbufnr(2) == -1 && bufname('%') == ">-brook's console<-" | quit | endif
" }}}

" custom commands {{{
com! -nargs=1 -bar H :call <SID>LHelpGrep(<q-args>)
com! -nargs=* -complete=command -bar Ri call <SID>ReadExCmd(0, "botri 10", <q-args>)
com! -nargs=* -complete=command -bar Rc call <SID>ReadExCmd(1, "botri 10", <q-args>)
com! -nargs=* -complete=file -bar Vsd call <SID>Vsd("<args>")
com! -nargs=? -bar L :call <SID>MyGrep(<q-args>)
com! -nargs=0 -bar HtmlImg :call <SID>HtmlImg()
com! -nargs=0 -bar Dos2Unix :%s/\r//g|set ff=unix
com! -nargs=0 -bar RmAllNL :%s/\n//g
com! -nargs=0 -bar RmDupLine :%s/^\(.*\)\n\1$/\1/g
com! -nargs=0 -bar ClearEmptyLine :g/^\s*$/d
com! -nargs=0 -bar FmtXML :%s/>\s*</>\r</ge|set ft=xml|normal ggVG=
com! -nargs=0 -bar Df :diffthis|exe "normal \<C-W>w"|diffthis
com! -nargs=? C call <SID>Count("<args>")
com! -nargs=? ET call <SID>ExpandTab("<args>")
com! -nargs=? I exec ":il ".<f-args>."<Bar>let nr=input('GotoLine:')" | exec ":".nr
com! -range TrailBlanks :call <SID>TrailBlanks(<line1>, <line2>)
" }}}

" expandtab functions {{{
let g:tabWidth = 4
function! s:ExpandTab(tabWidth)
  if (a:tabWidth == "") || (a:tabWidth == 0)
    if &expandtab == 0
      setl expandtab
      execute 'setl tabstop='.g:tabWidth
      execute 'setl shiftwidth='.g:tabWidth
      execute 'setl softtabstop='.g:tabWidth
      let @/="\t"
    else
      setl tabstop=8
      setl shiftwidth=8
      setl softtabstop=0
      setl noexpandtab
    endif
  else
    let g:tabWidth = a:tabWidth
    setl expandtab
    execute 'setl tabstop='.a:tabWidth
    execute 'setl shiftwidth='.a:tabWidth
    execute 'setl softtabstop='.a:tabWidth
    let @/="\t"
  endif
endfunction
" }}}

" Read Ex-Command output to current buffer, for example, to read output of ls, just type -- {{{
" :Rex ls
function! s:ReadExCmd(flag,winOp,exCmd)
  redi @x
  silent exec a:exCmd
  redi END
  if a:flag == 1
    let l:consoleWin = bufwinnr(">-brook's console<-")
    if(l:consoleWin == -1)
      execute "silent ".a:winOp." new >-brook's console<-"
      setlocal buftype=nofile
      let l:consoleWin = bufwinnr(">-brook's console<-")
    endif
    execute l:consoleWin."wincmd w"
    exec "normal gg\"_dG\"xp" | %s#\r## | normal 50%z.
    execute "normal \<c-w>p"
  else
    exec "normal \"xp"
  endif
endfunction

function! s:CloseConsole()
  let l:consoleWin = bufwinnr(">-brook's console<-")
  if(l:consoleWin != -1)
    execute l:consoleWin."wincmd w"
    quit
  endif
endfunction
" }}}

" MyGrep functions {{{
function! s:MyGrep(word)
  let l:start = localtime()
  let @/='\<'.a:word.'\>'
  if strlen(a:word) > 0
    execute 'lgrep! "\<'.a:word.'\>" *'
    lw
  endif
  let l:end = localtime()
  let g:MyGrepTime = l:end - l:start
endfunction
" }}}

" misc functions {{{
function! s:LHelpGrep(word)
  if strlen(a:word) > 0
    execute 'lhelpgrep '.a:word
    lw
  endif
endfunction

function! s:HtmlImg()
  %s# #\ #g
  %s#^.*\(jpg\|png\|gif\)$#<img src="file://&">#
endfunction

function! s:TrailBlanks(s, e)
  let l:cols = []
  exec a:s.','.a:e."g/^/call add(cols, col('$'))"
  let l:maxCol = max(cols)
  exec a:s.','.a:e."g/^/let n=l:maxCol-col('$') | exec 'normal '.n.'A '"
endfunction

function! s:Count(pat)
  let l:pat = (a:pat == "")? @/ : a:pat
  try
    execute '%s/'.l:pat.'//n'
  catch
    echo "0 match on 0 line"
  endtry
endfunction

function! s:Vsd(fn)
  exec 'diffsplit '.a:fn
  exec "normal \<c-w>L"
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
Bundle 'brookhong/DBGPavim'
Bundle 'brookhong/cscope.vim'
Bundle 'taglist.vim'
Bundle 'matchit.zip'
Bundle 'maksimr/vim-translator.git'
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
function! s:ToggleNERDTree(dir)
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
      \ 'file': '\.3dm$\|\.3g2$\|\.3gp$\|\.7z$\|\.a$\|\.a.out$\|\.accdb$\|\.ai$\|\.aif$\|\.aiff$\|\.app$\|\.arj$\|\.asf$\|\.asx$\|\.au$\|\.avi$\|\.bak$\|\.bin$\|\.bmp$\|\.bz2$\|\.cab$\|\.cer$\|\.cfm$\|\.cgi$\|\.com$\|\.cpl$\|\.csr$\|\.csv$\|\.cue$\|\.cur$\|\.dat$\|\.db$\|\.dbf$\|\.dbx$\|\.dds$\|\.deb$\|\.dem$\|\.dll$\|\.dmg$\|\.dmp$\|\.dng$\|\.doc$\|\.docx$\|\.drv$\|\.dwg$\|\.dxf$\|\.ear$\|\.efx$\|\.eps$\|\.epub$\|\.exe$\|\.fla$\|\.flv$\|\.fnt$\|\.fon$\|\.gadget$\|\.gam$\|\.gbr$\|\.ged$\|\.gif$\|\.gpx$\|\.gz$\|\.hqx$\|\.ibooks$\|\.icns$\|\.ico$\|\.ics$\|\.iff$\|\.img$\|\.indd$\|\.iso$\|\.jar$\|\.jpeg$\|\.jpg$\|\.key$\|\.keychain$\|\.kml$\|\.lnk$\|\.lz$\|\.m3u$\|\.m4a$\|\.max$\|\.mdb$\|\.mid$\|\.mim$\|\.moov$\|\.mov$\|\.movie$\|\.mp2$\|\.mp3$\|\.mp4$\|\.mpa$\|\.mpeg$\|\.mpg$\|\.msg$\|\.msi$\|\.nes$\|\.o$\|\.obj$\|\.ocx$\|\.odt$\|\.otf$\|\.pages$\|\.part$\|\.pct$\|\.pdb$\|\.pdf$\|\.pif$\|\.pkg$\|\.plugin$\|\.png$\|\.pps$\|\.ppt$\|\.pptx$\|\.prf$\|\.ps$\|\.psd$\|\.pspimage$\|\.qt$\|\.ra$\|\.rar$\|\.rm$\|\.rom$\|\.rpm$\|\.rtf$\|\.sav$\|\.scr$\|\.sdf$\|\.sea$\|\.sit$\|\.sitx$\|\.sln$\|\.smi$\|\.so$\|\.svg$\|\.swf$\|\.swp$\|\.sys$\|\.tar$\|\.tar.gz$\|\.tax2010$\|\.tga$\|\.thm$\|\.tif$\|\.tiff$\|\.tlb$\|\.tmp$\|\.toast$\|\.torrent$\|\.ttc$\|\.ttf$\|\.uu$\|\.uue$\|\.vb$\|\.vcd$\|\.vcf$\|\.vcxproj$\|\.vob$\|\.war$\|\.wav$\|\.wma$\|\.wmv$\|\.wpd$\|\.wps$\|\.xll$\|\.xlr$\|\.xls$\|\.xlsx$\|\.xpi$\|\.yuv$\|\.Z$\|\.zip$\|\.zipx$\|\.lib$\|\.res$\|\.rc$\|\.out$',
      \ }
" }}}
"
" python utilities {{{
if has("python")
  python import cgi
  python import HTMLParser
  python import urllib
  python import base64
  python htmlparser = HTMLParser.HTMLParser()
  com! -nargs=1 -bar CgiEscape python print cgi.escape("<args>", True)
  com! -nargs=1 -bar CgiUnescape python print htmlparser.unescape("<args>")
  com! -nargs=1 -bar UrlEncode python print urllib.quote_plus("<args>")
  com! -nargs=1 -bar UrlDecode python print urllib.unquote_plus("<args>")
  com! -nargs=1 -bar Base64Encode python print base64.encodestring("<args>")
  com! -nargs=1 -bar Base64Decode python print base64.decodestring("<args>")
endif
" }}}

let g:goog_user_conf = { 'langpair': 'en|zh', 'v_key': 'T' }
