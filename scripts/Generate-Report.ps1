<#
.SYNOPSIS
    Generates a plain-text or Markdown summary suitable for pasting into a ticket.

.DESCRIPTION
    Runs the key read-only checks and writes a clean report file.
    Safe to run as a normal user.

.PARAMETER OutputPath
    Where to save the report. Default is network-report.txt in the current directory.

.PARAMETER Format
    txt or md. Default is txt.

.EXAMPLE
    .\Generate-Report.ps1
    .\Generate-Report.ps1 -OutputPath C:\Temp\ticket-notes.md -Format md
#>

[CmdletBinding()]
param(
    [string]$OutputPath = "network-report.txt",
    [ValidateSet('txt','md')]
    [string]$Format = 'txt'
)

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$report = @()

function Add-Section {
    param($Title, $Content)
    if ($Format -eq 'md') {
        $script:report += "## $Title`n"
        $script:report += '```'
        $script:report += $Content
        $script:report += '```'
        $script:report += ""
    } else {
        $script:report += "=== $Title ==="
        $script:report += $Content
        $script:report += ""
    }
}

$report += if ($Format -eq 'md') { "# Network Troubleshooting Report`nGenerated: $timestamp`n" } else { "Network Troubleshooting Report`nGenerated: $timestamp`n" }

# Adapters
$adapters = Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress | Format-Table -AutoSize | Out-String
Add-Section -Title "Adapters" -Content $adapters.Trim()

# IP Config
$ip = Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq 'Up' } |
    Select-Object InterfaceAlias,
                  @{N='IPv4';E={$_.IPv4Address.IPAddress}},
                  @{N='Gateway';E={$_.IPv4DefaultGateway.NextHop}},
                  @{N='DNS';E={$_.DNSServer.ServerAddresses -join ', '}} |
    Format-List | Out-String
Add-Section -Title "Active IP Configuration" -Content $ip.Trim()

# Quick connectivity
$conn = @()
$targets = @(
    @{N='Gateway'; T=(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4DefaultGateway.NextHop | Select-Object -First 1},
    @{N='8.8.8.8'; T='8.8.8.8'},
    @{N='google.com'; T='google.com'}
)
foreach ($t in $targets) {
    if (-not $t.T) { $conn += "$($t.N): no target"; continue }
    $r = Test-Connection -ComputerName $t.T -Count 2 -ErrorAction SilentlyContinue
    if ($r) {
        $avg = [math]::Round(($r | Measure-Object ResponseTime -Average).Average,0)
        $conn += "$($t.N) ($($t.T)): OK (avg ${avg}ms)"
    } else {
        $conn += "$($t.N) ($($t.T)): FAIL"
    }
}
Add-Section -Title "Quick Connectivity" -Content ($conn -join "`n")

# APIPA check
$apipa = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like '169.254.*' }
if ($apipa) {
    $apipaText = ($apipa | Select-Object InterfaceAlias, IPAddress | Format-Table -AutoSize | Out-String).Trim()
    Add-Section -Title "WARNING: APIPA Detected" -Content $apipaText
}

# Recent events (short)
$events = Get-WinEvent -FilterHashtable @{LogName='System'; Level=2,3; StartTime=(Get-Date).AddHours(-6)} -ErrorAction SilentlyContinue |
    Where-Object { $_.ProviderName -match 'Tcpip|Dhcp|Dns|WLAN|Netwtw' } |
    Select-Object -First 8 TimeCreated, ProviderName, Id, @{N='Msg';E={$_.Message.Split("`n")[0]}} |
    Format-Table -AutoSize | Out-String
if ($events.Trim()) {
    Add-Section -Title "Recent Network Events (last 6h)" -Content $events.Trim()
}

$final = $report -join "`n"
$final | Out-File -FilePath $OutputPath -Encoding utf8
Write-Host "Report written to: $OutputPath" -ForegroundColor Green
Write-Host "You can open it and paste the contents into a ticket." -ForegroundColor DarkGray
