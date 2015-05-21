<#
    .SYNOPSIS
    Copy Trend Micro pattern files to multiple Exchange Servers and restart SMEX master Service 
   
   	Copyright (c) Thomas Stensitzki
	
	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
	Version 1.0, 2015-05-19

    Ideas, comments and suggestions to support@granikos.eu 
 
    .LINK  
    More information can be found at http://www.granikos.eu/en/scripts 
	
    .DESCRIPTION
	
    This script copies pattern files from a given source location to dedicated Exchange Server file 
    locations. The target file locations must be the same across all servers. The list of Exchange 
    Servers is created using the Get-ExchangeServer cmdlet.

    .NOTES 
    Requirements 
    - Windows Server 2012 or Windows Server 2012 R2  

    Revision History 
    -------------------------------------------------------------------------------- 
    1.0     Initial community release 
	
	.PARAMETER RestartService
    Restart the AV service on the target server after copying pattern files

	.EXAMPLE
    Copy pattern files to Exchange 2013 servers and restart service
    .\Copy-AntiVirusPattern -RestartService

    .EXAMPLE
    Copy pattern files to Exchange 2010 and 2013 servers and restart service
    .\Copy-AntiVirusPattern -RestartService -IncludeExchange2010

    #>

Param(
    [parameter(Mandatory=$false,ValueFromPipeline=$false,HelpMessage='Restart AV service at target server')][switch]$RestartService,  
    [parameter(Mandatory=$false,ValueFromPipeline=$false,HelpMessage='Use automatic folder detection for Exchange and IIS log paths')][switch]$IncludeExchange2010
)

Set-StrictMode -Version Latest

$SourcePath = "D:\TrendMicroActiveUpdate\pattern\*.*"
$TargetDrive = "d$"
$TargetPathLatest = "\Program Files\Trend Micro\Smex\engine\vsapi\latest\pattern"
$TargetPathPrimary = "\Program Files\Trend Micro\Smex\engine\vsapi\primary\pattern"
$ServiceName = "ScanMail_Master"

function Copy-Files {

    $TargetFolders = @("\\" + $Server + "\" + $TargetDrive + $TargetPathLatest)
    $TargetFolders += "\\" + $Server + "\" + $TargetDrive + $TargetPathPrimary
    
    foreach($TargetServerFolder in $TargetFolders) {

        Write-Verbose "Testing target $($TargetServerFolder)"

        if(Test-Path $TargetServerFolder) {

            $Files = Get-ChildItem -Path $TargetServerFolder
            $c = ($Files | Measure-Object).Count

            Write-Verbose "$($c) files will be deleted!"

            foreach ($File in $Files) {
                Remove-Item $File.FullName -ErrorAction SilentlyContinue -Force | out-null
            }
    
            Write-Verbose "Copying files to $($TargetServerFolder)"

            Copy-Item -Path $SourcePath -Destination $TargetServerFolder -Force
        }
    }
}

function Restart-RemoteService {
    try {
        # try to restart the AV service on target server
        Get-Service -Name $ServiceName -ComputerName $Server | Restart-Service
    }
    catch {
        Write-Error "Error restarting $($ServiceName) on server $($Server)"
    }
}

if($IncludeExchange2010) {
    # select Exchange 2010 and 2013 servers 
    $Servers = Get-ExchangeServer | Where {$_.IsE14OrLater -eq $true} | Sort-Object Name

}
else {
    # select Exchange 2013 servers only
    $Servers = Get-ExchangeServer | Where {$_.IsE15OrLater -eq $true} | Sort-Object Name
}



foreach ($Server in $Servers) {
    Write-Output "Updating Server $($Server)"

    Copy-Files

    if($RestartService) {
        Restart-RemoteService
    } 
    else {
        Write-Output "Not restarting any remote service on server $($Server)"
    }
}