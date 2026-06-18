# AI Prompt Log

This document records representative prompts used to guide the AI-assisted workflow for the case study. The prompts are written in an enterprise style and sanitized for portfolio use.

They are not meant to expose private employer details or tool secrets. They show how GitHub Copilot and Codex were used to move from idea to infrastructure, scanning, remediation, validation, and documentation.

## Prompting Approach

The project used AI agents as engineering collaborators, not as unchecked automation.

The prompts generally followed this pattern:

1. Define the role and context.
2. State the environment.
3. Describe the desired outcome.
4. Add constraints such as cost, security scope, and evidence requirements.
5. Ask for scripts, commands, documentation, or validation steps.
6. Review results and iterate.

## Phase 1: Terraform Azure Buildout

Preview:

> Create a beginner-friendly Terraform project that deploys a very small Azure case study environment for learning and keeps costs low.

Full representative prompt:

```text
You are an expert Azure and Terraform engineer helping a cybersecurity professional learn Infrastructure as Code.

Environment:
- MacBook
- VS Code
- GitHub Copilot
- Azure account
- Beginner with Terraform
- Intermediate with Azure and cybersecurity

Goal:
Create a beginner-friendly Terraform project that deploys a small Azure security environment for learning purposes while minimizing cost.

Requirements:
- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Ubuntu target VM
- Public IP
- Network Interface
- Variables, outputs, provider configuration, and terraform.tfvars
- Comments explaining the code
- Step-by-step install, authentication, deploy, SSH, and destroy instructions
- Tags for Environment, Owner, and Project
```

## Phase 2: Scanner and Baseline Vulnerability Assessment

Preview:

> Set up Nessus Essentials on a scanner VM and run the first baseline scan against the Azure target.

Full representative prompt:

```text
Set up a scanner workflow for the Azure Terraform security environment.

Use Nessus Essentials on a dedicated scanner VM and scan the target VM over the private Azure virtual network.

Requirements:
- Keep vulnerable services internal to the case study network.
- Use Nmap for service discovery.
- Use Nessus for vulnerability scanning.
- Save scan outputs under a reports folder.
- Create Markdown summaries that explain what was found.
- Include screenshots where useful.
- Make sure the output can be used as portfolio evidence.
```

## Phase 3: Controlled Vulnerable Mode

Preview:

> Add intentionally vulnerable services that create observable scan telemetry, but do not expose them broadly to the internet.

Full representative prompt:

```text
Create a controlled vulnerable mode for the Azure target VM.

The goal is to generate realistic vulnerability management telemetry for Nmap and Nessus while keeping the case study safe.

Add intentionally vulnerable or misconfigured services such as:
- OWASP Juice Shop
- DVWA
- Anonymous FTP
- Directory listing with fake backup/config files
- Old local software for inventory practice

Constraints:
- Do not open vulnerable ports broadly to the public internet.
- Keep scanning internal from the scanner VM to the target VM.
- Save Nmap and Nessus results.
- Create a written summary of the findings and the intended remediation path.
```

## Phase 4: Enterprise Remediation Workflow

Preview:

> Simulate how a real enterprise would triage, approve, remediate, and validate vulnerabilities through a CAB/change process.

Full representative prompt:

```text
Turn the vulnerability findings into an enterprise-style remediation workflow.

Document the process as if this happened in a production environment:
- Vulnerability Management Team discovers findings.
- Asset owner is notified.
- Severity and business impact are reviewed.
- A change request is created.
- CAB approves the remediation.
- The remediation team implements the fix.
- The Security Team validates remediation.
- The ticket is closed with evidence.

For the case study, we will act as both the detection team and remediation team, but the documentation should explain that these duties are usually separated in an enterprise.
```

## Phase 4 Redo: High-Severity Case Study

Preview:

> Create a stronger portfolio story by generating Critical findings internally, then remediate and validate them.

Full representative prompt:

```text
The current remediation story is technically correct, but the findings are not severe enough for a strong portfolio case study.

Create a safer high-severity simulation that produces High or Critical vulnerability telemetry without exposing the target publicly.

Requirements:
- Use internal-only vulnerable services reachable from the scanner VM.
- Run Nmap before remediation to prove service exposure.
- Run Nessus before remediation to capture Critical findings.
- Remediate by removing or disabling the vulnerable services.
- Run Nmap after remediation to confirm ports are closed.
- Run Nessus after remediation to confirm Critical, High, and Medium findings are gone.
- Save all evidence and screenshots.
```

## Remediation Script Prompt

Preview:

> Create a remediation script that removes the vulnerable services and prints before/after validation.

Full representative prompt:

```text
Create a Bash remediation script for the target VM.

The script should:
- Show before-remediation listening services.
- Stop and remove the vulnerable containers.
- Preserve intentionally retained case study services.
- Show after-remediation listening services.
- Be safe to run more than once.
- Use clear output suitable for evidence collection.

The script should be saved in the scripts folder and referenced in the README and remediation report.
```

## Security Validation Prompt

Preview:

> Add a host health check script as Security Team validation proof.

Full representative prompt:

```text
Create a Security Team host health check script.

The script should run on the target VM and verify:
- Remediated vulnerable containers are not present.
- High-severity ports are no longer listening.
- Intentionally retained case study services are still available.
- Output is clear and can be saved as validation evidence.

Add the health check output to the final case study and pair it with post-remediation Nmap and Nessus evidence.
```

## Case Study Documentation Prompt

Preview:

> Turn the full project into a recruiter-friendly README that tells the story from buildout to closure.

Full representative prompt:

```text
Rewrite the README as a front-facing portfolio case study.

The README should tell the full story:
- AI-assisted Terraform buildout
- Azure architecture
- Scanner and target VM
- Baseline scans
- Vulnerable services
- Critical Nessus findings
- Enterprise triage and CAB flow
- Remediation script execution
- Security Team validation
- Jira-style closure
- Evidence links
- Cost control
- Terraform destroy next step

Keep the detailed scripts, raw scan outputs, and screenshots linked from supporting folders so the README stays readable.
```

## Safety and Sanitization Prompt

Preview:

> Remove employer-specific wording and keep the story fictional but realistic.

Full representative prompt:

```text
Review the case study language for anything that could sound employer-specific or proprietary.

Replace sensitive or real-world team references with neutral fictional terms.

Use terms like:
- Internal Security Assessment Platform
- Security Assessment Platform Team
- Vulnerability Management Team
- Remediation Team
- Security Team

Keep the story realistic, but make it clear this is a case study simulation and not disclosure of employer systems, processes, or secrets.
```
