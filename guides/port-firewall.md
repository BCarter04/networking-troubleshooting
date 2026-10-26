# Port and Firewall Troubleshooting

Use this when the machine has general internet access but **one application, website, or port** fails.

## Remember

- Test the port directly before blaming the application.
- `Test-NetConnection -Port` is your friend.
- Distinguish between “port closed on the remote host” vs “blocked by local or intermediate firewall”.

## Quick checks (copy-paste)

```powershell
# Test common ports
Test-NetConnection -ComputerName google.com -Port 443
Test-NetConnection -ComputerName 8.8.8.8 -Port 53
Test-NetConnection -ComputerName dc01.company.local -Port 389

# More detail
Test-NetConnection -ComputerName example.com -Port 443 -InformationLevel Detailed
```

```powershell
# What is listening locally?
Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess | Sort-Object LocalPort
# Or classic
netstat -ano | findstr LISTENING
```

## Common ports (see also cheatsheets/common-ports.md)

| Port | Service | Typical use |
|------|---------|-------------|
| 53 | DNS | Name resolution |
| 80 | HTTP | Web |
| 443 | HTTPS | Secure web |
| 3389 | RDP | Remote Desktop |
| 445 | SMB | File shares |
| 22 | SSH | Secure shell |
| 1433 | SQL | SQL Server |

## Firewall checks

```powershell
# Windows Firewall status
Get-NetFirewallProfile | Format-Table Name, Enabled, DefaultInboundAction, DefaultOutboundAction -AutoSize

# Recent firewall blocks (if auditing is on)
Get-WinEvent -LogName "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" -MaxEvents 20 -ErrorAction SilentlyContinue |
    Where-Object { $_.Id -eq 5152 -or $_.Id -eq 5157 } |
    Select-Object TimeCreated, Message
```

## Script to run

```powershell
.\scripts\Test-PortConnectivity.ps1 -ComputerName "server01" -Ports 80,443,3389
.\scripts\Test-PortConnectivity.ps1 -ComputerName "8.8.8.8" -Ports 53
```
