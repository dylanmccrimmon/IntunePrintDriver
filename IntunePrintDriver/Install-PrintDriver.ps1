[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
    [String]$DriverName,
    [Parameter(Mandatory = $True)]
    [String]$INFFile
)

Start-Transcript -Path "$($env:TEMP)\IntunePrintDriver.log" -Append

Write-Output "Starting IntunePrintDriver.ps1"

# Generate Variables
$PNPUtilPath = Join-Path -Path "C:\Windows\SysNative" -ChildPath 'pnputil.exe'
$INFFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Driver\$INFFile"

Write-Output "Passed Variables"
Write-Output "Driver Name: $DriverName"
Write-Output "INF File: $INFFile"
Write-Output "Generated Variables"
Write-Output "PNPUtil Path: $PNPUtilPath"
Write-Output "INF File Path: $INFFilePath"

# Check if the driver is already present in Print Management
$DriverExist = Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue

# If the driver is already present, exit the script
if ($DriverExist) {
    Write-Output "Driver $DriverName is already installed. Exiting script."
    Exit 0
}

# Add the driver to the Windows Driver Store
Try {
    $INFARGS = @(
            "/add-driver"
            "`"$INFFilePath`""
    )
    Write-Output "Running command: Start-Process $PNPUtilPath -ArgumentList $($INFARGS) -NoNewWindow -Wait"
    Start-Process $PNPUtilPath -ArgumentList $INFARGS -NoNewWindow -Wait | Out-Null
}
Catch {
    Write-Output "An error occurred while adding the driver to the Windows Driver Store. Error: $($_.Exception)"
    Exit 1
}

# Install the driver if there was no error
Try {
    Write-Output "Installing Printer Driver to Print Management"
    Add-PrinterDriver -Name $DriverName -Confirm:$false
}
Catch {
    Write-Output "An error occurred while installing the driver to the Print Management. Error: $($_.Exception)"
    Exit 1
}

Write-Output "Script has completed successfully."
Exit 0