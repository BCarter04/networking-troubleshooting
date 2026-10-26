# Wi-Fi Troubleshooting

Use this when the machine is on Wi-Fi but has weak signal, frequent drops, or “Limited connectivity” only on wireless.

## Remember

- Signal strength and recent disconnects are the first things to check.
- Compare with a wired connection on the same network if possible.
- Power management on the adapter is a common cause of intermittent drops.

## Quick checks (copy-paste)

```powershell
# Current Wi-Fi status and signal
netsh wlan show interfaces

# Available networks (optional)
netsh wlan show networks mode=bssid

# Recent WLAN events
Get-WinEvent -LogName System -MaxEvents 30 -ErrorAction SilentlyContinue |
    Where-Object { $_.ProviderName -match 'WLAN|Netwtw' } |
    Select-Object TimeCreated, Id, LevelDisplayName, @{N='Msg';E={$_.Message.Split("`n")[0]}}
```

## Decision guide

| Observation | Meaning | Next step |
|-------------|---------|-----------|
| Signal < 50% or “Poor” | Distance, interference, or obstruction | Move closer, check for microwave/cordless phone interference |
| Frequent disconnects in event log | Driver, power saving, or AP issue | Disable power management on the adapter; update driver |
| Connected but no internet | Same as wired problems | Follow basic-connectivity.md after confirming Wi-Fi link |
| Works wired, fails wireless | Wi-Fi specific | Focus on signal, driver, and AP settings |

## Useful commands

```powershell
# Disable power management (elevation required, changes state)
# Device Manager → Network adapters → Wi-Fi → Power Management → uncheck “Allow the computer to turn off this device”

# Restart WLAN service (elevation)
Restart-Service WlanSvc -Force
```

## Script to run

```powershell
.\scripts\Get-WiFiStatus.ps1
```
