# IP Address, DHCP, and Adapter Issues

Use this when the machine has no IP, a 169.254.x.x address, wrong subnet, or the adapter looks disabled/disconnected.

## Remember

- 169.254.x.x = APIPA = DHCP failed.
- Check physical link (cable light, Wi-Fi connected) before blaming DHCP.
- Compare with another working device on the same network.

## Quick checks (copy-paste)

```powershell
# Adapter status
Get-NetAdapter | Format-Table Name, Status, LinkSpeed, MacAddress, InterfaceDescription -AutoSize

# Full IP configuration
Get-NetIPConfiguration | Format-List InterfaceAlias, InterfaceDescription, NetProfile, IPv4Address, IPv4DefaultGateway, DNSServer

# Detailed view (classic)
ipconfig /all
```

```powershell
# DHCP specific
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.PrefixOrigin -eq 'Dhcp' -or $_.PrefixOrigin -eq 'Manual' } | Format-Table InterfaceAlias, IPAddress, PrefixLength, PrefixOrigin -AutoSize
```

## Decision guide

| Observation | Meaning | Next step |
|-------------|---------|-----------|
| Status = Disconnected | No link | Cable, switch port, Wi-Fi, airplane mode |
| Status = Up but no IPv4 | DHCP or static config missing | Release/renew or set static temporarily |
| 169.254.x.x | DHCP failed | Check DHCP server, scope, relay, or try static |
| Correct IP but no gateway | Misconfigured static or DHCP option | Check gateway setting |
| Multiple adapters with IPs | Routing confusion possible | Disable unused adapters for testing |

## Useful commands (some change state)

```powershell
# Release and renew (elevation required)
ipconfig /release
ipconfig /renew

# Restart adapter (elevation required)
Restart-NetAdapter -Name "Ethernet" -Confirm:$false

# Disable / enable (stronger reset)
Disable-NetAdapter -Name "Wi-Fi" -Confirm:$false
Enable-NetAdapter -Name "Wi-Fi"
```

## Script to run

```powershell
.\scripts\Get-AdapterDetails.ps1
.\scripts\Get-NetworkSummary.ps1
```
