# About Brook Hong's vimfiles

Used across vim(terminal), MacVim(MAC) and gVim(WINDOWS/linux).

## Installation

    git clone git://github.com/brookhong/vimfiles.git <your_vimrc_folder>
    cd <your_vimrc_folder>
    git clone git://github.com/gmarik/vundle.git bundle/vundle
    echo "source <your_vimrc_folder>/vimrc" >> <system_vimrc or user_vimrc>
    vim +BundleInstall! +BundleClean +q

## Key Mappings

    ^                   => search word under cursor with ignorecase on
    Y                   => y$
    <C-C>               => calculate expession at current line, for example, at a new line, input (3+4)*2=<C-C>
    <F5>                => insert date time like 22:35 2012/03/21
    <S-TAB>             => toggle expandtab
    <leader>,           => translate word uner cursor with sdcv
    <leader>d           => delete to black hole register "_
    <leader>e           => ToggleNERDTree
    <leader>g           => Grep word under cursor
    <leader>i           => search input string with Ignorecase on
    <leader>j           => paste from registers interactively
    <leader>l           => toggle Location list
    <leader>m           => go to Mark interactively
    <leader>r           => run current file
    <leader>nh          => clear(No) search Highlight
    <leader>qa          => Quit All
    <leader>qb          => Quick Buffer by CtrlPBuffer
    <leader>qc          => Quick Clear
    <leader>qd          => Quick Diff by Gdiff
    <leader>qf          => Quick File by CtrlPMRU
    <leader>qi          => Quick Index word under cursor
    <leader>ql          => Quick Load session
    <leader>qs          => Quit and Save session
    <leader>qx          => force to Quit
    <leader>sh          => Split Horizontally
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

## Extened Commands

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

## Most useful keystrokes
### Insert mode
    ctrl+r              => help <C-R>
### Normal mode
    vat                 => help text-objects
