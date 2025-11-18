# ================================
# Printer Management Toolbox
# ================================
Clear-Host
Write-Host "======================================="
Write-Host "       PRINTER MANAGEMENT TOOLBOX      "
Write-Host "======================================="

function Enable-PSRemotingRemote {
    $PC = Read-Host "Enter remote PC name or IP"
    $PsExecPath = Join-Path $PSScriptRoot "PsExec.exe"  # Adjust path if PsExec not in same folder
    & $PsExecPath "\\$PC" -u "ENT\$env:USERNAME" -h powershell -Command "Enable-PSRemoting -Force"
}

function Get-PrinterDrivers {
    $RemotePC = Read-Host "Enter remote PC name or IP"
    Invoke-Command -ComputerName $RemotePC -ScriptBlock {
        Get-PrinterDriver | Select-Object Name
    }
}

function Get-PrinterDetails {
    $RemotePC = Read-Host "Enter remote PC name or IP"
    Invoke-Command -ComputerName $RemotePC -ScriptBlock {
        Get-Printer | Select-Object Name, DriverName, PortName
    } | Format-Table -AutoSize
}

function Remove-PrinterRemote {
    $PC = Read-Host "Enter remote PC name or IP"
    $PrinterName = Read-Host "Enter printer name to remove"
    Invoke-Command -ComputerName $PC -ScriptBlock {
        param($PrinterName)
        Remove-Printer -Name $PrinterName -ErrorAction SilentlyContinue
    } -ArgumentList $PrinterName
    Write-Host "Printer '$PrinterName' removed from '$PC' (if it existed)."
}

function Add-PrinterRemote {
    $PC = Read-Host "Enter remote PC name or IP"
    $PrinterName = Read-Host "Enter printer name"
    $PrinterIP = Read-Host "Enter printer IP address"
    $DriverName = Read-Host "Enter printer driver name"

    Invoke-Command -ComputerName $PC -ScriptBlock {
        param($PrinterName,$PrinterIP,$DriverName)
        Add-PrinterPort -Name $PrinterIP -PrinterHostAddress $PrinterIP -ErrorAction SilentlyContinue
        Add-Printer -Name $PrinterName -PortName $PrinterIP -DriverName $DriverName -ErrorAction SilentlyContinue
    } -ArgumentList $PrinterName,$PrinterIP,$DriverName

    Write-Host "Printer '$PrinterName' added to '$PC'."
}

function Disable-PSRemotingRemote {
    $PC = Read-Host "Enter remote PC name or IP"
    $PsExecPath = Join-Path $PSScriptRoot "PsExec.exe"  # Adjust if PsExec.exe is not in the same folder
    & $PsExecPath "\\$PC" -u "ENT\$env:USERNAME" -h powershell -Command "Disable-PSRemoting -Force"
    Write-Host "PS Remoting disabled on '$PC'."
}

function Add-PrinterFromPrintServer {
    $PC = Read-Host "Enter remote PC name or IP"
    $PrintServer = Read-Host "Enter Print Server name (e.g. CRLPMF1369)"
    $PrinterShare = Read-Host "Enter Printer Share Name (e.g. CRLMFD47)"

    $ConnectionPath = "\\$PrintServer\$PrinterShare"

    Invoke-Command -ComputerName $PC -ScriptBlock {
        param($ConnectionPath)
        Add-Printer -ConnectionName $ConnectionPath -ErrorAction SilentlyContinue
    } -ArgumentList $ConnectionPath

    Write-Host "Printer '$PrinterShare' installed from server '$PrintServer' on '$PC'."
}

function Send-TestPrint {
    $PC = Read-Host "Enter remote PC name or IP"
    $PrinterName = Read-Host "Enter printer name to send test page"

    Invoke-Command -ComputerName $PC -ScriptBlock {
        param($PrinterName)
        $printer = Get-CimInstance -ClassName Win32_Printer -Filter "Name='$PrinterName'"
        if ($printer) {
            $result = $printer | Invoke-CimMethod -MethodName PrintTestPage
            if ($result.ReturnValue -eq 0) {
                Write-Host "Test page sent successfully to '$PrinterName'."
            } else {
                Write-Host "Failed to send test page. Error code: $($result.ReturnValue)"
            }
        } else {
            Write-Host "Printer '$PrinterName' not found on this PC."
        }
    } -ArgumentList $PrinterName
}


do {
    Write-Host "`nSelect an option:"
    Write-Host "1. Enable PS Remoting on Remote PC"
    Write-Host "2. Get Installed Printer Drivers"
    Write-Host "3. Get Printer Details (Name, Driver, Port)"
    Write-Host "4. Remove a Printer from Remote PC"
    Write-Host "5. Add a Printer to Remote PC"
    Write-Host "6. Disable PS Remoting on Remote PC"
    Write-Host "7. Add Printer From Print Server (Shared Queue)"
    Write-Host "8. Send Test Print to a Printer"
    Write-Host "0. Exit"
    $choice = Read-Host "Enter choice"

    switch ($choice) {
        "1" { Enable-PSRemotingRemote }
        "2" { Get-PrinterDrivers }
        "3" { Get-PrinterDetails }
        "4" { Remove-PrinterRemote }
        "5" { Add-PrinterRemote }
        "6" { Disable-PSRemotingRemote }
        "7" { Add-PrinterFromPrintServer }
        "8" { Send-TestPrint }
        "0" { Write-Host "Exiting Toolbox..." }
        default { Write-Host "Invalid choice. Please try again." }
    }
} while ($choice -ne "0")
