# Example Registry Backup Structure

This folder provides **text-based examples** showing the structure and content of registry backup files that Win-Tweak creates. **No actual .reg files are included** in this repository to avoid any accidental imports.

## � Registry Backup Examples

### Desktop Settings Example (`Backup_Desktop.reg`)
```registry
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Desktop]
"MenuShowDelay"="400"
"WaitToKillAppTimeout"="20000"
"HungAppTimeout"="5000"
"AutoEndTasks"="0"
"LowLevelHooksTimeout"="5000"
"ForegroundLockTimeout"=dword:00030d40
"ForegroundFlashCount"=dword:00000003
"CursorBlinkRate"="530"
"ScreenSaveActive"="1"
"ScreenSaveTimeOut"="900"
"SCRNSAVE.EXE"=""
"Pattern"=""
"Wallpaper"="C:\\Windows\\Web\\Wallpaper\\Windows\\img0.jpg"
"TileWallpaper"="0"
"WallpaperStyle"="10"
"ScreenSaverIsSecure"="0"
```

### Explorer Advanced Settings Example (`Backup_ExplorerAdvanced.reg`)
```registry
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Hidden"=dword:00000002
"HideFileExt"=dword:00000001
"ShowInfoTip"=dword:00000001
"HideIcons"=dword:00000000
"MapNetDrvBtn"=dword:00000000
"WebView"=dword:00000001
"Filter"=dword:00000000
"ShowSuperHidden"=dword:00000000
"SeparateProcess"=dword:00000000
"AutoCheckSelect"=dword:00000001
"IconsOnly"=dword:00000000
"ShowTypeOverlay"=dword:00000001
"ShowStatusBar"=dword:00000001
"StoreAppsOnTaskbar"=dword:00000001
"ListviewAlphaSelect"=dword:00000001
"ListviewShadow"=dword:00000001
"TaskbarAnimations"=dword:00000001
"TaskbarGlomLevel"=dword:00000000
"TaskbarSizeMove"=dword:00000001
"TaskbarSmallIcons"=dword:00000000
"TaskbarDa"=dword:00000001
"ShowSecondsInSystemClock"=dword:00000000
"TaskbarEndTask"=dword:00000000

; TaskbarDa controls Widgets button (1=enabled, 0=disabled)
; ShowSecondsInSystemClock controls seconds in taskbar clock
; TaskbarEndTask controls "End Task" option in taskbar context menu
```

### Copilot Policy Example (`Backup_CopilotPolicy.reg`)
```registry
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=dword:00000000

; Values:
; 0 = Copilot enabled (default Windows behavior)
; 1 = Copilot disabled via policy (Win-Tweak modification)
;
; Note: This key may not exist before Win-Tweak creates it
```

## ⚠️ Important Notes

### **NO .REG FILES IN REPOSITORY**
- This repository contains **NO actual .reg files**
- All examples above are **text-based demonstrations only**
- **Never import** examples from documentation into your registry
- Always use the actual backup files created by Win-Tweak on YOUR system

### **Use Your Own Backups**
- Win-Tweak creates real backups with names like `Backup_Desktop.reg`
- These files contain YOUR actual system settings
- Only import the backup files that Win-Tweak created on YOUR specific system
- Keep your backup files local to your machine

## 🔍 Understanding Backup Files

### Registry Structure
```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Path\To\Registry\Key]
"ValueName"="StringValue"
"DWordValue"=dword:00000001
```

### Common Registry Paths Modified by Win-Tweak
- `HKCU\Control Panel\Desktop` - Desktop and UI settings
- `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced` - Explorer settings
- `HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot` - Copilot policy
- `HKLM\SYSTEM\CurrentControlSet\Control` - System-wide settings
- `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System` - System policies

### Value Types
- **REG_SZ**: String value (text)
- **REG_DWORD**: 32-bit number (shown as dword:xxxxxxxx)
- **REG_BINARY**: Binary data
- **REG_MULTI_SZ**: Multiple strings

## 📋 Backup File Naming Convention

Win-Tweak creates backup files with these names:
- `Backup_Desktop.reg` - Desktop settings
- `Backup_ExplorerPolicies.reg` - Explorer policies
- `Backup_CopilotPolicy.reg` - Copilot settings
- `Backup_ExplorerAdvanced.reg` - Advanced Explorer settings
- `Backup_Explorer.reg` - General Explorer settings
- `Backup_DWM.reg` - Desktop Window Manager
- `Backup_SearchSettings.reg` - Search configuration
- `Backup_PriorityControl.reg` - Process priorities
- `Backup_MemoryManagement.reg` - Memory settings
- `Backup_SystemPolicies.reg` - System policies
- `Backup_Control.reg` - System control settings

## 🔄 How to Use Real Backups

### To Restore Settings
1. **Locate your actual backup file** (not these examples)
2. **Right-click the .reg file** → Select "Merge"
3. **Click "Yes"** to confirm UAC prompt
4. **Click "Yes"** to confirm registry modification
5. **Restart Windows Explorer** or reboot for full effect

### Alternative Method
1. **Open Registry Editor** (regedit) as administrator
2. **File** → **Import**
3. **Select your backup .reg file**
4. **Click "Open"** to import

## 🛡️ Safety Tips

### Before Importing Backups
- **Verify the backup file** is one YOU created
- **Check the date** to ensure it's recent
- **Create a new restore point** before importing
- **Close other applications** to avoid conflicts

### After Importing Backups
- **Restart Windows Explorer**: Task Manager → End "Windows Explorer" → File → Run new task → "explorer.exe"
- **Check settings**: Verify that your desired settings are restored
- **Reboot if needed**: Some changes require a full restart

## 📞 Need Help?

If you have questions about backup files:
1. **Read the main README.md** for comprehensive information
2. **Check TROUBLESHOOTING.md** for common issues
3. **Visit GitHub Issues** for community support
4. **Use Win-Tweak Option 6** for automatic restoration

Remember: These example files are for educational purposes only. Always use the actual backup files created by Win-Tweak on your specific system.