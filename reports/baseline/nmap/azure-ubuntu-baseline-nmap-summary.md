# Azure Ubuntu Target - Baseline Nmap Scan

## Scan Metadata

- Scanner: `tflearn-nessus-scanner-vm`
- Target: `10.10.1.4`
- Target DNS: `tflearn-ubuntu-vm.internal.cloudapp.net`
- Scan type: TCP SYN scan, service/version detection, default scripts, vuln scripts
- Command:

```bash
sudo nmap -Pn -sS -sV -sC --script vuln --reason --open -oA ~/nmap-baseline/azure-ubuntu-baseline 10.10.1.4
```

## Open Ports

| Port | Service | Version |
|---|---|---|
| `22/tcp` | SSH | `OpenSSH 9.6p1 Ubuntu 3ubuntu13.16` |

## Key Observations

- The target host was reachable over the private Azure network.
- Only SSH was exposed during the baseline scan.
- This matches the intended minimal attack surface for the initial case study environment.
- Nmap's vulnerability scripts returned multiple possible OpenSSH CVE matches from external script data.

## Validation Note

The Nmap `vuln` script output should be treated as **possible exposure requiring validation**, not as confirmed vulnerability evidence. OpenSSH packages on Ubuntu often include backported security fixes while preserving upstream-looking version strings. Nessus reported no high or critical findings in the baseline scan, so the OpenSSH CVE list needs package-level validation before being written up as confirmed risk.

## Saved Artifacts

- Normal output: `azure-ubuntu-baseline.nmap`
- Grepable output: `azure-ubuntu-baseline.gnmap`
- XML output: `azure-ubuntu-baseline.xml`
