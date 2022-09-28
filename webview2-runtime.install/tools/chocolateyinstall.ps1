$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE' #only one of these: exe, msi, msu
  file          = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx86_754b1b0c87453e57edf4bcb2e3c45898e629ef94.exe'
  file64        = Join-Path $toolsDir 'microsoftedgestandaloneinstallerx64_194e774a2f3a9f032463d446cde5669be0aa9212.exe'
  silentArgs    = '/silent /install'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.exe
