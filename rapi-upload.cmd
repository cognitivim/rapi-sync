@echo off

call "config.cmd"
setlocal enabledelayedexpansion

:: upload files
%ROOT%\libs\xda-tools-rapi\pput.exe -f -v -r "%LOCAL_UPLOAD_FOLDER%\*" "%REMOTE_UPLOAD_FOLDER%/"

:: handle errors
if %ERRORLEVEL% neq 0 goto ONERROR

:: delete uploaded files
del /f /s /q "%LOCAL_UPLOAD_FOLDER%\*"

@echo on
exit /b 0

:ONERROR
echo exeption: upload failed!
pause
@echo on
exit /b 1


:: TODO save MAC + last lync timestamp