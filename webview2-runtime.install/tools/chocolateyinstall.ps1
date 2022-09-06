$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE' #only one of these: exe, msi, msu
  file          = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx86_e04bb25031c5412119e66ee72d3c8bb3bbf25d88.exe'
  file64        = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx64_c7b2071fecbd4018d3d491f9d766436f90f5c288.exe'
  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.exe
