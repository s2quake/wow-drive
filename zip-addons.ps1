Import-Module "./common.psm1" -Verbose

$addonsPath = Join-Path $installPath "Interface\AddOns" -Resolve

if (-Not (Test-Path $addonsPath)) {
    Write-Error "'$addonsPath' does not exists." -ErrorAction Stop
}

$date = Get-Date -Format yyyy-MM-dd
$outputPath = Join-Path $PSScriptRoot "AddOns-$date.zip"
if (Test-Path $outputPath) {
    Write-Error "'$outputPath' already exists." -ErrorAction Stop
}

$archivePath = Join-Path $addonsPath "*" 
Compress-Archive -Path "$archivePath" -DestinationPath "$outputPath"
