# About Brook Hong's vimfiles

Used across MacVim(MAC) and gVim(WINDOWS).

## Installation

    git clone git://github.com/brookhong/vimfiles.git <your_vimrc_folder>
    cd <your_vimrc_folder>
    git clone git://github.com/gmarik/vundle.git bundle/vundle
    echo "source <your_vimrc_folder>/vimrc" >> <system_vimrc or user_vimrc>
    vim +BundleInstall! +BundleClean +q

## Key Mappings

    ^                   => search word under cursor with ignorecase on
    <C-C>               => calculate expession at current line, for example, at a new line, input (3+4)*2=<C-C>
    <F5>                => insert date time like 22:35 2012/03/21
    <leader>e           => ToggleNERDTree
    <leader>d           => delete to black hole register "_
    <leader>f           => tabf <cfile>
    <leader>g           => Grep word under cursor
    <leader>i           => search input string with Ignorecase on
    <leader>j           => paste from registers interactively
    <leader>l           => toggle Location list
    <leader>m           => go to Mark interactively
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
    <leader>wt          => search from Web by baidu Translation
    <leader>ya          => Yank All lines with PATTERN to register Z
    <Space>q            => close current window
    <Space>t            => new Tab
    <Space>w            => new Window
    <S-TAB>             => toggle expandtab
