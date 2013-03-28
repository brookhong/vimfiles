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
if isdirectory($HOME.'/.vim_swap') == 0
  call mkdir($HOME.'/.vim_swap')
endif
set directory^=$HOME/.vim_swap//

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
let g:win_prefix = ''
let g:cloudStorage = $HOME.'/Dropbox'
if has("win32")
  set gfn=Consolas:h14:cANSI
  set enc=utf-8
  if isdirectory('D:/tools/vim/')
    let g:win_prefix = 'D:'
    let g:cscope_cmd = 'D:/tools/vim/cscope.exe'
  else
    let g:win_prefix = 'C:'
    let g:cscope_cmd = 'C:/tools/vim/cscope.exe'
  endif
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
if &term == 'builtin_gui' || &term == ''
  source $VIMRUNTIME/mswin.vim
  set clipboard=unnamed

  let s:schemeList=["desert", "darkspectrum","desert256","moria"]
  let s:random=substitute(localtime(),'\d','&+','g')
  let s:random=eval(substitute(s:random,'\(.*\)+$','(\1)%'.len(s:schemeList),''))
  let g:myScheme=s:schemeList[s:random]
  exec "colorscheme ".s:schemeList[s:random]
else
  colorscheme darkspectrum
  highlight CursorLine  term=standout cterm=bold
  highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
  highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black 
  highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black 
  highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black
endif
" }}}

" extended key map {{{
let mapleader = ","
nnoremap # /\c\<<C-R><C-W>\><CR>
nnoremap }} g_l
nnoremap Y y$
nnoremap dl dt_
inoremap <C-F> <Esc>:s/=[^=]*$//g<CR>$yiW$a=<C-R>=<C-R>0<CR>
nnoremap <expr> <C-j> (len(getloclist(0))>0)?':lnext<CR>':'<C-j>'
nnoremap <expr> <C-k> (len(getloclist(0))>0)?':lprevious<CR>':'<C-k>'
nnoremap <expr> <C-b> (bufnr('%')==bufnr('$'))?':buffer 1<CR>':':bnext<CR>'
inoremap <F5> <C-R>=strftime("%H:%M %Y/%m/%d")<CR>
nnoremap <S-TAB> :call <SID>ExpandTab(0)<cr>
inoremap <S-TAB> <C-O>:call <SID>ExpandTab(0)<cr>
inoremap <leader>. <Esc>
nnoremap <silent> <leader>, :call <SID>ReadExCmd(1, "topleft 20", "!sdcv -n --data-dir ".g:cloudStorage."/stardict-oxford-gb-formated-2.4.2/ --utf8-output ".expand("<cword>"))<CR>

