 [CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
    [String]$DriverName,
    [Parameter(Mandatory = $True)]
    [String]$INFFile,
    [Parameter(Mandatory = $False)]
    [String]$CatalogFile

)

Start-Transcript -Path "$($env:TEMP)\IntunePrintDriver.log" -Append

Write-Output "Starting IntunePrintDriver.ps1"

#Run script in 64bit PowerShell to enumerate correct path for pnputil
If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    Write-Output "Powershell is running in a 32bit context. Re-running in SysNative."
    $ThrowBad = $True
    Try {
        &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH -DriverName "$DriverName" -INFFile "$INFFile" -CatalogFile $CatalogFile
    }
    Catch {
        Write-Error "Failed to start $PSCOMMANDPATH"
        Write-Warning "$($_.Exception.Message)"
        Exit 0
    }
}

If (-not $ThrowBad) {

    
    $INFFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Driver\$INFFile"

    Write-Output "Driver Name: $DriverName"
    Write-Output "INF File: $INFFile"
    Write-Output "INF File Path: $INFFilePath"
    

    if ($CatalogFile) {
        $CatalogFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Driver\$CatalogFile"
        Write-Output "Catalog File: $CatalogFile"
        Write-Output "Catalog File Path: $CatalogFilePath"
        Write-Output "Adding the publisher certificate to the Trusted Prublisher store"

        # Trust the publisher certificate
        $signature = Get-AuthenticodeSignature $CatalogFilePath
        $store = Get-Item -Path Cert:\LocalMachine\TrustedPublisher
        $store.Open("ReadWrite")
        $store.Add($signature.SignerCertificate)
        $store.Close() 
    }


    # Add the driver to the Windows Driver Store
    Try {
        Write-Output "Running command: PNPUtil"
        & pnputil.exe /add-driver $INFFilePath /install /force
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

} 
