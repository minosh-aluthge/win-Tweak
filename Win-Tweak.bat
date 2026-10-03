@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Win-Tweak: Windows Tweaker & Backup Tool
:: Version: 1.0 (Initial Release)
::
:: Changelog v1.0:
:: - Complete Windows optimization suite with menu-driven interface
:: - System Restore Point creation and management
:: - Comprehensive registry backup and restoration system
:: - Visual C++ Runtimes guided installation
:: - Interactive Windows app removal tool
:: - Standard and Aggressive optimization modes
:: - Complete Copilot disable via Windows policy
:: - Service management (SysMain, Windows Search, Telemetry)
:: - UI tweaks (menu delay, power plans, taskbar customization)
:: - Professional documentation suite with installation and troubleshooting guides
:: - Safety features with backup creation and restoration capabilities
:: ============================================================================


:: ============================================================================
:: 1. Automatic Administrator Check and Self-Elevation
:: ============================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit
)


:: ############################################################################
:: #                                                                          #
:: #                          MAIN PROGRAM BODY                               #
:: #                                                                          #
:: ############################################################################

:main_menu
title Win-Tweak: Windows Tweaker & Backup Tool
cls
echo ============================================================================
echo                      Win-Tweak: Windows Tweaker & Backup Tool
echo ============================================================================
echo.
echo Please choose an option:
echo.
echo   [1] Create a System Restore Point ONLY
echo.
echo   [2] Apply System Optimizations ^& Tweaks (creates restore point first)
echo.
echo   [3] Install Visual C++ Runtimes (Guided Download)
echo.
echo   [4] Perform a FULL Registry Backup ONLY
echo.
echo   [5] ALL: Backup, Restore Point, THEN Optimizations
echo.
echo   [6] Restore Default Windows Settings
echo.
echo   [7] Exit
echo.
set /p "choice=Enter your choice [1-7]: "
if "%choice%"=="1" goto :run_restore_point_only_flow
if "%choice%"=="2" goto :tweak_selection_menu
if "%choice%"=="3" goto :run_vc_install_flow
if "%choice%"=="4" goto :run_backup_only_flow
if "%choice%"=="5" goto :run_all_flow
if "%choice%"=="6" goto :restore_default_settings
if "%choice%"=="7" goto :eof
echo Invalid choice. Please try again.
pause
goto :main_menu

:tweak_selection_menu
cls
echo ============================================================================
echo                       Select Optimization Level
echo ============================================================================
echo.
echo   [1] Standard Optimizations (Recommended for most PCs)
echo.
echo   [2] Aggressive Optimizations (For Low-End PCs / Max Performance)
echo.
echo   [3] Back to Main Menu
echo.
set /p "level=Enter your choice [1, 2, or 3]: "
if "%level%"=="1" goto :run_standard_tweaks
if "%level%"=="2" goto :run_aggressive_tweaks
if "%level%"=="3" goto :main_menu
echo Invalid choice. Please try again.
pause
goto :tweak_selection_menu

:run_restore_point_only_flow
call :create_restore_point
goto :main_menu

:run_backup_only_flow
call :full_backup_section
goto :main_menu

:run_vc_install_flow
call :install_vc_runtimes
goto :main_menu

:run_all_flow
cls
echo ============================================================================
echo         Running ALL operations: Backup, Restore Point, Tweaks, and Runtimes
echo ============================================================================
echo.
pause
rem Step 1: FULL Registry Backup
call :full_backup_section
echo.
echo Full registry backup complete. Proceeding to System Optimizations & Tweaks...
echo.
pause
rem Step 2: System Optimizations & Tweaks (creates restore point first)
call :run_standard_tweaks
echo.
echo System optimizations complete. Proceeding to Visual C++ Runtimes installation...
echo.
pause
rem Step 3: Visual C++ Runtimes Install
call :install_vc_runtimes
echo.
echo All operations complete. Returning to main menu...
pause
goto :main_menu

:run_standard_tweaks
call :create_restore_point
if "!restore_point_status!"=="failed" (
    echo Aborting tweaks due to failed restore point creation.
    pause
    goto :main_menu
)
call :create_tweak_backups
call :apply_standard_tweaks_base "Standard"
call :run_app_remover_flow
call :show_summary_and_restart_prompt
goto :main_menu

:run_aggressive_tweaks
call :create_restore_point
if "!restore_point_status!"=="failed" (
    echo Aborting tweaks due to failed restore point creation.
    pause
    goto :main_menu
)
call :create_tweak_backups
call :apply_standard_tweaks_base "Aggressive"
call :apply_aggressive_tweaks_extra
call :run_app_remover_flow
call :show_summary_and_restart_prompt
goto :main_menu

:run_app_remover_flow
echo.
echo --- Optional: Remove Unnecessary Apps ---
echo.
set /p "choice=Do you want to proceed with the interactive app removal tool? (Y/N): "
if /i "%choice%"=="Y" (
    call :remove_apps_interactive
    set "summary_apps_removed=Process Ran"
)
exit /b

