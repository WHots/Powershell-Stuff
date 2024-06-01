$TargetFolder = (Get-Location).Drive.Name + ':\'
$Filter = '*'
$TraverseDirectory = $true
$AttributeFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite, [IO.NotifyFilters]::Size, [IO.NotifyFilters]::Security
$ChangeTypes = [System.IO.WatcherChangeTypes]::All




function Invoke-DirectoryModified {
    param (
        [Parameter(Mandatory)]
        [System.IO.WaitForChangedResult] $ChangeInformation
    )

    $changeType = $ChangeInformation.ChangeType

    switch ($changeType) {
        'Deleted' {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor Red
        }
        'Created' {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor DarkRed
        }
        'Renamed' {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor DarkYellow
        }
        'Changed' {
            $ChangeInformation | Out-String | Write-Host -ForegroundColor Gray
        }
    }
}

$watcher = New-Object -TypeName IO.FileSystemWatcher -ArgumentList $TargetFolder, $Filter -Property @{
    IncludeSubdirectories = $TraverseDirectory
    NotifyFilter = $AttributeFilter
}

try {
    while ($true) {
        $result = $watcher.WaitForChanged($ChangeTypes, 750)

        if ($result.TimedOut) {
            continue
        }

        Invoke-DirectoryModified -ChangeInformation $result
    }
}
finally {
    $watcher.Dispose()
}
