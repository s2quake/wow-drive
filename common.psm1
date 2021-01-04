function Get-InstallationPath {
    $registryPath = "HKLM:\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft"
    
    $platform = [System.Environment]::OSVersion.Platform
    if ($platform -eq "Win32NT") {
        if (-Not (Test-Path $registryPath)) {
            Write-Error "'$registryPath' does not exists." -ErrorAction Stop
        }
        $installPath = (Get-ItemProperty -Path $registryPath -Name "InstallPath").InstallPath
    }
    elseif ($platform -eq "Unix") {
        $installPath = "/Applications/World of Warcraft/_retail_/"
    }
    
    if (!$installPath -or !(Test-Path $installPath)) {
        Write-Error "World of Warcraft is not installed." -ErrorAction Stop
    }
    return $installPath
}

function Get-OneDrivePath {
    return Resolve-Path "~/OneDrive/World of Warcraft"
}

function Get-WTFPath {
    $installationPath = Get-InstallationPath
    return Join-Path $installationPath "WTF" -Resolve -ErrorAction Stop
}

function Get-AddonsPath {
    $installationPath = Get-InstallationPath
    return Join-Path $installationPath "Interface/AddOns" -Resolve -ErrorAction Stop
}

function Get-AccountPaths {
    param(
        [string]$WTFPath,
        [string[]]$Filter
    )
    $accountPath = Join-Path $WTFPath "Account" -Resolve
    $accountPaths = Get-ChildItem $accountPath -Exclude "SavedVariables"
    return $accountPaths | Where-Object {
        $item = Get-Item $_
        return !$Accounts -or ($item.Name -in $Accounts)
    }
}

function New-ZipPath {
    param(
        [string]$Path,
        [string]$Name,
        [switch]$Resolve
    )
    $date = Get-Date -Format yyyy-MM-dd
    $outputPath = Join-Path $Path "$Name-$date.zip" -Resolve:$Resolve
    if (!$Resolve -and (Test-Path $outputPath)) {
        throw "'$outputPath' already exists."
    }
    return $OutputPath
}

function Get-LatestZipPath {
    param(
        [string]$Path,
        [string]$Name
    )    
    $files = Get-ChildItem $Path | 
    Where-Object { $_ -Match "$Name-\d\d\d\d-\d\d-\d\d[.]zip" } | 
    ForEach-Object -Process { $_ -replace ".*$Name-(\d\d\d\d-\d\d-\d\d)[.]zip", "`$1" } | 
    ForEach-Object -Process { [DateTime]::ParseExact($_, "yyyy-MM-dd", $null) } | 
    Sort-Object -Descending
        
    if ($files.Length -eq 0) {
        throw "$Name file does not exits."
    }
    $zipName = "$Name-" + ("{0:yyyy-MM-dd}" -f $files[0]) + ".zip"
    return Join-Path $Path $zipName
}

Export-ModuleMember Get-InstallationPath, Get-AccountPaths, New-ZipPath, Get-LatestZipPath, Get-WTFPath, Get-AddonsPath, Get-OneDrivePath