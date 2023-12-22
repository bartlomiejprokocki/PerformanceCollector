<#
Installer for Performance Collector 
author: Bartlomiej Prokocki
contact: bartlomiej.prokocki@gmail.com

https://github.com/bartlomiejprokocki
#>
cls
Write-Host "START [ OK ]`n" -ForegroundColor DarkYellow
#directory
$directory_perf_coll = "C:\Scripts\Perf_Coll"
$check_directory_perf_coll=Test-Path $directory_perf_coll

    If ($check_directory_perf_coll -match "False")
    {
    Write-Host "Folder $directory_perf_coll does not exist creating new folder" -ForegroundColor DarkYellow
    New-Item -Path "C:\Scripts\Perf_Coll\" -ItemType Directory -Verbose
    Write-Host "Folder $directory_perf_coll was created [ OK ]`n" -ForegroundColor DarkYellow
    }
    Else
    {
    Write-Host "Folder $directory_perf_coll exist. [ OK ]`n" -ForegroundColor DarkYellow
    }
#files
$current_path=Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$files_to_copy=Get-ChildItem -Path $current_path
$destination_to_copy="C:\Scripts\Perf_Coll"
foreach ($file in $files_to_copy)
{
$f_FullName = $file.FullName
$f_Name = $file.Name
$file_perf_coll = $f_FullName
$check_file_perf_coll=Test-Path "C:\Scripts\Perf_Coll\$f_Name"
    If ($check_file_perf_coll -match "False")
    {
    Write-Host "$f_Name does not exist copying file" -ForegroundColor DarkYellow
    Copy-Item $f_FullName -Destination $destination_to_copy -Verbose
    Write-Host "File $f_Name was copied.  [ OK ]`n" -ForegroundColor DarkYellow
    }
    Else
    {
    Write-Host "File $f_Name exist in $f_FullName  [ OK ]`n" -ForegroundColor DarkYellow
    }


}
#csv_memory
$directory_csv_cpu="C:\Scripts\Perf_Coll\csv\cpu"
$check_directory_csv_cpu=Test-Path $directory_csv_cpu
    If ($check_directory_csv_cpu -match "False")
    {
    Write-Host "Folder $directory_csv_cpu file does not exist creating new folder" -ForegroundColor DarkYellow
    New-Item -Path "C:\Scripts\Perf_Coll\csv\cpu" -ItemType Directory -Verbose
    Write-Host "Folder $directory_csv_cpu was created [ OK ]`n" -ForegroundColor DarkYellow
    }
    Else
    {
    Write-Host "Folder $directory_csv_cpu exist. [ OK ]`n" -ForegroundColor DarkYellow
    }
#csv memory
$directory_csv_memory="C:\Scripts\Perf_Coll\csv\memory"
$check_directory_csv_memory=Test-Path $directory_csv_memory
    If ($check_directory_csv_memory -match "False")
    {
    Write-Host "Folder $directory_csv_memory file does not exist creating new folder" -ForegroundColor DarkYellow
    New-Item -Path "C:\Scripts\Perf_Coll\csv\memory" -ItemType Directory -Verbose
    Write-Host "Folder $directory_csv_memory was created [ OK ]`n" -ForegroundColor DarkYellow
    }
    Else
    {
    Write-Host "Folder $directory_csv_memory exist. [ OK ]`n" -ForegroundColor DarkYellow
    }

sl "C:\Scripts\Perf_Coll"
.\Perf_Coll_TS.ps1
Write-Host "Finish [ OK ]" -ForegroundColor DarkYellow
