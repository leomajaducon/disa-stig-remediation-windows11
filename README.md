# 🛡️ DISA STIG Implementation and Remediation

## 📌 Overview

In this project, I practice implementing and remediating **DISA Security Technical Implementation Guides (STIGs)** on a Windows 11 virtual machine. I explore each selected security requirement through manual configuration changes and script-based remediation using PowerShell, with the assistance of ChatGPT to generate and refine remediation scripts.

My goal is to understand how security configuration requirements translate into practical system hardening, how to implement them manually, and how to automate remediation while validating the results through follow-up scans.

## 🎯 Objectives

- Understand and implement selected DISA STIG security requirements.
- Practice manual Windows security configuration and hardening.
- Develop remediation scripts with the assistance of ChatGPT.
- Compare manual remediation with script-based implementation.
- Validate remediation effectiveness through follow-up Tenable scans.
- Document reusable fixes and track implementation progress.

## 💡 Why This Matters

DISA STIGs provide security configuration guidance designed to strengthen system security and reduce vulnerabilities. Learning to implement these requirements helps me understand how misconfigurations can be addressed and how automated remediation can support repeatable security operations.

This project allows me to practice a remediation workflow used in vulnerability management: **identify findings, implement fixes, and validate the results.**

## 🧰 Technologies Used

- **Tenable** — Enterprise vulnerability management platform used to audit system configurations and review findings.
- **Azure Virtual Machines** — Hosts my Windows 11 scan target and Nessus scan engine.
- **PowerShell** — Used to develop and execute Windows remediation scripts.
- **ChatGPT** — Used to assist in generating and refining remediation scripts based on selected STIG requirements.

AI-generated scripts are treated as proposed solutions rather than automatically trusted fixes. I review the commands, test them in my lab, and validate their effectiveness through follow-up scans.

## ⚙️ Methodology

I follow an iterative workflow for each STIG requirement I choose to implement.

### 1. Establish a Baseline Scan

I scan my Windows 11 virtual machine using a Tenable audit policy based on Windows 11 STIG requirements. I review the results to identify configuration findings that I can investigate and remediate.

### 2. Select a STIG Requirement

I select a finding from the scan results and review its associated security requirement, expected configuration, and remediation guidance.

### 3. Implement the Fix Manually

Before automating the remediation, I investigate how to implement the selected STIG manually. I apply the required configuration change and observe its effect on the system.

### 4. Validate the Manual Implementation

I run a follow-up scan using the same applicable audit policy to determine whether the finding has been resolved. I review the audit result rather than assuming the configuration change was successful.

### 5. Develop an AI-Assisted Remediation Script

After testing the manual approach, I use ChatGPT to help generate or refine a PowerShell script that implements the same security requirement.

I review the generated commands, verify that they align with the intended STIG requirement, and execute the script in my lab environment.

### 6. Validate the Script-Based Implementation

I perform another scan to determine whether the scripted remediation successfully addresses the finding. If the finding remains, I investigate the result and refine the implementation as necessary.

### 7. Document and Track the Results

Once I have validated the remediation, I publish the reusable script and its supporting documentation to GitHub. I also record the STIG requirement, implementation approach, validation result, and relevant notes in my experience-tracking spreadsheet.

## 🔄 Remediation Workflow

```text
Baseline Scan
     ↓
Select STIG Requirement
     ↓
Manual Remediation
     ↓
Rescan and Validate
     ↓
AI-Assisted Script Development
     ↓
Execute Remediation Script
     ↓
Rescan and Validate
     ↓
Document and Track Results
