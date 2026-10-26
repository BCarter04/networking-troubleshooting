<#
.SYNOPSIS
    Tests TCP connectivity to one or more ports on a target host.

.DESCRIPTION
    Simple, readable port tester. Returns clear results for each port.

.PARAMETER ComputerName
    Target host (name or IP).

.PARAMETER Ports
    One or more TCP ports to test.

.EXAMPLE
    .\Test-PortConnectivity.ps1 -ComputerName "server01" -Ports 80,443,3389
    .\Test-PortConnectivity.ps1 -ComputerName "8.8.8.8" -Ports 53
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ComputerName,

    [Parameter(Mandatory = $true)]
    [int[]]$Ports
)

Write-Host "`n=== Port Connectivity Test ===" -ForegroundColor Cyan
Write-Host "Target: $ComputerName`n" -ForegroundColor DarkGray

$results = foreach ($port in $Ports) {
    $test = Test-NetConnection -ComputerName $ComputerName -Port $port -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        ComputerName = $ComputerName
        Port         = $port
        TcpTestSucceeded = $test.TcpTestSucceeded
        RemoteAddress    = $test.RemoteAddress
    }
}

$results | Format-Table -AutoSize

$failed = $results | Where-Object { -not $_.TcpTestSucceeded }
if ($failed) {
    Write-Host "Some ports failed. Possible causes:" -ForegroundColor Yellow
    Write-Host "  - Service not running on the target" -ForegroundColor DarkGray
    Write-Host "  - Firewall (local, remote, or intermediate) blocking the port" -ForegroundColor DarkGray
    Write-Host "  - Wrong hostname / IP" -ForegroundColor DarkGray
} else {
    Write-Host "All tested ports succeeded." -ForegroundColor Green
}
Write-Host ""
