import-module au

 
$uri64 = "https://www.catalog.update.microsoft.com/Search.aspx?q=Microsoft Edge-WebView2 Runtime x64"
$uri32 = "https://www.catalog.update.microsoft.com/Search.aspx?q=Microsoft Edge-WebView2 Runtime x86"

function global:au_SearchReplace {
  $toolsDir = '$toolsDir'
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=.*)('.*')"   = "`$1'$(Split-Path $Latest.URL32 -Leaf)'"
      "(?i)(^\s*file64\s*=.*)('.*')" = "`$1'$(Split-Path $Latest.URL64 -Leaf)'"
    }
  }
}

function global:au_BeforeUpdate { 
  Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    # setup includes x32 and x64 versions

    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $uri32

    $re    = 'Microsoft Edge-WebView2 Runtime'
    $line   = $download_page.links | Where-Object outerHTML -match $re | Select-Object -First 1
    $versionMatch = $line -match ".*Build\s(\d+\.\d+\.\d+\.\d+).*"
    $version = $Matches[1]

    $guidMatch = $line -match '.*goToDetails\("(.*)"\).*'
    $guid = $Matches[1]

    $Post = @{size = 0; updateID = $guid; uidInfo = $guid} | ConvertTo-Json -Compress
    $Body = @{updateIDs = "[$Post]"}

    $Params = @{
        Uri = "https://www.catalog.update.microsoft.com/DownloadDialog.aspx"
        Method = "Post"
        Body = $Body
        ContentType = "application/x-www-form-urlencoded"
        UseBasicParsing = $true
    }

    $DownloadDialog = Invoke-WebRequest @Params
    
    $Regex = ".*'(https:.*)'.*"
    $url32line = $DownloadDialog.Content | Select-String  -Pattern $Regex
    $url32Match = $url32line -match $Regex
    $url32 = $Matches[1]
    


    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $uri64

    $re    = 'Microsoft Edge-WebView2 Runtime'
    $line   = $download_page.links | Where-Object outerHTML -match $re | Select-Object -First 1

    $guidMatch = $line -match '.*goToDetails\("(.*)"\).*'
    $guid = $Matches[1]

    $Post = @{size = 0; updateID = $guid; uidInfo = $guid} | ConvertTo-Json -Compress
    $Body = @{updateIDs = "[$Post]"}

    $Params = @{
        Uri = "https://www.catalog.update.microsoft.com/DownloadDialog.aspx"
        Method = "Post"
        Body = $Body
        ContentType = "application/x-www-form-urlencoded"
        UseBasicParsing = $true
    }

    $DownloadDialog = Invoke-WebRequest @Params
       
    $Regex = ".*'(https:.*)'.*"
    $url64line = $DownloadDialog.Content | Select-String  -Pattern $Regex
    $url64Match = $url64line -match $Regex
    $url64 = $Matches[1]


    # $content = $download_page.Content
    # $lines = $Content -split '\n'
    # $version = $lines | Where-Object {$_ -match "^\s+(\d+\.\d+\.\d+\.\d+)$"} | Select-Object -First 1
    # $version = $version.Trim()

    # $re_checksum = "#HxDPortableSetup_zip-signatures-popup"
    # $uri_checksum   = $download_page.links | Where-Object href -match $re_checksum | Select-Object -First 1 -expand href
    # $uri_checksum = $releases + $uri_checksum
        
    # $checksum_page = Invoke-WebRequest -UseBasicParsing -Uri $uri_checksum
    
    # $content1 = $checksum_page.Content
    # $lines = $Content1 -split '\n'
    # $checksum = $lines | Where-Object {$_ -match ">([0-9a-z]{128,128})<" } | Select-Object -First 1
    # $checksum -match ">([0-9a-z]{128,128})<"
    # $checksum = $Matches[1]
    
    @{
    URL32 = $url32
    URL64 = $url64
    Version = $version
  }
}

Update-Package -ChecksumFor None
