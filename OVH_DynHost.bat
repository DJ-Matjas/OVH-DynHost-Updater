@echo off
setlocal enabledelayedexpansion
title OVH DynHost Updater by DJ Matjas Software

REM Set here your DynHost settings
set "username=enter_here_the_username"
set "password=enter_here_the_password"
set "hostname=enter_here_the_hostname"

set internet_offline=1

cd /d "%~dp0"
set "LOG_FOLDER=.\Logs"

for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set "DATE=%%G"
set "YEAR=!DATE:~0,4!"
set "MONTH=!DATE:~4,2!"
set "DAY=!DATE:~6,2!"
set "LOG_DATE=!YEAR!!MONTH!!DAY!"

set "LOG_FILE=%LOG_FOLDER%\log_%LOG_DATE%.txt"

if not exist "%LOG_FOLDER%" mkdir "%LOG_FOLDER%"

:check_internet
if exist "%LOG_FILE%" (
    for /f %%A in ("%LOG_FILE%") do (
        if not "%%~nA"=="log_%LOG_DATE%" (
            set "NEW_LOG_FILE=%LOG_FOLDER%\log_%LOG_DATE%.txt"
            echo Created new log: %NEW_LOG_FILE%
            set "LOG_FILE=%NEW_LOG_FILE%"
        )
    )
)
ping -n 1 8.8.8.8 >nul
if errorlevel 1 (
    if !internet_offline! == 0 (
        set internet_offline=1
		cls
		echo OVH DynHost Updater by DJ Matjas Software
		echo.
		echo Status: Internet offline
        echo [%time%] Status: Internet offline >> %LOG_FILE%
    )
) else (
    if !internet_offline! == 1 (
        goto internet_back
    )
)

timeout /t 10 >nul
goto check_internet

:internet_back
cls
echo OVH DynHost Updater by DJ Matjas Software
echo.
set internet_offline=0
echo Status: Internet back online
echo [%time%] Status: Internet back online >> %LOG_FILE%
echo.
curl http://api.ipify.org/ > %appdata%\temp_odu.txt

set "ip="
for /f "delims=" %%a in (%appdata%\temp_odu.txt) do (
	set "ip=%%a"
)

echo.
echo Your public IP address: %ip% >> %LOG_FILE%

set "url=https://%username%:%password%@www.ovh.com/nic/update?system=dyndns^&hostname=%hostname%^&myip=%ip%"
echo Your update link: %url% >> %LOG_FILE%

start /min chrome.exe %url%
timeout /t 5
taskkill /IM chrome.exe

echo The link has been opened in your browser, your DynHost has been changed.

del %appdata%\temp_odu.txt

cls
echo OVH DynHost Updater by DJ Matjas Software
echo.
echo Status: Internet online
echo [%time%] Status: Internet online >> %LOG_FILE%

goto check_internet