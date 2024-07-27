@echo off
setlocal enabledelayedexpansion

rem Define URLs
set "repo_url=https://github.com/YourUsername/MiddleEastBlocker/raw/main"
set "version_file_url=%repo_url%/version.txt"
set "script_file_url=%repo_url%/%~nx0"
set "version_file=%temp%\version.txt"
set "script_file=%temp%\%~nx0"

rem Get the current script version
set "current_version=1.0"  rem Set the current version of the script here

rem Function to check and update the script
:check_and_update
cls
echo ========================================================
echo Checking for updates...
echo ========================================================
rem Download the version file
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%version_file_url%', '%version_file%')"

rem Read the version from the file
set /p new_version=<"%version_file%"

rem Compare versions
if "%current_version%" NEQ "%new_version%" (
    echo A new version (%new_version%) is available. Updating...
    rem Download the new script file
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%script_file_url%', '%script_file%')"
    
    rem Replace the old script with the new one
    move /y "%script_file%" "%~f0"
    
    rem Clean up
    del "%version_file%"

    echo ========================================================
    echo Update completed. Restarting the script...
    echo ========================================================
    call "%~f0"
    exit /b
) else (
    echo You are already using the latest version (%current_version%).
)

rem Proceed with the rest of the script
goto main_menu

rem Call the update check function
call :check_and_update

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
echo 4. Update Script
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
rem Call the update check function
call :check_and_update
echo ========================================================
pause
goto main_menu

:end
cls
echo ========================================================
echo                    Exiting...
echo ========================================================
endlocal