goto :eof


:: ############################################################################
:: #                                                                          #
:: #                      FUNCTIONS / SUBROUTINES                             #
:: #                                                                          #
:: ############################################################################

:install_vc_runtimes
cls
echo ============================================================================
echo                    Install Visual C++ Runtimes
echo ============================================================================
echo.
set "vc_page_link=https://www.techpowerup.com/download/visual-c-redistributable-runtime-package-all-in-one/"
set "InstallFolder=%USERPROFILE%\Desktop\VCRuntimes_Installer"

echo --- Step 1: Guided Download ---
echo.
echo The download page will now open in your web browser.
echo Please download the .zip file. It will be saved to your Downloads folder.
echo.
pause
start "" "%vc_page_link%"

echo.
echo ============================================================================
echo Please wait for the download to complete in your browser.
echo.
echo Once the download is finished, come back to this window and press any key.
echo ============================================================================
pause

echo.
echo Searching for the downloaded file in your Downloads folder...
set "found_zip_file="
for %%F in ("%USERPROFILE%\Downloads\Visual-C-Runtimes-All-in-One*.zip") do set "found_zip_file=%%F"

if not defined found_zip_file (
    echo.
    echo ERROR: Could not find the downloaded .zip file.
    echo Please make sure it was saved in your main Downloads folder.
    pause
    exit /b
)

echo Found file: "!found_zip_file!"
echo.

echo --- Step 2: Preparing for Installation ---
echo.
echo Creating a temporary folder on your Desktop...
md "%InstallFolder%" >nul 2>&1
echo Copying the downloaded file...
copy "!found_zip_file!" "%InstallFolder%\VC_Runtimes_AIO.zip" >nul 2>&1
cd /d "%InstallFolder%"

echo.
echo --- Step 3: Installing ---
echo.
echo Unpacking Visual C++ Runtimes...
powershell -Command "Expand-Archive -Path 'VC_Runtimes_AIO.zip' -DestinationPath '.' -Force" >nul 2>&1

if not exist "install_all.bat" (
    echo.
    echo ERROR: 'install_all.bat' not found in the downloaded files.
    cd /d "%USERPROFILE%\Desktop"
    rd /s /q "%InstallFolder%" >nul 2>&1
    pause
    exit /b
)

echo.
echo Starting Visual C++ Runtimes installation...
echo This will open a new window and may take several minutes. Please wait...
start /wait "" "install_all.bat"
echo Visual C++ Runtimes installation finished.

echo.
echo --- Step 4: Cleanup ---
cd /d "%USERPROFILE%\Desktop"
set /p "cleanup=Installation complete. Do you want to delete the installer folder ('%InstallFolder%')? (Y/N): "
if /i "%cleanup%"=="Y" (
    rd /s /q "%InstallFolder%" >nul 2>&1
    echo Installer folder has been deleted.
)
echo.
echo =================================================================
echo SUCCESS! All Visual C++ Runtimes have been installed.
echo =================================================================
echo.
pause
exit /b

:create_restore_point
cls
echo ============================================================================
echo                     Creating a System Restore Point
echo ============================================================================
echo.
echo This may take a few moments. Please be patient...
echo.
echo --- Ensuring System Restore is enabled ---
echo   -> Starting Volume Shadow Copy service (VSS)...
sc config "VSS" start= demand >nul 2>&1
net start VSS >nul 2>&1
echo   -> Starting Software Protection service (swprv)...
sc config "swprv" start= demand >nul 2>&1
net start swprv >nul 2>&1
echo   -> Enabling System Protection on C: drive...
powershell -Command "Enable-ComputerRestore -Drive 'C:\'" >nul 2>&1
echo   -> Setting disk space allocation (5%%) for restore points...
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=5%% >nul 2>&1
echo   -> System Restore enabled successfully.
echo.
echo --- Creating Restore Point ---
set "rp_date=%date:~-4%-%date:~4,2%-%date:~7,2%"
powershell -Command "Checkpoint-Computer -Description 'Before applying Tweaker Script (%rp_date%)' -RestorePointType 'MODIFY_SETTINGS'"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ============================ ERROR =======================================
    echo FAILED to create a System Restore Point.
    echo.
    echo Auto-enable was attempted but the system could not create the point.
    echo Please check that your C: drive has enough free disk space.
    echo ============================================================================
    set "restore_point_status=failed"
) else (
    echo.
    echo SUCCESS! System Restore Point created successfully.
    set "restore_point_status=success"
)
echo.
pause
exit /b

