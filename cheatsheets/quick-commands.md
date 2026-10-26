# Quick Commands Cheat Sheet

Copy-and-paste commands for common situations.  
Most are read-only. Commands that change state are marked **[CHANGES STATE]**.

## Connectivity

```powershell
Test-Connection 8.8.8.8 -Count 4
Test-NetConnection google.com -InformationLevel Detailed
tracert 8.8.8.8
pathping 1.1.1.1
```

## DNS

```powershell
Resolve-DnsName google.com
Resolve-DnsName google.com -Server 8.8.8.8
Get-DnsClientServerAddress -AddressFamily IPv4
Clear-DnsClientCache                          # flush cache
ipconfig /flushdns
```

## IP / Adapter

```powershell
Get-NetAdapter
Get-NetIPConfiguration
ipconfig /all
Get-NetIPAddress -AddressFamily IPv4
```

## Ports

```powershell
Test-NetConnection server01 -Port 443
Get-NetTCPConnection -State Listen | Sort-Object LocalPort
netstat -ano | findstr LISTENING
```

## Firewall

```powershell
Get-NetFirewallProfile
```

## State-changing (use carefully)

```powershell
# [CHANGES STATE] Release / renew DHCP
ipconfig /release
ipconfig /renew

# [CHANGES STATE] Restart adapter
Restart-NetAdapter -Name "Ethernet" -Confirm:$false

# [CHANGES STATE] Temporarily set public DNS
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 8.8.8.8,1.1.1.1
# Restore
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ResetServerAddresses
```

## Event log

```powershell
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object { $_.ProviderName -match 'Tcpip|Dhcp|Dns' }
```
