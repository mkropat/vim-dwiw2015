$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$bootstrapPath = Join-Path $toolsPath bootstrap.ps1
$installCtxPath = Join-Path $toolsPath 'Install-ContextMenu.ps1'

& $bootstrapPath

Start-ChocolateyProcessAsAdmin "& `'$installCtxPath`'"
