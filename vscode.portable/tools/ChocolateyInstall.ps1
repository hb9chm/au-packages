
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$PackageName = 'vscode.portable'
$PackageDir = 'vscode'

$File32  = (Join-Path $toolsDir "vscode_portable_x32.zip")
$File64  = (Join-Path $toolsDir "vscode_portable_x64.zip")

$ChecksumType32 = 'sha256'
$Checksum32 = '9824E1AEDEB92F80AE49C65D66276BF6D92FA24CA49D0DB2159F9F8F701B5FC2'

$ChecksumType64 = 'sha256'
$Checksum64 = 'E28C2585633052746EFBF0EFE9291FF8DFD82E232DF5A672FE7923F989214114'
$InstallationPath = Join-Path $(Get-ToolsLocation) $PackageDir
$DataPath = Join-Path $InstallationPath 'data'

Get-ChildItem -Path $InstallationPath -Exclude data -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $InstallationPath -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $DataPath -Force -ErrorAction SilentlyContinue

$PackageArgs = @{
    PackageName    = $PackageName
    File           = $File32
    ChecksumType   = $ChecksumType32
    Checksum       = $Checksum32
    File64         = $File64
    ChecksumType64 = $ChecksumType64
    Checksum64     = $Checksum64
    UnzipLocation  = $InstallationPath
}
Install-ChocolateyZipPackage @PackageArgs

$BinPath = Join-Path $InstallationPath "bin\code.cmd"
Install-BinFile -Name Code -Path $BinPath
$BinPath = Join-Path $InstallationPath "Code.exe"
$LinkPath = Join-Path $([Environment]::GetFolderPath("CommonDesktopDirectory")) "Visual Studio Code.lnk"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $LinkPath = Join-Path $([Environment]::GetFolderPath("DesktopDirectory")) "Visual Studio Code.lnk"
}
Install-ChocolateyShortcut -ShortcutFilePath $LinkPath -TargetPath $BinPath -WorkingDirectory $InstallationPath

Remove-Item -Force -ErrorAction SilentlyContinue -Path $toolsDir\*.zip
