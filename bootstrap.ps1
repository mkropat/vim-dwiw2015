$myvimrc_path      = Join-Path $env:UserProfile _vimrc
$myvimfiles_path   = Join-Path $env:UserProfile vimfiles
$myvimfiles_tlde   = '~/vimfiles'
$loader_file_path  = Join-Path $myvimfiles_path dwiw-loader.vim
$loader_file_tlde  = "$myvimfiles_tlde/dwiw-loader.vim"
$bundles_file_path = Join-Path $myvimfiles_path bundles.vim
$bundles_file_tlde = "$myvimfiles_tlde/bundles.vim"
$bundle_path       = Join-Path $myvimfiles_path bundle
$bundle_tlde       = "$myvimfiles_tlde/bundle"
$vundle_path       = Join-Path $bundle_path vundle
$vundle_tlde       = "$bundle_tlde/vundle"

function main {
    EnsureInstalled-Vundle
    EnsureCreated-LoaderFile
    EnsurePopulated-BundlesFile
    EnsureAdded-VimrcHook
    InstallOrUpdate-Bundles
}

function EnsureInstalled-Vundle {
    if (Test-Path -LiteralPath (Join-Path $vundle_path '.git') -PathType Container) {
        return
    }

    if (! (Get-Command -Name git -CommandType Application -ErrorAction SilentlyContinue)) {
        throw "Unable to locate git.exe"
    }

    Write-Output "Installing Vundle into $vundle_path"

    New-Item -Path $bundle_path -Type Directory -Force | Out-Null
    Push-Location $bundle_path
    try {
        & git clone --quiet https://github.com/gmarik/vundle.git vundle
    } finally {
        Pop-Location
    }
}

$dwiw_loader_script = @"
" loader.vim - Load Vundle and tell it about bundles
" Version: 1.0
set nocompatible
filetype off
set rtp+=$vundle_tlde/
call vundle#rc("$bundle_tlde")
source $bundles_file_tlde
filetype plugin indent on
"@

function EnsureCreated-LoaderFile {
    if (Test-Path -LiteralPath $loader_file_path) {
        return
    }
    Write-Output "Creating loader script at $loader_file_path"
    $dwiw_loader_script | Out-File -Encoding ascii $loader_file_path
}

function EnsurePopulated-BundlesFile {
    try {
        $old_lines = Get-Content $bundles_file_path -ErrorAction Stop
    } catch {
        Write-Output "Creating bundles file at $bundles_file_path"
        $old_lines = @()
    }
    $bundles =
        'gmarik/vundle',
        'tpope/vim-sensible',
        'mkropat/vim-dwiw2015',
        'bling/vim-airline',
        'tpope/vim-sleuth',
        'scrooloose/nerdcommenter',
        'kien/ctrlp.vim'
    $lines_to_add = $bundles | %{ "Bundle '$_'" }
    $lines = $old_lines + $lines_to_add | Select-Object -Unique
    [System.IO.File]::WriteAllLines($bundles_file_path, $lines) # Vim chokes on BOM outputted by Out-File
}

function EnsureAdded-VimrcHook {
    try {
        $lines = Get-Content $myvimrc_path -ErrorAction Stop
    } catch {
        Write-Output "Adding hook to $myvimrc_path"
        $lines = @()
    }
    if (! ($lines | Select-String -Pattern "source $loader_file_tlde")) {
        $lines = ,"source $loader_file_tlde" + $lines
        [System.IO.File]::WriteAllLines($myvimrc_path, $lines) # Vim chokes on BOM written by Out-File
    }
}

function InstallOrUpdate-Bundles {
    Write-Output "Calling Vundle's :BundleInstall!"
    Start-Process gvim -ArgumentList -u,$loader_file_path,+BundleInstall,+qall
}

main
