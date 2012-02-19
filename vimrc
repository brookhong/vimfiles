" vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set nocompatible
set number
set nobackup " do not keep a backup file, use versions instead
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set hlsearch    "hilight searches by default
set cursorline
set guioptions-=T "disable toolbar
" set paste " cause abbreviate not working under linux/terminal

" automatic change directory to current buffer
"if exists('+autochdir')
  "set autochdir
"endif

syntax on
colorscheme desert

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
  redi @x
  silent exec a:exCmd
  redi END
  exec "normal \"xp"
endfunction
com! -nargs=* -complete=command -bar Rx call ReadExCmd(<q-args>)

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
nmap <silent> <leader>qd :%s/^\(.*\)\n\1$/\1/g<CR>
nmap <silent> <leader>qj :%s/\n//g<CR>
nmap <silent> <leader>qc :g/^\s*$/d<CR>
nmap <silent> <leader>nh /the quick brown fox jumps over the lazy dog/<CR>
nmap <silent> <leader>e :NERDTreeToggle<CR>
nmap <silent> <leader>m :MRU<CR>
nmap <silent> <leader>f :tabf <cfile><CR>
nmap <silent> <leader>sh :sp <cfile><CR>
nmap <silent> <leader>sv :vs <cfile><CR>

function! LaunchWebBrowser(url)
  if has("win32")
    execute ":silent ! start ".a:url
  elseif has("mac")
    execute ":silent ! open /Applications/Google\\ Chrome.app ".a:url
  else
    echo a:url
  endif
endfunction
autocmd FileType php        noremap <silent> <leader>r :!php %<CR>
autocmd FileType python     noremap <silent> <leader>r :!python %<CR>
autocmd FileType ruby       noremap <silent> <leader>r :!ruby %<CR>
autocmd FileType perl       noremap <silent> <leader>r :!perl %<CR>
autocmd FileType php        noremap K :call LaunchWebBrowser("http://jp.php.net/manual-lookup.php?pattern=".expand("<cword>")."&lang=zh&scope=quickref")<CR>
autocmd FileType vim        setlocal keywordprg=:help
noremap T :call LaunchWebBrowser("http://dict.baidu.com/s?wd=".expand("<cword>"))<CR>

map <silent> <Space>q :q<CR>
map <silent> <Space>t :tabe<CR>

set cscopequickfix=s-,c-,d-,i-,t-,e-
function! GetCscopeDB()
  redi @x
  silent execute ":cs show"
  redi END
  return getreg('x')
endfunction
function! ChangeDir(dir)
  cs kill -1
  execute ":cd ".a:dir
  if filereadable("cscope.out")
    cs add cscope.out
  endif
  let l:cs_show = GetCscopeDB()
  let g:no_cscope_db = stridx(l:cs_show,"no cscope connections")+1
endfunction
com! -nargs=? -complete=dir -bar C :call ChangeDir(<q-args>)

let g:no_cscope_db = 1
let w:family_type = "**/*"
function! SetFileFamily()
  let l:ext = expand("%:e")
  if l:ext == ""
    let w:family_type = "**/*"
  elseif (l:ext == "as" || l:ext == "mxml")
    let w:family_type = "**/*.as **/*.mxml"
  elseif (l:ext == "cpp" || l:ext == "cc" || l:ext == "cxx" || l:ext == "c" || l:ext == "m" || l:ext == "hpp" || l:ext == "hh" || l:ext == "h" || l:ext == "hxx")
    let w:family_type = "**/*.cpp **/*.cc **/*.cxx **/*.c **/*.m **/*.hpp **/*.hh **/*.h **/*.hxx"
  else
    let w:family_type = "**/*.".l:ext
  endif
endfunction
autocmd BufNewFile,BufCreate,BufRead * call SetFileFamily()
function! LVimGrep(word)
  if strlen(a:word) > 0
    let w:location_list=1
    if g:no_cscope_db == 1
      execute 'lvim /\<'.a:word.'\>/gj '.w:family_type.' | lw'
    else
      execute 'lcs find t '.a:word
      lw
    endif
  endif
endfunction
function! ToggleLocationList()
  if &buftype == "quickfix"
    if winnr() > 1
      silent exec "normal \<C-W>k"
      if &buftype == "quickfix"
        silent exec "normal \<C-W>j"
      endif
    endif
    if &buftype == "quickfix"
      lfirst
      let w:location_list = 1
    endif
  endif
  if exists('w:location_list') == 0
    echohl WarningMsg | echo "Type ".g:mapleader."g to grep at first." | echohl None
  elseif w:location_list == 1
    lclose
    let w:location_list = 0
  else
    let w:location_list = 1
    lopen
  endif
endfunction

com! -nargs=? -bar L :call LVimGrep(<q-args>)
nmap L :L 
nmap <leader>g :call LVimGrep("<C-R><C-W>")<CR>
nmap <leader>l :call ToggleLocationList()<CR>

com! -nargs=0 -bar Dos2Unix :%s/\r//g
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
