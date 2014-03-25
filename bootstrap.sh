#!/bin/sh

     myvimrc_path=~/.vimrc
  myvimfiles_path=~/.vim
  myvimfiles_tlde="~/.vim"
 loader_file_path="$myvimfiles_path/dwiw-loader.vim"
 loader_file_tlde="$myvimfiles_tlde/dwiw-loader.vim"
bundles_file_path="$myvimfiles_path/bundles.vim"
bundles_file_tlde="$myvimfiles_tlde/bundles.vim"
      vundle_path="$myvimfiles_path/bundle/vundle"
      vundle_tlde="$myvimfiles_tlde/bundle/vundle"

quiet=--quiet

main() {
    parse_options "$@"              &&
    check_for_prerequisites         &&

    ensure_vundle_installed         &&
    ensure_loader_file_exists       &&
    ensure_bundles_file_populated   &&
    ensure_vimrc_hook_exists        &&

    install_or_update_bundles       &&

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

check_for_prerequisites() {
    local missing=''
    for command in git vim; do
        if ! hash "$command" 2>/dev/null; then
            missing="$missing $command"
        fi
    done
    if [ -n "$missing" ]; then
        die "Error: missing dependencies:$missing"
    fi
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
    local loader_version="1.1"
    if [ ! -e "$loader_file_path" ]; then
        msg "Creating loader script at '$loader_file_path'"
        write_loader_script_to "$loader_file_path" "$loader_version" ||
            die "Error: unable to create loader script at $loader_file_path"
    elif [ "$(get_script_version "$loader_file_path")" != "$loader_version" ]; then
        msg "Upgrading loader script at '$loader_file_path' to latest version"
        write_loader_script_to "$loader_file_path" "$loader_version" ||
            die "Error: unable to create loader script at $loader_file_path"
    fi
}

get_script_version() {
    perl -ne '/^" Version: (.*)/ && do { print "$1\n"; exit }' "$1" 2>/dev/null
}

write_loader_script_to() {
    local script="\" dwiw-loader.vim - Load Vundle and tell it about bundles
\" Version: $2
set nocompatible
filetype off
set rtp+=$vundle_tlde/
call vundle#rc()
source $bundles_file_tlde
filetype plugin indent on
runtime! plugin/sensible.vim
runtime! plugin/dwiw2015.vim"
    printf '%s\n' "$script" >|"$1"
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
    if ! grep -qe "^source $loader_file_tlde" "$myvimrc_path" 2>/dev/null; then
        msg "Adding hook to .vimrc"
        prepend_line "source $loader_file_tlde" "$myvimrc_path" ||
            die "Error: unable to add loader hook to $myvimrc_path"
    fi
}

install_or_update_bundles() {
    msg "Calling Vundle's :BundleInstall!"
    vim -u "$loader_file_path" +BundleInstall! +qall - ||
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
    printf '%s\n' "$1" | cat - "$2" >"$tempfile" && mv "$tempfile" "$2"
}

make_tempfile() {
    mktemp "${TMPDIR:-/tmp}/dwiw2015.XXXXX"
}

main "$@"
