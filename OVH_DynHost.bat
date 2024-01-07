@echo off
title OVH DynHost Updater by DJ Matjas Software

set "username=enter_here_the_username"
set "password=enter_here_the_password"
set "hostname=enter_here_the_hostname"

echo OVH DynHost Updater by DJ Matjas Software
echo.

curl http://api.ipify.org/ > temp.txt

set "ip="
for /f "delims=" %%a in (temp.txt) do (
    set "ip=%%a"
)

echo.
echo Your public IP address: %ip%

set "url=https://%username%:%password%@www.ovh.com/nic/update?system=dyndns^&hostname=%hostname%^&myip=%ip%"
echo Your update link: %url%

start %url%

echo The link has been opened in your browser, your DynHost has been changed.

del temp.txt

PAUSE >nul