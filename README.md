# Win-Tweak: Windows Tweaker & Backup Tool

Win-Tweak is a comprehensive Windows batch script for system optimization, backup, and restoration. The script should be named `Win-Tweak.bat` for clarity. Version 15.0 is the final GitHub release, featuring a complete Copilot disable policy and menu-driven interface for applying performance tweaks, creating system restore points, performing full registry backups, installing Visual C++ runtimes, and restoring default Windows settings.

## Main Features

### 🔧 **System Optimization & Tweaks**
- **Standard Optimizations**: Recommended for most PCs with balanced performance improvements
- **Aggressive Optimizations**: Designed for low-end PCs requiring maximum performance
- **UI & Performance Tweaks**: Menu delay customization, power plan optimization, startup delay removal
- **Service Management**: Disable/enable system services (SysMain, Windows Search, Telemetry)
- **Visual Effects**: Configure for best performance or balanced settings
- **Advanced Tweaks**: Memory management, CPU priority, filesystem cache optimization

### 📋 **Menu Options**
1. **Create System Restore Point ONLY** - Quick backup before making changes
2. **Apply System Optimizations & Tweaks** - Choose between Standard or Aggressive modes
3. **Install Visual C++ Runtimes** - Guided download and installation from TechPowerUp
4. **Perform FULL Registry Backup ONLY** - Complete registry export to Desktop
5. **ALL Operations** - Backup + Restore Point + Optimizations + Runtimes
6. **Restore Default Windows Settings** - Revert all tweaks and reinstall default apps
7. **Exit** - Close the application

### 🛡️ **Backup & Safety Features**
- **Automatic Administrator Check**: Self-elevates to admin privileges
- **System Restore Points**: Creates restore points with date stamps
- **Registry Backups**: Both targeted and full registry exports
- **Restoration Capability**: Complete rollback of all applied tweaks

## Detailed Functionality

### UI & Performance Optimizations
- **Menu Delay Configuration**: Customize menu response time (50ms for fast, 400ms default)
- **Power Plan Optimization**: Switch to Ultimate or High Performance modes
- **Startup Delay Removal**: Eliminate program startup delays
- **Search Enhancements**: Disable search highlights and web suggestions
- **Taskbar Customization**: Show seconds in clock, disable widgets, enable "End Task"
- **Copilot Management**: Complete disable via Windows policy

### Service & System Tweaks
- **SysMain (Superfetch)**: Stop and disable for reduced background activity
- **Windows Search**: Disable indexing service for performance
- **Telemetry Service**: Stop DiagTrack for privacy
- **Hibernation Control**: Enable/disable based on current state
- **Verbose Status**: Enable detailed boot/shutdown messages
- **Svchost Optimization**: Improve process splitting for better resource usage

### Advanced Performance Tweaks
- **Filesystem Cache**: Increase cache size for better I/O performance
- **CPU Priority**: Optimize priority separation for foreground applications
- **Shutdown Speed**: Reduce application and service timeout values
- **Background Apps**: Disable all background app permissions (aggressive mode)
- **Filesystem Behavior**: Optimize last access time and 8.3 naming

### App Removal Tool
Interactive removal of unnecessary Windows apps including:
- **Gaming & Media**: Xbox apps, 3D Viewer, Clipchamp, Movies & TV
- **Productivity**: Mail/Calendar, People, Teams, Phone Link, To Do, Sticky Notes
- **System Utilities**: Alarms & Clock, Maps, Voice Recorder
- **Other Components**: News, Feedback Hub, Solitaire, OneDrive
- **Critical Apps**: Calculator, Photos (with warnings)

### Visual C++ Runtime Installation
- **Guided Download**: Opens TechPowerUp download page
- **Automatic Detection**: Finds downloaded files in Downloads folder
- **Installation Management**: Extracts and runs installer with cleanup options
- **Progress Tracking**: Step-by-step installation guidance

## File Structure

