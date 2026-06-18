# Nmap Juice Shop Web App Scan Summary

- Scanner: Nessus scanner VM
- Target: 10.10.1.4
- Port: 3000/tcp
- Result: Open
- Detected application: OWASP Juice Shop
- Output files:
  - azure-juice-shop-webapp.nmap
  - azure-juice-shop-webapp.gnmap
  - azure-juice-shop-webapp.xml

## Key Observations

- Nmap confirmed that the intentionally vulnerable Juice Shop app is reachable on TCP port 3000 from the scanner subnet.
- The HTTP response identified the page title as OWASP Juice Shop.
- Response headers included:
  - Access-Control-Allow-Origin: *
  - X-Content-Type-Options: nosniff
  - X-Frame-Options: SAMEORIGIN
  - Feature-Policy: payment 'self'
  - X-Recruiting: /#/jobs
- Nmap did not confirm a specific exploitable CVE from this scan. Treat this result as service discovery and exposure evidence, not a full web application security assessment.

## Portfolio Note

This scan demonstrates the discovery phase: identify the exposed service, confirm the application, collect HTTP metadata, then hand off to deeper web testing with Nessus Web Application Tests, OWASP ZAP, Burp Suite Community, or manual Juice Shop challenges.
