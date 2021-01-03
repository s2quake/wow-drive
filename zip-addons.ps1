Import-Module "./common.psm1"

try {
    $addonsPath = Get-AddonsPath
    $zipPath = New-ZipPath (Get-OneDrivePath) "AddOns"
    Compress-Archive -Path "$addonsPath/*" -DestinationPath $zipPath
}
finally {
    Remove-Module "common"
}