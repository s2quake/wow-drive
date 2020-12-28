Import-Module "./common.psm1" -Verbose

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
    $garbagePaths | ForEach-Object {
        if (Test-Path $_) {
            Remove-Item $_ -Recurse -Force
        }
    }

    $zipPath = New-ZipPath $PSScriptRoot "WTF"
    Compress-Archive -Path "$srcPath/*" -DestinationPath $zipPath
}
finally {
    if ($srcPath) {
       Remove-Item $srcPath -Recurse -Force
    }
}