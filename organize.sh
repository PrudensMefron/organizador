#!/bin/bash

# File Organizer Script
# Automatically organizes files in Downloads folder by type
# Cross-platform support for Windows and Ubuntu/Linux
# Created: $(date)
# Author: Assistant

# Function to show usage information
show_usage() {
    echo "Usage: $0 [downloads_path]"
    echo "       $0 -h | --help"
    echo ""
    echo "Automatically organizes files in Downloads folder by type."
    echo "Cross-platform support for Windows and Ubuntu/Linux."
    echo ""
    echo "Arguments:"
    echo "  downloads_path    Optional: Path to downloads folder"
    echo "                   Default: ~/Downloads (Linux) or C:/Users/user/Downloads (Windows)"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                          # Use default Downloads folder"
    echo "  $0 /home/user/MyDownloads   # Use custom folder"
    echo "  $0 ~/Desktop                # Organize Desktop files"
}

# Check for help argument
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Function to detect OS and set default paths
detect_os_and_set_defaults() {
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ -n "$WINDIR" ]]; then
        # Windows environment
        OS_TYPE="Windows"
        DEFAULT_DOWNLOADS="/c/Users/$USER/Downloads"
        DEFAULT_LOG_DIR="/d/Marcelo"
    else
        # Linux/Unix environment (including Ubuntu)
        OS_TYPE="Linux"
        DEFAULT_DOWNLOADS="$HOME/Downloads"
        DEFAULT_LOG_DIR="$HOME"
    fi
}

# Detect OS and set defaults
detect_os_and_set_defaults

# Set the downloads directory (use argument if provided, otherwise use default)
if [ -n "$1" ]; then
    DOWNLOADS_DIR="$1"
else
    DOWNLOADS_DIR="$DEFAULT_DOWNLOADS"
fi

# Set log file location
LOG_FILE="$DEFAULT_LOG_DIR/organize.log"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to create directory if it doesn't exist
create_dir_if_not_exists() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        log_message "Created directory: $1"
    fi
}

# Function to move files of a specific type
move_files() {
    local file_pattern="$1"
    local target_dir="$2"
    local file_type_name="$3"
    
    # Count files before moving
    local count=$(find "$DOWNLOADS_DIR" -maxdepth 1 -name "$file_pattern" 2>/dev/null | wc -l)
    
    if [ "$count" -gt 0 ]; then
        create_dir_if_not_exists "$target_dir"
        find "$DOWNLOADS_DIR" -maxdepth 1 -name "$file_pattern" -exec mv {} "$target_dir/" \; 2>/dev/null
        log_message "Moved $count $file_type_name file(s) to $target_dir"
    fi
}

# Function to move multiple file types with one command
move_multiple_types() {
    local target_dir="$2"
    local file_type_name="$3"
    shift 3
    local patterns=("$@")
    
    # Build find command with multiple patterns
    local find_cmd="find \"$DOWNLOADS_DIR\" -maxdepth 1 \\("
    for i in "${!patterns[@]}"; do
        if [ $i -gt 0 ]; then
            find_cmd+=" -o"
        fi
        find_cmd+=" -name \"${patterns[$i]}\""
    done
    find_cmd+=" \\)"
    
    # Count files
    local count=$(eval "$find_cmd" 2>/dev/null | wc -l)
    
    if [ "$count" -gt 0 ]; then
        create_dir_if_not_exists "$target_dir"
        eval "$find_cmd -exec mv {} \"$target_dir/\" \\;" 2>/dev/null
        log_message "Moved $count $file_type_name file(s) to $target_dir"
    fi
}

# Start logging
log_message "=== Starting file organization ==="
log_message "Operating System detected: $OS_TYPE"
log_message "Downloads directory: $DOWNLOADS_DIR"
log_message "Log file: $LOG_FILE"

# Change to downloads directory
cd "$DOWNLOADS_DIR" || {
    log_message "ERROR: Cannot access downloads directory: $DOWNLOADS_DIR"
    exit 1
}

