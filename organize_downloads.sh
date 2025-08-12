#!/bin/bash

# File Organizer Script
# Automatically organizes files in /d/Downloads/ by type
# Created: $(date)
# Author: Assistant

# Set the downloads directory
DOWNLOADS_DIR="/d/Downloads"
LOG_FILE="/d/Marcelo/organize_downloads.log"

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

# Move setup/installer files
move_multiple_types "" "$SETUP_DIR" "setup/installer" "*.exe" "*.msi" "*.deb" "*.rpm" "*.dmg" "*.pkg"

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

log_message "=== File organization completed ==="
log_message ""
