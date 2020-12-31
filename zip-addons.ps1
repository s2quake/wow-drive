Import-Module "./common.psm1"

try {
    $addonsPath = Get-AddonsPath
    $zipPath = New-ZipPath $PSScriptRoot "AddOns"
    Compress-Archive -Path "$addonsPath/*" -DestinationPath $zipPath
}
finally {
    Remove-Module "common"
}