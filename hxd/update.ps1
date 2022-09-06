import-module au

$domain   = 'https://mh-nexus.de'
$releases = "$domain/en/downloads.php?product=HxD20"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_BeforeUpdate { 
  $checksum_web = $Latest.Checksum32
  Get-RemoteFiles -Purge -Algorithm 'sha512'
  if ($Latest.Checksum32 -ne $checksum_web) {
    throw 'checksum difference between au_GetLatest and Get-RemoteFiles'
  } 
}

function global:au_GetLatest {
    # setup includes x32 and x64 versions

    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases

    $re    = 'HxDSetup.zip'
    $url   = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $content = $download_page.Content
    $lines = $Content -split '\n'
    $version = $lines | Where-Object {$_ -match "^\s+(\d+\.\d+\.\d+\.\d+)$"} | Select-Object -First 1
    $version = $version.Trim()

    $re_checksum = "#HxDPortableSetup_zip-signatures-popup"
    $uri_checksum   = $download_page.links | Where-Object href -match $re_checksum | Select-Object -First 1 -expand href
    $uri_checksum = $releases + $uri_checksum
        
    $checksum_page = Invoke-WebRequest -UseBasicParsing -Uri $uri_checksum
    
    $content1 = $checksum_page.Content
    $lines = $Content1 -split '\n'
    $checksum = $lines | Where-Object {$_ -match ">([0-9a-z]{128,128})<" } | Select-Object -First 1
    $checksum -match ">([0-9a-z]{128,128})<"
    $checksum = $Matches[1]
    
    @{
    URL32 = $url
    Version = $version
    ChecksumType32 = 'sha512'
    Checksum32 = $checksum
  }
}

Update-Package -ChecksumFor None
