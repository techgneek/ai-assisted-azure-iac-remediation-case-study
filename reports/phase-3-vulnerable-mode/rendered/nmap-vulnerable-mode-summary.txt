# Nmap Vulnerable Mode Scan Summary

## Scope

- Scanner: `tflearn-nessus-scanner-vm`
- Target: `10.10.1.4`
- Scan type: Targeted TCP service/version scan with default scripts
- Ports scanned: `22,2121,3000,8080,8081`

## Open Services

| Port | Service | Finding |
| --- | --- | --- |
| `22/tcp` | SSH | OpenSSH 9.6p1 on Ubuntu |
| `2121/tcp` | FTP | Anonymous FTP login allowed |
| `3000/tcp` | HTTP | OWASP Juice Shop detected |
| `8080/tcp` | HTTP | DVWA detected on Apache 2.4.25 |
| `8081/tcp` | HTTP | Nginx directory listing enabled |

## Notable Findings

- Anonymous FTP login is allowed on port `2121`.
- FTP exposed case study files including `README.txt` and `lab-drop/`.
- DVWA was detected on port `8080`.
- DVWA returned a `security=low` cookie.
- DVWA exposed `robots.txt`.
- Nmap found potentially interesting DVWA directories, including `/config/`, `/docs/`, and `/external/`.
- The Nginx service on port `8081` returned `Index of /`, confirming directory listing.
- The `/backups/` directory was enumerable on port `8081`.
- Juice Shop remained reachable on port `3000`.

## Interpretation

This scan confirms that vulnerable mode created observable attack surface for the case study. These findings are suitable for a before-and-after remediation story:

- Before: vulnerable services exposed internally to the scanner.
- Remediate: disable anonymous FTP, remove exposed backup files, stop vulnerable containers, and close unneeded ports.
- After: rescan to confirm the findings disappear.
