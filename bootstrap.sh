#!/bin/sh

       myvim_path=~/.vim
     myvimrc_path=~/.vimrc
 loader_file_path="$myvim_path/dwiw-loader.vim"
bundles_file_path="$myvim_path/bundles.vim"
      bundle_path="$myvim_path/bundle"
      vundle_path="$bundle_path/vundle"

quiet=--quiet

main() {
    parse_options "$@" &&

    ensure_vundle_installed &&
    ensure_loader_file_exists &&
    ensure_bundles_file_populated &&
    ensure_vimrc_hook_exists &&

    install_bundles &&

    msg 'Bootstrap successful! Run `vim` or `gvim` to get started'
}

parse_options() {
    while getopts v opt; do
        case "$opt" in
            v)  # be verbose
                quiet=
                ;;
        esac
    done

    shift $(( OPTIND - 1 ))
}

ensure_vundle_installed() {
    if [ -d "$vundle_path/.git" ]; then
        return
    fi

    msg "Installing Vundle into $vundle_path"
    git clone "$quiet" https://github.com/gmarik/vundle.git "$vundle_path" ||
        die "Error: unable to clone Vundle repo"
}

ensure_loader_file_exists() {
    if [ ! -e "$loader_file_path" ]; then
        msg "Creating loader script at $loader_file_path"
        write_loader_script_to "$loader_file_path" ||
            die "Error: unable to create loader script at $loader_file_path"
    fi
}

write_loader_script_to() {
    local script="\" loader.vim - Load Vundle and tell it about bundles
\" Version: 1.0
set nocompatible
filetype off
set rtp+=$vundle_path/
call vundle#rc()
source $bundles_file_path
filetype plugin indent on"
    echo "$script" >|"$1"
}

ensure_bundles_file_populated() {
    if [ ! -e "$bundles_file_path" ]; then
        msg "Creating bundles file at $bundles_file_path"
    fi

    ensure_bundle_line 'gmarik/vundle'

    ensure_bundle_line 'tpope/vim-sensible'
    ensure_bundle_line 'mkropat/vim-dwiw2015'

    ensure_bundle_line 'bling/vim-airline'
    ensure_bundle_line 'tpope/vim-sleuth'
    ensure_bundle_line 'mileszs/ack.vim'
    ensure_bundle_line 'scrooloose/nerdcommenter'
    ensure_bundle_line 'kien/ctrlp.vim'
}

ensure_bundle_line() {
    if ! fgrep -qe "$1" "$bundles_file_path" 2>/dev/null; then
        printf "Bundle '%s'\n" "$1" >>"$bundles_file_path"
    fi
}

ensure_vimrc_hook_exists() {
    if ! grep -qe "^source $loader_file_path" "$myvimrc_path"; then
        msg "Adding hook to .vimrc"
        prepend_line "source $loader_file_path" "$myvimrc_path" ||
            die "Error: unable to add loader hook to $myvimrc_path"
    fi
}

install_bundles() {
    msg "Calling Vundle's :BundleInstall!"
    vim +BundleInstall! +qall - ||
        die "Error: unable to start vim"
}

msg() {
    printf '%s\n' "$*"
}

die() {
    printf '%s\n' "$*"
    exit 1
}

prepend_line() {
    local tempfile=$(make_tempfile)
    touch "$2"
    echo "$1" | cat - "$2" >"$tempfile" && mv "$tempfile" "$2"
}

make_tempfile() {
    mktemp "${TMPDIR:-/tmp}/dwiw2015.XXXXX"
}

main "$@"