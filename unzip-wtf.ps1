
Import-Module "./common.psm1"

try {
    $installPath = Get-InstallationPath
    $wtfPath = Join-Path $installPath "WTF" -Resolve
    # $installPath = Resolve-Path "."
    # $wtfPath = Join-Path $installPath "WTF" -Resolve
    
    $zipPath = Get-LatestZipPath $PSScriptRoot "WTF"
    $expandPath = Join-Path (Resolve-Path "~") "WTF"
    # $zipPath = Get-LatestZipPath $PSScriptRoot "WTF"
    # $expandPath = Join-Path $PSScriptRoot "WTF-temp"
    Expand-Archive -LiteralPath $zipPath -DestinationPath $expandPath
    $accounts = Get-AccountPaths $expandPath
    $accounts | ForEach-Object {
        $item = Get-Item $_
        $destinationPath = Join-Path $wtfPath "Account/$($item.Name)"
        $destinationTempPath = Join-Path $wtfPath "Account/$($item.Name)-new"

        if (Test-Path $destinationPath) {
            Copy-Item $_ $destinationTempPath -Recurse
            Remove-Item $destinationPath -Recurse -Force
            Move-Item $destinationTempPath $destinationPath
        }
        else {
            Copy-Item $_ $destinationPath -Recurse
        }
    }
}
finally {
    if ($expandPath -and (Test-Path $expandPath)) {
        Remove-Item $expandPath -Force -Recurse
    }
    Remove-Module "common"
}