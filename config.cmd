@echo off

::==========================================================================
:: CONFIG
::==========================================================================

:: sync folders
set REMOTE_UPLOAD_FOLDER=
set REMOTE_LOAD_FOLDER=
set LOCAL_UPLOAD_FOLDER=
set LOCAL_LOAD_FOLDER=

::==========================================================================

:: root path
for %%A in ("%~dp0") do set "ROOT=%%~fA"

@echo on
