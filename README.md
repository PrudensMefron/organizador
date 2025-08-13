# Downloads Organizer - Cross-Platform

A bash script that automatically organizes files in your Downloads folder by type. Now supports both Windows and Ubuntu/Linux environments with smart folder creation and command-line arguments.

## ✨ New Features (v2.0)

- **🌐 Cross-Platform Support**: Works on Ubuntu/Linux and Windows
- **📁 Smart Folder Creation**: Only creates folders when files of that type exist
- **⚙️ Command Line Arguments**: Pass custom download paths or use OS defaults
- **🐧 Linux-Specific Support**: Special handling for .deb, .AppImage, and binaries
- **📋 Help System**: Built-in usage instructions
- **🔍 Enhanced Logging**: Shows OS detection and parameters

## Files Created

1. **`organize.sh`** - Main bash script that performs the file organization
2. **`organize.bat`** - Windows batch wrapper that can run the bash script
3. **`setup_scheduler.ps1`** - PowerShell script to create a Windows scheduled task
4. **`README.md`** - This instruction file

## 🚀 Cross-Platform Usage

### Default Behavior (Automatic OS Detection)

```bash
# Ubuntu/Linux - uses ~/Downloads
./organize.sh

# Windows (Git Bash/WSL) - uses /c/Users/user/Downloads
./organize.sh
```

### Custom Folder Path

```bash
# Organize any folder you specify
./organize.sh /home/user/MyDownloads
./organize.sh ~/Desktop
./organize.sh /path/to/any/folder
```

### Help & Usage

```bash
./organize.sh --help
./organize.sh -h
```

## File Organization

The script organizes files into these folders within your Downloads directory:

### 🐧 **Linux-Specific** (NEW)

- **`.deb/`** - Debian packages (\*.deb)
- **`.exe/`** - Windows executables (\*.exe)
- **`.binaries/`** - Linux executables (_.AppImage, _.appimage, _.bin, _.out, \*.elf)

### 📊 **Data & Spreadsheets**

- **`.csv and excels/`** - CSV, XLSX, XLS files
- **`.json files/`** - JSON files
- **`.data files/`** - Database files (_.db, _.sqlite, _.mdb, _.tsv, \*.parquet)

### 🎬 **Media Files**

- **`.video files/`** - All video formats (_.mp4, _.mov, _.avi, _.mkv, _.webm, _.flv, etc.)
- **`.audio files/`** - All audio formats (_.mp3, _.m4a, _.wav, _.ogg, _.flac, _.aac, etc.)
- **`.image files/`** - All image formats (_.png, _.jpg, _.gif, _.svg, _.tiff, _.psd, etc.)

### 📄 **Documents & Text**

- **`.pdf files/`** - PDF documents
- **`.document files/`** - Office docs (_.docx, _.doc, _.pptx, _.odt, _.pages, _.tex, etc.)
- **`.text files/`** - Plain text files (_.txt, _.md, _.log, _.cfg, _.conf, _.ini)
- **`.email files/`** - Email files (_.eml, _.msg, \*.pst)
- **`.ebook files/`** - E-books (_.epub, _.mobi, _.azw, _.fb2)

### 🗜️ **Archives & Compressed**

- **`.zip files/`** - ZIP archives
- **`.archive files/`** - All other archives (_.rar, _.7z, _.tar, _.gz, _.bz2, _.lzma, etc.)

### ⚙️ **System & Software**

- **`.setup files/`** - Installers (_.msi, _.rpm, _.dmg, _.pkg, _.run, _.flatpak, \*.snap)
- **`.system files/`** - System files (_.iso, _.img, _.desktop, _.service, certificates, etc.)
- **`.font files/`** - Font files (_.ttf, _.otf, _.woff, _.woff2)

### 💻 **Development** (NEW)

- **`.code files/`** - Source code (_.py, _.js, _.html, _.css, _.php, _.java, _.cpp, _.go, etc.)
- **`.cad files/`** - CAD/3D files (_.dwg, _.dxf, _.stl, _.obj, \*.blend, etc.)

## Setup Instructions

### Option 1: Manual Execution

```bash
# Run the bash script directly
C:/path/to/organize.sh

# Or run the Windows batch file
C:/path/to/organize.bat
```

### Option 2: Automated Scheduling (Recommended)

#### **Windows:**

1. **Right-click** on `setup_scheduler.ps1`
2. Select **"Run with PowerShell"** or **"Run as Administrator"**
3. Follow the prompts to create the scheduled task

**OR** manually run in PowerShell as Administrator:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
C:\path\to\setup_scheduler.ps1
```

#### **Ubuntu/Linux (crontab):**

```bash
# Edit your crontab
crontab -e

# Add one of these lines:
# Run every 15 minutes
*/15 * * * * /path/to/organize.sh

# Run every hour
0 * * * * /path/to/organize.sh

# Run at startup
@reboot /path/to/organize.sh
```

### What Automation Does:

- ✅ **Windows**: Runs every 15 minutes + at startup
- ✅ **Linux**: Runs based on your cron schedule
- ✅ Automatically detects and uses correct Downloads folder
- ✅ Creates organized folders only when needed
- ✅ Logs all activities with timestamps
- ✅ Works silently in the background

## Monitoring

### Check Logs

View the log file to see what files have been organized:

**Linux/Ubuntu:**

```bash
tail -f ~/organize.log
# or
cat ~/organize.log
```

**Windows:**

```
C:\user\organize.log
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

**Linux:**

- Make sure script is executable: `chmod +x organize.sh`
- Check the log file: `cat ~/organize.log`
- Verify cron job: `crontab -l`

**Windows:**

- Ensure you have Git for Windows or WSL installed
- Check the log file at `D:\Marcelo\organize.log`
- Verify the scheduled task exists in Task Scheduler

### Permission Issues

**Linux:**

- Ensure read/write permissions: `ls -la ~/Downloads`
- Make script executable: `chmod +x organize.sh`

**Windows:**

- Run PowerShell as Administrator when setting up the scheduled task
- Ensure the batch file has execute permissions

### Files Not Moving

- **Check Downloads folder exists**:
  - Linux: `ls -la ~/Downloads`
  - Windows: Check `C:\Users\YourUser\Downloads`
- **Verify file extensions match patterns in script**
- **Check log file for error messages**
- **Test manually**: Run `./organize.sh --help` first

### Common Issues

- **"Command not found"**: Make sure you're in the script directory or use full path
- **"Permission denied"**: Run `chmod +x organize.sh`
- **"No such file or directory"**: Verify Downloads folder path is correct
- **Files not organized**: Check if file extensions match the patterns in script

## Customization

To modify which file types are organized or add new categories:

1. Edit `organize.sh`
2. Add new file patterns and target directories
3. Update the move commands at the bottom of the script

## Support

If you encounter issues:

1. Check the log file first
2. Verify all paths are correct
3. Ensure required software (Git/WSL) is installed
4. Run the script manually to test functionality
