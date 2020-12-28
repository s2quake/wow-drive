Import-Module "./common.psm1"

try {
    $installPath = Get-InstallationPath
    $addonsPath = Join-Path $installPath "Interface/AddOns" -Resolve
    $backupPath = Join-Path $installPath "Interface/AddOns-new"
    $zipPath = Get-LatestZipPath $PSScriptRoot "AddOns"
    
    Expand-Archive -LiteralPath $zipPath -DestinationPath $backupPath
    Remove-Item $addonsPath -Recurse -Force
    Move-Item $backupPath $addonsPath
}
finally {
    Remove-Module "common"
}
