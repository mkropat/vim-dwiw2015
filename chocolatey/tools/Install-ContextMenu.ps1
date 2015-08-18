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

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT `
    -ErrorAction SilentlyContinue | Out-Null
    
Set-Location -LiteralPath HKCR:\*\shell
New-Item -Name vim -Force | Out-Null
Set-Item -Path vim -Value 'Edit with &Vim'

$path = Get-GvimExePath
New-Item -Path vim -Name command | Out-Null
Set-Item -Path vim\command -Value """${path}"" ""%1"""
