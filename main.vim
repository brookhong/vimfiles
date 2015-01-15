" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab foldmethod=marker
" ff=unix

" Purge previous auto commands (in case run twice)
autocmd!

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
set statusline=%f\ %h%m%r\ \[%{&ff}:%{&fenc}:%Y]\ %<%{getcwd()}\ %=%n%-10{((&expandtab)?'-ET'.&tabstop:'-TAB')}\ %=%-10.(%l,%c%V%)\ %P
set list
set listchars=tab:>-,trail:-
set fileformat=unix
if isdirectory($HOME.'/.vim_swap') == 0
  call mkdir($HOME.'/.vim_swap')
endif
set directory^=$HOME/.vim_swap//

if exists('&relativenumber')
  set relativenumber
endif
" set number
" set paste " cause abbreviate not working under linux/terminal
" automatic change directory to current buffer
if exists('+autochdir')
  set autochdir
endif
" }}}

" OS-specific {{{
" find root path of my vimfiles
let s:vimfiles_dir = expand("<sfile>:p:h")
let g:win_prefix = ''
let g:cloudStorage = s:vimfiles_dir.'/..'
set enc=utf-8
if has("win32")
  "set gfn=Consolas:h12:cANSI
  "set gfn=Microsoft_YaHei_Mono:h12:cANSI
  set gfn=Menlo:h10:cANSI
  if isdirectory('D:/tools/vim/')
    let g:win_prefix = 'D:'
  else
    let g:win_prefix = 'C:'
  endif
  if isdirectory('c:/cygwin/')
    let s:cygwin_dir = 'c:/cygwin/'
  else
    let s:cygwin_dir = 'd:/cygwin/'
  endif
  if executable('cscope') == 0
    let g:cscope_cmd = g:win_prefix.'/tools/vim/cscope.exe'
  endif
  let $NODE_PATH = g:win_prefix.'\tools\node_modules'
  let s:vimfiles_dir = substitute(s:vimfiles_dir,"\\","\/","g")
  let $PATH=s:cygwin_dir.'/bin;'.$PATH
  let $LANG="en_US.UTF8"
  let g:launchWebBrowser=":silent ! start "
  let g:cloudStorage = 'd:/Dropbox'
  let g:ctrlp_k_favorites = g:cloudStorage.'/data/cli.cmd'
  let g:fileBrowser="explorer"
elseif has("mac")
  set guifont=Menlo:h14
  let g:NERDTreeDirArrows = 1
  let g:launchWebBrowser=":silent ! open /Applications/Google\\ Chrome.app "
  let g:fileBrowser="open"
  let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
  let g:ctrlp_k_favorites = g:cloudStorage.'/data/cli.sh'
elseif has("unix")
  let g:launchWebBrowser=":silent ! /opt/chrome/chrome-wrapper "
  if executable('chromium')
    let g:launchWebBrowser=":silent ! chromium "
  endif
  let g:fileBrowser="thunar"
  let g:ctrlp_k_favorites = g:cloudStorage.'/data/cli.sh'
  if has("X11")
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
  endif
endif
" add it into runtimepath
let &runtimepath = s:vimfiles_dir.",".&runtimepath
" }}}

" UI-specific {{{
if &term == 'builtin_gui' || &term == ''
  if has('mac')
    set clipboard=unnamed
  elseif has('unix')
    set clipboard=unnamedplus
  endif

  let day=strftime("%H")
  if day>7 && day<19
    let s:schemeList=["moria"]
  else
    let s:schemeList=["desert", "darkspectrum","desert256"]
  endif
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

function! GetFilePath(bufnum)
  return fnamemodify(bufname(str2nr(a:bufnum)), ":p:h")
endfunction
cmap <expr> <C-x> GetFilePath(input("buffer number: "))

function! s:Replace(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>\"_xP"
  elseif a:type == 'line'
    silent exe "normal! '[V']\"_xP"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]\"_xP"
  else
    silent exe "normal! `[v`]\"_xP"
  endif

  let &selection = sel_save
  let @@ = reg_save
