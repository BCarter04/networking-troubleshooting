<#
.SYNOPSIS
    Quick snapshot of the current network configuration and basic health.

.DESCRIPTION
    One command to run first on most tickets. Shows adapters, IP config,
    DNS servers, and a short connectivity test. Safe to run as a normal user.

.EXAMPLE
    .\Get-NetworkSummary.ps1
#>

[CmdletBinding()]
param()

Write-Host "`n=== Network Summary ===" -ForegroundColor Cyan
Write-Host "Run time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor DarkGray

# --- Adapters ---
Write-Host "`n--- Adapters ---" -ForegroundColor Yellow
Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress, InterfaceDescription |
    Format-Table -AutoSize

# --- IP Configuration ---
Write-Host "--- IP Configuration (active) ---" -ForegroundColor Yellow
Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq 'Up' } |
    Select-Object InterfaceAlias,
                  @{N='IPv4';E={$_.IPv4Address.IPAddress}},
                  @{N='Gateway';E={$_.IPv4DefaultGateway.NextHop}},
                  @{N='DNS';E={$_.DNSServer.ServerAddresses -join ', '}} |
    Format-List

# --- Quick connectivity ---
Write-Host "--- Quick Connectivity ---" -ForegroundColor Yellow
$tests = @(
    @{ Name = 'Default Gateway'; Target = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway }).IPv4DefaultGateway.NextHop | Select-Object -First 1 }
    @{ Name = 'External IP (8.8.8.8)'; Target = '8.8.8.8' }
    @{ Name = 'Hostname (google.com)'; Target = 'google.com' }
)

foreach ($t in $tests) {
    if (-not $t.Target) {
        Write-Host "$($t.Name): No target available" -ForegroundColor DarkGray
        continue
    }
    $result = Test-Connection -ComputerName $t.Target -Count 2 -ErrorAction SilentlyContinue
    if ($result) {
        $avg = [math]::Round(($result | Measure-Object ResponseTime -Average).Average, 0)
        Write-Host "$($t.Name) ($($t.Target)): OK  (avg ${avg}ms)" -ForegroundColor Green
    } else {
        Write-Host "$($t.Name) ($($t.Target)): FAIL" -ForegroundColor Red
    }
}

Write-Host "`n=== End of Summary ===`n" -ForegroundColor Cyan
Write-Host "Next steps:" -ForegroundColor DarkGray
Write-Host "  No connectivity     → Test-BasicConnectivity.ps1" -ForegroundColor DarkGray
Write-Host "  Names fail          → Test-DnsResolution.ps1" -ForegroundColor DarkGray
Write-Host "  Specific port fails → Test-PortConnectivity.ps1" -ForegroundColor DarkGray