nnoremap <silent> <leader>a :call <SID>AppendToFile(g:cloudStorage.'/data/vocabulary.lst', expand('<cword>'))<CR>
nnoremap <silent> <leader>d "_d
nnoremap <silent> <leader>e :call <SID>ToggleNERDTree(getcwd())<CR>
nnoremap <silent> <leader>g :call <SID>MyGrep("<C-R><C-W>")<CR>
nnoremap <silent> <leader>h :call <SID>ToggleHexView()<CR>
nnoremap <silent> <leader>i :let nr = input("/\\c")<Bar>:exe "/\\c" . nr<CR>
nnoremap <silent> <leader>j :reg<CR>:let nr = input(">\"")<Bar>exe "normal \"" . nr ."p"<CR>
nnoremap <silent> <leader>m :marks<CR>:let nr = input(">`")<Bar>exe "normal `" . nr<CR>
nnoremap <silent> <leader>t :Tlist<CR>
nnoremap <silent> <leader>nh :let @/=""<CR>
nnoremap <silent> <leader>qa :qall!<cr>
nnoremap <silent> <leader>qb :CtrlPBuffer<CR>
nnoremap <silent> <leader>qc :e!<Esc>ggdG<CR>
nnoremap <silent> <leader>qd :call <SID>MyGdiff()<CR>
nnoremap <silent> <leader>qf :CtrlPMRU<CR>
nnoremap <silent> <leader>qi [I:let nr = input("Goto: ")<Bar>exe "normal " . nr ."[\t"<CR>
nnoremap <silent> <leader>qk :execute 'e '.g:cloudStorage.'/data/tech.org'<CR>
nnoremap <silent> <leader>qn :enew!<CR>
nnoremap <silent> <leader>qx :q!<CR>
nnoremap <silent> <leader>sh :sp <cfile><CR>
nnoremap <silent> <leader>sl :let &list=!&list<CR>
nnoremap <silent> <leader>sv :vs <cfile><CR>
nnoremap <silent> <leader>ve :e $brookvim_root/vimrc<CR>
nnoremap <silent> <leader>vs :so $brookvim_root/vimrc<CR>
nnoremap <silent> <leader>wb :execute g:launchWebBrowser."http://www.baidu.com/s?wd=".expand("<cword>")<CR>
nnoremap <silent> <leader>wl :execute g:launchWebBrowser.expand("<cWORD>")<CR>
nnoremap <silent> <leader>wt :execute 'Translate '.expand("<cword>")<CR>
nnoremap <silent> <leader>ya :let @z=""<Bar>:let nr=input("Yank all lines with PATTERN to register Z >")<Bar>:exe ":g/".nr."/normal \"Zyy\<CR\>"<CR>
nnoremap <silent> <space>, :call <SID>CloseConsole()<CR>
nnoremap <silent> <space>f :tabf <cfile><CR>
vnoremap <silent> <space>f y:tabf <C-R>"<CR>
let g:eregex_meta_chars = '^$()|[]{}.*+?\/'
let g:vregex_meta_chars = '^$|[].*\/'
vnoremap <silent> * "vy/<C-r>=substitute(escape(@v,g:vregex_meta_chars),"\n",'\\n','g')<CR><CR>N
vnoremap <leader>s "vy:<C-u>%s/\<<C-r>=substitute(escape(@v,g:eregex_meta_chars),"\n",'\\n','g')<CR>\>//g<Left><Left>
vnoremap <leader>g "vy:<C-u>%s/<C-r>=substitute(escape(@v,g:eregex_meta_chars),"\n",'\\n','g')<CR>//g<Left><Left>
nnoremap <silent> <space>q :q<CR>
nnoremap <silent> <space>t :tabe<CR>
nnoremap <silent> <space>v :vnew<CR>
nnoremap <silent> <space>w :new<CR>
" }}}

" autocmds {{{
autocmd BufRead,BufNewFile  *.as set filetype=actionscript
autocmd BufRead,BufNewFile  *.json set filetype=javascript
autocmd FileType sh         nnoremap <buffer> <leader>r :call <SID>RunMe('bash', 'botri 10')<CR>
autocmd FileType php        nnoremap <buffer> <leader>r :call <SID>RunMe('php', 'botri 10')<CR>
autocmd FileType python     nnoremap <buffer> <leader>r :call <SID>RunMe('python', 'botri 10')<CR>
autocmd FileType ruby       nnoremap <buffer> <leader>r :call <SID>RunMe('ruby', 'botri 10')<CR>
autocmd FileType perl       nnoremap <buffer> <leader>r :call <SID>RunMe('perl', 'botri 10')<CR>
autocmd FileType jade       nnoremap <buffer> <leader>r :call <SID>RunMe('jade -P', 'botri 10')<CR>
autocmd FileType html       nnoremap <buffer> <leader>r :execute g:launchWebBrowser.expand("%")<CR>
autocmd FileType php        nnoremap <buffer> K :execute g:launchWebBrowser."http://jp.php.net/manual-lookup.php?pattern=".expand("<cword>")."&lang=zh&scope=quickref"<CR>
autocmd FileType vim        setlocal keywordprg=:help | nnoremap <buffer> <leader>r :%y"<CR>:@"<CR>
autocmd FileType markdown   call <SID>MyMarkDown()
autocmd FileType yaml       call <SID>ExpandTab(2)
autocmd FileType txt        call <SID>Hi('/[\x00-\xff]\+/')
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
com! -nargs=0 Bk call <SID>BackUp()
com! -nargs=0 Bd call <SID>BackDiff()
com! -nargs=? C call <SID>Count("<args>")
com! -nargs=? CC cd %:h
com! -nargs=? Cf Rc echo expand('%:p')
com! -nargs=1 -bar H :call <SID>LHelpGrep(<q-args>)
com! -nargs=1 Ft let &ft=<f-args>
com! -nargs=? I exec ":il ".<f-args>."<Bar>let nr=input('GotoLine:')" | exec ":".nr
com! -nargs=1 K exec ':lvimgrep /'.<f-args>.'/ '.g:cloudStorage.'/data/tech.org' | let @/=<f-args> | normal ggn
com! -nargs=? -bar L :call <SID>MyGrep(<q-args>)
com! -nargs=1 S let @/='\<'.<f-args>.'\>' | normal n
com! -nargs=0 -bar Df :if &diff|diffoff|exe "normal \<C-W>w"|diffoff|else|diffthis|exe "normal \<C-W>w"|diffthis|endif
com! -nargs=? Et call <SID>ExpandTab("<args>")
com! -nargs=0 -range=% Gd exec ':<line1>,<line2>g/'.@/.'/d'
com! -nargs=* -complete=command -bar Rc call <SID>ReadExCmd(1, "botri 10", <q-args>)
com! -nargs=* -complete=command -bar Ri call <SID>ReadExCmd(0, "botri 10", <q-args>)
com! -nargs=0 -range Ucfirst let a=@/ | s/\(\a\)\(\a*\)/\1\L\2/g | let @/=a
com! -nargs=0 -range=% Vd exec ':<line1>,<line2>v/'.@/.'/d'
com! -nargs=0 -bar D2h call <SID>D2h()
com! -nargs=0 -bar H2d call <SID>H2d()
com! -nargs=* -complete=file -bar Vsd call <SID>Vsd("<args>")
com! -nargs=0 -bar Dos2Unix :%s/\r//g|set ff=unix
com! -nargs=0 -bar FmtXML :%s/>\s*</>\r</ge|set ft=xml|normal ggVG=
com! -nargs=0 -bar FmtJSON :%s/,"/,\r"/ge|%s/{"/{\r"/ge|%s/\(\S\)}/\1\r}/ge|set ft=javascript|normal ggVG=
com! -nargs=0 -bar HtmlImg :call <SID>HtmlImg()
com! -nargs=* -range Number :call <SID>Number(<line1>,<line2>,<f-args>)
com! -nargs=0 -bar RmAllNL :%s/\n//g
com! -nargs=0 -bar RmDupLine :%s/^\(.*\)\n\1$/\1/g
com! -nargs=0 -bar RmEmptyLine :g/^\s*$/d
com! -nargs=0 -bar RmTrailingBlanks :%s/\s\+$//g
com! -nargs=0 -bar RmTags :%s/<[^>]*>//g
com! -range TrailBlanks :call <SID>TrailBlanks(<line1>, <line2>)
com! -nargs=0 LargeFont :let &gfn=substitute(&gfn,"\\(\\D*\\)\\(\\d\\+\\)", "\\=submatch(1).(submatch(2)+2)","")
com! -nargs=0 SmallFont :let &gfn=substitute(&gfn,"\\(\\D*\\)\\(\\d\\+\\)", "\\=submatch(1).(submatch(2)-2)","")
com! -nargs=0 ToggleAutoSDCV :call <SID>ToggleAutoSDCV()
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
function! s:FocusMyConsole(winOp)
  let l:consoleWin = bufwinnr(">-brook's console<-")
  if(l:consoleWin == -1)
    execute "silent ".a:winOp." new >-brook's console<-"
    setlocal buftype=nofile
    setlocal nobuflisted
    let l:consoleWin = bufwinnr(">-brook's console<-")
  endif
  execute l:consoleWin."wincmd w"
