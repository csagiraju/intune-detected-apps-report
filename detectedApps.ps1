<#
.SYNOPSIS
Searches for detected applications in Microsoft Intune that match a given keyword and exports the result to a CSV file.

.PARAMETER AppName
The partial or full name of the application to search for.

.EXAMPLE
.\detectedApps.ps1 -AppName "Chrome"
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$AppName
)

# Connect to Microsoft Graph with required permissions
try {
    Connect-MgGraph -Scopes "DeviceManagementConfiguration.Read.All" | Out-Null
} catch {
    Write-Error "Failed to connect to Microsoft Graph."
    exit 1
}

# Output path (CSV in current script folder)
$OutputCSV = Join-Path -Path $PSScriptRoot -ChildPath "DetectedApps_$($AppName)_$(Get-Date -Format yyyyMMdd_HHmmss).csv"

Write-Host "Searching for apps matching: $AppName"
$detectedApps = Get-MgDeviceManagementDetectedApp -All | Where-Object { $_.DisplayName -like "*$AppName*" }

if (-not $detectedApps) {
    Write-Host "No applications found matching '$AppName'"
    Disconnect-MgGraph
    exit 0
}

# Initialize result array
$Results = @()

foreach ($app in $detectedApps) {
    $deviceList = Get-MgDeviceManagementDetectedAppManagedDevice -DetectedAppId $app.Id -All

    foreach ($device in $deviceList) {
        $Results += [PSCustomObject]@{
            ApplicationName = $app.DisplayName
            Version         = $app.Version
            DeviceName      = $device.DeviceName
            DeviceId        = $device.Id
        }
    }
}

# Export to CSV
$Results | Export-Csv -Path $OutputCSV -NoTypeInformation -Encoding UTF8
Write-Host "Report saved to: $OutputCSV"

# Clean up
Disconnect-MgGraph
