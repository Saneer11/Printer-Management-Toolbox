# 📦 Printer Management Toolbox (PowerShell)

A PowerShell automation script to remotely manage printers on Windows
computers.\
This toolbox helps IT Support, Service Desk, and System Admins quickly
deploy, remove, and troubleshoot printers across the enterprise.

## 🚀 Features

✔ Enable or disable PowerShell Remoting on remote PCs\
✔ List installed printer drivers\
✔ View printer name, driver, and port details\
✔ Add printers using IP address\
✔ Add printers from a Windows Print Server (shared queue)\
✔ Remove printers from a remote PC\
✔ Send a test print page to any installed printer\
✔ Uses CIM, PsExec, and native PrintManagement cmdlets\
✔ Interactive menu-driven console interface

## 🛠 Technologies Used

-   **PowerShell**
-   **PrintManagement Module**
-   **CIM / Win32_Printer**
-   **PsExec (Sysinternals)**
-   **Windows 10/11 / Windows Server**

## 📁 Project Structure

    📦 Printer-Management-Toolbox
     ┣ 📄 PrinterManagementToolbox.ps1
     ┗ 📄 README.md

## 📖 How It Works

The script provides a menu system for managing printers remotely.\
Operations are performed using:

-   `Invoke-Command` for remote PowerShell\
-   `Add-Printer`, `Remove-Printer`, `Add-PrinterPort` for deployments\
-   `PsExec` to enable or disable PS remoting\
-   `CIM` to send test print pages

## ▶️ Usage Instructions

1.  Download the script\
2.  Place **PsExec.exe** in the same folder\
3.  Run PowerShell as Administrator\
4.  Execute:

``` powershell
.\PrinterManagementToolbox.ps1
```

5.  Select an option from the menu

## ✨ Example Menu

    1. Enable PS Remoting on Remote PC
    2. Get Installed Printer Drivers
    3. Get Printer Details (Name, Driver, Port)
    4. Remove a Printer from Remote PC
    5. Add a Printer to Remote PC
    6. Disable PS Remoting on Remote PC
    7. Add Printer From Print Server (Shared Queue)
    8. Send Test Print to a Printer
    0. Exit

## 📌 Use Cases

-   Deploying printers across multiple locations\
-   Reconfiguring or troubleshooting remote printers\
-   Resolving driver or port issues\
-   Standardizing printer setups\
-   Creating an internal IT automation toolkit

## 🧑‍💻 Author

**Saneer Ahamed**

## 📜 License

MIT License
