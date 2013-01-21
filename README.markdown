# About Brook Hong's vimfiles

Used across vim(terminal), MacVim(MAC) and gVim(WINDOWS/linux).

## Installation

    git clone git://github.com/brookhong/vimfiles.git <your_vimrc_folder> && cd <your_vimrc_folder> && git submodule update --init
    echo "source <your_vimrc_folder>/vimrc" >> <system_vimrc or user_vimrc>
    vim +BundleInstall! +BundleClean +q

## Key Mappings

### Insert mode
    <C-F>               => calculate expession at current line, for example, at a new line, input (3+4)*2=<C-C>
    <F5>                => insert date time like 22:35 2012/03/21
    <S-TAB>             => toggle expandtab
### Visual mode
    <Space>f            => tabf <selected file>
    *                   => search visual selected text
    <leader>g           => quick replace visual selected text
    <leader>s           => quick replace visual selected text, with word boundary
### Normal mode
    #                   => search word under cursor with ignorecase on
    dl                  => dt_, delete till _
    Y                   => y$
    <C-B>               => switch buffer forward
    <C-J>               => go to next location from location list, with :lnext
    <C-K>               => go to previous location from location list, with :lprevious
    <S-TAB>             => toggle expandtab
    <leader>,           => translate word uner cursor with sdcv
    <leader>a           => Add current word to my vocabulary.lst
    <leader>d           => delete to black hole register "_
    <leader>e           => ToggleNERDTree
    <leader>g           => Grep word under cursor
    <leader>i           => search input string with Ignorecase on
    <leader>j           => paste from registers interactively
    <leader>l           => toggle Location list
    <leader>m           => go to Mark interactively
    <leader>r           => run current file, for perl/php/python/ruby/perl/html. As to bash, current buffer will be replaced.
    <leader>t           => toggle Tag list
    <leader>nh          => clear(No) search Highlight
    <leader>qa          => Quit All
    <leader>qb          => Quick Buffer by CtrlPBuffer
    <leader>qc          => Quick Clear
    <leader>qd          => Quick Diff by Gdiff
    <leader>qf          => Quick File by CtrlPMRU
    <leader>qi          => Quick Index word under cursor
    <leader>ql          => Quick Load session
    <leader>qn          => force to new buffer
    <leader>qs          => Quit and Save session
    <leader>qx          => force to Quit
    <leader>sh          => Split Horizontally
    <leader>sl          => Toggle &list
    <leader>sv          => Split Vertically
    <leader>ve          => Vimrc to be Edit
    <leader>vs          => Vimrc to be Source
    <leader>wb          => search from Web by Baidu
    <leader>wl          => Web Launcher with URL under cursor
    <leader>wt          => search from Web by baidu Translation
    <leader>ya          => Yank All lines with PATTERN to register Z
    <Space>,            => close brook's console window
    <Space>f            => tabf <cfile>
    <Space>q            => close current window
    <Space>t            => new Tab
    <Space>v            => new window Vertically
    <Space>w            => new Window

## Extended Commands

    C                   => Count the number of matches for last search pattern(@/)
    C <pattern>         => Count the number of matches for pattern
    H <pattern>         => search in Help
    I <pattern>         => include-search(:il) in current buffer, then open location list
    L                   => Locate PATTERN in current directory
    S <phrase>          => search \<<phrase>\>
    Df                  => diff two vertically opened files
    Et <number>         => expandtab with tabstop as <number>
    Gd                  => exec ':g/'.@/.'/d'
    Rc <excommands>     => Read result from command to brook's console window
    Ri <excommands>     => Read result from command to current buffer
    Vd                  => exec ':v/'.@/.'/d'
    D2h                 => convert current line from Decimal to Hexical
    H2d                 => convert current line Hexical to Decimal
    Vsd <file>          => Vertically split open <file>, then diff it with current file
    Dos2Unix            => Dos2Unix
    FmtXML              => FmtXML
    HtmlImg             => convert image file path to <img> html tag
    RmAllNL             => Remove All New Line
    RmDupLine           => Remove Duplicate Lines
    RmEmptyLine         => Clear Empty Line
    TrailBlanks         => padding all visual selected lines with trailing blanks
    SmallFont           => reduce font size in VIM with GUI, such gvim/macvim
    LargeFont           => enlarge font size in VIM with GUI, such gvim/macvim

## Most useful keystrokes
### Insert mode
    ctrl+r              => help <C-R>
### Normal mode
    vat                 => help text-objects

## Plugins
### gmarik/vundle -- https://github.com/gmarik/vundle
### Shougo/neocomplcache -- https://github.com/Shougo/neocomplcache
### Shougo/neosnippet -- https://github.com/Shougo/neosnippet
### scrooloose/nerdcommenter -- https://github.com/scrooloose/nerdcommenter
### scrooloose/nerdtree -- https://github.com/scrooloose/nerdtree
### kien/ctrlp.vim -- https://github.com/kien/ctrlp.vim
### tpope/vim-fugitive -- https://github.com/tpope/vim-fugitive
### tpope/vim-surround -- https://github.com/tpope/vim-surround
### brookhong/DBGPavim -- https://github.com/brookhong/DBGPavim
### brookhong/cscope.vim -- https://github.com/brookhong/cscope.vim
### brookhong/neco-php -- https://github.com/brookhong/neco-php
### taglist.vim
### matchit.zip
### godlygeek/tabular -- https://github.com/godlygeek/tabular
### hsitz/VimOrganizer -- https://github.com/hsitz/VimOrganizer
### mattn/gist-vim -- https://github.com/mattn/gist-vim
