<#
.SYNOPSIS
    Tests DNS resolution against the configured servers and public resolvers.

.DESCRIPTION
    Shows which DNS servers are in use, then resolves a name against them
    and against well-known public DNS servers for comparison.

.PARAMETER Name
    The name to resolve. Default is google.com.

.EXAMPLE
    .\Test-DnsResolution.ps1
    .\Test-DnsResolution.ps1 -Name "intranet.company.local"
#>

[CmdletBinding()]
param(
    [string]$Name = 'google.com'
)

Write-Host "`n=== DNS Resolution Test ===" -ForegroundColor Cyan
Write-Host "Target name: $Name`n" -ForegroundColor DarkGray

# Configured DNS servers
Write-Host "--- Configured DNS Servers ---" -ForegroundColor Yellow
$configured = Get-DnsClientServerAddress -AddressFamily IPv4 |
    Where-Object { $_.ServerAddresses } |
    Select-Object InterfaceAlias, ServerAddresses

if ($configured) {
    $configured | Format-Table -AutoSize
} else {
    Write-Host "  No DNS servers configured on active adapters." -ForegroundColor Red
}

# Collect unique servers to test
$servers = @()
$configured | ForEach-Object { $servers += $_.ServerAddresses }
$servers += '8.8.8.8','1.1.1.1'
$servers = $servers | Select-Object -Unique

Write-Host "`n--- Resolution Results ---" -ForegroundColor Yellow
foreach ($server in $servers) {
    Write-Host "Server $server :" -NoNewline
    try {
        $result = Resolve-DnsName -Name $Name -Server $server -ErrorAction Stop -DnsOnly
        $ips = ($result | Where-Object Type -eq 'A').IPAddress -join ', '
        if ($ips) {
            Write-Host " OK  → $ips" -ForegroundColor Green
        } else {
            Write-Host " No A record" -ForegroundColor Yellow
        }
    } catch {
        Write-Host " FAIL  ($($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`nTip: If public DNS works but configured servers fail, the problem is with your DNS servers or the path to them." -ForegroundColor DarkGray
Write-Host "Flush cache with: Clear-DnsClientCache   or   ipconfig /flushdns`n" -ForegroundColor DarkGray
