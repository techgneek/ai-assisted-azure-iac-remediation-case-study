# Phase 4 Redo: High-Severity Remediation

## Purpose

The original remediation phase proved the workflow, but the findings were not severe enough for a strong portfolio story. This redo creates a more realistic high-priority vulnerability management scenario by introducing internal-only vulnerable services that produce Critical Nessus findings.

No public Azure NSG exposure was added. The vulnerable services were reachable only from the scanner VM over the Azure virtual network path.

## Enterprise Scenario

The affected server is treated as a production-facing internal security assessment platform owned by a fictional Security Assessment Platform Team.

The vulnerability management team identifies Critical findings and notifies the server owner. The owner confirms that the vulnerable services are not required for production use. Because the asset is treated as production-sensitive and public-facing in the scenario, the issue is escalated for expedited CAB approval.

In this case study, James and Codex act as both the detection team and the remediation team so the full process can be demonstrated end to end.

## Pre-Remediation Exposure

The high-severity case study exposed selected vulnerable services internally:

| Host Port | Service | Evidence |
| --- | --- | --- |
| `8021/tcp` | FTP | `vsftpd 2.3.4` |
| `8022/tcp` | SSH | `OpenSSH 4.7p1 Debian` |
| `8023/tcp` | Telnet | `Linux telnetd` |
| `8083/tcp` | HTTP | `Apache 2.2.8` |
| `8180/tcp` | HTTP | `Apache Tomcat 5.5` |
| `8667/tcp` | IRC | `UnrealIRCd` |

## Nessus Pre-Remediation Result

Nessus scan:

- Scan name: `Azure Target - High Severity Metasploitable Pre-Remediation`
- Target: `10.10.1.4`
- Status: Completed
- Hosts scanned: 1

Severity counts:

- Critical: 4
- High: 0
- Medium: 3
- Low: 4
- Info: 38

Critical findings:

- `Apache Tomcat SEoL (<= 5.5.x)`
- `Canonical Ubuntu Linux SEoL (8.04.x)`
- `Debian OpenSSH/OpenSSL Package Random Number Generator Weakness`
- `UnrealIRCd Backdoor Detection`

## Change Request

Change title:

> Emergency removal of vulnerable high-risk services from internal security assessment platform.

Change reason:

> Nessus identified Critical vulnerabilities on internally exposed services. In the enterprise scenario, the asset is treated as production-facing and sensitive. These services are not required and should be removed immediately.

Implementation plan:

1. Remove the `metasploitable2-lab` container.
2. Remove the `vulnerable-apache-249` container.
3. Validate that ports `8021`, `8022`, `8023`, `8082`, `8083`, `8180`, and `8667` are closed.
4. Preserve Juice Shop and DVWA for later web application practice.
5. Save pre- and post-remediation scan evidence.

Remediation script:

- `scripts/remediate-phase4-high-severity.sh`

Rollback plan:

1. Recreate the vulnerable containers only if explicitly approved.
2. Re-run Nmap to confirm the services are restored.
3. Document the rollback and re-open CAB review.

CAB decision:

> Approved for emergency remediation due to Critical vulnerability severity and low business need for the vulnerable services.

## Remediation Performed

The remediation script removed:

- `metasploitable2-lab`
- `vulnerable-apache-249`

Services intentionally left running:

- OWASP Juice Shop on `3000/tcp`
- DVWA on `8080/tcp`

## Post-Remediation Validation

Post-remediation Nmap confirmed:

| Port | State |
| --- | --- |
| `8021/tcp` | Closed |
| `8022/tcp` | Closed |
| `8023/tcp` | Closed |
| `8082/tcp` | Closed |
| `8083/tcp` | Closed |
| `8180/tcp` | Closed |
| `8667/tcp` | Closed |

Security Team host health check:

- `reports/phase-4-high-severity-remediation/host-health-check-phase4-high-severity.txt`

Host health check result:

- Remediated vulnerable containers are not present.
- Remediated high-severity ports are not listening.
- Juice Shop and DVWA remain intentionally available for later case study practice.

Post-remediation Nessus validation:

- Scan name: `Azure Target - High Severity Post-Remediation Validation`
- Status: Completed
- Critical: 0
- High: 0
- Medium: 0
- Low: 1
- Info: 14

The remaining Low finding is `ICMP Timestamp Request Remote Date Disclosure`, which is unrelated to the remediated high-severity case study services.

## Evidence

Nmap pre-remediation:

- `reports/phase-4-high-severity-remediation/nmap/metasploitable-pre-remediation/metasploitable-selected-pre-remediation.nmap`
- `reports/phase-4-high-severity-remediation/nmap/metasploitable-pre-remediation/metasploitable-selected-pre-remediation.xml`

Nessus pre-remediation:

- `reports/phase-4-high-severity-remediation/nessus-metasploitable-pre-scan.json`
- `reports/phase-4-high-severity-remediation/nessus-metasploitable-pre-summary.md`
- `reports/phase-4-high-severity-remediation/screenshots/nessus-high-severity-metasploitable-pre-remediation.png`
- `reports/phase-4-high-severity-remediation/screenshots/nessus-tomcat-critical-drilldown.png`

Nmap post-remediation:

- `reports/phase-4-high-severity-remediation/nmap/post-remediation/high-severity-post-remediation.nmap`
- `reports/phase-4-high-severity-remediation/nmap/post-remediation/high-severity-post-remediation.xml`

Nessus post-remediation:

- `reports/phase-4-high-severity-remediation/nessus-high-severity-post-scan.json`
- `reports/phase-4-high-severity-remediation/nessus-high-severity-post-summary.md`
- `reports/phase-4-high-severity-remediation/screenshots/nessus-high-severity-post-remediation-validation.png`

Remediation script:

- `scripts/remediate-phase4-high-severity.sh`

Security validation script:

- `scripts/host-health-check-phase4-high-severity.sh`