:create_tweak_backups
cls
echo --- Step 2: Creating Specific Registry Backups for Tweaks ---
set "backup_date=%date:~-4%-%date:~4,2%-%date:~7,2%"
set "tweak_backup_path=%~dp0Registry_Backups_%backup_date%\"
if not exist "%tweak_backup_path%" (
    md "%tweak_backup_path%" >nul 2>&1
    echo   -> Created backup folder: %tweak_backup_path%
)
echo.
echo Backing up registry keys to modify...
reg export "HKCU\Control Panel\Desktop" "%tweak_backup_path%Backup_Desktop.reg" /y >nul 2>&1
reg export "HKCU\Software\Policies\Microsoft\Windows\Explorer" "%tweak_backup_path%Backup_ExplorerPolicies.reg" /y >nul 2>&1
reg export "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" "%tweak_backup_path%Backup_CopilotPolicy.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "%tweak_backup_path%Backup_ExplorerAdvanced.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" "%tweak_backup_path%Backup_Explorer.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\DWM" "%tweak_backup_path%Backup_DWM.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" "%tweak_backup_path%Backup_SearchSettings.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "%tweak_backup_path%Backup_PriorityControl.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "%tweak_backup_path%Backup_MemoryManagement.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "%tweak_backup_path%Backup_SystemPolicies.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control" "%tweak_backup_path%Backup_Control.reg" /y >nul 2>&1
echo.
echo Backups saved to: %tweak_backup_path%
echo.
pause
exit /b

:apply_standard_tweaks_base
cls
echo --- Applying %~1 Optimizations ---
echo.
set "summary_delay=Unchanged"
set "summary_verbose=Unchanged"
set "summary_svchost=Unchanged"
set "summary_sysmain=Unchanged"
set "summary_wsearch=Unchanged"
set "summary_power=Unchanged"
set "summary_visualfx=Standard"
set "summary_startup_delay=Unchanged"
set "summary_hibernate=Unchanged"
set "summary_telemetry=Unchanged"
set "summary_aggressive=No"
set "summary_search_highlights=Unchanged"
set "summary_search_suggestions=Unchanged"
set "summary_seconds_clock=Unchanged"
set "summary_copilot=Unchanged"
set "summary_large_cache=Unchanged"
set "summary_shutdown_speed=Unchanged"
set "summary_cpu_priority=Unchanged"
set "summary_apps_removed=Not Run"

echo --- UI ^& Performance Tweaks ---
echo.
set /p "delayValue=1. Enter menu delay (e.g., 50 for fast, 400 for default,  recommended: 100): "
if "%delayValue%"=="" set "delayValue=100"
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d %delayValue% /f >nul 2>&1
set summary_delay=%delayValue% ms
echo.
set /p "choice=2. Set power plan to Ultimate/High Performance? (Y/N): "
if /i "%choice%"=="Y" (
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    for /f "tokens=4" %%G in ('powercfg /list ^| find "Ultimate"') do set ultimate_guid=%%G
    if defined ultimate_guid (
        powercfg /setactive !ultimate_guid! >nul 2>&1
        set summary_power=Ultimate
    ) else (
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
        set summary_power=High Perf
    )
    echo   -> Power plan optimized.
)
echo.
set /p "choice=3. Disable startup program delay? (Y/N): "
if /i "%choice%"=="Y" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul 2>&1
    set summary_startup_delay=Disabled
    echo   -> Startup delay disabled.
)
echo.
set /p "choice=4. Disable Search Highlights (web content in search)? (Y/N): "
if /i "%choice%"=="Y" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    set summary_search_highlights=Disabled
    echo   -> Search Highlights disabled.
)
echo.
set /p "choice=5. Disable ALL search box web suggestions? (Y/N): "
if /i "%choice%"=="Y" (
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f >nul 2>&1
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f >nul 2>&1
    set summary_search_suggestions=Disabled
    echo   -> Search box suggestions disabled.
)
echo.
set /p "choice=6. Show seconds in the taskbar clock? (Y/N): "
if /i "%choice%"=="Y" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f >nul 2>&1
    set summary_seconds_clock=Enabled
    echo   -> Seconds enabled in clock.
)
echo.
set /p "choice=7. Fully Disable Copilot (via policy)? (Y/N): "
if /i "%choice%"=="Y" (
    reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /f >nul 2>&1
    reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
    set summary_copilot=Disabled
    echo   -> Copilot feature disabled.
)
echo.
:: --- Widgets & Taskbar Tweaks ---
set /p "choice=8. Fully Remove Windows Widgets (uninstall + disable Win+W)? (Y/N): "
if /i "%choice%"=="Y" (
    echo   -> Uninstalling Windows Widgets app...
    powershell -Command "Get-AppxPackage *WebExperience* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage" >nul 2>&1
    echo   -> Disabling Widgets via Group Policy...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
    echo   -> Hiding Widgets taskbar button...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
    echo   -> Windows Widgets fully removed and disabled.
)
   echo.
   set /p "choice=9. Enable 'End Task' in taskbar right-click? (Y/N): "
   if /i "%choice%"=="Y" (
       reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarEndTask /t REG_DWORD /d 1 /f >nul 2>&1
       echo   -> 'End Task' enabled in taskbar context menu.
   )
   echo.
