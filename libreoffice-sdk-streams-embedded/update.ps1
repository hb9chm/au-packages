import-module au

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\tools\"
. $toolsDir\helpers.ps1

function global:au_BeforeUpdate() {
    #Download $Latest.URL32 / $Latest.URL64 in tools directory and remove any older installers.
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_SearchReplace {
  $filesToPatchHashTable = @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(?i)(^\s*fileType\s*=\s*)('.*')"    = "`$1'$($Latest.FileType)'"
      "(?i)(^\s*file\s*=.*)('.*')"   = "`$1'$(Split-Path $Latest.URL32 -Leaf)'"
      "(?i)(^\s*file64\s*=.*)('.*')" = "`$1'$(Split-Path $Latest.URL64 -Leaf)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"  = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*version\s*=\s*)('.*')"     = "`$1'$($Latest.Version)'"
    }
    ".\libreoffice-sdk-streams-embedded.nuspec"  = @{
      "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
    }
  }

  $linesToPatch = $filesToPatchHashTable[".\tools\chocolateyInstall.ps1"]
  if ($Latest.FileType -eq "exe") {
    $linesToPatch["(?i)(^\s*silentArgs\s*=\s*)('.*')"] = "`$1'/S'"
  } else {
    $linesToPatch["(?i)(^\s*silentArgs\s*=\s*)(.*)"] = "`$1'/qn /passive /norestart /l*v `"{0}`"' -f `"`$(`$env:TEMP)\`$(`$env:ChocolateyPackageName).`$(`$env:ChocolateyPackageVersion).MsiInstall.log`""
  }
  $filesToPatchHashTable[".\tools\chocolateyInstall.ps1"] = $linesToPatch

  return $filesToPatchHashTable
}

function global:au_AfterUpdate {
  # Patch the json stream file
  $global:chocolateyCoreteampackagesLibreofficeSdkStreamEmbeddedJson | ConvertTo-Json | Set-Content .\libreoffice-sdk-streams-embedded.json
}

function global:au_GetLatest {

  $global:chocolateyCoreteampackagesLibreofficeSdkStreamEmbeddedJson = (Get-Content .\libreoffice-sdk-streams-embedded.json) | ConvertFrom-Json

  $stillVersionFrom = $global:chocolateyCoreteampackagesLibreofficeSdkStreamEmbeddedJson.still
  $stillVersionTo = GetLatestStillVersionFromLibOUpdateChecker
  $freshVersionFrom = $global:chocolateyCoreteampackagesLibreofficeSdkStreamEmbeddedJson.fresh
  $freshVersionTo = GetLatestFreshVersionFromLibOUpdateChecker

  $global:chocolateyCoreteampackagesLibreofficeSdkStreamEmbeddedJson.still = $stillVersionTo
  $global:chocolateyCoreteampackagesLibreofficeSdkStreamEmbeddedJson.fresh = $freshVersionTo

  $streams = New-Object -TypeName System.Collections.Specialized.OrderedDictionary
  AddLibOVersionsToStreams $streams "still" $stillVersionFrom $stillVersionTo
  AddLibOVersionsToStreams $streams "fresh" $freshVersionFrom $freshVersionTo

  return @{ Streams = $streams }
}

update -ChecksumFor none -NoCheckChocoVersion