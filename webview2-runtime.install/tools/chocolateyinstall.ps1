$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE' #only one of these: exe, msi, msu
  file          = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx86_95b6e25c591f8ccf9aa20fc0877962dfbc906c3a.exe'
  file64        = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx64_d8024429abb0b9368551e07081c11b2722aefa80.exe'
  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.exe
