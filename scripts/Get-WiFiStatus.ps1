<#
.SYNOPSIS
    Shows current Wi-Fi status, signal strength, and recent disconnect events.

.DESCRIPTION
    Uses netsh and the event log. Safe to run as a normal user.

.EXAMPLE
    .\Get-WiFiStatus.ps1
#>

[CmdletBinding()]
param()

Write-Host "`n=== Wi-Fi Status ===" -ForegroundColor Cyan

Write-Host "`n--- Interface ---" -ForegroundColor Yellow
$wlan = netsh wlan show interfaces 2>$null
if ($wlan) {
    $wlan | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "  No Wi-Fi interface found or netsh failed." -ForegroundColor DarkGray
}

Write-Host "`n--- Recent WLAN Events (last 24h) ---" -ForegroundColor Yellow
$start = (Get-Date).AddHours(-24)
$events = Get-WinEvent -FilterHashtable @{
    LogName   = 'System'
    StartTime = $start
} -ErrorAction SilentlyContinue |
    Where-Object { $_.ProviderName -match 'WLAN|Netwtw|e1i' -and $_.Level -le 3 } |
    Select-Object TimeCreated, Id, LevelDisplayName,
                  @{N='Message';E={$_.Message.Split("`n")[0]}}

if ($events) {
    $events | Sort-Object TimeCreated -Descending | Select-Object -First 10 | Format-Table -AutoSize -Wrap
} else {
    Write-Host "  No recent WLAN errors/warnings." -ForegroundColor Green
}

Write-Host "`nTip: Signal quality below ~50% or frequent disconnects often point to distance, interference, or adapter power management.`n" -ForegroundColor DarkGray
