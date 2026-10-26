<#
.SYNOPSIS
    Detects VPN connections, proxy settings, and related routing clues.

.DESCRIPTION
    Checks for active VPN adapters, system proxy, and unusual default routes.
    Read-only and safe for normal users.

.EXAMPLE
    .\Get-VpnProxyStatus.ps1
#>

[CmdletBinding()]
param()

Write-Host "`n=== VPN & Proxy Status ===" -ForegroundColor Cyan

# VPN-like adapters
Write-Host "`n--- Possible VPN / Virtual Adapters ---" -ForegroundColor Yellow
$vpnAdapters = Get-NetAdapter | Where-Object {
    $_.InterfaceDescription -match 'VPN|TAP|TUN|WireGuard|OpenVPN|Cisco|AnyConnect|Forti|Pulse|GlobalProtect|Virtual'
} 
if ($vpnAdapters) {
    $vpnAdapters | Select-Object Name, Status, InterfaceDescription | Format-Table -AutoSize
} else {
    Write-Host "  No obvious VPN adapters detected." -ForegroundColor DarkGray
}

# System proxy
Write-Host "`n--- System Proxy ---" -ForegroundColor Yellow
$proxy = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction SilentlyContinue
if ($proxy.ProxyEnable -eq 1) {
    Write-Host "  Proxy ENABLED: $($proxy.ProxyServer)" -ForegroundColor Yellow
} else {
    Write-Host "  Proxy disabled or not set." -ForegroundColor Green
}

# Default routes (look for non-standard)
Write-Host "`n--- Default Routes ---" -ForegroundColor Yellow
Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
    Select-Object InterfaceAlias, NextHop, RouteMetric |
    Format-Table -AutoSize

Write-Host "`nTip: Multiple default routes or a VPN adapter in 'Up' state can explain split-tunnel or routing issues.`n" -ForegroundColor DarkGray
