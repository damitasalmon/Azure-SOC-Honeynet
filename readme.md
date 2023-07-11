# Building a SOC + Honeynet in Azure (w/Live Traffic)
<!-- Insert Project Image -->

## Introduction

In this project, I build a small-scale honeynet in Azure. I utilized Log Analytics to ingest logs from various sources that Microsoft Sentinel would leverage to build attack maps, trigger alerts, and create incidents. I configured log collection on the insecure environment, set security metrics then observed the environment for 24 hours. After investigating the incidents that Microsoft Sentinel generated during that period, security controls were applied to address the incidents and harden the environment. A second 24-hour observation was conducted to collect new data on the security metrics post-remediation. The collected metrics were:

- SecurityEvent (Windows Event Logs)
- Syslog (Linux Event Logs)
- SecurityAlert (Log Analytics Alerts Triggered)
- SecurityIncident (Incidents created by Sentinel)
- AzureNetworkAnalytics_CL (Malicious Flows allowed into our honeynet)

<!-- ## Architecture Before Hardening / Security Controls
![Architecture Diagram]()

## Architecture After Hardening / Security Controls
![Architecture Diagram]() --> 

The architecture of the mini honeynet in Azure consists of the following components:

- Virtual Network (VNet)
- Network Security Group (NSG)
- Virtual Machines (2 windows, 1 linux)
- Log Analytics Workspace
- Azure Key Vault
- Azure Storage Account
- Microsoft Sentinel

To collect the metrics for the insecure environment, all resources were originally deployed, exposed to the  public internet. The Virtual Machines had their Network Security Groups open (allowing all traffic) and built-in firewalls disabled. All other resources were deployed with endpoints visible to the public Internet.

To collect the metrics for the secured environment, Network Security Groups were hardened by blocking ALL traffic (with the exception of my workstation), and all other resources were protected by their built-in firewalls as well as Private Endpoint.

## Attack Maps Before Hardening / Security 

### NSG Allowed Malicious Inbound Flows
![NSG Allowed Inbound Malicious Flows](./Attack-Maps/nsg.png)<br>

### Linux SSH Authentication Failures
![Linux Syslog Auth Fail](./Attack-Maps/syslog.png)<br>

### Windows RDP/SMB Authentication Failures
![Windows RDP/SMB Auth Fail](./Attack-Maps/windows-rdp-smb.png)<br>

### MS SQL Server Authentication Failures
![MSSQL Server Auth Fail](./Attack-Maps/mssql.png)<br>

## Metrics Before Hardening / Security Controls

The following table shows the metrics we measured in our insecure environment for 24 hours:
Start Time	2023-07-09 22:23:51
Stop Time	2023-07-10 22:23:51

| Metric                   | Count
| ------------------------ | -----
| SecurityEvents           | 131638
| Syslog                   | 4847
| SecurityAlert            | 6
| SecurityIncident         | 359
| AzureNetworkAnalytics_CL | 2450

