# Installation Guide for Win-Tweak

This guide provides step-by-step instructions for downloading, installing, and running Win-Tweak on your Windows system.

## 📋 System Requirements

### Minimum Requirements
- **Operating System**: Windows 10 (version 1903 or later) or Windows 11
- **Architecture**: x86 (32-bit) or x64 (64-bit)
- **RAM**: 4GB minimum (8GB recommended for aggressive optimizations)
- **Storage**: 100MB free space for backups and temporary files
- **Privileges**: Administrator access required
- **Network**: Internet connection (for Visual C++ runtime download only)

### Software Prerequisites
- **PowerShell**: Version 5.0 or higher (included in Windows 10/11)
- **Windows Management Framework**: For advanced system operations
- **System Restore**: Enabled on C: drive (highly recommended)

## 🔽 Download Instructions

### Method 1: GitHub Release (Recommended)
1. Visit the [Win-Tweak GitHub releases page](https://github.com/your-username/win-tweak/releases)
2. Download the latest release (`Win-Tweak-v15.0.zip`)
3. Extract the ZIP file to your preferred location
4. The main script will be named `Win-Tweak.bat`

### Method 2: Direct Download
1. Download the `Win-Tweak.bat` file directly from the repository
2. Save it to a folder of your choice (e.g., `C:\Tools\Win-Tweak\`)
3. Ensure the file is not blocked by Windows security

### Method 3: Clone Repository
```powershell
git clone https://github.com/your-username/win-tweak.git
cd win-tweak
```

## 🛡️ Pre-Installation Safety Steps

### 1. Enable System Restore
Before running Win-Tweak, ensure System Restore is enabled:

1. Right-click **This PC** → **Properties**
2. Click **System Protection** (left sidebar)
3. Select your **C: drive** → Click **Configure**
4. Select **Turn on system protection**
5. Set disk usage to at least **5-10%**
6. Click **OK** → **Apply**

### 2. Create Manual Backup
For extra safety, create a manual backup:

1. **Files**: Back up important documents to external storage
2. **System Image**: Consider creating a full system image
3. **Registry**: Export critical registry keys if known

### 3. Check Antivirus Settings
Some antivirus software may flag batch scripts:

1. **Temporarily disable real-time protection** (if needed)
2. **Add Win-Tweak folder to exclusions**
3. **Scan the downloaded file** before running

## 🚀 Installation Process

### Step 1: Extract and Place Files
1. **Create a dedicated folder**: `C:\Win-Tweak\` (recommended)
2. **Extract all files** to this folder
3. **Verify contents**:
   - `Win-Tweak.bat` (main script)
   - `README.md` (documentation)
   - `LICENSE` (license file)

### Step 2: Verify File Integrity
1. **Check file size**: Win-Tweak.bat should be approximately 15-20KB
2. **Scan for malware**: Run a full antivirus scan on the folder
3. **Verify digital signature**: Check if the file has a valid signature

### Step 3: Initial Setup
1. **Right-click** on `Win-Tweak.bat`
2. **Select "Properties"**
3. **Check "Unblock"** if present in the security section
4. **Click "OK"**

## ▶️ First Run Instructions

### Step 1: Administrator Launch
1. **Right-click** `Win-Tweak.bat`
2. **Select "Run as administrator"**
3. **Click "Yes"** when prompted by UAC
4. **Wait** for the script to self-elevate (if needed)

### Step 2: Initial Menu Navigation
Upon first launch, you'll see the main menu:

```
============================================================================
                   Win-Tweak: Windows Tweaker & Backup Tool
============================================================================

Please choose an option:

  [1] Create a System Restore Point ONLY
  [2] Apply System Optimizations & Tweaks (creates restore point first)
  [3] Install Visual C++ Runtimes (Guided Download)
  [4] Perform a FULL Registry Backup ONLY
  [5] ALL: Backup, Restore Point, THEN Optimizations
  [6] Restore Default Windows Settings
  [7] Exit
```

### Step 3: Recommended First Steps
For first-time users, we recommend this sequence:

1. **Choose Option [1]**: Create a System Restore Point
2. **Choose Option [4]**: Perform a Full Registry Backup
3. **Choose Option [2]**: Apply Standard Optimizations (not Aggressive)

## 🔧 Configuration Options

### Standard vs Aggressive Mode
When selecting Option [2], you'll choose optimization level:

#### Standard Optimizations (Recommended)
- **Safe for most systems**
- **Balanced performance improvements**
- **Easily reversible changes**
- **Minimal risk of system issues**

#### Aggressive Optimizations (Advanced Users)
- **Maximum performance gains**
- **Designed for low-end PCs**
- **More extensive system changes**
- **Requires careful consideration**

### Interactive Prompts
Win-Tweak uses interactive Y/N prompts for each tweak:

- **Read each prompt carefully**
- **Type 'Y' to apply the tweak**
- **Type 'N' to skip the tweak**
- **Take your time to decide**

## 📁 File Organization

After installation and first use, your folder structure should look like:

```
C:\Win-Tweak\
├── Win-Tweak.bat              # Main script
├── README.md                  # Documentation
├── LICENSE                    # License file
├── CHANGELOG.md               # Version history
├── CONTRIBUTING.md            # Contribution guidelines
├── docs\                      # Additional documentation
├── examples\                  # Example files
├── utils\                     # Utility scripts
├── Backup_Desktop.reg         # Generated backups
├── Backup_Explorer.reg        # (created during use)
└── Full_Registry_Backup_YYYY-MM-DD\  # Full backups
    ├── Backup_HKCR.reg
    ├── Backup_HKCU.reg
    └── ...
```

## ✅ Verification Steps

### After Installation
1. **Script launches**: Win-Tweak.bat opens without errors
2. **Menu displays**: Main menu appears correctly
3. **Admin elevation**: Script successfully requests admin rights
4. **Folder structure**: All files are in the correct locations

### After First Use
1. **Backups created**: Registry backup files are generated
2. **Restore point exists**: System restore point is created successfully
3. **System stable**: No immediate system issues or errors
4. **Tweaks applied**: Selected optimizations are working

## 🚨 Troubleshooting Installation

### Common Issues

#### "Script won't run"
**Symptoms**: Double-clicking does nothing or shows error
**Solutions**:
1. Right-click → "Run as administrator"
2. Check if file is blocked (Properties → Unblock)
3. Verify PowerShell execution policy: `Get-ExecutionPolicy`
4. Enable script execution: `Set-ExecutionPolicy RemoteSigned`

#### "Access Denied" errors
**Symptoms**: Script starts but can't modify registry/services
**Solutions**:
1. Ensure running as administrator
2. Check User Account Control (UAC) settings
3. Verify antivirus isn't blocking operations
4. Close other system utilities that might conflict

#### "System Restore Point Failed"
**Symptoms**: Error when creating restore point
**Solutions**:
1. Enable System Restore on C: drive
2. Free up disk space (need at least 1GB)
3. Run Disk Cleanup to clear space
4. Check if System Restore service is running

#### "PowerShell Errors"
**Symptoms**: PowerShell commands fail
**Solutions**:
1. Update to PowerShell 5.0 or higher
2. Install Windows Management Framework
3. Check execution policy settings
4. Run Windows Update for latest PowerShell

### Getting Help

If you encounter issues not covered here:

1. **Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** for detailed solutions
2. **Review the [README.md](README.md)** for comprehensive information
3. **Visit GitHub Issues** to report bugs or ask questions
4. **Check community forums** for user discussions

## 🔄 Updating Win-Tweak

### Checking for Updates
1. Visit the GitHub repository regularly
2. Check the releases page for new versions
3. Review CHANGELOG.md for new features

### Update Process
1. **Backup current settings**: Keep your existing backup files
2. **Download new version**: Get the latest release
3. **Replace script file**: Overwrite Win-Tweak.bat with new version
4. **Keep configuration**: Preserve any custom settings or backups

## 🛡️ Security Considerations

### File Verification
- **Always download from official sources**
- **Verify file checksums if provided**
- **Scan files with antivirus before running**
- **Check digital signatures when available**

### Execution Safety
- **Run only on systems you own**
- **Never run on production servers without testing**
- **Keep backups of critical data**
- **Have recovery plans ready**

### Network Security
- **Visual C++ downloads**: Only from TechPowerUp (trusted source)
- **No data transmission**: Script doesn't send data anywhere
- **Local operations only**: All changes are made locally

## 📞 Support Resources

### Documentation
- **README.md**: Comprehensive feature guide
- **TROUBLESHOOTING.md**: Detailed problem-solving guide
- **CONTRIBUTING.md**: Guidelines for contributing
- **CHANGELOG.md**: Version history and changes

### Community
- **GitHub Issues**: Bug reports and feature requests
- **Discussions**: General questions and community help
- **Wiki**: Community-maintained tips and tricks

### Emergency Recovery
- **System Restore**: Use created restore points
- **Registry Import**: Import backup .reg files
- **Default Restoration**: Use Win-Tweak Option [6]
- **Manual Recovery**: Re-enable services via services.msc

---

**Remember**: Win-Tweak is a powerful tool that modifies system settings. Always proceed with caution, create backups, and test on non-critical systems first.