# Sample Output — Healthy Machine (Get-NetworkSummary.ps1)

```
=== Network Summary ===
Run time: 2026-10-26 09:15:22

--- Adapters ---
Name     Status LinkSpeed MacAddress        InterfaceDescription
----     ------ --------- ----------        --------------------
Ethernet Up     1 Gbps    00-1A-2B-3C-4D-5E Realtek PCIe GbE

--- IP Configuration (active) ---
InterfaceAlias : Ethernet
IPv4           : 192.168.1.45
Gateway        : 192.168.1.1
DNS            : 192.168.1.1, 8.8.8.8

--- Quick Connectivity ---
Default Gateway (192.168.1.1): OK  (avg 2ms)
External IP (8.8.8.8): OK  (avg 12ms)
Hostname (google.com): OK  (avg 18ms)

=== End of Summary ===
```

# Sample Output — APIPA Case (Get-AdapterDetails.ps1)

```
WARNING: APIPA address detected (DHCP failed):
InterfaceAlias IPAddress
-------------- ---------
Ethernet       169.254.87.142

See guides/dhcp-ipconfig.md
```
