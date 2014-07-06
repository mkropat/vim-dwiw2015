$packageName = 'vim-dwiw2015'

$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$bootstrapPath = Join-Path $toolsPath bootstrap.ps1

try {
    & $bootstrapPath -Uninstall
    Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
