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
    Builds "CoolStuff" Folder on Desktop.
#>
function Build-Structure
{    
    $dir = New-Item -Path $DesktopPath -Name "CoolStuff" -ItemType "directory"

    If($dir)
    {
        Write-Host "----Directory CoolStuff created at Desktop----" 
        return $true
    }
    Else
    {
        Write-Host $faileddirectory
        return $false
    }   
}


<#
.Description
    Starting point of entire script, starts the domino effect.
#>
function Get-Files
{
    foreach($input in Get-Content .\files.txt) 
    {       
        if($input -like "*|*")
        {        
            Write-Host "[*] Working on $($input.split("|")[2]) ..."
            $homemade = Make-Directory -softname $input.split("|")[2]

            if($homemade)
            {
                Download-Files -url $input.split("|")[0] -softname $input.split("|")[2] -hardname $input.split("|")[1]
            }
        }
    }
}


<#
.Description
    Builds folders for each download "CoolStuf\{$softname}".

.PARAMETER $softname
    Internal / Friendly name / Nickname of the file. Example: instead of MyProgram.exe .. It's MyProgram.
#>
function Make-Directory([string] $softname)
{
    $dir = New-Item -Path $DesktopPath$CoolStuff -Name $softname -ItemType "directory"

    if($dir)
    {        
        Write-Host "    Working on $($softname) Folder"
        return $true
    }
    else
    {
        Write-Host "    Failed making $($softname) Folder"
    }

    return $false
}


<#
.Description
    Handles Download process of each file.

.PARAMETER $url
    Download Uri for file.

.PARAMETER $softname
    Internal / Friendly name / Nickname of the file. Example: instead of MyProgram.exe .. It's MyProgram.

.PARAMETER $hardname
    Download file name + Extention, opposite of $softname...Literal file name.
#>
function Download-Files([string] $url, [string] $softname, [string] $hardname)
{
    $path = $DesktopPath+$CoolStuff+$softname+$slash+$hardname

    $download = Invoke-WebRequest -Uri $url -OutFile $path

    if(!$download)
    {
        Post-DownloadResult -download $hardname -status $true
    }
    else
    {
        Post-DownloadResult -download $hardname -status $false
    }
}


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
        Write-Host "    Failed downloading $($download)"
    }
    Else
    {
        Write-Host "    Downloaded $($download)"
    }
}




# I'm lazy
if(Build-Structure)
{
    Get-Files
}