# About Brook Hong's vimfiles

Used across MacVim(MAC) and gVim(WINDOWS).

## Installation

    git clone git://github.com/brookhong/vimfiles.git <your_vimrc_folder>
    cd <your_vimrc_folder>
    git submodule update --init
    echo "source <your_vimrc_folder>/vimrc" >> <system_vimrc or user_vimrc>

Then launch vim and run --

    :call pathogen#helptags()

## Notes:

 * Can not submodule pathogen, refer to http://stackoverflow.com/questions/5232829/adding-git-submodule-into-the-root-of-the-repository, since I don't like the symlink idea.