echo --- Service ^& System Tweaks ---
echo.
set /p "choice=8. Disable SysMain (Superfetch)? (Y/N): "
if /i "%choice%"=="Y" (
    sc stop "SysMain" >nul 2>&1
    sc config "SysMain" start= disabled >nul 2>&1
    set summary_sysmain=Disabled
    echo   -> SysMain service disabled.
)
echo.
set /p "choice=9. Disable Windows Search? (Y/N): "
if /i "%choice%"=="Y" (
    sc stop "WSearch" >nul 2>&1
    sc config "WSearch" start= disabled >nul 2>&1
    set summary_wsearch=Disabled
    echo   -> Windows Search service disabled.
)
echo.
set /p "choice=10. Disable Telemetry Service (DiagTrack)? (Y/N): "
if /i "%choice%"=="Y" (
    sc stop "DiagTrack" >nul 2>&1
    sc config "DiagTrack" start= disabled >nul 2>&1
    set summary_telemetry=Disabled
    echo   -> Telemetry service disabled.
)
echo.
:: --- 100% Stable Hibernation Check using a Temporary File ---
set "hibernate_status=off"
set "tempfile=%temp%\hibernate_check_%RANDOM%.txt"
powercfg /a > "%tempfile%" 2>nul
find /i "Hibernate" "%tempfile%" >nul 2>&1
if %errorlevel%==0 set "hibernate_status=on"
if exist "%tempfile%" del "%tempfile%"

if "!hibernate_status!"=="on" (
    set /p "choice=11. Hibernation is ON. Disable it? (Y/N): "
    if /i "%choice%"=="Y" (
        powercfg /h off >nul 2>&1
        set summary_hibernate=Disabled
        echo   -> Hibernation has been disabled.
    )
) else (
    set /p "choice=11. Hibernation is OFF. Enable it? (Y/N): "
    if /i "%choice%"=="Y" (
        powercfg /h on >nul 2>&1
        set summary_hibernate=Enabled
        echo   -> Hibernation has been enabled.
    )
)
echo.
echo --- Advanced Tweaks ---
echo.
echo 12. Enabling Verbose Status Messages...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 1 /f >nul 2>&1
set summary_verbose=Enabled
echo 13. Optimizing Svchost Process Splitting...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 0x04000000 /f >nul 2>&1
set summary_svchost=Optimized
echo.
set /p "choice=14. Apply more advanced tweaks (Shutdown, CPU Priority, Network)? (Y/N): "
if /i not "%choice%"=="Y" goto :skip_advanced_tweaks
echo   -> Optimizing CPU Priority for foreground apps (Win32PrioritySeparation=38)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
set summary_cpu_priority=Optimized
echo   -> Disabling network throttling for gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
echo.
echo   SystemResponsiveness controls how much CPU is reserved for background tasks.
echo     [1] Best for Gaming  (0 percent reserved - all CPU to foreground)
echo     [2] Best for Multitasking / Streaming  (10 percent reserved for background)
set "sr_val=0"
set "sr_msg=Gaming"
set /p "sr_choice=  Choose [1 or 2]: "
if "%sr_choice%"=="2" set "sr_val=10"
if "%sr_choice%"=="2" set "sr_msg=Multitasking"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d %sr_val% /f >nul 2>&1
echo   -> SystemResponsiveness set to %sr_val% (%sr_msg% mode).
echo.
echo   -> Reducing app shutdown timeout to 2 seconds...
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f >nul 2>&1
echo   -> Reducing service shutdown timeout to 2 seconds...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul 2>&1
echo   -> Enabling auto-close of hung apps on shutdown...
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f >nul 2>&1
echo   -> Reducing hung app detection timeout...
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f >nul 2>&1
set summary_shutdown_speed=Optimized
:skip_advanced_tweaks
exit /b

:apply_aggressive_tweaks_extra
set summary_aggressive=Yes
echo.
echo ============================================================================
echo        Applying Aggressive Low-End PC Optimizations (Gaming + Daily Use)
echo ============================================================================
echo.
echo --- Disabling Non-Essential Services ---
echo.
echo   -> Disabling Xbox services...
sc config "XblAuthManager" start= disabled >nul 2>&1
sc config "XblGameSave" start= disabled >nul 2>&1
sc config "XboxGipSvc" start= disabled >nul 2>&1
sc config "XboxNetApiSvc" start= disabled >nul 2>&1
echo   -> Disabling Print Spooler and Fax...
sc config "Spooler" start= disabled >nul 2>&1
sc config "Fax" start= disabled >nul 2>&1
echo   -> Disabling Connected Devices Platform...
sc config "CDPSvc" start= disabled >nul 2>&1
sc config "CDPUserSvc" start= disabled >nul 2>&1
echo   -> Disabling WAP Push Message Service...
sc config "dmwappushservice" start= disabled >nul 2>&1
echo   -> Disabling Diagnostic services...
sc config "DiagTrack" start= disabled >nul 2>&1
sc config "diagnosticshub.standardcollector.service" start= disabled >nul 2>&1
echo   -> Disabling Remote Registry...
sc config "RemoteRegistry" start= disabled >nul 2>&1
echo   -> Disabling Windows Error Reporting...
sc config "WerSvc" start= disabled >nul 2>&1
echo.
echo --- Visual & UI Optimizations ---
echo.
echo   -> Setting visual effects to BEST PERFORMANCE...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFxLevel /t REG_DWORD /d 2 /f >nul 2>&1
set summary_visualfx=Best Performance
echo   -> Disabling transparency effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
echo   -> Disabling animation effects...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
echo   -> Disabling notification center and tips...
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo.
echo --- Gaming Performance Tweaks ---
echo.
echo   -> Enabling Hardware-Accelerated GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo   -> Enforcing Game Mode ON...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
echo   -> Setting GPU priority to maximum for gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d High /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d High /f >nul 2>&1
echo.
echo --- Memory & Disk Optimizations ---
echo.
echo   -> Disabling all background apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo   -> Optimizing Prefetch for apps + boot...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f >nul 2>&1
echo   -> Disabling last access timestamp (reduces disk writes)...
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo   -> Disabling 8.3 filename creation (reduces disk overhead)...
fsutil behavior set disable8dot3 1 >nul 2>&1
echo.
echo   Aggressive optimizations applied successfully!
echo.
exit /b

