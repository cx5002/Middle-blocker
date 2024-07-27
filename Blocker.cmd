@echo off
setlocal enabledelayedexpansion

rem Define the list of IP Prefixes
set "ips=15.184.0.0/16 15.185.0.0/16 16.24.0.0/16 157.175.0.0/16 51.16.0.0/15 51.84.0.0/16 51.85.0.0/16 15.220.160.0/21 3.28.0.0/15 40.172.0.0/16 51.112.0.0/16"

:main_menu
cls
echo ========================================================
echo            Middle-East Blocker - By hosseine3
echo ========================================================
echo.
echo 1. Block Middle-East
echo 2. Unblock Middle-East
echo 3. Check Middle-East Connection
echo 4. Checking For Updater
echo 5. Quit
echo ========================================================
echo.
set /p choice="Select an option [1-5]: "

if "%choice%"=="1" goto block_ips
if "%choice%"=="2" goto unblock_ips
if "%choice%"=="3" goto check_rules
if "%choice%"=="4" goto update_script
if "%choice%"=="5" goto end

echo Invalid choice. Please select a valid option.
pause
goto main_menu

:block_ips
cls
echo ========================================================
echo                    Blocking IPs...
echo ========================================================
rem Convert IP Prefixes into a comma-separated list
set "ip_list="
for %%i in (%ips%) do (
    set "ip_list=!ip_list!,%%i"
)

rem Remove the leading comma
set "ip_list=%ip_list:~1%"

rem Add the block rules
echo Adding rules to block IP Prefixes...
netsh advfirewall firewall add rule name="Middle-East Blocker" dir=in action=block remoteip=%ip_list%
netsh advfirewall firewall add rule name="Middle-East Blocker" dir=out action=block remoteip=%ip_list%
echo ========================================================
echo IPs Blocked successfully.
echo ========================================================
pause
goto main_menu

:unblock_ips
cls
echo ========================================================
echo                    Unblocking IPs...
echo ========================================================
rem Remove the block rules
echo Removing rules to unblock IP Prefixes...
netsh advfirewall firewall delete rule name="Middle-East Blocker"
echo ========================================================
echo IPs Unblocked successfully.
echo ========================================================
pause
goto main_menu

:check_rules
cls
echo ========================================================
echo                    Checking Middle-East Connection...
echo ========================================================
rem Create a temporary file
set "tempfile=%temp%\firewall_rules.txt"

rem Check if the rule exists
netsh advfirewall firewall show rule name="Middle-East Blocker" > "%tempfile%"

rem Look for the rule in the file
findstr /i "Middle-East Blocker" "%tempfile%" >nul
if !errorlevel! equ 0 (
    echo "Middle-East" successfully blocked.
) else (
    echo "Middle-East" is not blocked.
)

rem Clean up
del "%tempfile%"

echo ========================================================
pause
goto main_menu

:update_script
cls
echo ========================================================
echo                    Updating Script...
echo ========================================================
rem Define the URL of the GitHub raw file
set "raw_url=https://raw.githubusercontent.com/cx5002/Middle-blocker/master/Blocker.cmd"

rem Define the path to download the updated script
set "download_path=%temp%\Blocker.cmd"

rem Use PowerShell to download the updated script
powershell -Command "Invoke-WebRequest -Uri '%raw_url%' -OutFile '%download_path%'"

rem Check if the download was successful
if not exist "%download_path%" (
    echo Failed to download the updated script. Please check your network connection and try again.
    pause
    goto main_menu
)

rem Replace the current script with the updated script
copy /y "%download_path%" "%~dp0"

echo ========================================================
echo Script updated successfully.
echo ========================================================
pause
goto main_menu

:end
cls
echo ========================================================
echo                    Exiting...
echo ========================================================
endlocal

