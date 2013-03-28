usage() {
    echo "-r        run 'git checkout' for each bundle."
    echo "-p        tar vimfiles to ~/vimfiles.tgz without git metadata."
}
if [ $# -lt 1 ]; then
    usage
else
    case "x$1" in
        x-r)
            for i in `ls -1 bundle`;do cd bundle/$i && git co . && cd ../..;done;;
        x-p)
            (cd .. && tar czvf ~/vimfiles.tgz --exclude .gitignore --exclude .gitmodules --exclude .git --exclude .netrwhist --exclude .vundle --exclude .DS_Store vimfiles && cd - )>/dev/null && ls -l ~/vimfiles.tgz;;
        x*)
            usage;;
    esac
fi
