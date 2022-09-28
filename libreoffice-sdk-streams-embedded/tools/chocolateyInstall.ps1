$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'libreoffice-sdk-still'
  version                = '7.3.6'
  fileType               = 'msi'
  file                   =  Join-Path $toolsDir 'LibreOffice_7.3.6_Win_x86_sdk.msi'
  file64                 =  Join-Path $toolsDir 'LibreOffice_7.3.6_Win_x64_sdk.msi'
  checksum               = '6874B9F7B3A8B4D09850FCCD6DF85DE604513DB39BC206BC8A7C38A52C2BED94'
  checksum64             = '22D4AB0B33E18064D2CE08CA47BF38B795EB615939166714E0F04BACCC8946A6'
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  silentArgs             = '/qn /passive /norestart /l*v "{0}"' -f "$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log"
  validExitCodes         = @(0,3010)
  softwareName           = 'LibreOffice SDK*'
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $toolsDir\*.msi -Force -ErrorAction SilentlyContinue

