# Carousel: How I Diagnose “No Internet” in Under 2 Minutes

**Upload:** `carousel-decision-tree.pdf` as a LinkedIn Document post

**Caption:**

When someone says “the internet is down,” I don’t start randomly checking things.

I use this simple decision tree. It points me at the right guide and the right PowerShell script in under two minutes.

Swipe to see the path.

---

**Slide outline:**

1. **Cover**  
   How I Diagnose “No Internet” in Under 2 Minutes

2. **Can the machine reach anything?**  
   No → basic-connectivity guide + Test-BasicConnectivity.ps1

3. **Names fail but IPs work?**  
   DNS problem → dns guide + Test-DnsResolution.ps1

4. **Only one site or port fails?**  
   → port-firewall guide + Test-PortConnectivity.ps1

5. **No IP or 169.254?**  
   DHCP failed → dhcp-ipconfig guide + Get-AdapterDetails.ps1

6. **Wi-Fi or slow/intermittent?**  
   → matching guide + script

7. **One-command start**  
   Get-NetworkSummary.ps1  
   Then Generate-Report.ps1 for the ticket

8. **CTA**  
   Full tree + all scripts free in the repo

**First comment:**
https://github.com/BCarter04/networking-troubleshooting
