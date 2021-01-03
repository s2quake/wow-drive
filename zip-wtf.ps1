Import-Module "./common.psm1"

$garbagePaths = @(
    "WTF/Config.wtf",
    "WTF/SavedVariables",
    "WTF/Account/SavedVariables"
)

try {
    $installPath = Get-InstallationPath
    $wtfPath = Join-Path $installPath "WTF" -Resolve -ErrorAction Stop

    Copy-Item -Path $wtfPath -Destination "~" -Recurse
    $srcPath = Join-Path "~" "WTF" -Resolve
    $garbagePaths | Where-Object { Test-Path $_ } | ForEach-Object { Remove-Item $_ -Recurse -Force }
    $zipPath = New-ZipPath (Get-OneDrivePath) "WTF"
    Compress-Archive -Path "$srcPath/*" -DestinationPath $zipPath
}
finally {
    if ($srcPath) {
        Remove-Item $srcPath -Recurse -Force
    }
    Remove-Module "common"
}