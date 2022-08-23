$admin_sid = "S-1-5-32-544"




function Is-Admin
{
    $var -ne (whoami /groups /fo csv | ConvertFrom-Csv | Where-Object { $_.SID -eq $admin_sid })
    return $var
}


if(Is-Admin)
{
    Import-Certificate -FilePath .\cert.crt -CertStoreLocation Cert:\LocalMachine\Root
}
else
{
    Write-Host "Not in admin!"
    read-host
    Exit -1
}