# Define target directories
CSV_DIR="$DOWNLOADS_DIR/.csv and excels"
JSON_DIR="$DOWNLOADS_DIR/.json files"
VIDEO_DIR="$DOWNLOADS_DIR/.video files"
AUDIO_DIR="$DOWNLOADS_DIR/.audio files"
ZIP_DIR="$DOWNLOADS_DIR/.zip files"
IMAGE_DIR="$DOWNLOADS_DIR/.image files"
PDF_DIR="$DOWNLOADS_DIR/.pdf files"
DOCUMENTS_DIR="$DOWNLOADS_DIR/.document files"
SETUP_DIR="$DOWNLOADS_DIR/.setup files"
FONTS_DIR="$DOWNLOADS_DIR/.font files"
ARCHIVE_DIR="$DOWNLOADS_DIR/.archive files"
SYSTEM_DIR="$DOWNLOADS_DIR/.system files"
EMAIL_DIR="$DOWNLOADS_DIR/.email files"
TEXT_DIR="$DOWNLOADS_DIR/.text files"
DEB_DIR="$DOWNLOADS_DIR/.deb"
EXE_DIR="$DOWNLOADS_DIR/.exe"
BINARIES_DIR="$DOWNLOADS_DIR/.binaries"
CODE_DIR="$DOWNLOADS_DIR/.code files"
CAD_DIR="$DOWNLOADS_DIR/.cad files"
E_BOOK_DIR="$DOWNLOADS_DIR/.ebook files"
DATA_DIR="$DOWNLOADS_DIR/.data files"

# Move CSV and Excel files
move_multiple_types "" "$CSV_DIR" "CSV/Excel" "*.csv" "*.xlsx" "*.xls"

# Move JSON files
move_files "*.json" "$JSON_DIR" "JSON"

# Move video files
move_multiple_types "" "$VIDEO_DIR" "video" "*.mp4" "*.mov" "*.avi" "*.mkv" "*.MOV"

# Move audio files
move_multiple_types "" "$AUDIO_DIR" "audio" "*.mp3" "*.m4a" "*.wav" "*.ogg" "*.opus" "*.waptt.opus"

# Move ZIP files
move_files "*.zip" "$ZIP_DIR" "ZIP"

# Move image files
move_multiple_types "" "$IMAGE_DIR" "image" "*.png" "*.jpg" "*.jpeg" "*.gif" "*.bmp" "*.svg" "*.webp" "*.ai" "*.JPG"

# Move PDF files
move_files "*.pdf" "$PDF_DIR" "PDF"

# Move document files (Word, PowerPoint, etc.)
move_multiple_types "" "$DOCUMENTS_DIR" "document" "*.docx" "*.doc" "*.pptx" "*.ppt" "*.rtf" "*.odt"

# Move setup/installer files (excluding .deb and .exe which have their own folders)
move_multiple_types "" "$SETUP_DIR" "setup/installer" "*.msi" "*.rpm" "*.dmg" "*.pkg" "*.run" "*.sh" "*.flatpak" "*.snap"

# Move font files
move_multiple_types "" "$FONTS_DIR" "font" "*.ttf" "*.otf" "*.woff" "*.woff2" "*.eot"

# Move archive files (not ZIP)
move_multiple_types "" "$ARCHIVE_DIR" "archive" "*.rar" "*.7z" "*.tar" "*.gz" "*.bz2" "*.xz" "*.tar.gz" "*.tar.bz2"

# Move system/ISO files
move_multiple_types "" "$SYSTEM_DIR" "system/ISO" "*.iso" "*.img" "*.bin" "*.dll" "*.sys"

# Move email files
move_multiple_types "" "$EMAIL_DIR" "email" "*.eml" "*.msg" "*.pst"

# Move text files
move_multiple_types "" "$TEXT_DIR" "text" "*.txt" "*.md" "*.log" "*.cfg" "*.conf" "*.ini"

# Move encrypted/secure files
move_multiple_types "" "$SYSTEM_DIR" "encrypted/plugin" "*.enc" "*.plgx" "*.key" "*.pem" "*.cert"

# Move playlist files
move_multiple_types "" "$AUDIO_DIR" "playlist" "*.m3u8" "*.m3u" "*.pls"

