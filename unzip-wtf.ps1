param(
    [string[]]$Accounts = @("S2QUAKE")
)
Import-Module "./common.psm1"

try {
    $wtfPath = Get-WTFPath
    $zipPath = Get-LatestZipPath (Get-OneDrivePath) "WTF"
    $expandPath = Join-Path (Resolve-Path "~") "WTF"

    Expand-Archive -LiteralPath $zipPath -DestinationPath $expandPath
    $accountPaths = Get-AccountPaths $expandPath -Filter $Accounts
    $accountPaths | ForEach-Object {
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