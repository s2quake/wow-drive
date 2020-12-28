$registryPath = "HKLM:\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft"

if (-Not (Test-Path $registryPath)) {
    Write-Error "''$registryPath'' does not exists." -ErrorAction Stop
}

$installPath = (Get-ItemProperty -Path $registryPath -Name "InstallPath").InstallPath
$addonsPath = Join-Path (Join-Path $installPath "Interface") "AddOns"
$backupPath = Join-Path (Join-Path $installPath "Interface") "AddOns.bak"

if (-Not (Test-Path $addonsPath)) {
    Write-Error "''$addonsPath'' does not exists." -ErrorAction Stop
}

$files = Get-ChildItem "$PSScriptRoot" | 
        Where-Object { $_ -Match "AddOns-\d\d\d\d-\d\d-\d\d[.]zip" } | 
        ForEach-Object -Process { $_ -replace "AddOns-(\d\d\d\d-\d\d-\d\d)[.]zip", "`$1" } | 
        ForEach-Object -Process { [DateTime]::ParseExact($_, "yyyy-MM-dd", $null) } | 
        Sort-Object -Descending
        
if ($files.Length -eq 0) {
    Write-Error "AddOns file does not exits." -ErrorAction Stop
}

$zipName = "AddOns-" + ("{0:yyyy-MM-dd}" -f $files[0]) + ".zip"
$zipPath = Join-Path "$PSScriptRoot" $zipName

if (Test-Path $addonsPath) {
    Move-Item $addonsPath $backupPath -ErrorAction Stop
}

Expand-Archive -LiteralPath "$zipPath" -DestinationPath "$addonsPath"

if (Test-Path $backupPath) {
    Remove-Item $backupPath -Recurse
}
