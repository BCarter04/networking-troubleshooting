# Networking Troubleshooting

A clean, practical repository of guides and PowerShell scripts for the most common network problems.

Designed for help-desk technicians, junior administrators, and anyone who needs a reliable, copy-and-paste reference — including the classic indicators that appear in interviews.

> I also maintain a separate PowerShell IT admin toolkit in another repository. This networking repo is intentionally standalone so it can be used or shared on its own.

---

## How to Run the Scripts

1. Open PowerShell (right-click Start → Windows PowerShell, or search for it).
2. Navigate to the `scripts` folder, or run with a full path.
3. If you see an execution policy error:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
4. Then run, for example:
   ```powershell
   .\Get-NetworkSummary.ps1
   ```

All scripts are read-only by default and safe to run as a normal user.

---

## Start Here

```
Can the machine reach the internet at all?
│
├─ No                    → guides/basic-connectivity.md
│                         scripts/Test-BasicConnectivity.ps1
│
├─ Names fail, IPs work  → guides/dns.md
│                         scripts/Test-DnsResolution.ps1
│
├─ One site/port fails   → guides/port-firewall.md
│                         scripts/Test-PortConnectivity.ps1
│
├─ No IP / 169.254.x.x   → guides/dhcp-ipconfig.md
│                         scripts/Get-AdapterDetails.ps1
│
├─ Wi-Fi issues          → guides/wifi.md
│                         scripts/Get-WiFiStatus.ps1
│
└─ Slow or intermittent  → guides/slow-network.md
                          scripts/Get-NetworkEventErrors.ps1
```

**One-command starting point**

```powershell
.\scripts\Get-NetworkSummary.ps1
```

**Generate a ticket-ready report**

```powershell
.\scripts\Generate-Report.ps1
```

---

## Repository Layout

```
networking-troubleshooting/
├── README.md
├── LICENSE
├── guides/                  # Symptom playbooks
│   ├── basic-connectivity.md
│   ├── dns.md
│   ├── dhcp-ipconfig.md
│   ├── port-firewall.md
│   ├── slow-network.md
│   └── wifi.md
├── scripts/                 # Copy-and-paste PowerShell helpers
│   ├── Get-NetworkSummary.ps1
│   ├── Test-BasicConnectivity.ps1
│   ├── Test-DnsResolution.ps1
│   ├── Get-AdapterDetails.ps1
│   ├── Test-PortConnectivity.ps1
│   ├── Get-NetworkEventErrors.ps1
│   ├── Get-WiFiStatus.ps1
│   ├── Get-VpnProxyStatus.ps1
│   └── Generate-Report.ps1
├── cheatsheets/
│   ├── common-ports.md
│   └── quick-commands.md
└── examples/                # Sample outputs
```

---

## Common Indicators (Interview-Ready)

| What you see              | Most likely meaning          | First action                  |
|---------------------------|------------------------------|-------------------------------|
| `169.254.x.x`             | DHCP failed (APIPA)          | Check link, then DHCP         |
| Valid IP, no gateway      | Cannot leave the subnet      | Verify gateway / DHCP opt 3   |
| Ping IP works, name fails | DNS problem                  | Test 8.8.8.8, flush cache     |
| Ping gateway fails        | Local Layer 2/3 issue        | Cable, switch, Wi-Fi, ARP     |
| Yellow triangle           | Limited / no internet        | Gateway → 8.8.8.8 → hostname  |
| One port fails            | Service down or firewall     | `Test-NetConnection -Port`    |
| Weak Wi-Fi signal         | Distance, interference, or driver | Check signal & recent disconnects |

---

## How to Use

1. Run `Get-NetworkSummary.ps1` for a quick snapshot.
2. Match the symptom to the decision tree above.
3. Open the matching guide (explains *why*) and/or run the script (does the check).
4. Use `Generate-Report.ps1` when you need something to paste into a ticket.
5. Use the cheatsheets for one-off commands.

All scripts are self-contained, use only built-in PowerShell, and are safe to run as a normal user (they only read information). State-changing commands are clearly marked in the guides.

---

## Design Principles

- **Recognizable indicators first** — APIPA, missing gateway, and DNS-vs-path distinctions are explicit.
- **Readable** — Guides and script comments explain the reasoning.
- **Copy-and-paste ready** — Every command block works immediately.
- **Safe by default** — Scripts do not change system state.
- **Independent** — No dependency on other toolkits or external modules.

---

## License

MIT — see [LICENSE](LICENSE).
