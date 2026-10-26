# Common Ports Cheat Sheet

| Port | Protocol | Service | Typical use |
|------|----------|---------|-------------|
| 20/21 | TCP | FTP | File transfer |
| 22 | TCP | SSH | Secure shell / SFTP |
| 23 | TCP | Telnet | Unencrypted remote access (avoid) |
| 25 | TCP | SMTP | Email sending |
| 53 | TCP/UDP | DNS | Name resolution |
| 67/68 | UDP | DHCP | IP address assignment |
| 80 | TCP | HTTP | Web |
| 110 | TCP | POP3 | Email retrieval |
| 123 | UDP | NTP | Time sync |
| 135 | TCP | RPC | Windows RPC |
| 137-139 | TCP/UDP | NetBIOS | Legacy Windows networking |
| 143 | TCP | IMAP | Email |
| 161/162 | UDP | SNMP | Network monitoring |
| 389 | TCP | LDAP | Directory |
| 443 | TCP | HTTPS | Secure web |
| 445 | TCP | SMB | Windows file shares |
| 465 | TCP | SMTPS | Secure email sending |
| 587 | TCP | Submission | Email submission |
| 636 | TCP | LDAPS | Secure LDAP |
| 993 | TCP | IMAPS | Secure IMAP |
| 995 | TCP | POP3S | Secure POP3 |
| 1433 | TCP | MSSQL | SQL Server |
| 3306 | TCP | MySQL | MySQL |
| 3389 | TCP | RDP | Remote Desktop |
| 5432 | TCP | PostgreSQL | PostgreSQL |
| 8080 | TCP | HTTP-Alt | Alternate web / proxies |
| 8443 | TCP | HTTPS-Alt | Alternate secure web |

**Tip**: Test with  
`Test-NetConnection -ComputerName <host> -Port <port>`
