<#
Performance Collector
author: Bartlomiej Prokocki
contact: bartlomiej.prokocki@gmail.com
#>
cls
$MemoryTable=@()
$CPUTable=@()

$actual_date= Get-Date -Format "yyyyMMdd"
$actual_time=Get-Date -Format "HH:mm"

$host_name = Hostname
$file_name_memory = "$host_name-memory-$actual_date"
$file_name_cpu = "$host_name-cpu-$actual_date"

Write-Host "Actual Time: $actual_time" -ForegroundColor Cyan
Write-Host "Server name: $host_name"
Write-Host ""
$job_memory = Start-Job -ScriptBlock {
    $actual_date= Get-Date -Format "yyyyMMdd"
    $actual_time=Get-Date -Format "HH:mm"
    $host_name = Hostname
    $file_name_memory = "$host_name-memory-$actual_date"
    Write-Host "Memory..." -ForegroundColor DarkCyan
    #$memoryTotalGB=((Get-WmiObject -Class WIN32_OperatingSystem | select TotalVisibleMemorySize -ExpandProperty TotalVisibleMemorySize)/1MB)
    $memoryTotalGB=((Get-WmiObject -Class WIN32_OperatingSystem | select TotalVisibleMemorySize -ExpandProperty TotalVisibleMemorySize)/1MB)
    $memoryTotalGB_short="{0:N2}" -f ($memoryTotalGB)
    $memoryTotalGB_dot=$memoryTotalGB_short.Replace(",",".")
    Write-Host "Total Memory: $memoryTotalGB_dot GB"

    #$memoryAvailableGB=((Get-Counter '\Memory\available mbytes' | Select-Object -ExpandProperty countersamples | select CookedValue -ExpandProperty CookedValue| Measure-Object -Average | select Average -ExpandProperty Average)/1024)
    $memoryAvailableGB=((Get-Counter '\Memory\available mbytes' -SampleInterval 590 -MaxSamples 6 | Select-Object -ExpandProperty countersamples | select CookedValue -ExpandProperty CookedValue| Measure-Object -Average | select Average -ExpandProperty Average)/1024)
    $memoryAvailableGB_short="{0:N2}" -f ($memoryAvailableGB)
    $memoryAvailableGB_dot=$memoryAvailableGB_short.Replace(",",".")
    Write-Host "Available Memory: $memoryAvailableGB_dot GB"

    $memoryUsedGB=$memoryTotalGB-$memoryAvailableGB
    $memoryUsedGB_short="{0:N2}" -f ($memoryUsedGB)
    $memoryUsedGB_dot=$memoryUsedGB_short.Replace(",",".")
    #$memoryUsedGB_dot=$memoryUsedGB.Replace(",",".")
    Write-Host "Used Memory: $memoryUsedGB_dot GB"
    Write-Host ""

    $memory = New-Object psObject -Property @{
                                                'Date' = $actual_date
                                                'Time' = $actual_time
                                                'TotalMemoryGB' = $memoryTotalGB_dot
                                                'AvailableMemoryGB' = $memoryAvailableGB_dot
                                                'MemoryUsageGB' = $memoryUsedGB_dot                                                                                 
                                             }
            $MemoryTable += $memory


    $CheckFile=Test-Path "C:\Scripts\$file_name_memory.csv"

    If ($CheckFile -match "False")
    {
    Write-Host "Memory file does not exist creating new file" -ForegroundColor Yellow
    $MemoryTable | Export-Csv "C:\Scripts\$file_name_memory.csv"
    }
    Else
    {
    Write-Host "Memory file exist. Appending" -ForegroundColor Yellow
    $MemoryTable | Export-Csv "C:\Scripts\$file_name_memory.csv" -Append
    }
    Write-Host ""
}
$job_cpu = Start-Job -ScriptBlock {
    $actual_date= Get-Date -Format "yyyyMMdd"
    $actual_time=Get-Date -Format "HH:mm"
    $host_name = Hostname
    $file_name_cpu = "$host_name-cpu-$actual_date"
    Write-Host "CPU..." -ForegroundColor DarkCyan
    $cpuUsed=Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 590 -MaxSamples 6 | Select-Object -ExpandProperty countersamples | Select-Object  -ExpandProperty CookedValue | Measure-Object -Average | select Average -ExpandProperty Average
    $cpuUsed_short="{0:N2}" -f ($cpuUsed)
    $cpuUsed_dot=$cpuUsed_short.Replace(",",".")
    Write-Host "CPU Usage: $cpuUsed_dot"

    $cpu = New-Object psObject -Property @{
                                                'Date' = $actual_date
                                                'Time' = $actual_time
                                                'CpuPercent' = $cpuUsed_dot                                                                               
                                             }
            $CPUTable += $cpu


    $CheckFile=Test-Path "C:\Scripts\$file_name_cpu.csv"

    If ($CheckFile -match "False")
    {
    Write-Host "Memory file does not exist creating new file" -ForegroundColor Yellow
    $CPUTable | Export-Csv "C:\Scripts\$file_name_cpu.csv"
    }
    Else
    {
    Write-Host "Memory file exist. Appending" -ForegroundColor Yellow
    $CPUTable | Export-Csv "C:\Scripts\$file_name_cpu.csv" -Append
    }
    Write-Host ""
}
Get-Job | Wait-Job
Receive-Job $job_memory
Receive-Job $job_cpu
Remove-Job $job_memory.id
Remove-Job $job_cpu.id