endfunction

" extended key map {{{
nnoremap s <Nop>
let mapleader = "s"
xnoremap <expr> P '"_d"'.v:register.'P'
xnoremap C "_c
nnoremap # /\c\<<C-R><C-W>\><CR>
nnoremap }} g_l
nnoremap Y y$:let @*=@+<CR>
vnoremap Y y:let @*=@+<CR>
nnoremap dl dt_
inoremap <C-F> <Esc>:let a=@/<CR>:s/=[^=]*$//g<CR>$yiW$a=<C-R>=<C-R>0<CR><Esc>:let @/=a<CR>
nnoremap <expr> <C-j> (len(getloclist(0))>0)?':lnext<CR>':((len(getqflist())>0)?':cnext<CR>':'<C-j>')
nnoremap <expr> <C-k> (len(getloclist(0))>0)?':lprevious<CR>':((len(getqflist())>0)?':cprevious<CR>':'<C-j>')
nnoremap <expr> <C-b> (bufnr('%')==bufnr('$'))?':buffer 1<CR>':':bnext<CR>'
inoremap <S-F5> <C-R>=strftime("%H:%M:%S %Y/%m/%d")<CR>
nnoremap <silent> <S-TAB> :call <SID>ToggleTab()<cr>
inoremap <silent> <S-TAB> <C-O>:call <SID>ToggleTab()<cr>
nnoremap <silent> <leader>a :call AppendToFile(g:cloudStorage.'/data/vocabulary.lst', expand('<cword>'))<CR>
nnoremap <leader>b :execute "silent !" . g:fileBrowser . " %:h"<CR>
nnoremap <silent> <space>d "_d
nnoremap <silent> <space>c "_c
nnoremap <silent> <space>C "_C
nnoremap <silent> <leader>cr :let @k='curl -s "'.expand('<cWORD>').'"'<BAR>call k#RunReg('k', 'bash', 'botri 10', '', '', 0)<CR>
nnoremap <silent> <leader>e :call <SID>ToggleNERDTree(getcwd())<CR>
nnoremap <silent> <leader>fl :Gllog<Bar>lw<CR>
nnoremap <leader>g :LAg <C-R><C-W> <C-R>=ag#prePath()<CR>
vnoremap <leader>g "vy:<C-u>LAg <C-r>='"'.substitute(escape(@v,g:eregex_meta_chars),"\n",'\\n','g').'"'<CR> <C-R>=ag#prePath()<CR>
nnoremap <silent> <leader>h :call <SID>ToggleHexView()<CR>
nnoremap <silent> <leader>k :let nr = input("/\\c")<Bar>if nr != "" <Bar>exe "/\\c" . nr<Bar>endif<CR>
nnoremap <silent> <leader>j :reg<CR>:let nr = input(">\"")<Bar>if nr != "" <Bar>exe "normal \"" . nr ."p"<Bar>endif<CR>
nnoremap <silent> <leader>m :marks<CR>:let nr = input(">`")<Bar>exe "normal `" . nr<CR>
nnoremap <silent> <leader>nh :let @/=""<CR>
nnoremap <silent> <leader>qa :qall!<cr>
nnoremap <silent> <leader>qb :CtrlPBuffer<CR>
nnoremap <silent> <leader>qc :e!<Esc>ggdG<CR>
nnoremap <silent> <leader>qd :call <SID>MyGdiff()<CR>
nnoremap <silent> <leader>qe :CtrlPK<CR>
nnoremap <silent> <leader>qf :CtrlPMRU<CR>
nnoremap <silent> <leader>ql :CtrlPLine<CR>
nnoremap <silent> <leader>qt :CtrlPFunky<CR>
nnoremap <silent> <leader>qi :lgetexpr []<Bar>g/<C-r>=expand("<cword>")<CR>/laddexpr expand("%") . ":" . line(".") .  ":" . getline(".")<CR>:lw<CR>
vnoremap <silent> <leader>qi "vy:lgetexpr []<Bar>g/<C-r>=substitute(escape(@v,g:vregex_meta_chars),"\n",'\\n','g')<CR>/laddexpr expand("%") . ":" . line(".") .  ":" . getline(".")<CR>:lw<CR>
nnoremap <silent> <leader>qk :execute 'e '.g:cloudStorage.'/data/tech.org'<CR>
nnoremap <silent> <space>1 :execute 'e '.g:cloudStorage.'/data/clipboard.txt'<CR>
nnoremap <silent> <leader>qn :enew!<CR>
nnoremap <silent> <leader>qx :q!<CR>
nnoremap <silent> <leader>ol :let &list=!&list<CR>
nnoremap <silent> <leader>op :let &paste=!&paste<CR>
nnoremap <silent> <leader>yt :exec exists('g:syntax_on')?'syntax off':'syntax on'<CR>
let g:main_vim = expand("<sfile>:p")
nnoremap <silent> <leader>ve :exec ':e '.g:main_vim<CR>
nnoremap <silent> <leader>vs :exec ':so '.g:main_vim<CR>
nnoremap <silent> <leader>wb :execute g:launchWebBrowser."http://www.baidu.com/s?wd=".expand("<cword>")<CR>
nnoremap <silent> <leader>wg :execute g:launchWebBrowser."https://www.google.com/search?q=".expand("<cword>")<CR>
nnoremap <silent> <leader>wl :execute g:launchWebBrowser.expand("<cWORD>")<CR>
nnoremap <silent> <leader>wt :execute 'Translate '.expand("<cword>")<CR>
nnoremap <silent> <leader>W :w<CR>
nnoremap <silent> <leader>x :set opfunc=<SID>Replace<CR>g@
vnoremap <silent> <leader>x :<C-U>call <SID>Replace(visualmode(), 1)<CR>
nnoremap <silent> <leader>ya :let @z=""<Bar>:let nr=input("Yank all lines with PATTERN to register Z >")<Bar>:exe ":g/".nr."/normal \"Zyy\<CR\>"<CR>
nnoremap <silent> <space>e :source $HOME/.vim_swap/e.vim<Bar>:call writefile([], $HOME."/.vim_swap/e.vim")<CR>
nnoremap <silent> <space>f :tabf <cfile><CR>
vnoremap <silent> <space>f y:tabf <C-R>"<CR>
let g:eregex_meta_chars = '^$()[]{}.*+?\/'
let g:vregex_meta_chars = '^$[].*\/~'
vnoremap <silent> * "vy/<C-r>=substitute(escape(@v,g:vregex_meta_chars),"\n",'\\n','g')<CR><CR>N
vnoremap <leader>sw "vy:<C-u>%s/\<<C-r>=substitute(escape(@v,g:eregex_meta_chars),"\n",'\\n','g')<CR>\>//g<Left><Left>
vnoremap <leader>sg "vy:<C-u>%s/<C-r>=substitute(escape(@v,g:eregex_meta_chars),"\n",'\\n','g')<CR>//g<Left><Left>
nnoremap <space>p :CBPut 
vnoremap <space>y :CBYank 
nnoremap <silent> <space>q :q<CR>
nnoremap <silent> <space>t :tabe<CR>
nnoremap <silent> <space>v :vnew<CR>
nnoremap <silent> <space>w :new<CR>
if executable('say')
  nnoremap <silent> <space>r :silent exec ':!say -v Vicki '.expand('<cword>')<CR>
  vnoremap <silent> <space>r "vy:silent exec ':!say -v Vicki "'.@v.'"'<CR>
