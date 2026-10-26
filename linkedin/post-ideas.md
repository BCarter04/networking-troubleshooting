# Additional LinkedIn Post Ideas

Short posts you can schedule. Each can stand alone or link back to the repo.

---

### 1. One-command summary
**Hook:**  
One PowerShell command. Full network snapshot.

**Body:**  
I run this first on almost every network ticket:

.\Get-NetworkSummary.ps1

It shows adapters, IPs, gateways, DNS servers, and a few key checks without changing anything.

Then if I need something for the ticket:

.\Generate-Report.ps1

Both are in the free networking-troubleshooting repo (link in comments).

---

### 2. APIPA reminder
**Hook:**  
If you see 169.254.x.x, stop looking at DNS.

**Body:**  
That’s an APIPA address. DHCP failed.

First actions:
1. Check the link (cable / Wi-Fi)
2. Look at the DHCP server or scope
3. Then re-test

The full indicators table (and the script that surfaces this) is in the repo.

---

### 3. DNS vs path
**Hook:**  
Ping by IP works. Ping by name fails. What’s broken?

**Body:**  
Almost always DNS.

Quick confirmation:
- ping 8.8.8.8   → works
- ping google.com → fails
- ipconfig /flushdns
- Check the DNS servers on the adapter

I keep a short decision tree and a Test-DnsResolution.ps1 script for exactly this case.

---

### 4. Interview angle
**Hook:**  
Network interview question I still see: “What does 169.254 mean?”

**Body:**  
It means the machine couldn’t get a DHCP lease and fell back to APIPA.

Other classics that come up:
- Valid IP but no gateway
- Can ping IP but not name
- Yellow triangle / limited connectivity

I collected the most common ones with the first action for each. Useful for both the job and the interview.

---

### 5. Safe by default
**Hook:**  
I only write network scripts that are safe to run as a normal user.

**Body:**  
No changing settings. No restarting services. Just reading information and reporting it clearly.

That’s the design rule for every script in the networking-troubleshooting repo. You can drop them on a machine and run them without worrying about side effects.

---

**Tip:** For each of these, put the GitHub link in the first comment rather than the main post.