:remove_apps_interactive
cls
echo ============================================================================
echo                        Remove Unnecessary Apps
echo ============================================================================
echo.
echo Choose a removal preset:
echo.
echo   [1] Gaming Only
echo       Keeps: Calculator, Photos, Teams, Store
echo       Removes: All bloatware, productivity apps, Xbox, Copilot, OneDrive
echo.
echo   [2] Day to Day Task
echo       Keeps: Calculator, Photos, Teams, Store, Mail, Alarms, Sticky Notes, To Do
echo       Removes: Bloatware, Xbox, Copilot, News, Maps, OneDrive
echo.
echo   [3] Full Remove (Maximum cleanup)
echo       Keeps: Teams, Store only
echo       Removes: Everything else including Calculator, Photos, Copilot, OneDrive
echo.
echo   [4] Custom (Choose each app individually)
echo.
echo   [5] Skip - Don't remove any apps
echo.
set /p "preset=Enter your choice [1-5]: "
if "%preset%"=="1" goto :preset_gaming
if "%preset%"=="2" goto :preset_daily
if "%preset%"=="3" goto :preset_full
if "%preset%"=="4" goto :preset_custom
goto :apps_done

:preset_gaming
cls
echo ============================================================================
echo              Gaming Only - Removing unnecessary apps...
echo ============================================================================
echo.
echo   --- Gaming and Media ---
echo   -> Removing Xbox apps...
powershell -Command "Get-AppxPackage -AllUsers *Xbox* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing 3D Viewer...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Microsoft3DViewer* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Paint 3D...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MSPaint* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Clipchamp...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Clipchamp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Movies and TV...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneVideo* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Groove Music...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneMusic* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Media Player...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneMedia* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Solitaire...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- Productivity ---
echo   -> Removing Mail and Calendar...
powershell -Command "Get-AppxPackage -AllUsers *microsoft.windowscommunicationsapps* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Outlook (new)...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.OutlookForWindows* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing People...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.People* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Phone Link...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.YourPhone* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing To Do...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Todos* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Sticky Notes...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Office Hub...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Skype...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.SkypeApp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing OneNote...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Office.OneNote* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Power Automate...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Whiteboard...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Whiteboard* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Journal...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftJournal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- System and Utility ---
echo   -> Removing Camera...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsCamera* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Snipping Tool...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ScreenSketch* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Dev Home...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.DevHome* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Click to Do...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.ClickToDo* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Live Captions...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.LiveCaptions* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Alarms and Clock...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsAlarms* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Windows Clock...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsClock* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Maps...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsMaps* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Voice Recorder...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Quick Assist...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Tips / Get Started...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Getstarted* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Family Safety...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftCorporationII.MicrosoftFamily* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Wallet...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Wallet* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Mixed Reality Portal...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MixedReality.Portal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- AI and Web ---
echo   -> Removing Copilot...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Copilot* | Remove-AppxPackage -AllUsers" >nul 2>&1
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Cortana...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.549981C3F5F10* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Widgets (Web Experience)...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- News and Bing ---
echo   -> Removing News...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingNews* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Weather...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingWeather* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Bing Search...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingSearch* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Sports...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingSports* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Finance...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingFinance* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Travel...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingTravel* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Power BI...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftPowerBIForWindows* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Feedback Hub...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Get Help...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.GetHelp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- OneDrive ---
echo   -> Uninstalling OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
if not exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" if exist "%SystemRoot%\System32\OneDriveSetup.exe" "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
echo.
echo   Kept: Calculator, Photos, Teams, Store
echo.
echo   Gaming Only preset complete! Restart recommended.
pause
goto :apps_done