elseif executable('tts')
  if !exists('g:ttsVoice')
    let g:ttsVoice = 0
  endif
  nnoremap <silent> <space>r :silent exec ':!tts -v '.g:ttsVoice.' '.expand('<cword>')<CR>
  vnoremap <silent> <space>r "vy:silent exec ':!tts -v '.g:ttsVoice.' "'.@v.'"'<CR>
endif
" }}}

" autocmds {{{
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufFilePre,BufRead *.* call <SID>ExpandTab(4)
autocmd BufRead,BufNewFile  *.grp set filetype=grp
autocmd FileType grp        nnoremap <silent> K :call <SID>PreviewFile()<CR>
function! s:PreviewFile()
    let l:files = matchlist(expand('<cWORD>'),'\([^:]*\):\(\d\+\)')
    let l:own = winnr()
    exec "normal \<c-w>j"
    let l:cwn = winnr()
    let l:action = 'e'
    if(l:cwn == l:own)
        let l:action = 'bot sf'
    endif
    exec l:action.' +'.l:files[2].' '.l:files[1]
    exec "normal \<c-w>k"
endfunction

autocmd BufRead,BufNewFile  *.as set filetype=actionscript
autocmd BufRead,BufNewFile  *.json set filetype=javascript
autocmd FileType html       nnoremap <buffer> <leader>r :execute g:launchWebBrowser.expand("%")<CR>
autocmd FileType vim        setlocal keywordprg=:help | nnoremap <buffer> <leader>r :%y"<CR>:@"<CR>
autocmd FileType markdown   call <SID>MyMarkDown()
autocmd FileType yaml,jade       call <SID>ExpandTab(2)
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

