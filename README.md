# 🖥️ Intune Detected Applications Report Script

This PowerShell script connects to Microsoft Graph and retrieves a list of devices that have a specific application detected via Microsoft Intune. It is ideal for IT administrators needing audit or compliance reports for software like antivirus agents, monitoring tools, or unwanted applications.

---

## 🚀 Features

- Searches for detected applications using a partial match
- Retrieves the device name, app version, and device ID
- Outputs to a CSV file in the current script directory
- Fully scriptable and reusable for automation
- Uses Microsoft Graph API (modern authentication)

---

## 🛠️ Prerequisites

- PowerShell 7+
- Microsoft Graph PowerShell SDK  
  Install it with:
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
