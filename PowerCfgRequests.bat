@echo off
rem script to run to verify that TV service and the backup is not running
rem if they're not then it will reboot the PC
rem this is only to be used late at night when the PC should actually be asleep
rem if reboot store powercfg -request to text file
set found=0
set OutputText=
set outputFile="%TMP%\PowerCfgRequestsOutput.txt"
set WriteMsg="C:\Users\skp12\Documents\batch jobs\bin\EvtLogWriteMsg.exe"
set Source=CheckReboot

setlocal EnableDelayedExpansion
rem Get Output Text
set LF=---
FOR /F "delims=" %%a in ('powercfg -requests') do (
 if "!OutputText!"=="" (
	set  OutputText=%%a
  ) else (
	set  OutputText=!OutputText!%LF%%%a
 )
)


REM is the TV service running
FOR /F "delims=" %%a in ('powercfg -requests ^| find "TVService"') do (
  set found=1
)

REM is the backup running
FOR /F "delims=" %%a in ('powercfg requests ^| find "Macrium"') do (
  set found=1
)
IF %found% EQU 1 (
   echo "Backup or TVService is running" 
   %WriteMsg% -s %Source% -m "Backup or TVService is running.%LF%%OutputText%" -nl "%LF%"
) ELSE (
   %WriteMsg% -s %Source% -m "Making system reboot beacause Backup or TVService is not running.%LF%%OutputText%" -nl "%LF%"
   echo "NO TV Service output stored in %outputFile%"
   shutdown /r /f /t 30
) 