" }}}

" custom commands {{{
com! -nargs=0 Bk call <SID>BackUp()
com! -nargs=0 Bd call <SID>BackDiff()
com! -nargs=? Ct call <SID>Count("<args>")
com! -nargs=? CC cd %:h
com! -nargs=? Cf Rc echo expand('%:p')
com! -nargs=1 -complete=buffer Dw exec ':w! '.g:cloudStorage.'/tmp/'.<f-args>
com! -nargs=1 -bar H :call <SID>LHelpGrep(<q-args>)
com! -nargs=? I exec ":il ".<f-args>."<Bar>let nr=input('GotoLine:')" | exec ":".nr
com! -nargs=1 K exec ':lvimgrep /'.<f-args>.'/ '.g:cloudStorage.'/data/tech.org' | let @/=<f-args> | normal ggn
com! -nargs=1 S let @/='\<'.<f-args>.'\>' | normal n
com! -nargs=0 -bar Df :exe "normal \<C-W>h"|if &diff|diffoff|exe "normal \<C-W>l"|diffoff|else|diffthis|exe "normal \<C-W>l"|diffthis|endif
com! -nargs=? Et call <SID>ExpandTab("<args>")
com! -nargs=0 -range=% Gd exec ':<line1>,<line2>g/'.@/.'/d'
com! -nargs=0 -range Ucfirst let a=@/ | s/\(\a\)\(\a*\)/\1\L\2/g | let @/=a
com! -nargs=0 -range=% Vd exec ':<line1>,<line2>v/'.@/.'/d'
com! -nargs=0 -bar D2h call <SID>D2h()
com! -nargs=0 -bar H2d call <SID>H2d()
com! -nargs=* -complete=file -bar Vsd call <SID>Vsd("<args>")
com! -nargs=0 -bar Dos2Unix :%s/\r//g|set ff=unix
com! -nargs=0 -bar FmtXML :%s/>\s*</>\r</ge|set ft=xml|normal ggVG=
com! -nargs=0 -bar FmtJSON :%s/,"/,\r"/ge|%s/{"/{\r"/ge|%s/\(\S\)}/\1\r}/ge|set ft=javascript|normal ggVG=
com! -nargs=0 -bar HtmlImg :call <SID>HtmlImg()
com! -nargs=* Lmerge :call <SID>Lmerge(<f-args>)
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
com! -nargs=* -range TE :let z=getline(<line1>,<line2>)|tabnew|call append(0, z)|set ft=<args>|unlet z
" }}}

