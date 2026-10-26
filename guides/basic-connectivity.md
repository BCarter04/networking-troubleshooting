# Basic Connectivity Troubleshooting

Use this when the machine has **no internet** or cannot reach a specific host at all.

## Remember the order

1. Is the adapter up and has an IP?
2. Can I reach the default gateway?
3. Can I reach an external IP (bypass DNS)?
4. Can I reach a hostname (tests DNS + path)?

## Quick checks (copy-paste)

```powershell
# 1. Adapter and IP summary
Get-NetAdapter | Where-Object Status -eq 'Up' | Format-Table Name, Status, LinkSpeed, MacAddress -AutoSize
Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq 'Up' } | Format-List InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer
```

```powershell
# 2. Gateway reachability
$gw = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway }).IPv4DefaultGateway.NextHop
Test-Connection -ComputerName $gw -Count 4 -ErrorAction SilentlyContinue
```

```powershell
# 3. External IP (DNS bypass)
Test-Connection -ComputerName 8.8.8.8 -Count 4
Test-NetConnection -ComputerName 1.1.1.1 -InformationLevel Detailed
```

```powershell
# 4. Hostname (full path + DNS)
Test-Connection -ComputerName google.com -Count 4
Resolve-DnsName google.com
```

## Decision guide

| Result | Meaning | Next step |
|--------|---------|-----------|
| No IP or APIPA (169.254.x.x) | DHCP or adapter problem | See `dhcp-ipconfig.md` |
| Gateway fails | Local network issue (cable, switch, Wi-Fi, AP) | Check physical / Wi-Fi, try another device |
| Gateway OK, 8.8.8.8 fails | Upstream / ISP / firewall / routing | Check other devices, traceroute |
| 8.8.8.8 OK, hostname fails | DNS problem | See `dns.md` |
| Everything fails only for one host | Host-specific or port issue | See `port-firewall.md` |

## Useful one-liners

```powershell
# Trace route to see where it dies
tracert 8.8.8.8
pathping 8.8.8.8

# Clear ARP cache (sometimes helps after network changes)
arp -d *

# Release and renew (requires elevation, changes state)
ipconfig /release
ipconfig /renew
```

## Script to run

```powershell
.\scripts\Test-BasicConnectivity.ps1
.\scripts\Get-NetworkSummary.ps1
```
