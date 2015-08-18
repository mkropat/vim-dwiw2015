$packageName = 'vim-dwiw2015'

$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$bootstrapPath = Join-Path $toolsPath bootstrap.ps1
$installCtxPath = Join-Path $toolsPath 'Install-ContextMenu.ps1'

try {
    & $bootstrapPath

    Start-ChocolateyProcessAsAdmin "& `'$installCtxPath`'"

    Write-ChocolateySuccess "$packageName"
} catch {
    Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
    throw
}
