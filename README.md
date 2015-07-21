# Copy-AntiVirusPattern.ps1
Copy AV pattern files from a single source location to different Exchange 2010/2013 servers and restart the required AV service.

##Description
Copy Trend Micro pattern files to multiple Exchange Servers and restart SMEX master Service 

##Inputs
RestartService
Restart the AV service on the target server after copying pattern files

##Outputs
None

##Examples
```
.\Copy-AntiVirusPattern -RestartService
```
Copy pattern files to Exchange 2013 servers and restart service

```
.\Copy-AntiVirusPattern -RestartService -IncludeExchange2010
```
Copy pattern files to Exchange 2010 and 2013 servers and restart service

##TechNet Gallery
Find the script at TechNet Gallery
* https://gallery.technet.microsoft.com/Copy-anti-virus-pattern-to-f05a9af2

##Credits
Written by: Thomas Stensitzki

Find me on:

* My Blog:	http://www.sf-tools.net/
* Twitter:	https://twitter.com/apoc70
* LinkedIn:	http://de.linkedin.com/in/thomasstensitzki
* Github:	https://github.com/Apoc70

For more Office 365, Cloud Security and Exchange Server stuff checkout services provided by Granikos

* Blog:     http://blog.granikos.eu/
* Website:	https://www.granikos.eu/en/
* Twitter:	https://twitter.com/granikos_de
