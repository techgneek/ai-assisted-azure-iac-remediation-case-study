# Phase 2 Scan Summary: OWASP Juice Shop

## Scope

- Target VM: tflearn-ubuntu-vm
- Target private IP: 10.10.1.4
- Application: OWASP Juice Shop
- Application port: 3000/tcp
- Scanner: tflearn-nessus-scanner-vm
- Scan date: 2026-06-17

## Nmap Result

Nmap confirmed that Juice Shop is reachable on `10.10.1.4:3000`.

Important evidence:

- Port `3000/tcp` is open.
- The HTTP title and response content identify the application as OWASP Juice Shop.
- The response exposes web metadata and headers that can be used during web application recon.

Nmap output files are saved in:

- `reports/phase-2-juice-shop/nmap/azure-juice-shop-webapp.nmap`
- `reports/phase-2-juice-shop/nmap/azure-juice-shop-webapp.gnmap`
- `reports/phase-2-juice-shop/nmap/azure-juice-shop-webapp.xml`
- `reports/phase-2-juice-shop/nmap/azure-juice-shop-webapp-nmap-summary.md`

## Nessus Result

The corrected Nessus Web Application Tests scan completed successfully against host `10.10.1.4` with port `3000` in scope.

Summary:

- Hosts scanned: 1
- Critical: 0
- High: 0
- Medium: 0
- Low: 0
- Informational: 10

Top informational findings:

- External URLs
- HTTP Methods Allowed
- HyperText Transfer Protocol information
- Missing or permissive `frame-ancestors` Content-Security-Policy header
- Web Application Sitemap
- Web Server Directory Enumeration
- Web Server No 404 Error Code Check
- Web Server `robots.txt` Information Disclosure

Nessus output files are saved in:

- `reports/phase-2-juice-shop/nessus-juice-shop-webapp-port3000-scan.json`
- `reports/phase-2-juice-shop/nessus-juice-shop-webapp-port3000-summary.json`
- `reports/phase-2-juice-shop/nessus-juice-shop-webapp-port3000-summary.md`

Screenshot evidence:

- `reports/phase-2-juice-shop/screenshots/nessus-port-3000-webapp-scan-overview.png`
- `reports/phase-2-juice-shop/screenshots/nessus-web-application-tests-overview.png`

## Interpretation

This phase proves that the vulnerable app is deployed and discoverable from the scanner VM. Nessus identified web metadata and informational findings but did not report confirmed Low, Medium, High, or Critical vulnerabilities.

That does not mean Juice Shop is secure. Juice Shop is intentionally vulnerable, but many of its weaknesses are application-logic issues that require interactive testing, authentication, crawling, form submission, or purpose-built DAST tools.

## Recommended Next Step

Use OWASP ZAP or Burp Suite Community next. That will let the case study show a stronger web application security workflow:

- Baseline Nmap discovery
- Nessus network and web scan
- OWASP ZAP spider and passive scan
- Manual Juice Shop challenge exploitation
- Remediation notes and retest evidence
