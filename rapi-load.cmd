@echo off

call "config.cmd"
setlocal enabledelayedexpansion

:: load files
%ROOT%\libs\xda-tools-rapi\pget.exe -f -r -v "%REMOTE_LOAD_FOLDER%/*" "%LOCAL_LOAD_FOLDER%/"

:: handle errors
if %ERRORLEVEL% neq 0 goto ONERROR

:: delete loaded files on device
%ROOT%\libs\xda-tools-rapi\pdel.exe -r "%REMOTE_LOAD_FOLDER%/*"

@echo on
exit /b 0

:ONERROR
echo exeption: load failed!
pause
@echo on
exit /b 1


:: TODO: AFTER FTP UPLOAD TO SERVER
:: move files to archive
::set now=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%
::mkdir %ROOT%\archive\%now%
::move %LOCAL_UPLOAD_FOLDER%\* %ROOT%\archive\%now%