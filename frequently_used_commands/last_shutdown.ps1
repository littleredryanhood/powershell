Get-EventLog -LogName System | Where-Object { $_.EventID -eq 1074 -or $_.EventID -eq 6008 } | Sort-Object Time -Descending | Select-Object -First 1 | Format-List *
