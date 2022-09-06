$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'libreoffice-sdk-still'
  version                = '7.3.5'
  fileType               = 'msi'
  file                   =  Join-Path $toolsDir 'LibreOffice_7.3.5_Win_x86_sdk.msi'
  file64                 =  Join-Path $toolsDir 'LibreOffice_7.3.5_Win_x64_sdk.msi'
  checksum               = 'A3690A80067C98601DD6809F69BB9586DB889A6176497CA3E030F43A272F276B'
  checksum64             = '3DF0BC2BA17FB897BB91FA8213BD04BEEDFE5CB1F71D10FDBED98463514D2C26'
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  silentArgs             = '/qn /passive /norestart /l*v "{0}"' -f "$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log"
  validExitCodes         = @(0,3010)
  softwareName           = 'LibreOffice SDK*'
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.msi -Force -ErrorAction SilentlyContinue

