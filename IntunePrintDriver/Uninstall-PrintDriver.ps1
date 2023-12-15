[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
    [String]$DriverName
)

Start-Transcript -Path "$($env:TEMP)\IntunePrintDriver.log" -Append

Write-Output "Starting Uninstall-PrintDriver.ps1"

# Generate Variables
$PNPUtilPath = Join-Path -Path "C:\Windows\SysNative" -ChildPath 'pnputil.exe'

Write-Output "Passed Variables"
Write-Output "Driver Name: $DriverName"
Write-Output "Generated Variables"
Write-Output "PNPUtil Path: $PNPUtilPath"

# Check if the driver is already present in Print Management
$DriverExist = Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue

# If the driver is already present, exit the script
if (!$DriverExist) {
    Write-Output "Driver $DriverName isn't installed. Exiting script."
    Exit 0
}

$INFFilePath = $DriverExist.InfPath
Write-Output "INF File Path: $INFFilePath"

# Remove the driver from Print Management
Try {
    Write-Output "Removing Printer Driver '$($DriverName)' from Print Management"
    Remove-PrinterDriver -Name $DriverName -Confirm:$false
}
Catch {
    Write-Output "An error occurred while removing the driver to the Print Management. Error: $($_.Exception)"
    Exit 1
}

# Remove the driver to the Windows Driver Store
Try {
    Write-Output "Removing Printer Driver from Windows Driver Store"
    $INFARGS = @(
            "/delete-driver"
            "`"$INFFilePath`""
            "/force"
    )
    Write-Output "Running command: Start-Process $PNPUtilPath -ArgumentList $($INFARGS) -NoNewWindow -Wait"
    Start-Process $PNPUtilPath -ArgumentList $INFARGS -NoNewWindow -Wait | Out-Null
}
Catch {
    Write-Output "An error occurred while removing the driver to the Windows Driver Store. Error: $($_.Exception)"
    Exit 1
}

Write-Output "Script has completed successfully."
Exit 0