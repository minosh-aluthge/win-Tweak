# Troubleshooting Guide for Win-Tweak

This comprehensive guide helps you diagnose and resolve common issues when using Win-Tweak. Follow the solutions step-by-step and refer to the appropriate sections based on your specific problem.

## 🚨 Emergency Recovery

### Immediate Recovery Options
If Win-Tweak caused system instability, try these solutions in order:

1. **System Restore** (Recommended first step)
2. **Registry Backup Import** (For specific issues)
3. **Win-Tweak Default Restoration** (Option 6)
4. **Manual Service Recovery** (Advanced users)
5. **Windows Safe Mode** (If system won't boot normally)

### Quick Recovery Steps
```
1. Restart your computer
2. Press F8 during startup (or Shift+F8 on newer systems)
3. Select "System Restore" or "Safe Mode"
4. Choose a restore point created before using Win-Tweak
5. Follow the restoration wizard
```

## 🔧 Installation and Launch Issues

### Problem: Script Won't Start

#### Symptoms
- Double-clicking Win-Tweak.bat does nothing
- Command window flashes briefly and disappears
- "Access Denied" error when launching

#### Solutions

**Solution 1: Administrator Rights**
```powershell
1. Right-click Win-Tweak.bat
2. Select "Run as administrator"
3. Click "Yes" when prompted by UAC
```

**Solution 2: File Properties**
```powershell
1. Right-click Win-Tweak.bat → Properties
2. If "Unblock" checkbox exists, check it
3. Click "OK"
4. Try running again
```

**Solution 3: PowerShell Execution Policy**
```powershell
1. Open PowerShell as administrator
2. Run: Get-ExecutionPolicy
3. If "Restricted", run: Set-ExecutionPolicy RemoteSigned
4. Type "Y" to confirm
```

**Solution 4: Antivirus Interference**
```powershell
1. Temporarily disable real-time protection
2. Add Win-Tweak folder to antivirus exclusions
3. Run script again
4. Re-enable protection after use
```

### Problem: UAC Prompt Loops

#### Symptoms
- Repeated UAC prompts
- Script keeps asking for administrator rights
- Unable to proceed past elevation

#### Solutions

**Solution 1: UAC Settings**
```powershell
1. Press Win+R → type "UserAccountControlSettings"
2. Move slider to "Never notify" temporarily
3. Restart computer
4. Run Win-Tweak
5. Reset UAC to original setting
```

**Solution 2: Run as Built-in Administrator**
```powershell
1. Enable built-in Administrator account
2. Log in as Administrator
3. Run Win-Tweak from this account
4. Disable built-in Administrator when done
```

## 🔄 System Restore Issues

### Problem: Cannot Create Restore Point

#### Symptoms
- "Failed to create System Restore Point" error
- Script aborts after restore point failure
- Error code from checkpoint creation

#### Solutions

**Solution 1: Enable System Restore**
```powershell
1. Right-click "This PC" → Properties
2. Click "System Protection"
3. Select C: drive → Configure
4. Choose "Turn on system protection"
5. Allocate at least 5-10% disk space
```

**Solution 2: Free Disk Space**
```powershell
1. Check available space on C: drive
2. Run Disk Cleanup (cleanmgr.exe)
3. Delete temporary files and logs
4. Empty Recycle Bin
5. Ensure at least 1GB free space
```

**Solution 3: Service Dependencies**
```powershell
1. Press Win+R → type "services.msc"
2. Find "Volume Shadow Copy" service
3. Set to "Automatic" and start it
4. Find "System Restore Service"
5. Set to "Automatic" and start it
```

**Solution 4: Registry Fix**
```powershell
1. Open Registry Editor (regedit)
2. Navigate to: HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore
3. Check if "RPSessionInterval" exists
4. If not, create DWORD with value 1
5. Restart computer
```

### Problem: Restore Point Creation Slow

#### Symptoms
- System Restore takes very long time
- Script appears frozen during restore point creation
- High disk activity during process

#### Solutions

**Solution 1: Wait Patiently**
- System Restore can take 5-30 minutes on slower systems
- Don't interrupt the process
- Monitor disk activity LED

**Solution 2: Optimize System**
```powershell
1. Close unnecessary programs
2. Disable real-time antivirus temporarily
3. Run Disk Defragmentation
4. Check for Windows Updates
```

## 📝 Registry and Backup Issues

### Problem: Registry Backup Fails

#### Symptoms
- "Failed to export registry" errors
- Backup files not created
- Permission denied during backup

#### Solutions

**Solution 1: Registry Permissions**
```powershell
1. Open Registry Editor as administrator
2. Navigate to failing registry key
3. Right-click → Permissions
4. Grant "Full Control" to Administrators group
```

**Solution 2: Disk Space**
```powershell
1. Check free space where backups are saved
2. Registry backups can be 100-500MB each
3. Free up space if needed
4. Try backup again
```

**Solution 3: Registry Corruption**
```powershell
1. Run: sfc /scannow
2. Run: DISM /Online /Cleanup-Image /RestoreHealth
3. Restart computer
4. Try backup again
```

### Problem: Cannot Import Registry Backups

#### Symptoms
- "Cannot import .reg file" error
- Registry entries not restored
- Access denied when importing

#### Solutions

**Solution 1: Administrator Import**
```powershell
1. Right-click .reg file
2. Select "Merge" (not "Edit")
3. Click "Yes" to UAC prompt
4. Confirm registry modification
```

**Solution 2: Manual Registry Editor**
```powershell
1. Open Registry Editor as administrator
2. File → Import
3. Select backup .reg file
4. Confirm import
```

**Solution 3: Command Line Import**
```powershell
1. Open Command Prompt as administrator
2. Run: reg import "path\to\backup.reg"
3. Check for error messages
```

## ⚙️ Service Management Issues

### Problem: Services Won't Start/Stop

#### Symptoms
- "Failed to stop service" errors
- Services restart automatically
- Dependency conflicts

#### Solutions

**Solution 1: Service Dependencies**
```powershell
1. Open services.msc as administrator
2. Right-click problematic service
3. Check "Dependencies" tab
4. Stop dependent services first
5. Then stop main service
```

**Solution 2: Force Stop Services**
```powershell
1. Open Command Prompt as administrator
2. Run: net stop "ServiceName" /y
3. If fails, use: taskkill /f /im servicename.exe
4. Then change startup type
```

**Solution 3: Registry Service Fix**
```powershell
1. Open Registry Editor
2. Navigate to: HKLM\SYSTEM\CurrentControlSet\Services\ServiceName
3. Check "Start" DWORD value:
   - 0 = Boot, 1 = System, 2 = Automatic, 3 = Manual, 4 = Disabled
4. Modify as needed
```

### Problem: System Becomes Unstable After Service Changes

#### Symptoms
- Slow boot times
- Applications won't start
- Network connectivity issues
- Audio/video problems

#### Solutions

**Solution 1: Identify Problem Service**
```powershell
1. Review which services were disabled
2. Common problems:
   - Audio issues: Windows Audio service
   - Network: DHCP Client, DNS Client
   - Updates: Windows Update service
```

**Solution 2: Re-enable Critical Services**
```powershell
1. Open services.msc
2. Find disabled service
3. Right-click → Properties
4. Set Startup type to "Automatic"
5. Click "Start" to start immediately
```

**Solution 3: Use Win-Tweak Restoration**
```powershell
1. Run Win-Tweak.bat as administrator
2. Choose Option [6] "Restore Default Windows Settings"
3. This will re-enable all services
4. Restart computer
```

## 🎯 Performance and Optimization Issues

### Problem: No Performance Improvement

#### Symptoms
- System feels the same after tweaks
- No noticeable speed increase
- Benchmarks show minimal difference

#### Analysis
Performance improvements depend on:
- **System specifications**: Older/slower systems see more benefit
- **Current state**: Already optimized systems see less improvement
- **Usage patterns**: Benefits vary by how you use your computer
- **Expectations**: Dramatic improvements are rare on modern systems

#### Solutions

**Solution 1: Verify Tweaks Applied**
```powershell
1. Check registry entries manually
2. Verify service states in services.msc
3. Look for visual changes (menu speed, etc.)
4. Test specific optimizations individually
```

**Solution 2: Try Aggressive Mode**
```powershell
1. Use Win-Tweak Option [2]
2. Select "Aggressive Optimizations"
3. Apply all suggested tweaks
4. Restart computer to see full effect
```

**Solution 3: Additional Optimizations**
```powershell
1. Run Disk Cleanup and Defragmentation
2. Update drivers, especially graphics
3. Disable startup programs manually
4. Consider hardware upgrade if system is very old
```

### Problem: System Becomes Slower After Tweaks

#### Symptoms
- Longer boot times
- Applications load slowly
- General system sluggishness

#### Solutions

**Solution 1: Check Disabled Services**
Some disabled services might be needed for your workflow:
```powershell
- Windows Search: Affects file searching
- SysMain: May help on systems with limited RAM
- Windows Update: Needed for security updates
```

**Solution 2: Revert Specific Changes**
```powershell
1. Import specific registry backups
2. Re-enable one service at a time
3. Test performance after each change
4. Identify the problematic modification
```

## 🖥️ Visual and UI Issues

### Problem: Desktop Becomes Unresponsive

#### Symptoms
- Right-click menu very slow
- Desktop icons don't respond
- Taskbar freezes periodically

#### Solutions

**Solution 1: Restart Explorer**
```powershell
1. Press Ctrl+Shift+Esc (Task Manager)
2. Find "Windows Explorer" process
3. Right-click → Restart
4. Desktop should refresh
```

**Solution 2: Registry Menu Delay Fix**
```powershell
1. Import Backup_Desktop.reg
2. Or manually set MenuShowDelay to 400
3. Restart computer
```

### Problem: Missing Taskbar Features

#### Symptoms
- Search box disappeared
- Widgets button missing
- Taskbar buttons don't work

#### Solutions

**Solution 1: Restore Explorer Settings**
```powershell
1. Import Backup_ExplorerAdvanced.reg
2. Import Backup_Explorer.reg
3. Restart Windows Explorer
```

**Solution 2: Manual Registry Fix**
```powershell
1. Open Registry Editor
2. Navigate to: HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
3. Reset these values:
   - TaskbarDa = 1 (Widgets)
   - ShowSecondsInSystemClock = 0
   - TaskbarEndTask = 0
```

## 🔒 Security and Permission Issues

### Problem: PowerShell Execution Errors

#### Symptoms
- "Execution policy" errors
- PowerShell commands fail
- Access denied in PowerShell

#### Solutions

**Solution 1: Execution Policy**
```powershell
1. Open PowerShell as administrator
2. Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
3. Type "Y" to confirm
4. Close and restart PowerShell
```

**Solution 2: Bypass Policy Temporarily**
```powershell
1. Run: PowerShell -ExecutionPolicy Bypass -File "path\to\script"
2. Or add to script: Set-ExecutionPolicy Bypass -Scope Process
```

### Problem: Registry Access Denied

#### Symptoms
- Cannot modify certain registry keys
- "Access denied" when running tweaks
- Registry backup fails for specific keys

#### Solutions

**Solution 1: Take Ownership**
```powershell
1. Download and run Registry Ownership tool
2. Or use PsExec: psexec -i -s regedit.exe
3. This runs Registry Editor as SYSTEM
```

**Solution 2: User Rights Assignment**
```powershell
1. Run: secpol.msc
2. Navigate to: Local Policies → User Rights Assignment
3. Add user to "Back up files and directories"
4. Add user to "Restore files and directories"
```

## 🌐 Network and Connectivity Issues

### Problem: Internet Connection Lost

#### Symptoms
- No internet access after running Win-Tweak
- Network adapter shows as disconnected
- DNS resolution fails

#### Solutions

**Solution 1: Re-enable Network Services**
```powershell
1. Open services.msc
2. Find and start these services:
   - DHCP Client
   - DNS Client
   - Network Location Awareness
   - Network List Service
```

**Solution 2: Reset Network Configuration**
```powershell
1. Open Command Prompt as administrator
2. Run these commands:
   netsh winsock reset
   netsh int ip reset
   ipconfig /release
   ipconfig /renew
   ipconfig /flushdns
3. Restart computer
```

### Problem: Windows Update Stopped Working

#### Symptoms
- Updates won't download
- Update service disabled
- Error codes from Windows Update

#### Solutions

**Solution 1: Re-enable Update Services**
```powershell
1. Open services.msc
2. Find "Windows Update" service
3. Set to "Automatic (Delayed Start)"
4. Start the service
5. Also check "Background Intelligent Transfer Service"
```

**Solution 2: Reset Windows Update**
```powershell
1. Stop Windows Update service
2. Delete contents of: C:\Windows\SoftwareDistribution
3. Start Windows Update service
4. Run Windows Update manually
```

## 📱 App and Application Issues

### Problem: Removed Apps Needed Back

#### Symptoms
- Accidentally removed essential apps
- Missing Calculator, Photos, etc.
- Store apps won't reinstall

#### Solutions

**Solution 1: Win-Tweak Restoration**
```powershell
1. Run Win-Tweak as administrator
2. Choose Option [6] "Restore Default Windows Settings"
3. This reinstalls default Windows apps
4. Restart computer
```

**Solution 2: Manual PowerShell Reinstall**
```powershell
1. Open PowerShell as administrator
2. Run: Get-AppxPackage -AllUsers | Where-Object {$_.InstallLocation -like "*SystemApps*"} | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
3. For specific apps: Get-AppxPackage -name "*calculator*" | Remove-AppxPackage
```

**Solution 3: Microsoft Store Reinstall**
```powershell
1. Open Microsoft Store
2. Search for needed apps
3. Click "Install" to reinstall
4. Some system apps may not be available
```

### Problem: Third-Party Apps Won't Start

#### Symptoms
- Applications crash on startup
- "Missing dependencies" errors
- Visual C++ runtime errors

#### Solutions

**Solution 1: Install Visual C++ Runtimes**
```powershell
1. Run Win-Tweak as administrator
2. Choose Option [3] "Install Visual C++ Runtimes"
3. Follow guided download process
4. Install all runtime packages
```

**Solution 2: Check Application Dependencies**
```powershell
1. Download and run Dependency Walker
2. Open problematic application
3. Check for missing DLL files
4. Install required redistributables
```

## 🔍 Diagnostic Tools and Logs

### System Information Gathering

**Basic System Info**
```powershell
# Run these commands to gather system information:
systeminfo > systeminfo.txt
msinfo32 /report msinfo.txt
dxdiag /t dxdiag.txt
```

**Service Status Check**
```powershell
# Check service states:
sc query > services_status.txt
get-service | export-csv services_list.csv
```

**Registry Verification**
```powershell
# Check registry integrity:
sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
```

### Event Log Analysis

**Check for Errors**
```powershell
1. Press Win+R → type "eventvwr.msc"
2. Navigate to: Windows Logs → System
3. Look for red error entries around time of Win-Tweak use
4. Note Event IDs and descriptions
```

**PowerShell Log Check**
```powershell
1. In Event Viewer: Applications and Services Logs
2. Microsoft → Windows → PowerShell → Operational
3. Look for errors during script execution
```

## 📞 Getting Additional Help

### Before Contacting Support

1. **Try System Restore** first
2. **Check this troubleshooting guide** thoroughly
3. **Gather system information** using diagnostic tools
4. **Document exact error messages**
5. **Note your Windows version** and system specifications

### Where to Get Help

**GitHub Issues**
- Report bugs with detailed information
- Search existing issues first
- Include system info and error messages

**Community Forums**
- General usage questions
- Share experiences with other users
- Get community solutions

**Documentation**
- Re-read README.md for feature details
- Check INSTALL.md for setup issues
- Review CONTRIBUTING.md for technical details

### Emergency Contacts

**Critical System Issues**
- Boot from Windows recovery media
- Use System Restore from recovery environment
- Consider professional technical support

**Data Recovery**
- If important data is affected
- Contact professional data recovery services
- Don't attempt DIY recovery on critical data

---

**Remember**: Most issues can be resolved by using System Restore or Win-Tweak's built-in restoration feature (Option 6). When in doubt, restore first and then investigate the specific problem.