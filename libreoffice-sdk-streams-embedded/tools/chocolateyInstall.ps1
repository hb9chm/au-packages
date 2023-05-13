$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'libreoffice-sdk-still'
  version                = '7.4.7'
  fileType               = 'msi'
  file                   =  Join-Path $toolsDir 'LibreOffice_7.4.7_Win_x86_sdk.msi'
  file64                 =  Join-Path $toolsDir 'LibreOffice_7.4.7_Win_x64_sdk.msi'
  checksum               = '664610BDD23455DE14CD1AE4B26EB46C4C77C758E9B6DD7E8420C33C045C8A84'
  checksum64             = '3D42520E9B00079E2EFB152F14D572E9ABDD91E6B12B0DCFB4AD47ABFC457099'
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  silentArgs             = '/qn /passive /norestart /l*v "{0}"' -f "$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log"
  validExitCodes         = @(0,3010)
  softwareName           = 'LibreOffice SDK*'
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.msi -Force -ErrorAction SilentlyContinue

