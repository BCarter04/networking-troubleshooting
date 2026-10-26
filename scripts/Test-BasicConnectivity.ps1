<#
.SYNOPSIS
    Sequential basic connectivity tests with clear pass/fail and next-step hints.

.DESCRIPTION
    Tests in the recommended order:
    1. Active adapter + IP
    2. Default gateway
    3. External IP (bypasses DNS)
    4. Hostname resolution + reachability

.EXAMPLE
    .\Test-BasicConnectivity.ps1
#>

[CmdletBinding()]
param(
    [string]$ExternalIP = '8.8.8.8',
    [string]$Hostname   = 'google.com'
)

function Test-Step {
    param($Name, $Target, $Hint)
    Write-Host "`n[$Name]" -ForegroundColor Yellow
    if (-not $Target) {
        Write-Host "  SKIPPED - no target" -ForegroundColor DarkGray
        return $false
    }
    $ok = Test-Connection -ComputerName $Target -Count 3 -ErrorAction SilentlyContinue
    if ($ok) {
        $avg = [math]::Round(($ok | Measure-Object ResponseTime -Average).Average, 0)
        Write-Host "  PASS  $Target  (avg ${avg}ms)" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  FAIL  $Target" -ForegroundColor Red
        if ($Hint) { Write-Host "  Hint: $Hint" -ForegroundColor DarkGray }
        return $false
    }
}

Write-Host "`n=== Basic Connectivity Test ===" -ForegroundColor Cyan

# 1. Adapter / IP
Write-Host "`n[Adapter & IP]" -ForegroundColor Yellow
$up = Get-NetAdapter | Where-Object Status -eq 'Up'
$ip = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' -and $_.PrefixOrigin -ne 'WellKnown' }

if ($up -and $ip) {
    Write-Host "  PASS  Adapter(s) up with IPv4 address" -ForegroundColor Green
    $ip | Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table -AutoSize
} else {
    Write-Host "  FAIL  No active adapter with a usable IPv4 address" -ForegroundColor Red
    Write-Host "  Hint: Check cable/Wi-Fi, then see guides/dhcp-ipconfig.md" -ForegroundColor DarkGray
}

# 2. Gateway
$gw = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway }).IPv4DefaultGateway.NextHop | Select-Object -First 1
$gwOk = Test-Step -Name 'Default Gateway' -Target $gw -Hint 'Local network problem (cable, switch, AP, Wi-Fi)'

# 3. External IP
$extOk = Test-Step -Name 'External IP' -Target $ExternalIP -Hint 'Upstream/ISP/firewall issue if gateway worked'

# 4. Hostname
$hostOk = Test-Step -Name 'Hostname' -Target $Hostname -Hint 'DNS problem if external IP worked — see guides/dns.md'

Write-Host "`n=== Result ===" -ForegroundColor Cyan
if ($gwOk -and $extOk -and $hostOk) {
    Write-Host "Basic connectivity looks good." -ForegroundColor Green
} elseif ($gwOk -and $extOk -and -not $hostOk) {
    Write-Host "Path works, name resolution fails → DNS issue." -ForegroundColor Yellow
} elseif ($gwOk -and -not $extOk) {
    Write-Host "Gateway works, external fails → upstream problem." -ForegroundColor Yellow
} else {
    Write-Host "Local connectivity problem." -ForegroundColor Yellow
}
Write-Host ""