### Main Script: `Win-Tweak.bat`
- **Version**: 15.0 (Final GitHub Release)
- **Size**: Comprehensive batch script with multiple functions
- **Safety**: Includes error handling and confirmation prompts

### Generated Backup Files
The script creates various backup files in the same directory:
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

### Full Registry Backup
Creates a timestamped folder on Desktop containing:
- `Backup_HKCR.reg` - HKEY_CLASSES_ROOT
- `Backup_HKCU.reg` - HKEY_CURRENT_USER
- `Backup_HKLM.reg` - HKEY_LOCAL_MACHINE
- `Backup_HKU.reg` - HKEY_USERS
- `Backup_HKCC.reg` - HKEY_CURRENT_CONFIG

## Usage Instructions

### Prerequisites
- Windows 10/11 operating system
- Administrator privileges (script auto-elevates)
- Internet connection (for Visual C++ runtime download)

### Running the Script
1. **Download**: Save the script file to your preferred location
2. **Execute**: Double-click `Win-Tweak.bat` or run from command prompt
3. **Elevation**: Allow administrator privileges when prompted
4. **Navigate**: Use the numbered menu system to select operations
5. **Follow Prompts**: Answer Y/N questions based on your preferences

### Safety Recommendations
1. **Always create a restore point** before applying tweaks
2. **Read each prompt carefully** - some changes are irreversible
3. **Start with Standard optimizations** before trying Aggressive mode
4. **Keep backup files** until you're satisfied with changes
5. **Test system stability** after applying optimizations

### Restoration Process
The script includes comprehensive restoration capabilities:
- **Registry Restoration**: Import backup .reg files to restore settings
- **Default Settings**: Built-in function to restore Windows defaults
- **App Reinstallation**: Automatic reinstallation of removed Windows apps
- **Service Recovery**: Restore disabled services to default states

## Technical Details

### Registry Modifications
The script modifies various registry keys for optimization:
- **HKCU\Control Panel\Desktop**: Menu delays, timeouts
- **HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer**: UI settings
- **HKLM\SYSTEM\CurrentControlSet\Control**: System-wide settings
- **HKCU\Software\Policies\Microsoft\Windows**: Policy configurations

### Service Management
Uses Windows Service Control (sc) commands to:
- Stop and disable unnecessary services
- Configure service startup types
- Manage Xbox, print, and telemetry services

### PowerShell Integration
Incorporates PowerShell for:
- App package removal (Get-AppxPackage)
- System restore point creation (Checkpoint-Computer)
- Archive extraction (Expand-Archive)
- App reinstallation during restoration

## Compatibility & Requirements
- **Operating Systems**: Windows 10, Windows 11
- **Architecture**: x86, x64
- **Privileges**: Administrator rights required
- **Dependencies**: PowerShell (included in modern Windows)
- **Disk Space**: Minimal (backups require additional space)

## Safety & Warnings

### ⚠️ **Important Disclaimers**
- **Use at your own risk**: System modifications can affect stability
- **Backup essential data**: Always backup important files before running
- **Test in VM first**: Consider testing in a virtual machine environment
- **Administrator required**: Script must run with elevated privileges
- **System-specific**: Some tweaks may not work on all Windows configurations

### 🔒 **Security Considerations**
- **PowerShell Execution**: Script uses PowerShell for advanced operations
- **Registry Modifications**: Makes extensive registry changes
- **Service Management**: Modifies Windows services and startup behavior
- **App Removal**: Permanently removes Windows Store applications
- **Network Access**: Downloads Visual C++ runtimes from external source

## Troubleshooting

### Common Issues
1. **Script won't run**: Ensure administrator privileges and PowerShell is enabled
2. **Restore point fails**: Check if System Restore is enabled on C: drive
3. **Apps won't remove**: Some system apps are protected and cannot be uninstalled
4. **Performance issues**: Use restoration feature to revert changes
5. **Service errors**: Some services may be dependencies for others