endfunction

function! s:ReadExCmd(flag,winOp,exCmd)
  if a:exCmd[0] == "!"
    let l:shCmd = strpart(a:exCmd,1)
    let l:result = split(system(l:shCmd),"\\n")
  else
    redi @x
    silent exec a:exCmd
    redi END
  endif
  if a:flag == 1
    call <SID>FocusMyConsole(a:winOp)
    exec "normal gg\"_dG"
    if a:exCmd[0] == "!" | call append(0, l:result) | else | exec "normal \"xp" | endif
    execute "normal gg\<c-w>p"
  else
    if a:exCmd[0] == "!" | call append(0, l:result) | else | exec "normal \"xp" | endif
  endif
endfunction

function! s:RunMe(interpreter, winOp)
  exec '%!'.a:interpreter
  exec "normal ggyGu"
  call <SID>FocusMyConsole(a:winOp)
  execute "normal gg\"_dGP\<c-w>p"
endfunction

function! s:CloseConsole()
  let l:consoleWin = bufwinnr(">-brook's console<-")
  if(l:consoleWin != -1)
    execute l:consoleWin."wincmd w"
    bdelete
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

function! s:D2h()
  let l:digits = split(getline('.'),' ')
  let l:hexCode = ""
  for i in l:digits
    let l:hexCode .= printf("%0x ",i)
  endfor
  call append("$", l:hexCode)