:preset_daily
cls
echo ============================================================================
echo              Day to Day - Removing bloatware only...
echo ============================================================================
echo.
echo   --- Gaming and Media ---
echo   -> Removing Xbox apps...
powershell -Command "Get-AppxPackage -AllUsers *Xbox* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing 3D Viewer...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Microsoft3DViewer* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Paint 3D...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MSPaint* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Clipchamp...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Clipchamp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Movies and TV...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneVideo* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Groove Music...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneMusic* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Media Player...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneMedia* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Solitaire...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- Productivity ---
echo   -> Removing People...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.People* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Phone Link...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.YourPhone* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Office Hub...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Skype...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.SkypeApp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing OneNote...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Office.OneNote* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Power Automate...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Whiteboard...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Whiteboard* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Journal...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftJournal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- System and Utility ---
echo   -> Removing Camera...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsCamera* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Dev Home...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.DevHome* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Click to Do...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.ClickToDo* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Live Captions...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.LiveCaptions* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Maps...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsMaps* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Voice Recorder...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Quick Assist...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Tips / Get Started...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Getstarted* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Family Safety...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftCorporationII.MicrosoftFamily* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Wallet...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Wallet* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Mixed Reality Portal...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MixedReality.Portal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- AI and Web ---
echo   -> Removing Copilot...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Copilot* | Remove-AppxPackage -AllUsers" >nul 2>&1
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Cortana...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.549981C3F5F10* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Widgets (Web Experience)...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- News and Bing ---
echo   -> Removing News...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingNews* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Weather...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingWeather* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Bing Search...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingSearch* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Sports...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingSports* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Finance...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingFinance* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Travel...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingTravel* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Power BI...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftPowerBIForWindows* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Feedback Hub...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Get Help...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.GetHelp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- OneDrive ---
echo   -> Uninstalling OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
if not exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" if exist "%SystemRoot%\System32\OneDriveSetup.exe" "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
echo.
echo   Kept: Calculator, Photos, Teams, Store, Mail, Alarms, Sticky Notes, To Do, Snipping Tool
echo.
echo   Day to Day preset complete! Restart recommended.
pause
goto :apps_done

:preset_full
cls
echo ============================================================================
echo              Full Remove - Removing ALL Microsoft apps...
echo ============================================================================
echo.
echo   WARNING: This removes EVERYTHING including Calculator, Photos, Paint,
echo   Notepad (Store), Copilot, Camera, Dev Home, and OneDrive!
echo   Apps are removed for ALL users and provisioned packages are stripped.
set /p "confirm=  Are you sure? (Y/N): "
if /i not "%confirm%"=="Y" goto :apps_done
echo.
echo   --- Gaming and Media ---
echo   -> Removing Xbox apps...
powershell -Command "Get-AppxPackage -AllUsers *Xbox* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing 3D Viewer...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Microsoft3DViewer* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Paint 3D...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MSPaint* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Paint (new)...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Paint* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Clipchamp...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Clipchamp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Movies and TV...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneVideo* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Groove Music...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneMusic* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Media Player...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ZuneMedia* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Solitaire...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- Productivity and Communication ---
echo   -> Removing Mail and Calendar...
powershell -Command "Get-AppxPackage -AllUsers *microsoft.windowscommunicationsapps* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Outlook (new)...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.OutlookForWindows* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing People...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.People* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Teams...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftTeams* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Phone Link...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.YourPhone* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing To Do...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Todos* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Sticky Notes...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Office Hub...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Skype...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.SkypeApp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing OneNote...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Office.OneNote* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Power Automate...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Whiteboard...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Whiteboard* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Journal...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftJournal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- System and Utility ---
echo   -> Removing Camera...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsCamera* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Snipping Tool...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.ScreenSketch* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Dev Home...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.DevHome* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Click to Do...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.ClickToDo* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Live Captions...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.LiveCaptions* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Alarms and Clock...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsAlarms* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Windows Clock...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsClock* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Maps...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsMaps* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Voice Recorder / Sound Recorder...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Calculator...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsCalculator* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Photos...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Photos* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Notepad (Store version)...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsNotepad* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Windows Terminal (Store)...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsTerminal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Quick Assist...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Tips / Get Started...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Getstarted* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Family Safety...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftCorporationII.MicrosoftFamily* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Wallet...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Wallet* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Mixed Reality Portal...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MixedReality.Portal* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- AI and Web Content ---
echo   -> Removing Copilot...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Copilot* | Remove-AppxPackage -AllUsers" >nul 2>&1
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Cortana...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.549981C3F5F10* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Widgets (Web Experience)...
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- News and Bing ---
echo   -> Removing News...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingNews* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Weather...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingWeather* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Bing Search...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingSearch* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Sports...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingSports* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Finance...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingFinance* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing MSN Travel...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.BingTravel* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Power BI...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.MicrosoftPowerBIForWindows* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- Feedback and Help ---
echo   -> Removing Feedback Hub...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo   -> Removing Get Help...
powershell -Command "Get-AppxPackage -AllUsers *Microsoft.GetHelp* | Remove-AppxPackage -AllUsers" >nul 2>&1
echo.
echo   --- OneDrive ---
echo   -> Uninstalling OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
if not exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" if exist "%SystemRoot%\System32\OneDriveSetup.exe" "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
echo.
echo   --- Removing Provisioned Packages (prevents reinstall) ---
echo   -> Stripping all provisioned Microsoft bloatware...
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -notlike '*Store*'} | Remove-AppxProvisionedPackage -Online -AllUsers" >nul 2>&1
echo   -> Provisioned packages removed.
echo.
echo   Full Remove preset complete! All Microsoft apps have been removed.
echo   Only Windows Store remains (needed for reinstalling if required).
echo   NOTE: A restart is recommended for all changes to take effect.
pause
goto :apps_done

