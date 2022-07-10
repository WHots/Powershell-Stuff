$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$CoolStuff = "\CoolStuff\"

# For building paths.
$slash = "\"
# Message for download errors.
$faileddownloadmsg = "[!] Failed Download..."
# Message for directory creating errors.
$faileddirectory = "[!] Failed Creating Directory..."




<#
.Description
    Handles verbose output of download responses.

.PARAMETER download
    Name of file being downloaded, so user can see which fill specifically is being referenced.

.PARAMETER status
    Status of the download, true or false. true = downloaded completed, false = download failed.
#>
function Post-DownloadResult([String] $download, [Boolean] $status)
{
    if(!$status)
    {
        Write-Host "[!] Failed downloading $($download) ..."
    }
    Else
    {
        Write-Host "[*] Downloaded $($download) ..."
    }
}


<#
.Description
    Builds directory tree.
#>
function Build-Structure
{
    # Directory names.
    $subdirs = @(
        "Autoruns",
        "ProcessExplorer",
        "Greenshot",
        "Revo"
    )
    
    $dir = New-Item -Path $DesktopPath -Name "CoolStuff" -ItemType "directory"

    If($dir)
    {
        Foreach($item in $subdirs)
        {
            New-Item -Path $dir -Name $item -ItemType "directory"
        }       
    }
    Else
    {
        Write-Host $faileddirectory
        return $false
    }

    return $true
}


<#
.Description
    Downloads Sysinternals tools to dedicated directory.
    Does NOT install full suite, just ones I personally like to use.

.NOTES
    - Downloaded files: ProcessExplorer & Autoruns.
    - Might fetch files from a JSON file instead of (now) hardcoded variables.
#>
function Get-WinternalsSuite
{
    $ProcessExplorer = "ProcessExplorer.zip"
    $Autoruns = "Autoruns.zip"

    $pexplorer_download_path = $DesktopPath+$CoolStuff+$ProcessExplorer.Split(".")[0]+$slash+$ProcessExplorer
    $autoruns_download_path = $DesktopPath+$CoolStuff+$Autoruns.Split(".")[0]+$slash+$AutoRuns

    $files = @{
        
        "https://download.sysinternals.com/files/ProcessExplorer.zip" = $pexplorer_download_path;
        "https://download.sysinternals.com/files/Autoruns.zip" = $autoruns_download_path
    }

    # Getting lazy here also.
    $files.GetEnumerator().ForEach({

        $download = Invoke-WebRequest -Uri ($_.Key) -OutFile ($_.Value)

        if(!$download)
        {
            Post-DownloadResult -download $_.Key -status $true
            #Write-Host "[*] $($_.Key)"
        }
        else
        {
            Post-DownloadResult -download $_.Key -status $false
        }
    })  
}


<#
.Description
    Downloads Greenshot snipping tool.
#>
function Get-Greenshot
{
    $greenshot = "https://github.com/greenshot/greenshot/releases/download/Greenshot-RELEASE-1.2.10.6/Greenshot-INSTALLER-1.2.10.6-RELEASE.exe"
    $Greenshot_exe = "Greenshot-INSTALLER-1.2.10.6-RELEASE.exe"
    $download = $DesktopPath+$CoolStuff+"Greenshot"+$slash+$Greenshot_exe

    $result = Invoke-WebRequest -Uri $greenshot -OutFile $download

    If(!$result)
    {
        Post-DownloadResult -download $Greenshot_exe -status $true
    }
    Else
    {
        Post-DownloadResult -download $Greenshot_exe -status $false
    }
}


<#
.Description
    Downloads Revo Uninstaller Portable.
#>
function Get-Revo
{
    $revo = "https://download.revouninstaller.com/download/RevoUninstaller_Portable.zip"
    $Revo_exe = "RevoUninstaller_Portable.zip"
    $download = $DesktopPath+$CoolStuff+"Revo"+$slash+$Revo_exe

    $result = Invoke-WebRequest -Uri $revo -OutFile $download

    If(!$result)
    {
        Post-DownloadResult -download $Revo_exe -status $true
    }
    Else
    {
        Post-DownloadResult -download $Revo_exe -status $false
    }
}


# I'm lazy
if(Build-Structure)
{
    Get-WinternalsSuite
    Get-Greenshot
    Get-Revo
}



