@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
	echo Usage: help script_name
	goto : EOF
)

set "file=%~1.sql"
if not exist "%file%" (
	echo File %file% not found.
	goto : EOF
)

set /a count=0
for /f "delims=" %%a in ('type "%file%"') do (
	echo %%a
	set /a count+=1
	if !count! geq 7 goto: EOF
)