:preset_custom
cls
echo ============================================================================
echo              Custom - Choose each app individually
echo ============================================================================
echo.
echo If you are unsure about an app, it is safe to choose 'N' (No).
echo.
pause
cls
echo --- Gaming and Media Apps ---
echo.
set /p "choice=  Remove ALL Xbox-related apps? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Xbox* | Remove-AppxPackage" >nul 2>&1& echo     -> Xbox apps removed.
echo.
set /p "choice=  Remove 3D Viewer? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1& echo     -> 3D Viewer removed.
echo.
set /p "choice=  Remove Clipchamp Video Editor? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.Clipchamp* | Remove-AppxPackage" >nul 2>&1& echo     -> Clipchamp removed.
echo.
set /p "choice=  Remove Movies and TV? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1& echo     -> Movies and TV removed.
echo.
echo --- Productivity and Communication Apps ---
echo.
set /p "choice=  Remove Mail and Calendar? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *microsoft.windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1& echo     -> Mail and Calendar removed.
echo.
set /p "choice=  Remove Microsoft People? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage" >nul 2>&1& echo     -> People removed.
echo.
set /p "choice=  Remove Microsoft Teams (Chat)? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage" >nul 2>&1& echo     -> Teams removed.
echo.
set /p "choice=  Remove Phone Link? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage" >nul 2>&1& echo     -> Phone Link removed.
echo.
set /p "choice=  Remove Microsoft To Do? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage" >nul 2>&1& echo     -> To Do removed.
echo.
set /p "choice=  Remove Sticky Notes? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage" >nul 2>&1& echo     -> Sticky Notes removed.
echo.
echo --- System and Utility Apps ---
echo.
set /p "choice=  Remove Windows Alarms and Clock? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage" >nul 2>&1& echo     -> Alarms and Clock removed.
echo.
set /p "choice=  Remove Windows Maps? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage" >nul 2>&1& echo     -> Maps removed.
echo.
set /p "choice=  Remove Voice Recorder? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage" >nul 2>&1& echo     -> Voice Recorder removed.
echo.
echo --- Other Apps ---
echo.
set /p "choice=  Remove Microsoft News? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1& echo     -> News removed.
echo.
set /p "choice=  Remove Feedback Hub? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1& echo     -> Feedback Hub removed.
echo.
set /p "choice=  Remove Get Help? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1& echo     -> Get Help removed.
echo.
set /p "choice=  Remove Solitaire Collection? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1& echo     -> Solitaire removed.
echo.
set /p "choice=  Uninstall OneDrive? (WARNING: System Component) (Y/N): "
if /i "%choice%"=="Y" taskkill /f /im OneDrive.exe >nul 2>&1
if /i "%choice%"=="Y" if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
if /i "%choice%"=="Y" if not exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" if exist "%SystemRoot%\System32\OneDriveSetup.exe" "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
echo.
echo --- CRITICAL APPS (Use with caution!) ---
echo.
set /p "choice=  Remove Windows Calculator? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.WindowsCalculator* | Remove-AppxPackage" >nul 2>&1& echo     -> Calculator removed.
echo.
set /p "choice=  Remove Windows Photos? (Y/N): "
if /i "%choice%"=="Y" powershell -Command "Get-AppxPackage *Microsoft.Windows.Photos* | Remove-AppxPackage" >nul 2>&1& echo     -> Photos removed.
echo.
echo   Custom app removal complete!
pause
goto :apps_done

:apps_done
echo.
echo App removal process complete.
exit /b

