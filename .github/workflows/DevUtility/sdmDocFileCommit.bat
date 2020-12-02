@echo off
set filePath= %1
set workspacePath= %2
set filePath=%filePath:.mdl=-A.html%
echo %filePath%

Rem remove double quotes using replacing 
set filePath=%filePath:"=%   
setlocal ENABLEDELAYEDEXPANSION
set ipList=
for %%i in (%filePath%) do ( set ipList=!ipList!%workspacePath%%%i )
echo %ipList%
