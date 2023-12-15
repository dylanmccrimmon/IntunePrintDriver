# IntunePrinterDriver
![GitHub License](https://img.shields.io/github/license/dyanmccrimmon/IntunePrinterDriver)


## Overview
A simple PowerShell script that installs a print driver to a device and add the driver to the print management console.

Once the print driver is installed on the device, it relatively easier to deploy shared printers to devices/users with scripts or with 3rd party applications such as [Papercut Print Deploy](https://www.papercut.com/products/do-more/print-deploy/). It also helps remove the headache from the [PrintNightmare](https://en.wikipedia.org/wiki/PrintNightmare) issue while helping the device secure.

## Documentation & Getting Started
A getting started guide can be found [here](/Docs/Getting%20Started.md).

## Troubleshooting
Both the install and uninstall scripts export a transcript while running. These logs can usually be found in the temp location and are named `IntunePrintDriver.log`.

## Support
Need support or found a bug? No problem, just [raise an issue](https://github.com/dylanmccrimmon/IntunePrinterDriver/issues). When creating a support issue, please add as much information as possible (code snippets, error messages, etc).

## License
This project is licensed under the Apache License 2.0. For more information on the Apache License 2.0, please read the [LICENSE](LICENSE) file.