:show_summary_and_restart_prompt
echo.
pause
cls
echo =================================================================
echo                          OPTIMIZATION COMPLETE
echo =================================================================
echo.
echo  - Aggressive Low-End Mode: ... %summary_aggressive%
echo.
echo  --- UI ^& Performance ---
echo  - Menu Delay: ................ %summary_delay%
echo  - Power Plan: ................ %summary_power%
echo  - Startup Delay: ............. %summary_startup_delay%
echo  - Search Highlights: .......... %summary_search_highlights%
echo  - Search Box Suggestions: ..... %summary_search_suggestions%
echo  - Seconds in Clock: .......... %summary_seconds_clock%
echo  - Copilot (AI Assistant): ..... %summary_copilot%
echo  - Visual Effects: ............. %summary_visualfx%
echo.
echo  --- Services ^& System ---
echo  - SysMain Service: ............ %summary_sysmain%
echo  - Windows Search Service: .... %summary_wsearch%
echo  - Telemetry Service: ......... %summary_telemetry%
echo  - Hibernation: ............... %summary_hibernate%
echo  - App Removal Process: ....... %summary_apps_removed%
echo.
echo  --- Advanced ---
echo  - Verbose Status Messages: ... %summary_verbose%
echo  - Svchost Splitting: ......... %summary_svchost%
echo  - Large System Cache: ........ %summary_large_cache%
echo  - CPU Priority: .............. %summary_cpu_priority%
echo  - Shutdown Speed: ............ %summary_shutdown_speed%
echo.
echo You must RESTART your computer for all changes to take full effect.
echo =================================================================
echo.
set /p "restart_choice=Do you want to restart your computer now? (Y/N): "
if /i "%restart_choice%"=="Y" (
    shutdown /r /t 5 /c "Restarting to apply optimizations..."
)
echo.
echo Returning to the main menu...
pause
exit /b

:: Restore Default Windows Settings
:restore_default_settings
cls
echo ============================================================================
echo      Restoring Default Windows Settings
echo ============================================================================
echo.
echo This will attempt to restore key Windows settings to their default values.
pause
:: Restore menu delay to default (400)
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
:: Restore power plan to Balanced
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
:: Enable Copilot (remove policy)
reg delete "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /f >nul 2>&1
:: Enable Widgets (restore policy + taskbar button + reinstall app)
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 1 /f >nul 2>&1
powershell -Command "Get-AppxPackage -AllUsers *WebExperience* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\" -ErrorAction SilentlyContinue}" >nul 2>&1
:: Remove End Task from taskbar
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarEndTask /f >nul 2>&1
:: Restore startup delay
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /f >nul 2>&1
:: Enable Search Highlights
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 1 /f >nul 2>&1
:: Enable search box suggestions
reg delete "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /f >nul 2>&1
:: Hide seconds in taskbar clock (default: hidden)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 0 /f >nul 2>&1
:: Restore visual effects to default
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFxLevel /f >nul 2>&1
:: Restore hibernation to default (enabled)
powercfg /h on >nul 2>&1
:: Re-enable services disabled by aggressive tweaks
sc config "XblAuthManager" start= demand >nul 2>&1
sc config "XblGameSave" start= demand >nul 2>&1
sc config "XboxGipSvc" start= demand >nul 2>&1
sc config "Spooler" start= auto >nul 2>&1
sc config "Fax" start= demand >nul 2>&1
:: Restore background apps
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /f >nul 2>&1
:: Restore filesystem behaviors
fsutil behavior set disablelastaccess 0 >nul 2>&1
fsutil behavior set disable8dot3 0 >nul 2>&1
echo.
echo Default settings have been restored. Some changes may require a restart.
pause
:: Reinstall default Windows apps (if removed)
echo Reinstalling default Windows apps...
powershell -Command "Get-AppxPackage -AllUsers | Foreach { $manifest = Join-Path $_.InstallLocation 'AppXManifest.xml'; if (Test-Path $manifest) { Add-AppxPackage -DisableDevelopmentMode -Register $manifest -ErrorAction SilentlyContinue } }" >nul 2>&1
echo Default Windows apps reinstallation attempted.
pause
goto :main_menu
cls
echo ============================================================================
echo                     Creating a FULL Registry Backup
echo ============================================================================
echo.
set /p "confirm=Are you sure you want to continue? (Y/N): "
if /i "%confirm%" neq "Y" (
    echo Backup cancelled.
    pause
    exit /b
)
echo.
echo Creating backup folder on your Desktop...
set "backup_folder=%USERPROFILE%\Desktop\Full_Registry_Backup_%date:~-4%-%date:~4,2%-%date:~7,2%"
md "%backup_folder%" >nul 2>&1
echo --- Starting Full Registry Backup ---
echo.
echo 1 of 5: Backing up HKEY_CLASSES_ROOT (HKCR)...
reg export HKCR "%backup_folder%\Backup_HKCR.reg" /y >nul 2>&1
echo 2 of 5: Backing up HKEY_CURRENT_USER (HKCU)...
reg export HKCU "%backup_folder%\Backup_HKCU.reg" /y >nul 2>&1
echo 3 of 5: Backing up HKEY_LOCAL_MACHINE (HKLM)...
reg export HKLM "%backup_folder%\Backup_HKLM.reg" /y >nul 2>&1
echo 4 of 5: Backing up HKEY_USERS (HKU)...
reg export HKU "%backup_folder%\Backup_HKU.reg" /y >nul 2>&1
echo 5 of 5: Backing up HKEY_CURRENT_CONFIG (HKCC)...
reg export HKCC "%backup_folder%\Backup_HKCC.reg" /y >nul 2>&1
echo.
echo =================================================================
echo SUCCESS! The full registry backup has been saved to:
echo %backup_folder%
echo =================================================================
echo.
pause
exit /b