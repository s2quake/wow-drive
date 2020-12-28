Import-Module "./common.psm1"

try {
    $addonsPath = Join-Path $installPath "Interface\AddOns" -Resolve
    $zipPath = New-ZipPath $PSScriptRoot "AddOns"
    Compress-Archive -Path "$addonsPath/*" -DestinationPath $zipPath
}
finally {
    Remove-Module "common"
}