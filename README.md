# Automatic File Organization System

This system automatically organizes files in `D:\Downloads\` by moving them to appropriate folders based on their file extensions.

## Files Created

1. **`organize_downloads.sh`** - Main bash script that performs the file organization
2. **`organize_downloads.bat`** - Windows batch wrapper that can run the bash script
3. **`setup_scheduler.ps1`** - PowerShell script to create a Windows scheduled task
4. **`README.md`** - This instruction file

## File Organization

The script organizes files into these folders within `D:\Downloads\`:

### 📊 **Data & Spreadsheets**
- **`.csv and excels/`** - CSV, XLSX, XLS files
- **`.json files/`** - JSON files

### 🎬 **Media Files**
- **`.video files/`** - MP4, MOV, AVI, MKV files
- **`.audio files/`** - MP3, M4A, WAV, OGG, OPUS files (includes playlists M3U8, M3U)
- **`.image files/`** - PNG, JPG, JPEG, GIF, BMP, SVG, WEBP, AI files

### 📄 **Documents & Text**
- **`.pdf files/`** - PDF documents
- **`.document files/`** - Word (DOCX, DOC), PowerPoint (PPTX, PPT), RTF, ODT files
- **`.text files/`** - TXT, MD, LOG, CFG, CONF, INI files
- **`.email files/`** - EML, MSG, PST files

### 🗜️ **Archives & Compressed**
- **`.zip files/`** - ZIP archives
- **`.archive files/`** - RAR, 7Z, TAR, GZ, BZ2, XZ files

### ⚙️ **System & Software**
- **`.setup files/`** - EXE, MSI, DEB, RPM, DMG, PKG installers
- **`.system files/`** - ISO, IMG, BIN, DLL, SYS files, encrypted files (ENC, PLGX)
- **`.font files/`** - TTF, OTF, WOFF, WOFF2, EOT files

## Setup Instructions

### Option 1: Manual Execution
```bash
# Run the bash script directly
/d/Marcelo/organize_downloads.sh

# Or run the Windows batch file
D:\Marcelo\organize_downloads.bat
```

### Option 2: Automated Scheduling (Recommended)

1. **Right-click** on `setup_scheduler.ps1`
2. Select **"Run with PowerShell"** or **"Run as Administrator"**
3. Follow the prompts to create the scheduled task

**OR** manually run in PowerShell as Administrator:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
D:\Marcelo\setup_scheduler.ps1
```

### What the Scheduled Task Does:
- ✅ Runs every **15 minutes**
- ✅ Runs at **system startup**
- ✅ Organizes files in `D:\Downloads\`
- ✅ Logs all activities to `D:\Marcelo\organize_downloads.log`
- ✅ Works in the background silently

## Monitoring

### Check Logs
View the log file to see what files have been organized:
```
D:\Marcelo\organize_downloads.log
```

### Task Manager
You can see the scheduled task in:
- **Task Scheduler** → **Task Scheduler Library** → **OrganizeDownloads**

### Manual Task Control
```bash
# Start the task manually
Start-ScheduledTask -TaskName "OrganizeDownloads"

# Stop the task
Stop-ScheduledTask -TaskName "OrganizeDownloads"

# Remove the task
Unregister-ScheduledTask -TaskName "OrganizeDownloads"
```

## Requirements

The system requires one of the following to run bash scripts on Windows:

1. **Git for Windows** (Recommended) - Installs Git Bash
2. **Windows Subsystem for Linux (WSL)**
3. **MSYS2**

Most systems with Git installed will work automatically.

## Troubleshooting

### Script Not Running
- Ensure you have Git for Windows or WSL installed
- Check the log file at `D:\Marcelo\organize_downloads.log`
- Verify the scheduled task exists in Task Scheduler

### Permission Issues
- Run PowerShell as Administrator when setting up the scheduled task
- Ensure the batch file has execute permissions

### Files Not Moving
- Check that the source directory `D:\Downloads\` exists
- Verify file extensions match the patterns in the script
- Check the log file for error messages

## Customization

To modify which file types are organized or add new categories:

1. Edit `organize_downloads.sh`
2. Add new file patterns and target directories
3. Update the move commands at the bottom of the script

## Support

If you encounter issues:
1. Check the log file first
2. Verify all paths are correct
3. Ensure required software (Git/WSL) is installed
4. Run the script manually to test functionality
