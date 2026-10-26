# Slow or Intermittent Network

Use this when connectivity exists but is slow, laggy, or drops occasionally.

## Remember

- Separate “high latency” from “packet loss” from “bandwidth saturation”.
- Check recent network errors in the event log.
- Compare with another device on the same network.

## Quick checks (copy-paste)

```powershell
# Latency and basic path
Test-Connection -ComputerName 8.8.8.8 -Count 10 | Measure-Object -Property ResponseTime -Average -Maximum -Minimum
pathping 8.8.8.8

# Trace route
tracert 1.1.1.1
```

```powershell
# Adapter statistics (errors, discards)
Get-NetAdapterStatistics | Format-Table Name, ReceivedBytes, SentBytes, ReceivedDiscardedPackets, OutboundDiscardedPackets -AutoSize
```

## Event log clues

```powershell
# Recent network-related errors
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    Level = 2,3
    StartTime = (Get-Date).AddHours(-24)
} -ErrorAction SilentlyContinue |
    Where-Object { $_.ProviderName -match 'Tcpip|Dhcp|Dns|Netwtw|e1i|e1q|NetBT|NlaSvc' } |
    Select-Object TimeCreated, ProviderName, Id, LevelDisplayName, Message -First 15
```

## Common patterns

| Observation | Possible cause | Next step |
|-------------|----------------|-----------|
| High latency to gateway | Local Wi-Fi / switch / cable | Check signal, try wired |
| High latency only after gateway | ISP or remote path | pathping, compare other devices |
| Packet loss | Bad cable, interference, overloaded link | Adapter stats + pathping |
| Periodic disconnects | Power management, driver, DHCP lease | Event log + disable power saving on adapter |

## Script to run

```powershell
.\scripts\Get-NetworkEventErrors.ps1 -Hours 24
.\scripts\Get-NetworkSummary.ps1
```
