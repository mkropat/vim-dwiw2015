# bootstrap.ps1 -- install the dwiw2015 Vim distribution

# See the Github page (https://github.com/mkropat/vim-dwiw2015) for details

# It should be safe to run -- even on an existing Vim set up.  Re-running the
# `bootstrap.ps1` script is safe — it simply resumes the installation and
# checks for updates on any plug-ins already installed.


param (
    [switch]$Uninstall = $false
)

if (Test-Path Env:Home) {
    $home_path = $Env:Home
} else {
    $home_path = $Home
}

$myvimrc_path      = Join-Path $home_path _vimrc
$myvimfiles_path   = Join-Path $home_path vimfiles
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
    if ($Uninstall) {
        Uninstall-Dwiw
    } else {
        Install-Dwiw
    }
}

function Install-Dwiw {
    Ensure-GitOnPath

    EnsureInstalled-Vundle

    # Create `~\vimfiles\dwiw-loader.vim` script to load Vundle and then call
    # `bundles.vim`. Do not modify the loader file.
    EnsureCreated-LoaderFile

    # Create `~\vimfiles\bundles.vim` script, which contains a list of Vundle
    # plug-ins. Feel free to make local modifications to this file.
    EnsurePopulated-BundlesFile

    # Prepand a one-line hook in `~\_vimrc` to call `dwiw-loader.vim`.
    EnsureAdded-VimrcHook

    InstallOrUpdate-Plugins
}

function Uninstall-Dwiw {
    Remove-VimrcHook
    Remove-Item $loader_file_path -ErrorAction Silent

    Remove-DwiwBundle
    $plugin_path = Join-Path $bundle_path 'vim-dwiw2015'
    Remove-Item -Recurse $plugin_path -Force -ErrorAction Silent
}

function Ensure-GitOnPath {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        return
    }

    $gitPath = Get-GitPathFromRegistry
    if (-not $gitPath) {
        throw 'Unable to locate git.exe'
    }

    Add-EnvPath -Container User (Split-Path $gitPath)
}

function EnsureInstalled-Vundle {
    if (Test-Path -LiteralPath (Join-Path $vundle_path '.git') -PathType Container) {
        return
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

$loader_version = '1.1'
$dwiw_loader_script = @"
" dwiw-loader.vim - Load Vundle and tell it about bundles
" Version: $loader_version
set nocompatible
filetype off
set rtp+=$vundle_tlde/
call vundle#rc("$bundle_tlde")
source $bundles_file_tlde
filetype plugin indent on
runtime! plugin/sensible.vim
runtime! plugin/dwiw2015.vim
"@

function EnsureCreated-LoaderFile {
    if (! (Test-Path -LiteralPath $loader_file_path)) {
        Write-Output "Creating loader script at $loader_file_path"
        $dwiw_loader_script | Out-FileVimSafe $loader_file_path
    } elseif ((Get-ScriptVersion $loader_file_path) -ne '1.1') {
        Write-Output "Updating loader script at $loader_file_path to version $loader_version"
        $dwiw_loader_script | Out-FileVimSafe $loader_file_path
    }
}

function EnsurePopulated-BundlesFile {
    try {
        $existing_lines = Get-Content $bundles_file_path -ErrorAction Stop
    } catch {
        Write-Output "Creating bundles file at $bundles_file_path"
        $existing_lines = @()
    }

    # Migrate from old Vundle interface to new interface
    $existing_lines = $existing_lines | foreach { $_ -replace '^Bundle','Plugin' }

    $bundles =
        'gmarik/vundle',
        'tpope/vim-sensible',
        'mkropat/vim-dwiw2015',
        'bling/vim-airline',
        'kien/ctrlp.vim',
        'rking/ag.vim',
        'tpope/vim-commentary',
        'tpope/vim-sleuth'
    $lines_to_add = $bundles | %{ "Plugin '$_'" }
    $lines = $existing_lines + $lines_to_add | Select-Object -Unique
    $lines | Out-FileVimSafe $bundles_file_path
}

function Remove-DwiwBundle {
    try {
        Get-Content $bundles_file_path -ErrorAction Stop |
            Where-Object { $_ -notmatch "^Plugin 'mkropat/vim-dwiw2015'$" } |
            Out-FileVimSafe $bundles_file_path
    } catch {
        # Oh well
    }
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
        $lines | Out-FileVimSafe $myvimrc_path
    }
}

function Remove-VimrcHook {
    try {
        Get-Content $myvimrc_path -ErrorAction Stop |
            Where-Object { $_ -notmatch "^source $loader_file_tlde$" } |
            Out-FileVimSafe $myvimrc_path
    } catch {
        # Oh well
    }
}

function InstallOrUpdate-Plugins {
    Write-Output "Calling Vundle's :PluginInstall!"
    $gvim_args = @( "-u", "`"$loader_file_path`"", "+PluginInstall!", "+qall" )
    try {
        # Try to find gvim.exe in $Env:Path or in App Paths
        Start-Process gvim -ArgumentList $gvim_args
    } catch {
        try {
            # Failing that, try to locate it manually
            Start-Process (Get-GvimExePath) -ArgumentList $gvim_args
        } catch {
            throw "Unable to locate gvim.exe"
        }
    }
}

function Get-GvimExePath {
    # Find Vim directory from the *Cream* Vim Installer's UninstallString
    $is64bit = [IntPtr]::size -eq 8
    if ($is64bit) {
        $hklmSoftwareWindows = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion'
    } else {
        $hklmSoftwareWindows = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion'
    }
    $uninstallVim = Join-Path $hklmSoftwareWindows 'Uninstall\Vim'
    $uninstallString = (Get-ItemProperty $uninstallVim UninstallString).UninstallString
    $installDir = Split-Path -Parent $uninstallString
    return Join-Path $installDir 'gvim.exe'
}

function Get-ScriptVersion($script_path) {
    return Get-Content $script_path -ErrorAction SilentlyContinue |
        Select-String '^" Version: (.*)' |
        select -First 1 -ExpandProperty Matches |
        select -ExpandProperty Groups |
        select -Index 1 |
        select -ExpandProperty Value
}

function Out-FileVimSafe {
    param (
        [string]$FilePath
    )

    # Vim chokes on BOM outputted by Out-File
    [System.IO.File]::WriteAllLines($FilePath, @($input))
}

function Get-GitPathFromRegistry {
    $gitDir = Get-ItemProperty HKLM:\SOFTWARE\GitForWindows InstallPath -ErrorAction SilentlyContinue |
        select -ExpandProperty InstallPath -ErrorAction SilentlyContinue
    if ($gitDir) {
        @('bin', 'usr\bin') |
            foreach { Join-Path (Join-Path $gitDir $_) 'git.exe' } |
            where { Test-Path $_ } |
            select -First 1
    }
}

function Add-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | where { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | where { $_ }
        $env:Path = $envPaths -join ';'
    }
}

main
