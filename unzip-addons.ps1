Import-Module "./common.psm1"

try {
    $addonsPath = Get-AddonsPath
    $backupPath = "$addonsPath-new"
    $zipPath = Get-LatestZipPath (Get-OneDrivePath) "AddOns"
    
    Expand-Archive -LiteralPath $zipPath -DestinationPath $backupPath
    Remove-Item $addonsPath -Recurse -Force
    Move-Item $backupPath $addonsPath
}
finally {
    Remove-Module "common"
}
