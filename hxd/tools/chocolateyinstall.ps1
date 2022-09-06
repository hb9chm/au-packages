$ErrorActionPreference = 'Stop';

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# setup includes x32 and x64 versions
$zipLocation   = Join-Path $toolsDir 'HxDSetup_x32.zip'
$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupExe = Join-Path $unzipLocation 'HxDSetup.exe'

$checksumValidArgs = @{
    file = $zipLocation
    checksum       = 'EA97D98877342D725ADCBFA075D5D5770470CF4A1D79477D577D299B6298D62F9A7FEC8903633F8ADCDA7D306BFF848751F8C788B611CC2D1074624A9153BC49'
    checksumType   = 'sha512'
}


Get-ChecksumValid @checksumValidArgs

Get-ChocolateyUnzip -FileFullPath $zipLocation -Destination $unzipLocation
Install-ChocolateyInstallPackage -PackageName 'HxD' -FileType 'exe' -SilentArgs '/silent' -File $setupExe

Remove-Item $unzipLocation -Recurse
Remove-Item $zipLocation
