# Replace the $DriverName variable with the name of the driver you want to detect
$DriverName = "uniFLOW Universal PclXL Driver"

# Attempt to get the Print Driver
$DriverExist = Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue

# If the driver exists, uninstall it
if ($DriverExist) {
    Write-Output "Driver '$($DriverName)' exists."
    exit 0
} else {
    Write-Output "Driver '$($DriverName)' doesn't exists."
    exit 1
}