# https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowpos
Add-Type -Name NativeMethods -Namespace Win32 -MemberDefinition @"
[DllImport("user32.dll")]
public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x, int y, int cx, int cy, uint uFlags);
"@
Add-Type -AssemblyName System.Windows.Forms


$maindisplay = [System.Windows.Forms.Screen]::PrimaryScreen

# Calculation to place windows in the lower right-hand side of the primary display.
$centerX = $maindisplay.WorkingArea.Left + $maindisplay.WorkingArea.Width / 1.5
$centerY = $maindisplay.WorkingArea.Top + $maindisplay.WorkingArea.Height / 2

# Get list of processes > filter it to processes that have a window title ...
Get-Process | Where-Object { $_.MainWindowHandle -and $_.MainWindowTitle } | ForEach-Object {
    $handle = $_.MainWindowHandle
    [Win32.NativeMethods]::SetWindowPos($handle, [IntPtr]::Zero, $centerX, $centerY, 565, 500, 0x0010)
}
