# Additional Post Ideas

Short posts you can schedule. Put the repository link in the first comment for each.

---

### One-command summary

**Hook**  
One PowerShell command. Full network snapshot.

**Body**  
I run this first on almost every network ticket:

.\Get-NetworkSummary.ps1

It shows adapters, addresses, gateways, and DNS servers without changing anything.

When I need something for the ticket:

.\Generate-Report.ps1

Both live in the networking-troubleshooting repository.

---

### APIPA reminder

**Hook**  
If you see 169.254.x.x, stop looking at DNS.

**Body**  
That is an APIPA address. DHCP failed.

First actions:
1. Check the link (cable or Wi-Fi)
2. Look at the DHCP server or scope
3. Re-test

The full indicators table and the script that surfaces this are in the repository.

---

### DNS versus path

**Hook**  
Ping by IP works. Ping by name fails. What is broken?

**Body**  
Almost always DNS.

Quick confirmation:
- ping 8.8.8.8 succeeds
- ping google.com fails
- Flush the cache
- Check the DNS servers on the adapter

I keep a short decision tree and a Test-DnsResolution.ps1 script for exactly this case.

---

### Interview angle

**Hook**  
Network interview question I still see: “What does 169.254 mean?”

**Body**  
It means the machine could not obtain a DHCP lease and fell back to APIPA.

Other classics that come up:
- Valid IP but no gateway
- Can ping by IP but not by name
- Yellow triangle / limited connectivity

I collected the most common ones with the first action for each. Useful on the job and in interviews.

---

### Safe by default

**Hook**  
I only write network scripts that are safe to run as a normal user.

**Body**  
No changing settings. No restarting services. Just reading information and reporting it clearly.

That is the design rule for every script in the networking-troubleshooting repository. You can drop them on a machine and run them without worrying about side effects.
