# DNS Troubleshooting

Use this when **IP addresses work but names do not**, or when only some names fail.

## Remember

- If `ping 8.8.8.8` works but `ping google.com` fails → almost always DNS.
- Check which DNS servers the adapter is using.
- Compare results from multiple DNS servers.
- Flush the cache only after you confirm the servers are correct.

## Quick checks (copy-paste)

```powershell
# What DNS servers am I using?
Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses } | Format-Table InterfaceAlias, ServerAddresses -AutoSize

# Resolve a name
Resolve-DnsName google.com
Resolve-DnsName google.com -Server 8.8.8.8
Resolve-DnsName google.com -Server 1.1.1.1
```

```powershell
# Flush DNS cache (safe, often helpful)
Clear-DnsClientCache
# or
ipconfig /flushdns
```

```powershell
# Show current cache (optional)
Get-DnsClientCache | Select-Object -First 20 Entry, Data, Status
```

## Common causes

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| All names fail | Wrong or unreachable DNS servers | Check DHCP or set 8.8.8.8 / 1.1.1.1 temporarily |
| Only internal names fail | DNS suffix or internal DNS issue | Check search list, try FQDN |
| Some names fail after a change | Stale cache | Flush DNS |
| Works on one adapter, not another | Per-adapter DNS settings | Compare `Get-DnsClientServerAddress` |

## Temporary test (does not persist)

```powershell
# Set DNS to public resolvers for testing (requires elevation)
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","1.1.1.1")
# Restore later with
# Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ResetServerAddresses
```

## Script to run

```powershell
.\scripts\Test-DnsResolution.ps1
.\scripts\Test-DnsResolution.ps1 -Name "intranet.company.local"
```