" expandtab functions {{{
function! s:ExpandTab(...)
  let l:tabWidth = 4
  if a:0 > 0
    let l:tabWidth = a:000[0]
  endif
  setl expandtab
  let b:tabWidth = l:tabWidth
  execute 'setl tabstop='.l:tabWidth
  execute 'setl shiftwidth='.l:tabWidth
  execute 'setl softtabstop='.l:tabWidth
endfunction

function! s:ToggleTab()
  if &expandtab == 0
    let l:tabWidth = 4
    if exists("b:tabWidth")
      let l:tabWidth = b:tabWidth
    endif
    call <SID>ExpandTab(l:tabWidth)
  else
    let b:tabWidth = &tabstop
    setl tabstop=8
    setl shiftwidth=8
    setl softtabstop=0
    setl noexpandtab
  endif
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
  let l:maxCol = max(cols)+2
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
  exec a:line1.','a:line2.'s/^/\=line(".")-'.a:line1.'+'.a:start.'."'.a:suffix.' "/'
  let @/ = l:a
endfunction

function! s:MyMarkDown()
  nnoremap <buffer> <leader>r :call k#RunMe('LC_CTYPE=UTF-8 ruby '.g:cloudStorage.'/snippets/ruby/md2html.rb', 'vert bel', "", 0)<CR>
  call <SID>ExpandTab(2)
  setlocal foldmethod=syntax
  syn region myFold start=/> > > ---/ end=/^$/ transparent fold
  syn sync fromstart
endfunction

function! s:MyGdiff()
  if &diff
    exec "normal \<C-W>hZQ"
  else
    Gvdiff
  endif
endfunction

function! AppendToFile(file, line)
  let l:myWords = readfile(a:file)
  if ! count(l:myWords, a:line)
    call add(l:myWords, a:line)
    call writefile(l:myWords, a:file)
    echo a:line
  endif
endfunction
" }}}
"

" plugins {{{
filetype off
let &runtimepath = s:vimfiles_dir."/bundle/vundle/,".&runtimepath
call vundle#rc()
let g:bundle_dir = s:vimfiles_dir."/bundle/"
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'tacahiroy/ctrlp-funky.git'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'brookhong/DBGPavim'
Bundle 'brookhong/cscope.vim'
Bundle 'brookhong/k.vim'
Bundle 'brookhong/ag.vim'
Bundle 'brookhong/cloudboard.vim'
Bundle 'matchit.zip'
Bundle 'digitaltoad/vim-jade'
Bundle 'godlygeek/tabular'
Bundle 'hsitz/VimOrganizer'
Bundle 'Lokaltog/vim-easymotion.git'
Bundle 'a.vim'
Bundle 'sukima/xmledit'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'ajh17/VimCompletesMe'
Bundle 'msanders/snipmate.vim'
let g:xmledit_enable_html=1
"Bundle 'DrawIt'
"Bundle 'taglist.vim'
"Bundle 'actionscript.vim--Leider'
filetype plugin indent on
syntax on

" k.vim setup
let g:kdbDir = g:cloudStorage.'/kdb'
let g:globalDBkeys = {
      \ 'oxford' : '<leader><leader>',
      \ 'oxford7' : '<leader>7',
      \ }
let g:localDBkeys = {
      \ 'php' : ['K', '<C-j>'],
      \ 'c' : ['K', '<C-j>'],
      \ }

" taglist setup
let Tlist_Show_One_File = 1

" nerdtree setup
let g:NERDTreeDirArrows = 0
let g:NERDTreeMapOpenVSplit = 'a'
function! s:ToggleNERDTree(dir)
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    NERDTreeClose
  else
    if &bt == "" && expand("%") != ""
      NERDTreeFind
    else
      execute ':NERDTree '.a:dir
    endif
  endif
endfunction
" nerdcommenter
let NERDSpaceDelims=1

function! s:ToggleAutoSDCV()
  if exists("b:AutoSDCV")
    nunmap <buffer> j
    nunmap <buffer> k
    unlet b:AutoSDCV
  else
    nmap <buffer> j j<leader><leader>
    nmap <buffer> k k<leader><leader>
    let b:AutoSDCV = 1
  endif
