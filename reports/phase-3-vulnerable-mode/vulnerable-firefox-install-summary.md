# Vulnerable Firefox Install Summary

## Purpose

This change adds intentionally outdated local software to the Azure Ubuntu target VM for vulnerability management and scanner inventory practice.

## Target

- VM: `tflearn-ubuntu-vm`
- Private IP: `10.10.1.4`
- Public IP: `REDACTED`

## Installed Software

- Software: Mozilla Firefox
- Version: `115.0`
- Install path: `/opt/vulnerable-firefox`
- Launcher: `/usr/local/bin/vulnerable-firefox`
- Verification command: `vulnerable-firefox --version`

## Important Scan Note

Firefox is local client software. It does not listen on a network port by default, so Nmap will not detect it during a normal port scan.

To make this useful for vulnerability management telemetry, run a credentialed Nessus scan against the target VM so Nessus can inspect installed software and filesystem/package evidence.

## Remediation

Remove the vulnerable Firefox install:

```bash
sudo rm -rf /opt/vulnerable-firefox
sudo rm -f /usr/local/bin/vulnerable-firefox
```

Optional cleanup for GUI/browser dependencies installed during testing should be reviewed carefully before removal because package dependencies can vary:

```bash
sudo apt autoremove
```
