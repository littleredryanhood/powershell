function WinDU {
    param(
        [string]$Path = ".",
        [int]$Depth = 1
    )

    # Function to get directory size
    function Get-DirectorySize {
        param(
            [string]$Path
        )
        
        $size = (Get-ChildItem -Recurse -File -Path $Path | Measure-Object -Property Length -Sum).Sum
        return $size
    }

    # Initial call to get the size of the root path
    $rootSize = Get-DirectorySize -Path $Path
    [PSCustomObject]@{
        "Name"  = (Get-Item -Path $Path).Name
        "Size"  = [Math]::Round(($rootSize / 1GB), 2)
        "Depth" = 0
    } | Format-Table -AutoSize

    # Recursive call to get sizes of sub-directories up to the specified depth
    Get-ChildItem -Directory -Path $Path | ForEach-Object {
        if ($_.FullName.Count -lt ($Path.Count + $Depth)) {
            $dirSize = Get-DirectorySize -Path $_.FullName
            [PSCustomObject]@{
                "Name"  = $_.Name
                "Size"  = [Math]::Round(($dirSize / 1GB), 2)
                "Depth" = $_.FullName.Count - $Path.Count
            } | Format-Table -AutoSize
        }
    }
}

# You can now call WinDU from the PowerShell prompt like this:
# WinDU -Path "C:\Path\To\Directory" -Depth 1
