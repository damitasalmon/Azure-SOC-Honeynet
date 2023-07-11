# Building a SOC + Honeynet in Azure (w/Live Traffic)
<!-- Insert Project Image -->

## Introduction

In this project, I build a small-scale honeynet in Azure. I utilized Log Analytics to ingest logs from various sources that Microsoft Sentinel would leverage to build attack maps, trigger alerts, and create incidents. I configured log collection on the insecure environment, set security metrics then observed the environment for 24 hours. After investigating the incidents that Microsoft Sentinel generated during that period, security controls were applied to address the incidents and harden the environment. A second 24-hour observation was conducted to collect new data on the security metrics post-remediation. The collected metrics were:

- SecurityEvent (Windows Event Logs)
- Syslog (Linux Event Logs)
- SecurityAlert (Log Analytics Alerts Triggered)
- SecurityIncident (Incidents created by Sentinel)
- AzureNetworkAnalytics_CL (Malicious Flows allowed into our honeynet)

