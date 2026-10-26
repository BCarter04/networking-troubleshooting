<#
.SYNOPSIS
    Detailed view of network adapters, IP addresses, and DHCP status.

.DESCRIPTION
    Useful when investigating missing IPs, APIPA addresses, or adapter problems.

.EXAMPLE
    .\Get-AdapterDetails.ps1
#>

[CmdletBinding()]
param()

Write-Host "`n=== Adapter Details ===" -ForegroundColor Cyan

Write-Host "`n--- All Adapters ---" -ForegroundColor Yellow
Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress, InterfaceDescription, DriverVersion |
    Format-Table -AutoSize

Write-Host "`n--- IPv4 Addresses ---" -ForegroundColor Yellow
Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike '127.*' } |
    Select-Object InterfaceAlias, IPAddress, PrefixLength, PrefixOrigin, AddressState |
    Format-Table -AutoSize

Write-Host "`n--- Default Gateways ---" -ForegroundColor Yellow
Get-NetIPConfiguration |
    Where-Object { $_.IPv4DefaultGateway } |
    Select-Object InterfaceAlias, @{N='Gateway';E={$_.IPv4DefaultGateway.NextHop}} |
    Format-Table -AutoSize

# Highlight APIPA
$apipa = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like '169.254.*' }
if ($apipa) {
    Write-Host "`nWARNING: APIPA address detected (DHCP failed):" -ForegroundColor Red
    $apipa | Select-Object InterfaceAlias, IPAddress | Format-Table -AutoSize
    Write-Host "See guides/dhcp-ipconfig.md" -ForegroundColor DarkGray
}

Write-Host "`n=== End ===`n" -ForegroundColor Cyan