endfunction

function! s:H2d()
  let l:digits = split(getline('.'),' ')
  let l:hexCode = ""
  for i in l:digits
    exec 'let l:hexCode .= 0x'.i
    let l:hexCode .= " "
  endfor
  call append("$", l:hexCode)
endfunction

function! s:Number(line1, line2, start, suffix)
  let l:a = @/
  exec a:line1.','a:line2.'s/^/\=line(".")-'.a:line1.'+'.a:start.'."'.a:suffix.'"/'
  let @/ = l:a
endfunction

function! s:MyMarkDown()
  nnoremap <buffer> <leader>r :execute ':!Markdown.pl --html4tags % >'.expand('%:r').'.html'<CR>
  call <SID>ExpandTab(2)
  setlocal foldmethod=syntax
  syn region myFold start=/> > > ---/ end=/^$/ transparent fold
  syn sync fromstart
endfunction

function! s:MyGdiff()
  if &diff
    exec "normal \<C-W>hZQ"
  else
    Gdiff
  endif
endfunction

function! s:AppendToFile(file, line)
  let l:myWords = readfile(a:file)
  call add(l:myWords, a:line)
  call writefile(l:myWords, a:file)
  echo a:line
endfunction
" }}}
"

" plugins {{{
filetype off
let &runtimepath = $brookvim_root."/bundle/vundle/,".&runtimepath
call vundle#rc()
let g:bundle_dir = $brookvim_root."/bundle/"
Bundle 'gmarik/vundle'
Bundle 'actionscript.vim--Leider'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'brookhong/DBGPavim'
Bundle 'brookhong/cscope.vim'
Bundle 'brookhong/neco-php'
Bundle 'taglist.vim'
Bundle 'matchit.zip'
Bundle 'maksimr/vim-translator'
Bundle 'digitaltoad/vim-jade'
Bundle 'godlygeek/tabular'
Bundle 'hsitz/VimOrganizer'
Bundle 'mattn/gist-vim'
Bundle 'mattn/webapi-vim'
Bundle 'chumakd/conque-shell-mirror'
Bundle 'Lokaltog/vim-easymotion.git'
Bundle 'DrawIt'
filetype plugin indent on
syntax on
map <unique> \rwp <Plug>RestoreWinPosn

" nerdtree setup
let g:NERDTreeDirArrows = 0
let t:NERDTreeRoot = ""
function! s:ToggleNERDTree(dir)
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && t:NERDTreeRoot == a:dir
    NERDTreeClose
  else
    if &bt == "" && expand("%") != ""
      NERDTreeFind
    else
      execute ':NERDTree '.a:dir
    endif
    let t:NERDTreeRoot = a:dir
  endif
endfunction
function! s:ToggleAutoSDCV()
  if exists("b:AutoSDCV")
    nunmap <buffer> j
    nunmap <buffer> k
    unlet b:AutoSDCV
  else
    nmap <buffer> j j,,
    nmap <buffer> k k,,
    let b:AutoSDCV = 1
  endif
endfunction
function! s:Hi(pat)
  highlight MyGroup ctermfg=green guifg=green
  execute 'match MyGroup '.a:pat
endfunction

let s:backup_vim_dir = substitute($HOME,'\\','/','g')."/.backup.vim"
if ! isdirectory(s:backup_vim_dir)
  call mkdir(s:backup_vim_dir)
endif

function! s:BackFileName()
  let l:fn = substitute(expand('%:p'),'\\','/','g')
  let l:fn = substitute(l:fn,'/','_','g')
  let l:fn = s:backup_vim_dir.'/'.l:fn
  return l:fn
endfunction

function! s:BackUp()
  exec ':w '.<SID>BackFileName()
endfunction

function! s:BackDiff()
  if &diff
    exec "normal \<C-W>hZQ"
    exec "diffoff"
  else
    exec 'diffsplit '.<SID>BackFileName()
    exec "normal \<c-w>H"
  endif
