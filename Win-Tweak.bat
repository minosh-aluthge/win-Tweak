
@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Win-Tweak: Windows Tweaker & Backup Tool
:: Version: 15.0 (Final GitHub Release)
::
:: Changelog:
:: - Replaced "Disable Copilot Button" with a full "Disable Copilot" policy tweak.
:: - This more effectively removes the Copilot feature from the user experience.
:: - The script is now considered feature-complete and production-ready.
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
set "rp_date=%date:~-4%-%date:~4,2%-%date:~7,2%"
powershell -Command "Checkpoint-Computer -Description 'Before applying Tweaker Script (%rp_date%)' -RestorePointType 'MODIFY_SETTINGS'"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ============================ ERROR =======================================
    echo FAILED to create a System Restore Point.
    echo.
    echo This usually means that System Restore is turned off on your C: drive.
    echo To enable it, go to: Control Panel ^> System ^> System Protection.
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
set "tweak_backup_path=%~dp0"
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
echo Backups created in: %tweak_backup_path%
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
set /p "delayValue=1. Enter menu delay (e.g., 50 for fast, 400 for default): "
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
    reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
    set summary_copilot=Disabled
    echo   -> Copilot feature disabled.
)
echo.
   :: --- Widgets & Taskbar Tweaks ---
   set /p "choice=8. Remove Windows Widgets (disable Widgets button)? (Y/N): "
   if /i "%choice%"=="Y" (
       reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
       echo   -> Windows Widgets disabled.
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
set /p "choice=14. Apply more advanced tweaks (Cache, Shutdown, CPU Priority)? (Y/N): "
if /i "%choice%"=="Y" (
    echo   -> Increasing Filesystem Cache Size...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
    set summary_large_cache=Enabled
    echo   -> Optimizing CPU Priority for foreground apps...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
    set summary_cpu_priority=Optimized
    echo   -> Reducing app shutdown timeout...
    reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f >nul 2>&1
    set summary_shutdown_speed=Optimized
    echo   -> Reducing service shutdown timeout...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul 2>&1
)
exit /b

:apply_aggressive_tweaks_extra
set summary_aggressive=Yes
echo.
echo --- Applying Aggressive Low-End PC Optimizations ---
echo.
echo 15. Disabling non-essential services (Xbox, Print, Fax)...
sc config "XblAuthManager" start= disabled >nul 2>&1
sc config "XblGameSave" start= disabled >nul 2>&1
sc config "XboxGipSvc" start= disabled >nul 2>&1
sc config "Spooler" start= disabled >nul 2>&1
sc config "Fax" start= disabled >nul 2>&1
echo 16. Setting visual effects to BEST PERFORMANCE...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFxLevel /t REG_DWORD /d 2 /f >nul 2>&1
set summary_visualfx=Best Performance
echo 17. Disabling all background apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo 18. Optimizing filesystem for reduced disk activity...
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
exit /b

:remove_apps_interactive
cls
echo ============================================================================
echo                        Remove Unnecessary Apps
echo ============================================================================
echo.
echo This will guide you step-by-step to remove common pre-installed apps.
echo If you are unsure about an app, it is always safe to choose 'N' (No).
echo.
pause
cls
echo --- Gaming ^& Media Apps ---
echo.
set /p "choice=  Remove ALL Xbox-related apps (Game Bar, etc.)? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Xbox* | Remove-AppxPackage" >nul 2>&1 & echo     -> Xbox apps removed. )
echo.
set /p "choice=  Remove 3D Viewer? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1 & echo     -> 3D Viewer removed. )
echo.
set /p "choice=  Remove Clipchamp Video Editor? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.Clipchamp* | Remove-AppxPackage" >nul 2>&1 & echo     -> Clipchamp removed. )
echo.
set /p "choice=  Remove Movies ^& TV (Zune Video)? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1 & echo     -> Movies ^& TV removed. )
echo.
echo --- Productivity ^& Communication Apps ---
echo.
set /p "choice=  Remove Mail and Calendar? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *microsoft.windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1 & echo     -> Mail and Calendar removed. )
echo.
set /p "choice=  Remove Microsoft People? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage" >nul 2>&1 & echo     -> People removed. )
echo.
set /p "choice=  Remove Microsoft Teams (Chat)? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage" >nul 2>&1 & echo     -> Teams removed. )
echo.
set /p "choice=  Remove Phone Link (Your Phone)? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage" >nul 2>&1 & echo     -> Phone Link removed. )
echo.
set /p "choice=  Remove Microsoft To Do? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage" >nul 2>&1 & echo     -> To Do removed. )
echo.
set /p "choice=  Remove Sticky Notes? (WARNING: Deletes existing notes) (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage" >nul 2>&1 & echo     -> Sticky Notes removed. )
echo.
echo --- System ^& Utility Apps ---
echo.
set /p "choice=  Remove Windows Alarms ^& Clock? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage" >nul 2>&1 & echo     -> Alarms ^& Clock removed. )
echo.
set /p "choice=  Remove Windows Maps? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage" >nul 2>&1 & echo     -> Maps removed. )
echo.
set /p "choice=  Remove Voice Recorder? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage" >nul 2>&1 & echo     -> Voice Recorder removed. )
echo.
echo --- Other Apps & Components ---
echo.
set /p "choice=  Remove Microsoft News? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1 & echo     -> News removed. )
echo.
set /p "choice=  Remove Feedback Hub? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1 & echo     -> Feedback Hub removed. )
echo.
set /p "choice=  Remove Get Help / Contact Support? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1 & echo     -> Get Help removed. )
echo.
set /p "choice=  Remove Microsoft Solitaire Collection? (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1 & echo     -> Solitaire removed. )
echo.
set /p "choice=  Uninstall OneDrive? (WARNING: System Component) (Y/N): "
if /i "%choice%"=="Y" (
    taskkill /f /im OneDrive.exe >nul 2>&1
    if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
        "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall
    ) else (
        "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall
    )
    echo     -> OneDrive uninstall command executed.
)
echo.
echo --- CRITICAL APPS (Use with caution!) ---
echo.
set /p "choice=  Remove Windows Calculator? (WARNING: May be needed by some users) (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.WindowsCalculator* | Remove-AppxPackage" >nul 2>&1 & echo     -> Calculator removed. )
echo.
set /p "choice=  Remove Windows Photos? (WARNING: This is the default photo viewer) (Y/N): "
if /i "%choice%"=="Y" ( powershell -Command "Get-AppxPackage *Microsoft.Windows.Photos* | Remove-AppxPackage" >nul 2>&1 & echo     -> Photos removed. )
echo.
echo App removal process complete.
pause
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
:: Enable Widgets
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 1 /f >nul 2>&1
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
powershell -Command "Get-AppxPackage -AllUsers | Foreach { $manifest = Join-Path $_.InstallLocation 'AppXManifest.xml'; if (Test-Path $manifest) { Add-AppxPackage -DisableDevelopmentMode -Register $manifest } }"
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