# Move .deb files (Debian packages)
move_files "*.deb" "$DEB_DIR" "DEB packages"

# Move .exe files (Windows executables)
move_files "*.exe" "$EXE_DIR" "Windows executables"

# Move binaries and executable files (Linux/Unix)
move_multiple_types "" "$BINARIES_DIR" "binary/executable" "*.AppImage" "*.appimage" "*.bin" "*.out" "*.elf"

# Move code/development files
move_multiple_types "" "$CODE_DIR" "code/development" "*.py" "*.js" "*.html" "*.css" "*.php" "*.java" "*.c" "*.cpp" "*.h" "*.hpp" "*.sh" "*.bash" "*.zsh" "*.sql" "*.xml" "*.yaml" "*.yml" "*.go" "*.rs" "*.rb" "*.pl" "*.lua" "*.r" "*.R" "*.scala" "*.kt" "*.swift" "*.dart" "*.vue" "*.tsx" "*.jsx" "*.ts" "*.cs" "*.vb" "*.ps1" "*.psm1" "*.bat" "*.cmd"

# Move CAD and 3D files
move_multiple_types "" "$CAD_DIR" "CAD/3D" "*.dwg" "*.dxf" "*.step" "*.stp" "*.iges" "*.igs" "*.stl" "*.obj" "*.fbx" "*.3ds" "*.blend" "*.max" "*.skp" "*.ipt" "*.prt" "*.sldprt" "*.sldasm" "*.catpart" "*.catproduct"

# Move e-book files
move_multiple_types "" "$E_BOOK_DIR" "e-book" "*.epub" "*.mobi" "*.azw" "*.azw3" "*.fb2" "*.lit" "*.pdb" "*.tcr" "*.prc"

# Move data/database files (excluding CSV which has its own folder)
move_multiple_types "" "$DATA_DIR" "data/database" "*.db" "*.sqlite" "*.sqlite3" "*.mdb" "*.accdb" "*.dbf" "*.sdf" "*.bak" "*.dump" "*.tsv" "*.parquet" "*.avro"

# Additional video formats (Linux/multimedia)
move_multiple_types "" "$VIDEO_DIR" "additional video" "*.webm" "*.flv" "*.3gp" "*.3g2" "*.m4v" "*.mpg" "*.mpeg" "*.m2v" "*.wmv" "*.asf" "*.rm" "*.rmvb" "*.vob" "*.ogv" "*.dv" "*.ts" "*.mts" "*.m2ts"

# Additional audio formats (Linux/multimedia)
move_multiple_types "" "$AUDIO_DIR" "additional audio" "*.flac" "*.ape" "*.wv" "*.aac" "*.ac3" "*.dts" "*.amr" "*.au" "*.ra" "*.wma" "*.aiff" "*.aif" "*.pcm"

# Additional image formats
move_multiple_types "" "$IMAGE_DIR" "additional image" "*.tiff" "*.tif" "*.ico" "*.icns" "*.psd" "*.xcf" "*.raw" "*.cr2" "*.nef" "*.arw" "*.dng" "*.orf" "*.rw2" "*.pef" "*.sr2" "*.x3f"

# Additional archive formats
move_multiple_types "" "$ARCHIVE_DIR" "additional archive" "*.lz" "*.lzma" "*.Z" "*.cab" "*.ace" "*.arj" "*.lha" "*.lzh" "*.zoo" "*.arc" "*.pak" "*.sit" "*.sitx" "*.sea" "*.hqx" "*.cpio"

# Configuration and system files (Linux)
move_multiple_types "" "$SYSTEM_DIR" "config/system" "*.desktop" "*.service" "*.timer" "*.mount" "*.automount" "*.socket" "*.target" "*.path" "*.slice" "*.scope" "*.swap" "*.device" "*.conf" "*.config" "*.rc"

# Additional document formats
move_multiple_types "" "$DOCUMENTS_DIR" "additional document" "*.pages" "*.numbers" "*.key" "*.keynote" "*.odp" "*.ods" "*.odg" "*.odf" "*.ott" "*.ots" "*.otp" "*.otg" "*.tex" "*.latex" "*.bib"

log_message "=== File organization completed ==="
log_message ""