endfunction
function! s:Hi(pat)
  highlight MyGroup ctermfg=green guifg=green
  execute 'match MyGroup '.a:pat
endfunction
function! Conceal(pat)
  execute 'sy match tag_conceal "'.a:pat.'" conceal'
  se cole=3
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

function! s:Lmerge(ba, bb)
  let l:la = getbufline(eval(a:ba), 1, '$')
  let l:lb = getbufline(eval(a:bb), 1, '$')
  let l:i = 0
  let n = min([len(l:la), len(l:lb)])
  while l:i < n
    call append("$", l:la[l:i])
    call append("$", l:lb[l:i])
    let l:i = l:i+1
  endwhile
  echo n
  if len(l:la) == n
    call append("$", l:lb[(n):])
  else
    call append("$", l:la[(n):])
  endif
endfunction

function! GetField(buffer, delim, index)
  let l:lines = getbufline(eval(a:buffer), 1, '$')
  let l:i = 0
  let n = len(l:lines)
  while l:i < n
    let fields = split(l:lines[l:i], a:delim)
    if len(fields) > a:index
      call append("$", fields[a:index])
    endif
    let l:i = l:i+1
  endwhile
endfunction

" ctrlp setup
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode   = 0
let g:ctrlp_max_height          = 25
let g:ctrlp_mruf_exclude        = 'dbgpavim_cli.*'
let g:ctrlp_custom_ignore       = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.3dm$\|\.3g2$\|\.3gp$\|\.7z$\|\.a$\|\.a.out$\|\.accdb$\|\.ai$\|\.aif$\|\.aiff$\|\.app$\|\.arj$\|\.asf$\|\.asx$\|\.au$\|\.avi$\|\.bak$\|\.bin$\|\.bmp$\|\.bz2$\|\.cab$\|\.cer$\|\.cfm$\|\.cgi$\|\.com$\|\.cpl$\|\.csr$\|\.csv$\|\.cue$\|\.cur$\|\.dat$\|\.db$\|\.dbf$\|\.dbx$\|\.dds$\|\.deb$\|\.dem$\|\.dll$\|\.dmg$\|\.dmp$\|\.dng$\|\.doc$\|\.docx$\|\.drv$\|\.dwg$\|\.dxf$\|\.ear$\|\.efx$\|\.eps$\|\.epub$\|\.exe$\|\.fla$\|\.flv$\|\.fnt$\|\.fon$\|\.gadget$\|\.gam$\|\.gbr$\|\.ged$\|\.gif$\|\.gpx$\|\.gz$\|\.hqx$\|\.ibooks$\|\.icns$\|\.ico$\|\.ics$\|\.iff$\|\.img$\|\.indd$\|\.iso$\|\.jar$\|\.jpeg$\|\.jpg$\|\.key$\|\.keychain$\|\.kml$\|\.lnk$\|\.lz$\|\.m3u$\|\.m4a$\|\.max$\|\.mdb$\|\.mid$\|\.mim$\|\.moov$\|\.mov$\|\.movie$\|\.mp2$\|\.mp3$\|\.mp4$\|\.mpa$\|\.mpeg$\|\.mpg$\|\.msg$\|\.msi$\|\.nes$\|\.o$\|\.obj$\|\.ocx$\|\.odt$\|\.otf$\|\.pages$\|\.part$\|\.pct$\|\.pdb$\|\.pdf$\|\.pif$\|\.pkg$\|\.plugin$\|\.png$\|\.pps$\|\.ppt$\|\.pptx$\|\.prf$\|\.ps$\|\.psd$\|\.pspimage$\|\.qt$\|\.ra$\|\.rar$\|\.rm$\|\.rom$\|\.rpm$\|\.rtf$\|\.sav$\|\.scr$\|\.sdf$\|\.sea$\|\.sit$\|\.sitx$\|\.sln$\|\.smi$\|\.so$\|\.svg$\|\.swf$\|\.swp$\|\.sys$\|\.tar$\|\.tar.gz$\|\.tax2010$\|\.tga$\|\.thm$\|\.tif$\|\.tiff$\|\.tlb$\|\.tmp$\|\.toast$\|\.torrent$\|\.ttc$\|\.ttf$\|\.uu$\|\.uue$\|\.vb$\|\.vcd$\|\.vcf$\|\.vcxproj$\|\.vob$\|\.war$\|\.wav$\|\.wma$\|\.wmv$\|\.wpd$\|\.wps$\|\.xll$\|\.xlr$\|\.xls$\|\.xlsx$\|\.xpi$\|\.yuv$\|\.Z$\|\.zip$\|\.zipx$\|\.lib$\|\.res$\|\.rc$\|\.out$',
      \ }
