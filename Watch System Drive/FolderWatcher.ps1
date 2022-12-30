#After some searching i found that this gives us the Downloads folder of the current user,
#Appears to be working as needed.
#$DownloadFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path

#The system drive is default ... this code fetches the drive letter the OS is installed on, so in most case this variable = C:\
$TargetFolder = (get-location).Drive.Name + ':\'
#Look for all files
$Filter = '*'
#Monitor changes in sub dirs ... Change to $false if you want to monitor a single directory.
$TraverseDirectory = $true

$AttributeFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite,[IO.NotifyFilters]::Size, [IO.NotifyFilters]::Security
#https://learn.microsoft.com/en-us/dotnet/api/system.io.watcherchangetypes?view=net-6.0
$ChangeTypes = [System.IO.WatcherChangeTypes]::All




function Invoke-DirectoryModified
{

  param
  (
    [Parameter(Mandatory)]
    [System.IO.WaitForChangedResult]
    $ChangeInformation
  )

  $var = $ChangeInformation | Select -ExpandProperty ChangeType
  
   switch ($var)
   {
        Deleted
        {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor Red
        }
        Created
        {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor DarkRed
        }
        Renamed
        {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor DarkYellow
        }
        Changed
        {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor Gray
        } 
   }

  #Write-Warning 'Modification Caught'
  #$ChangeInformation | Out-String | Write-Host -ForegroundColor Green
  #echo($ChangeInformation | Format-List | Out-String)
}




$result = $null

$watcher = New-Object -TypeName IO.FileSystemWatcher -ArgumentList $TargetFolder, $Filter -Property @{

    IncludeSubdirectories = $TraverseDirectory
    NotifyFilter = $AttributeFilter
}


try
{

    while($true)
    {
        $result = $watcher.WaitForChanged($ChangeTypes, 750)

        if($result.TimedOut)
        {                        
            continue
        }

        Invoke-DirectoryModified -Change $result
    }
}
finally
{
    $watcher.Dispose()
}