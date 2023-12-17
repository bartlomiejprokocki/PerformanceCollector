<#
Task Scheduler for Performance Collector
author: Bartlomiej Prokocki
contact: bartlomiej.prokocki@gmail.com
#>
$Trigger = New-ScheduledTaskTrigger -Daily -At "0:00 AM"
$Action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "C:\Scripts\Perf_Coll.ps1"
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -Action $Action -TaskName "_Perf_Coll" -Trigger $Trigger -Principal $Principal
$job=Get-ScheduledTask -TaskName "_Perf_Coll"
$job.Triggers.Repetition.Duration = "P1D"
$job.Triggers.Repetition.Interval = "PT1H"
$job | Set-ScheduledTask -User "NT AUTHORITY\SYSTEM"
