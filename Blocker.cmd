@echo off
setlocal enabledelayedexpansion

:: Define the URL of the GitHub raw file
set "raw_url=https://raw.githubusercontent.com/cx5002/Middle-blocker/master/Blocker.cmd"

:: Define the path to download the updated script
set "download_path=%temp%\Blocker.cmd"

:: Use PowerShell to download the updated script
powershell -Command "Invoke-WebRequest -Uri '%raw_url%' -OutFile '%download_path%'"

:: Check if the download was successful
if exist "%download_path%" (
    :: Replace the current script with the updated script
    copy /y "%download_path%" "%~dpnx0"
)


:: Check for administrator privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo **************************************************************
    echo This script requires administrator privileges. Restarting as administrator...
    echo **************************************************************
    pause
    :: Restart the script with administrator privileges
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:: Define the URL of the GitHub raw file
set "raw_url=https://raw.githubusercontent.com/cx5002/Middle-blocker/master/Blocker.cmd"
:: Define the path to download the updated script
set "download_path=%temp%\Blocker.cmd"

:: Define default list of IP Prefixes
set "default_ips=15.184.0.0/16 15.185.0.0/16 16.24.0.0/16 157.175.0.0/16 51.16.0.0/15 51.84.0.0/16 51.85.0.0/16 15.220.160.0/21 3.28.0.0/15 40.172.0.0/16 51.112.0.0/16"
set "ips=%default_ips%"

:main_menu
cls
echo ========================================================
echo            Middle-East Blocker - By hosseine3
echo ========================================================
echo.
echo 1. Block Middle-East
echo 2. Unblock Middle-East
echo 3. Check Middle-East Connection
echo 4. Show IP List
echo 5. Add IP to List
echo 6. Remove IP from List
echo 7. Reset to Default
echo 8. Quit
echo ========================================================
echo.
set /p choice="Select an option [1-8]: "

if "%choice%"=="1" goto block_ips
if "%choice%"=="2" goto unblock_ips
if "%choice%"=="3" goto check_rules
if "%choice%"=="4" goto show_ips
if "%choice%"=="5" goto add_ip
if "%choice%"=="6" goto remove_ip
if "%choice%"=="7" goto reset_ips
if "%choice%"=="8" goto end

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
if %errorlevel% neq 0 (
    echo Failed to add inbound rules. Please check your firewall settings.
) else (
    echo Inbound rules added successfully.
)

netsh advfirewall firewall add rule name="Middle-East Blocker" dir=out action=block remoteip=%ip_list%
if %errorlevel% neq 0 (
    echo Failed to add outbound rules. Please check your firewall settings.
) else (
    echo Outbound rules added successfully.
)
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
if %errorlevel% neq 0 (
    echo Failed to remove rules. Please check your firewall settings.
) else (
    echo Rules removed successfully.
)
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

:show_ips
cls
echo ========================================================
echo             Show Selected IPs For Blocking...
echo ========================================================
for %%i in (%ips%) do (
    echo %%i
)
echo ========================================================
pause
goto main_menu

:add_ip
cls
echo ========================================================
echo                  Add IP to Block List
echo ========================================================
set /p new_ip="Enter IP Prefix to Add (e.g., 192.168.1.0/24): "
if not "%new_ip%"=="" (
    set "ips=%ips% %new_ip%"
    echo IP Prefix added successfully.
) else (
    echo No IP Prefix entered.
)
echo ========================================================
pause
goto main_menu

:remove_ip
cls
echo ========================================================
echo                Remove IP from Block List
echo ========================================================
set /p del_ip="Enter IP Prefix to Remove (e.g., 192.168.1.0/24): "
if not "%del_ip%"=="" (
    set "new_ips="
    for %%i in (%ips%) do (
        if not "%%i"=="%del_ip%" (
            set "new_ips=!new_ips! %%i"
        )
    )
    set "ips=!new_ips:~1!"
    echo IP Prefix removed successfully.
) else (
    echo No IP Prefix entered.
)
echo ========================================================
pause
goto main_menu

:reset_ips
cls
echo ========================================================
echo                Resetting to Default IPs
echo ========================================================
set "ips=%default_ips%"
echo IP list reset to default successfully.
echo ========================================================
pause
goto main_menu

:end
cls
echo ========================================================
echo                    Exiting...
echo ========================================================
endlocal

updater