let g:ctrlp_extensions = ['funky', 'line', 'k']
let g:ctrlp_regexp = 1


" VimOrganizer setup
let g:ft_ignore_pat = '\.org'
function! s:SetOrgFile()
  if !exists('b:OrgFile')
    let b:OrgFile = 1
    if exists(':NeoComplCacheDisable')
      NeoComplCacheDisable
    endif
    call org#SetOrgFileType()
    nnoremap <buffer> K /^\*.*\c\<\><Left><Left>
    setlocal wrap
  endif
endfunction
au BufRead,BufWrite,BufWritePost,BufNewFile *.org :call <SID>SetOrgFile()
command! OrgCapture :call org#CaptureBuffer()
command! OrgCaptureFile :call org#OpenCaptureFile()
" }}}
"
"
function! s:VimEscape(str)
  return substitute(a:str, '%', '\\%', 'g')
endfunction

" python utilities {{{
if has("python")
  "function! s:PyUtils()
    python import cgi
    python import HTMLParser
    python import base64
    python import datetime
    python import time
    python import json
    python import vim
    python htmlparser = HTMLParser.HTMLParser()
    com! -nargs=1 -bar CgiEscape python print cgi.escape("<args>", True)
    com! -nargs=1 -bar CgiUnescape python print htmlparser.unescape("<args>")
    com! -nargs=1 -bar Base64Encode python print base64.encodestring("<args>")
    com! -nargs=1 -bar Base64Decode python print base64.decodestring("<args>")
    com! -nargs=1 -bar Tm python print datetime.datetime.fromtimestamp(int("<args>")).strftime('%Y-%m-%d %H:%M:%S')
    com! -nargs=0 -bar Now python print time.mktime(datetime.datetime.now().timetuple())
    com! -range -bar FmtJSON :call FmtJSON(<line1>, <line2>)

    function! FmtJSON(lineStart, lineEnd)

      python << EOF
fmtlStart = int(vim.eval('a:lineStart'))-1
fmtlEnd = int(vim.eval('a:lineEnd'))
jsonStr = "\n".join(vim.current.buffer[fmtlStart:fmtlEnd])
prettyJson = json.dumps(json.loads(jsonStr), sort_keys=True, indent=4, separators=(',', ': '), ensure_ascii=False)
vim.current.buffer[fmtlStart:fmtlEnd] = prettyJson.split('\n')
EOF
    endfunction

    vnoremap <leader>wb "vy:execute g:launchWebBrowser.'http://www.baidu.com/s?wd='.<SID>VimEscape(CloudBoard#UrlEncode(@v, 1))<CR>
    vnoremap <leader>wg "vy:execute g:launchWebBrowser.'http://www.google.com.hk/search?q='.<SID>VimEscape(CloudBoard#UrlEncode(@v, 1))<CR>
  "endfunction
  "com! -nargs=0 -bar PyUtils call <SID>PyUtils()
endif
" }}}

let g:goog_user_conf = { 'langpair': 'en|zh', 'v_key': 'T' }
let g:EasyMotion_leader_key = '\'

if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif
nnoremap <space>h :windo if &bt=='help' <Bar>quit<Bar>endif<CR>
let &runtimepath = &runtimepath.",".s:vimfiles_dir."/after"
