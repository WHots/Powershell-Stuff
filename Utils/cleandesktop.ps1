$randomFolderName = "Desktop_Organized_" + (Get-Random -Maximum 10000)
$mainFolderPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), $randomFolderName)

New-Item -ItemType Directory -Path $mainFolderPath

$subFolders = @{
    "Shortcuts_Links" = @("lnk", "url")
    "Executables"     = @("exe", "dll", "lib", "jar")
    "Text_Files"      = @("txt", "doc", "docx", "pdf")
    "Images"          = @("jpg", "jpeg", "png", "gif", "bmp", "tif", "tiff")
    "Folders"         = @()
}


foreach ($folder in $subFolders.Keys) {
    New-Item -ItemType Directory -Path ([System.IO.Path]::Combine($mainFolderPath, $folder))
}


$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$items = Get-ChildItem -Path $desktopPath


function Move-ItemToSubfolder {
    param (
        [string]$itemPath,
        [string]$destinationFolder
    )
    $itemName = [System.IO.Path]::GetFileName($itemPath)
    $destinationPath = [System.IO.Path]::Combine($destinationFolder, $itemName)
    Move-Item -Path $itemPath -Destination $destinationPath
}


foreach ($item in $items) {

    if ($item.PSIsContainer) {

        Move-ItemToSubfolder -itemPath $item.FullName -destinationFolder ([System.IO.Path]::Combine($mainFolderPath, "Folders"))
    } else {

        $fileExtension = $item.Extension.ToLower().TrimStart('.')
        $moved = $false

        foreach ($folder in $subFolders.Keys) {
            if ($subFolders[$folder] -contains $fileExtension) {
                Move-ItemToSubfolder -itemPath $item.FullName -destinationFolder ([System.IO.Path]::Combine($mainFolderPath, $folder))
                $moved = $true
                break
            }
        }


        if (-not $moved) {
            $othersFolderPath = [System.IO.Path]::Combine($mainFolderPath, "Others")
            if (-not (Test-Path -Path $othersFolderPath)) {
                New-Item -ItemType Directory -Path $othersFolderPath
            }
            Move-ItemToSubfolder -itemPath $item.FullName -destinationFolder $othersFolderPath
        }
    }
}

Write-Host "Desktop files and folders have been organized into: $mainFolderPath"