### Recovery Options
- **System Restore**: Use Windows System Restore to revert to pre-script state
- **Registry Import**: Import backup .reg files to restore specific settings
- **Default Restoration**: Use built-in menu option 6 to restore defaults
- **Manual Recovery**: Manually re-enable services via services.msc

## Version History

### Version 15.0 (Final GitHub Release)
- **New**: Complete Copilot disable via Windows policy
- **Improved**: More effective Copilot removal from user experience
- **Status**: Feature-complete and production-ready
- **Note**: This is the final version planned for GitHub release

### Key Changes from Previous Versions
- Enhanced Copilot management capabilities
- Improved error handling and user feedback
- Comprehensive backup and restoration features
- Streamlined Visual C++ runtime installation process

## Advanced Usage

### Command-Line Integration
While primarily menu-driven, the script can be integrated into larger automation workflows:
- Place in startup scripts for automated optimization
- Include in system deployment processes
- Use with task scheduling for regular maintenance

### Customization Options
Users can modify the script to:
- Adjust timeout values for their specific needs
- Add additional registry tweaks
- Customize the app removal list
- Modify service management preferences

### Batch Processing
The "ALL" option (menu choice 5) provides:
- Automated workflow execution
- Minimal user intervention required
- Complete system optimization in one process
- Ideal for new system setup or major maintenance

## Support & Resources

### Learning Resources
- **Windows Registry**: Understanding registry structure and safety
- **PowerShell Basics**: Learning PowerShell for system administration
- **Windows Services**: Understanding Windows service dependencies
- **System Restore**: Creating and managing restore points

### Community Guidelines
- **Share experiences**: Document what works for your system configuration
- **Report issues**: Provide detailed error messages and system information
- **Suggest improvements**: Propose new features or optimizations
- **Help others**: Share troubleshooting solutions

## Technical Requirements

### System Specifications
- **Minimum RAM**: 4GB (8GB recommended for aggressive optimizations)
- **Storage Space**: 100MB free for backups and temporary files
- **Processor**: Any x86/x64 compatible processor
- **Network**: Internet connection for Visual C++ runtime download

### Software Dependencies
- **Windows PowerShell**: Version 5.0 or higher (included in Windows 10/11)
- **Windows Management Framework**: For advanced system operations
- **Registry Editor**: For manual recovery if needed
- **.NET Framework**: For some PowerShell operations

## Legal & Compliance

### Usage Rights
- **Personal Use**: Free for personal and educational use
- **Commercial Use**: Evaluate licensing requirements for business environments
- **Modification**: Users may modify for personal use
- **Distribution**: Follow repository licensing terms

## Credits & Acknowledgments

### Development
- **Script Generation**: Win-Tweak.bat generated by Gemini 2.5 Pro AI
- **Project Maintainer**: Repository organization and documentation
- **Community Input**: Inspired by community best practices for Windows optimization
- **Version Control**: Maintained on GitHub for public access and collaboration
- **Testing**: Extensively tested across multiple Windows 10/11 configurations

### External Resources
- **Visual C++ Runtimes**: Courtesy of TechPowerUp's All-in-One package
- **Windows APIs**: Utilizes Microsoft's documented registry and service interfaces
- **PowerShell Framework**: Built on Microsoft PowerShell infrastructure
- **Community Feedback**: Incorporates user suggestions and bug reports

### Special Thanks
- Windows optimization community for shared knowledge
- Beta testers who provided valuable feedback
- Documentation contributors and technical reviewers
- Users who reported issues and suggested improvements

## License & Legal

### Open Source License
This project is released under an open source license. See [LICENSE](LICENSE) file for complete terms and conditions.

### Terms of Use
- **Warranty Disclaimer**: Provided "as-is" without warranties of any kind
- **Liability Limitation**: Authors not responsible for system damage or data loss
- **Modification Rights**: Users may modify for personal use
- **Attribution**: Credit original authors when redistributing

### Third-Party Components
- **TechPowerUp**: Visual C++ runtime package source
- **Microsoft**: Windows APIs and PowerShell framework
- **Community Scripts**: Inspiration from various Windows optimization scripts
