Usage:
In server where you want use Performance Collector you should create folder Scripts in C:\ and copy files Perf_Coll.ps1 and TS_Peft_Coll.ps1.

Fist run script TS_Perf_Coll.ps1 this script will create Task in Task Scheduler Job. Job name is _Perf_Coll.
Job wil start script Perf_Coll.ps1 every hour and export data to csv files.
