@echo off
setlocal enabledelayedexpansion

:: Define the URL of the GitHub raw file
set "raw_url=https://raw.githubusercontent.com/cx5002/Middle-blocker/master/Blocker.cmd"

:: Define the path to download the updated script
set "download_path=%temp%\Blocker.cmd"

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

:: Use PowerShell to download the updated script
powershell -Command "Invoke-WebRequest -Uri '%raw_url%' -OutFile '%download_path%'"

:: Check if the download was successful
if exist "%download_path%" (
    :: Replace the current script with the updated script
    copy /y "%download_path%" "%~dpnx0"
)

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
echo 8. Change DNS
echo 9. Quit
echo ========================================================
echo.
set /p choice="Select an option [1-9]: "

if "%choice%"=="1" goto block_ips
if "%choice%"=="2" goto unblock_ips
if "%choice%"=="3" goto check_rules
if "%choice%"=="4" goto show_ips
if "%choice%"=="5" goto add_ip
if "%choice%"=="6" goto remove_ip
if "%choice%"=="7" goto reset_ips
if "%choice%"=="8" goto change_dns
if "%choice%"=="9" goto end

echo Invalid choice. Please select a valid option.
pause
goto main_menu

:block_ips
cls
echo ========================================================
echo                    Blocking IPs...
echo ========================================================
:: Convert IP Prefixes into a comma-separated list
set "ip_list="
for %%i in (%ips%) do (
    set "ip_list=!ip_list!,%%i"
)

:: Remove the leading comma
set "ip_list=%ip_list:~1%"

:: Add the block rules
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
:: Remove the block rules
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
:: Create a temporary file
set "tempfile=%temp%\firewall_rules.txt"

:: Check if the rule exists
netsh advfirewall firewall show rule name="Middle-East Blocker" > "%tempfile%"

:: Look for the rule in the file
findstr /i "Middle-East Blocker" "%tempfile%" >nul
if !errorlevel! equ 0 (
    echo "Middle-East" successfully blocked.
) else (
    echo "Middle-East" is not blocked.
)

:: Clean up
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

:change_dns
cls
echo ========================================================
echo                  Change DNS Settings
echo ========================================================
:: List network adapters using PowerShell
echo Network Adapters:
echo -----------------
powershell -Command "Get-NetAdapter -Physical | ForEach-Object {Write-Host ""$($_.ifIndex): $($_.Name)""}"
set /p adapter_choice="Select a Connected Adapter (Enter Index): "

:: DNS Options
echo ========================================================
echo DNS Options:
echo 1. Google: 8.8.8.8, 8.8.4.4
echo 2. Cloudflare: 1.1.1.1, 1.0.0.1
echo 3. Electro: 78.157.42.100, 78.157.42.101
echo 4. Custom
echo 5. Reset DNS
echo ========================================================
set /p dns_choice="Select a DNS option [1-5]: "

if "%dns_choice%"=="1" (
    set "dns1=8.8.8.8"
    set "dns2=8.8.4.4"
) else if "%dns_choice%"=="2" (
    set "dns1=1.1.1.1"
    set "dns2=1.0.0.1"
) else if "%dns_choice%"=="3" (
    set "dns1=78.157.42.100"
    set "dns2=78.157.42.101"
) else if "%dns_choice%"=="4" (
    set /p dns1="Enter primary DNS: "
    set /p dns2="Enter secondary DNS: "
) else if "%dns_choice%"=="5" (
    set "dns1="
    set "dns2="
) else (
    echo Invalid choice. Returning to main menu.
    pause
    goto main_menu
)

:: Change DNS settings for the selected adapter
echo Changing DNS for adapter index: %adapter_choice%
if "%dns_choice%"=="5" (
    powershell -Command "Set-DnsClientServerAddress -InterfaceIndex %adapter_choice% -ResetServerAddresses"
) else (
    powershell -Command "Set-DnsClientServerAddress -InterfaceIndex %adapter_choice% -ServerAddresses @('%dns1%', '%dns2%')"
)
if %errorlevel% neq 0 (
    echo Failed to change DNS settings. Please check your network settings.
) else (
    echo DNS settings changed successfully.
)
echo ========================================================
pause
goto main_menu

:end
cls
echo ========================================================
echo                    Exiting...
echo ========================================================
endlocal
ssd
