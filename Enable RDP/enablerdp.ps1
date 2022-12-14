$admin_sid = "S-1-5-32-544"



#Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
#Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

#$var = Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1


function Is-Admin
{
    $var -ne (whoami /groups /fo csv | ConvertFrom-Csv | Where-Object { $_.SID -eq $admin_sid })
    return $var
}


function Post-Configs
{

    # Int32
    $var = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" | select -ExpandProperty UserAuthentication
    # Int32
    $var1 = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" | select -ExpandProperty fDenyTSConnections

    switch($var)
    {
        0 {"RDP-TCP" | Out-String | Write-Host -ForegroundColor Red}
        1 {"RDP-TCP" | Out-String | Write-Host -ForegroundColor Green}
    }
    switch($var1)
    {
        0 {"fDenyTSConnections" | Out-String | Write-Host -ForegroundColor Green}
        1 {"fDenyTSConnections" | Out-String | Write-Host -ForegroundColor Red}
    }
}




if(Is-Admin)
{
    "Current settings" | Out-String | Write-Host -ForegroundColor DarkGray
    Post-Configs
    "Making changes..." | Out-String | Write-Host -ForegroundColor DarkGray
}