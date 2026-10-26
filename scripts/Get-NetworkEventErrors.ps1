<#
.SYNOPSIS
    Shows recent network-related errors and warnings from the System log.

.DESCRIPTION
    Filters for common network providers. Useful for intermittent or slow issues.

.PARAMETER Hours
    How many hours back to look. Default is 24.

.EXAMPLE
    .\Get-NetworkEventErrors.ps1
    .\Get-NetworkEventErrors.ps1 -Hours 6
#>

[CmdletBinding()]
param(
    [int]$Hours = 24
)

Write-Host "`n=== Network Event Errors (last $Hours hours) ===" -ForegroundColor Cyan

$start = (Get-Date).AddHours(-$Hours)

$events = Get-WinEvent -FilterHashtable @{
    LogName   = 'System'
    Level     = 2,3          # Error, Warning
    StartTime = $start
} -ErrorAction SilentlyContinue |
    Where-Object {
        $_.ProviderName -match 'Tcpip|Dhcp|DnsClient|Netwtw|e1i|e1q|NetBT|NlaSvc|WLAN|Tcpip6|DHCPv6'
    } |
    Select-Object TimeCreated, ProviderName, Id, LevelDisplayName,
                  @{N='Message';E={$_.Message.Split("`n")[0]}}

if ($events) {
    $events | Sort-Object TimeCreated -Descending | Select-Object -First 25 | Format-Table -AutoSize -Wrap
    Write-Host "Showing up to 25 most recent matching events." -ForegroundColor DarkGray
} else {
    Write-Host "No matching network errors/warnings found in the last $Hours hours." -ForegroundColor Green
}

Write-Host ""