endfunction

function! s:ToggleHexView()
    if exists('b:isHexView') && b:isHexView == 1
        %!xxd -r
        let b:isHexView = 0
    else
        %!xxd
        let b:isHexView = 1
    endif
endfunction

" neocomplcache setup
let g:neocomplcache_enable_at_startup = 1
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" ctrlp setup
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode   = 0
let g:ctrlp_max_height          = 25
let g:ctrlp_mruf_exclude        = 'dbgpavim_cli.*'
let g:ctrlp_custom_ignore       = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.3dm$\|\.3g2$\|\.3gp$\|\.7z$\|\.a$\|\.a.out$\|\.accdb$\|\.ai$\|\.aif$\|\.aiff$\|\.app$\|\.arj$\|\.asf$\|\.asx$\|\.au$\|\.avi$\|\.bak$\|\.bin$\|\.bmp$\|\.bz2$\|\.cab$\|\.cer$\|\.cfm$\|\.cgi$\|\.com$\|\.cpl$\|\.csr$\|\.csv$\|\.cue$\|\.cur$\|\.dat$\|\.db$\|\.dbf$\|\.dbx$\|\.dds$\|\.deb$\|\.dem$\|\.dll$\|\.dmg$\|\.dmp$\|\.dng$\|\.doc$\|\.docx$\|\.drv$\|\.dwg$\|\.dxf$\|\.ear$\|\.efx$\|\.eps$\|\.epub$\|\.exe$\|\.fla$\|\.flv$\|\.fnt$\|\.fon$\|\.gadget$\|\.gam$\|\.gbr$\|\.ged$\|\.gif$\|\.gpx$\|\.gz$\|\.hqx$\|\.ibooks$\|\.icns$\|\.ico$\|\.ics$\|\.iff$\|\.img$\|\.indd$\|\.iso$\|\.jar$\|\.jpeg$\|\.jpg$\|\.key$\|\.keychain$\|\.kml$\|\.lnk$\|\.lz$\|\.m3u$\|\.m4a$\|\.max$\|\.mdb$\|\.mid$\|\.mim$\|\.moov$\|\.mov$\|\.movie$\|\.mp2$\|\.mp3$\|\.mp4$\|\.mpa$\|\.mpeg$\|\.mpg$\|\.msg$\|\.msi$\|\.nes$\|\.o$\|\.obj$\|\.ocx$\|\.odt$\|\.otf$\|\.pages$\|\.part$\|\.pct$\|\.pdb$\|\.pdf$\|\.pif$\|\.pkg$\|\.plugin$\|\.png$\|\.pps$\|\.ppt$\|\.pptx$\|\.prf$\|\.ps$\|\.psd$\|\.pspimage$\|\.qt$\|\.ra$\|\.rar$\|\.rm$\|\.rom$\|\.rpm$\|\.rtf$\|\.sav$\|\.scr$\|\.sdf$\|\.sea$\|\.sit$\|\.sitx$\|\.sln$\|\.smi$\|\.so$\|\.svg$\|\.swf$\|\.swp$\|\.sys$\|\.tar$\|\.tar.gz$\|\.tax2010$\|\.tga$\|\.thm$\|\.tif$\|\.tiff$\|\.tlb$\|\.tmp$\|\.toast$\|\.torrent$\|\.ttc$\|\.ttf$\|\.uu$\|\.uue$\|\.vb$\|\.vcd$\|\.vcf$\|\.vcxproj$\|\.vob$\|\.war$\|\.wav$\|\.wma$\|\.wmv$\|\.wpd$\|\.wps$\|\.xll$\|\.xlr$\|\.xls$\|\.xlsx$\|\.xpi$\|\.yuv$\|\.Z$\|\.zip$\|\.zipx$\|\.lib$\|\.res$\|\.rc$\|\.out$',
      \ }

" VimOrganizer setup
let g:ft_ignore_pat = '\.org'
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
function! s:SetOrgFile()
  if exists(':NeoComplCacheDisable') 
    NeoComplCacheDisable 
  endif
  call org#SetOrgFileType()
endfunction
au BufEnter *.org :call <SID>SetOrgFile()
command! OrgCapture :call org#CaptureBuffer()
command! OrgCaptureFile :call org#OpenCaptureFile()
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
let g:EasyMotion_leader_key = '\'
