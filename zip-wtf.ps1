Import-Module "./common.psm1"

$garbagePaths = @(
    "WTF/Config.wtf",
    "WTF/SavedVariables",
    "WTF/Account/SavedVariables"
)

try {
    $tempPath = Resolve-Path "~"
    $wtfPath = Get-WTFPath
    $zipPath = New-ZipPath $PSScriptRoot "WTF"
    Copy-Item $wtfPath $tempPath -Recurse
    $srcPath = Join-Path $tempPath "WTF" -Resolve
    $garbagePaths | Where-Object { Test-Path $_ } | ForEach-Object { Remove-Item $_ -Recurse -Force }
    Compress-Archive "$srcPath/*" $zipPath
}
finally {
    if ($srcPath) {
        Remove-Item $srcPath -Recurse -Force
    }
    Remove-Module "common"
}