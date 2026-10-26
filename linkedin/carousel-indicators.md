# Carousel: 7 Classic Network Indicators

**Upload:** `carousel-indicators.pdf` as a LinkedIn Document post

**Caption:**

Most network problems announce themselves with one of these signs.

Here are the 7 classic indicators every help-desk tech should recognize on sight — plus the first action to take.

(These also come up in interviews.)

Swipe through, then grab the full checklist + matching PowerShell scripts from the repo.

---

**Slide outline (for reference or recreation):**

1. **Cover**  
   7 Classic Network Indicators  
   Every Help-Desk Tech Should Know  
   Interview-ready + daily use

2. **169.254.x.x**  
   DHCP failed (APIPA)  
   First action: Check link, then DHCP

3. **Valid IP, no gateway**  
   Cannot leave the subnet  
   First action: Verify gateway / DHCP option 3

4. **Ping IP works, name fails**  
   DNS problem  
   First action: Test 8.8.8.8, flush cache

5. **Ping gateway fails**  
   Local Layer 2/3 issue  
   First action: Cable, switch, Wi-Fi, ARP

6. **Yellow triangle**  
   Limited / no internet  
   First action: Gateway → 8.8.8.8 → hostname

7. **One port fails**  
   Service down or firewall  
   First action: Test-NetConnection -Port

8. **Weak Wi-Fi signal**  
   Distance, interference, or driver  
   First action: Check signal & recent disconnects

9. **CTA**  
   Full checklist + scripts in the repo  
   Link in the first comment

**First comment:**
https://github.com/BCarter04/networking-troubleshooting
