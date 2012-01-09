# About Brook Hong's vimfiles

Used across MacVim(MAC) and gVim(WINDOWS).

## Installation

    git clone git://github.com/brookhong/vimfiles.git <your_vimrc_folder>
    cd <your_vimrc_folder>
    git submodule update --init
    echo "source <your_vimrc_folder>/vimrc" >> <system_vimrc or user_vimrc>

To install Command-T under Windows

 * Download http://rubyforge.org/frs/download.php/75128/ruby-1.9.2-p290-i386-mingw32.7z, extract to a folder such as D:\tools\ruby-1.9.2-p290-i386-mingw32
 * Run sysdm.cpl to add D:\tools\ruby-1.9.2-p290-i386-mingw32\bin to system-wide path
 * Download https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe, extract to a folder such as D:\tools\DevKit-tdm-32
 * Download *gvim with ruby support* from http://wyw.dcweb.cn/download.asp?path=vim&file=gvim73.zip
 * Start command prompt then run D:/tools/DevKit-tdm-32/devkitvars.bat
 * cd <your_vimrc_folder>/bundle/bundle/command-t/ruby/command-t
 * ruby extconf.rb
 * make

Then launch vim and run --

    :call pathogen#helptags()

## Notes:

 * Can not submodule pathogen, refer to http://stackoverflow.com/questions/5232829/adding-git-submodule-into-the-root-of-the-repository, since I don't like the symlink idea.
