# monitorsysdrv.ps1

monitorsysdrv.ps1 is a PowerShell script designed to monitor and handle changes in the file system of the specified target folder. It identifies and logs changes such as file creation, deletion, modification, and renaming.

## Features

- Monitors the specified target folder and its subdirectories for changes.
- Logs changes to the console with color-coded messages for different types of changes:
  - **Red:** File/Folder Deleted
  - **DarkRed:** File/Folder Created
  - **DarkYellow:** File/Folder Renamed
  - **Gray:** File/Folder Modified

## Usage

1. **Download the Script:**
   Save the script as `monitorsysdrv.ps1`  or whatever you'd like the name to be.

2. **Run the Script:**
   - Right-click on the script file and select "Run with PowerShell".
   - Alternatively, open PowerShell, navigate to the directory containing the script, and execute the script by typing:
     ```powershell
     .\monitorsysdrv.ps1
     ```

## Requirements

- Windows operating system.
- PowerShell.

## Example

The script will monitor the root of the system drive (e.g., `C:\`) and log changes in real-time. You can modify the `$TargetFolder` variable to monitor a different folder.

## Author

- WHots


---


# cleandesktop.ps1

cleandesktop.ps1 is a PowerShell script designed to organize your Windows desktop by sorting files and folders into categorized subfolders within a newly created folder. This helps keep your desktop tidy and clutter-free.

## Features

- Creates a new folder with a randomized name on your desktop.
- Organizes files into subfolders based on their type:
  - Shortcuts/Links
  - Executables
  - Text Files
  - Images
- Moves folders into a dedicated subfolder.
- Places files that do not match predefined types into an "Others" folder.

## Usage

1. **Download the Script:**
   Save the script as `cleandesktop.ps1`.

2. **Run the Script:**
   - Right-click on the script file and select "Run with PowerShell".
   - Alternatively, open PowerShell, navigate to the directory containing the script, and execute the script by typing:
     ```powershell
     .\cleandesktop.ps1
     ```

## Requirements

- Windows operating system.
- PowerShell.

## Example

After running the script, a new folder with a name like `Desktop_Organized_1234` will be created on your desktop. Inside this folder, you will find the following subfolders:

- `Shortcuts_Links`
- `Executables`
- `Text_Files`
- `Images`
- `Folders`
- `Others`

Each item from your desktop will be moved to the appropriate subfolder based on its type.

## Author

- WHots

---

# windowstoscreen

`windowstoscreen.ps1` is a PowerShell script designed to reposition all active application windows to the lower right-hand side of the primary display on a Windows system.

## Features

- Uses the Windows API to reposition windows.
- Targets all active windows with a visible title.
- Moves windows to a calculated position on the lower right-hand side of the primary screen.

## Usage

1. **Download the Script:**
   Save the script as `windowstoscreen.ps1`.

2. **Run the Script:**
   - Right-click on the script file and select "Run with PowerShell".
   - Alternatively, open PowerShell, navigate to the directory containing the script, and execute the script by typing:
     ```powershell
     .\windowstoscreen.ps1
     ```

### Requirements

- Windows operating system.
- PowerShell.
- Requires `user32.dll` to access the `SetWindowPos` function.

## How It Works

1. The script defines a .NET type to access the `SetWindowPos` function from the `user32.dll` library.
2. It retrieves the primary screen's working area using the `System.Windows.Forms.Screen` class.
3. It calculates the position to place the windows on the lower right-hand side of the primary display.
4. It iterates through all processes with a main window handle and visible title, repositioning each window to the calculated coordinates.

## Example

After running the script, all active windows with a visible title will be moved to the lower right-hand side of your primary screen with a size of 565x500 pixels.

### Author

- WHots



