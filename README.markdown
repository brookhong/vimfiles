# About Brook Hong's vimfiles

Used across MacVim(MAC) and gVim(WINDOWS).

## Installation

    git clone git://github.com/brookhong/vimfiles.git <your_vimrc_folder>
    cd <your_vimrc_folder>
    git clone git://github.com/gmarik/vundle.git bundle/vundle
    echo "source <your_vimrc_folder>/vimrc" >> <system_vimrc or user_vimrc>
    vim +BundleInstall! +BundleClean +q
