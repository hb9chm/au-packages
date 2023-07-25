$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE' #only one of these: exe, msi, msu
  file          = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx86_b76527bea95a9a774a382cf1980397e17f4afa82.exe'
  file64        = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx64_83324cb7595e16735415a41cae6ed0d1b9a4888c.exe'
  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.exe
