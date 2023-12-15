# Getting Started Guide
This guide should help you in getting a print driver deploy to a device.

## Prerequisite

- Print driver in the form of an inf file and related files.
- A copy of the [IntuneWinAppUtil.exe](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool)
- Access to Intune's management console

## Download this repo
You'll now need to take a clone of this project repo. You can do this by running the below cmdlet (requires Git to be installed). 

``` bash
git clone https://github.com/dylanmccrimmon/IntunePrintDriver
```

If you don't have Git installed, you can instead download it in a browser with the below URL

```
https://codeload.github.com/dylanmccrimmon/IntunePrintDriver/zip/refs/heads/main
```

## Add your drivers
You'll now need to add your driver to the Driver folder. Make sure all of the relevant are copied into this directory such as the `.inf`, `.cat`, `.dll` files; keep any existing folder structures too.

### Example
```
└── Drivers
    ├── x64
        ├── MomUdPclXLPrint.dll
        ├── MomUdUIPclXl.dll
    ├── momudpclxl.inf
    ├── momudpclxl.PNF
    ├── momudpclxlamd64.cat
    ├── MomUdPclXLPrint.gpd
    └── MomUdPclXLPrint.ini
```

## Grab the driver name
You can usually find the driver name within the INF file of your driver; you will need this later on. Open up the INF file in your favorite text editor. In the file you should be able to find the driver name, in our example, it's **uniFlow Universal PclXL Driver**.

![Driver Name](/Docs/Assets/DriverName.jpg)

## Package into a .intunewim file
Now it's time to package and create the .intunewim file so that you can import this into the Intune admin center.

Run the IntuneWinAppUtil.exe and create your packaged app. The setup file to use is `Install-PrintDriver.ps1`.

## Edit the detection script
Edit the Detect-PrintDriver.ps1 file to include your driver name. This will be used to detect if the driver is installed or not.

## Uploading the intunewim
Now that you have the scripts and drivers all packaged with, you can now add this to the Intune admin center. Microsoft have a guide that details the process needed to add the intunewim [here](https://learn.microsoft.com/en-us/mem/intune/apps/apps-win32-add).

When adding your settings, use the following to help.
``` yaml
# App information
Name:               Print Driver - {{driver_name}}
Description:        Print Driver - {{driver_name}}
Publisher:          Dylan McCrimmon
Information URL:    https://github.com/dylanmccrimmon/IntunePrintDriver

# Program
Install command:    %windir%\system32\windowspowershell\v1.0\powershell.exe -ExecutionPolicy Bypass -file "Install-PrintDriver.ps1" -DriverName "{{driver_name}}" -INFFile "{{driver_inf_file}}"
Uninstall command:  %windir%\system32\windowspowershell\v1.0\powershell.exe -ExecutionPolicy Bypass -file "Uninstall-PrintDriver.ps1" -DriverName "{{driver_name}}"
Install behavior:   System

# Detection rules
Detection Script:   Upload the Detect-PrintDriver.ps1 file
```