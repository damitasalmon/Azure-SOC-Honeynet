# Building a (mini) SOC + Honeynet in Azure (w/Live Traffic)

Note: This is a general overview. For a more in-depth walkthrough of the process, please check my [Field Notes](https://fieldnotes.iruldanet.com/azure-soc-honeynet/) for updates. 

![Architecture Diagram](./Architecture-Topology/topology-diagram-2.png)

## Introduction

In this project, I built a small-scale honeynet and SOC in Azure. Log Analytics was used to ingest logs from various sources that Microsoft Sentinel would leverage to build attack maps, trigger alerts, and create incidents. Microsoft Defender for Cloud was used as a data source for LAW and to assess the VM configuration relative to regulatory frameworks/security controls. I configured log collection on the insecure environment, set security metrics then observed the environment for 24 hours. After investigating the incidents that Microsoft Sentinel generated during that period, security controls were applied to address the incidents and harden the environment based on recommendations from Microsoft Defender. After a second 24-hour observation new metrics were collected on the environment post-remediation. 

Collected metrics: 

- SecurityEvent (Windows Event Logs)
- Syslog (Linux Event Logs)
- SecurityAlert (Log Analytics Alerts Triggered)
- SecurityIncident (Incidents created by Sentinel)
- AzureNetworkAnalytics_CL (Malicious Flows allowed into our honeynet)

## Architecture Before Hardening / Security Controls
![Architecture Diagram](./Architecture-Topology/architecture-before.png)<br>

The architecture of the mini honeynet in Azure consists of the following tools and components:

- Virtual Network (VNet)
- Network Security Group (NSG)
- Virtual Machines (2 Windows, 1 Linux)
- Azure Key Vault
- Azure Storage Account
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Azure Active Directory

Additionally, the SOC utilized the following tools, components and regulations: 
- Microsoft Sentinel (SIEM)
- Microsoft Defender for Cloud (MDC)
  - [NIST SP 800-53 Revision 4](https://csrc.nist.gov/publications/detail/sp/800-53/rev-4/archive/2015-01-22)
  - [PCI DSS 3.2.1](https://listings.pcisecuritystandards.org/documents/PCI_DSS-QRG-v3_2_1.pdf) 
- Log Analytics Workspace
- Windows Event Viewer
- Kusto Query Language (KQL)
- PowerShell 

To collect the metrics for the insecure environment, all resources were originally deployed, exposed to the  public internet. The Virtual Machines had their Network Security Groups open (allowing all traffic) and built-in firewalls disabled. All other resources were deployed with endpoints visible to the public Internet.

### Implementing Security Controls

To collect the metrics for the secured environment, Network Security Groups were hardened by blocking ALL traffic (with the exception of my workstation), and built-in firewalls enabled. Azure Key Vault and Storage Container were protected by disabling access to public endpoints and replacing them with rivate endpoints.

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

The following table shows the measurements taken in the insecure environment after 24 hours: <br>
Start Time	2023-07-09 22:23:51 <br>
Stop Time	2023-07-10 22:23:51

| Metric                   | Count
| ------------------------ | -----
| SecurityEvents           | 131638
| Syslog                   | 4847
| SecurityAlert            | 6
| SecurityIncident         | 359
| AzureNetworkAnalytics_CL | 2450


## Architecture After Hardening / Security Controls
![Architecture Diagram](./Architecture-Topology/architecture-after-5.png)<br>

## Attack Maps After Hardening / Security Controls

```All map queries returned no results due to no instances of malicious activity for the 24-hour period after hardening.```

### NSG Allowed Malicious Inbound Flows
![NSG Allowed Inbound Malicious Flows](./Attack-Maps/nsg-after.png)<br>

### Linux SSH Authentication Failures
![Linux Syslog Auth Fail](./Attack-Maps/syslog-after.png)<br>

### Windows RDP/SMB Authentication Failures
![Windows RDP/SMB Auth Fail](./Attack-Maps/windows-rdp-smb-after.png)<br>

### MS SQL Server Authentication Failures
![MSSQL Server Auth Fail](./Attack-Maps/mssql-after.png)<br>

## Metrics After Hardening 

The following table shows the measurements taken after applying the security controls the environment and observing for another 24 hours: <br />
2023-07-11 22:15<br />
2023-07-12 22:15

| Metric                   | Count
| ------------------------ | -----
| SecurityEvent            | 22668
| Syslog                   | 24
| SecurityAlert            | 0
| SecurityIncident         | 0
| AzureNetworkAnalytics_CL | 0

### Impact of Security Controls 

| Metric                                       | Change post-hardening
| -------------------------------------------- | -----
| SecurityEvent (Windows VMs)                  | 82.78%
| Syslog (Linux VMs)                           | 99.50%
| SecurityAlert (Microsoft Defender for Cloud) | 100%
| SecurityIncident (Sentinel Incidents)        | 100%
| AzureNetworkAnalytics_CL                     | 100%

## Conclusion

In this project, a mini honeynet was constructed in Microsoft Azure utilizing VMs and a SOC with Log Analytics, Microsoft Defender for Cloud and Microsoft Sentinel. Sentinel used logs ingested by a Log Analytics workspace to trigger alerts and create incidents. Next, logging was enabled and data collected on the insecure environment based on established security metrics, before applying security controls recommended by Microsoft Defender. The logs and data were reassessed after implementing security measures. As a result, the number of security events and incidents were drastically reduced after the security controls were applied. 

It is worth noting that if the resources within the network were heavily utilized by regular users, it is likely that more security events and alerts may have been generated within the 24-hour period following the implementation of the security controls.


