<#
Task Scheduler for Performance Collector
author: Bartlomiej Prokocki
contact: bartlomiej.prokocki@gmail.com

https://github.com/bartlomiejprokocki
#>
$task_name = "_Perf_Coll"
$check_task = Get-ScheduledTask -TaskName $task_name -ErrorAction SilentlyContinue
if($check_task)
    {
    Write-Host "Task Scheduler $TaskName exist [ OK ]`n" -ForegroundColor DarkYellow
    }
else
    {
    Write-Host "Task Scheduler $task_name does not exist. Creating new task" -ForegroundColor  DarkYellow
    $trigger = New-ScheduledTaskTrigger -Daily -At "0:00 AM"
    $action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "C:\Scripts\Perf_Coll\Perf_Coll.ps1"
    $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
    Register-ScheduledTask -Action $action -TaskName $task_name -Trigger $trigger -Principal $principal
    $job=Get-ScheduledTask -TaskName $task_name
    $job.Triggers.Repetition.Duration = "P1D"
    $job.Triggers.Repetition.Interval = "PT1H"
    $job | Set-ScheduledTask -User "NT AUTHORITY\SYSTEM"
    Write-Host "Task Scheduler was created [ OK ]`n" -ForegroundColor DarkYellow
    }
