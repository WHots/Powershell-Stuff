# Windows admin SID: https://docs.microsoft.com/en-us/windows/security/identity-protection/access-control/security-identifiers
$admin_sid = "S-1-5-32-544"
# Message for Tech.
$message = "This script is intended for experienced Techs only`r`n`r`nDo you consent to take responsibility for any damages or loss of data as an effect of running this script?"
# Message for Tech /and/or User
$message_notadmin = "You must be an Administrator to run this script!"
# The adapter the user will pick to disable IPv6 for.
$adapter = $null
# Barrier to help display the current adapter.
$barrier = "-"*14




function Is-Admin
{
    $var -ne (whoami /groups /fo csv | ConvertFrom-Csv | Where-Object { $_.SID -eq $admin_sid })
    return $var
    #    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    #    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}


<#
.Description
    Prompts user for software usage Acknowledgment.
#>
function Prompt-Acknowledgment
{
    $msbbox =  [System.Windows.MessageBox]::Show($message, 'Acknowledgement', 'YesNo','Information')

    switch($msbbox)
    {
        'No'{Exit}
    }
}


<#
.Description
    Prompts user that this script needs to be used by an Administrator.
#>
function Prompt-NotAdmin
{
    $msbbox =  [System.Windows.MessageBox]::Show($message, 'AccessDenied', 'Ok','Error')
    Exit  
}


<#
.Description
    Displays the current connect adapter name.
#>
function Get-CurrentAdapter
{   
    
    Write-Host $barrier -ForegroundColor Green
    get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" | ForEach-Object {$_.netconnectionid;}
    Write-Host "Current/Connected" -ForegroundColor Gray
    Write-Host $barrier -ForegroundColor Green
}


<#
.Description
    Attempts to disable IPv6 on specified adapter, returns the result.
.PARAMETER $name
    Name of adapter.
#>
function Disable-Adapter([string] $name)
{
    $result = Disable-NetAdapterBinding -Name $name -ComponentID ms_tcpip6
    return $result
}




if(Is-Admin)
{   
    Prompt-Acknowledgment

    # lazy
    Get-CurrentAdapter
    Get-NetAdapterBinding -ComponentID ms_tcpip6 | ForEach-Object {$_.Name; if($_.Enabled){Write-Host "On" -ForegroundColor DarkGreen}else{Write-Host "Off" -ForegroundColor Red}}      

    $adapter = Read-Host "`r`nEnter adapter name to disable Ipv6 for"

    if(Disable-Adapter($adapter))
    {
        Write-Host "`r`nSomething went wrong!"
        Read-Host
    }
    else
    {
        Write-Host "Successfully disabled Ipv6."
        Read-Host
    }
}
else
{
    Prompt-NotAdmin
}
