#!/bin/bash
# analyze-image.sh - Pure macOS CLI image analysis (NO external dependencies)
# Uses only built-in macOS tools: sips, mdls, file, curl, qlmanage

set -e

# -------- Configuration --------
TEMP_DIR="${TMPDIR:-/tmp}/claude-image-analysis-$$"
IMAGE_PATH=""
SOURCE_URL=""

# -------- Helper Functions --------

log() {
    echo "[analyze-image] $1" >&2
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# -------- Download Image --------

download_image() {
    local url="$1"
    local extension=""

    mkdir -p "$TEMP_DIR"

    # Detect extension from URL or default to .png
    if [[ "$url" =~ \.(png|jpg|jpeg|gif|webp|bmp|tiff)(\?|$) ]]; then
        extension=$(echo "$url" | grep -oE '\.(png|jpg|jpeg|gif|webp|bmp|tiff)' | head -1)
    else
        extension=".png"
    fi

    IMAGE_PATH="$TEMP_DIR/image$$$extension"

    log "Downloading from: $url"
    curl --silent --location --fail --output "$IMAGE_PATH" --url "$url" || {
        echo "ERROR: Failed to download image" >&2
        exit 1
    }

    SOURCE_URL="$url"
    log "Saved to: $IMAGE_PATH"
}

# -------- Analyze Image --------

analyze_image() {
    local path="$1"

    echo ""
    echo "IMAGE ANALYSIS REPORT"
    echo "===================="
    echo ""

    echo "Source: ${SOURCE_URL:-local file}"
    echo "Path: $path"
    echo ""

    # --- Basic file type ---
    echo "=== File Info ==="
    file "$path"
    echo ""

    # --- Dimensions and format via sips ---
    echo "=== Image Properties ==="
    sips -g pixelHeight -g pixelWidth -g format -g colorSpace "$path" 2>/dev/null || true
    echo ""

    # --- File size ---
    echo "=== File Size ==="
    local size
    size=$(stat -f%z "$path" 2>/dev/null || stat -c%s "$path" 2>/dev/null || echo "unknown")
    if [[ "$size" != "unknown" ]]; then
        echo "$(( size / 1024 )) KB ($size bytes)"
    else
        echo "Unknown"
    fi
    echo ""

    # --- Spotlight/metadata via mdls ---
    echo "=== Spotlight Metadata ==="
    mdls "$path" 2>/dev/null | grep -E "^\s+(\w+:)" | grep -v "(null)" | head -30 || echo "No metadata found"
    echo ""

    # --- EXIF via sips ---
    echo "=== EXIF Data ==="
    sips -g exif:* "$path" 2>/dev/null | grep -v "^---\|^$" | head -40 || echo "No EXIF data"
    echo ""

    # --- Generate thumbnail via qlmanage ---
    echo "=== Thumbnail ==="
    local thumb_path="$TEMP_DIR/thumb.jpg"
    qlmanage -t -s 400 -o "$TEMP_DIR" "$path" 2>/dev/null && echo "Thumbnail: $thumb_path" || echo "(thumbnail generation unavailable)"
    echo ""

    # --- Color profile info ---
    echo "=== Color Profile ==="
    sips -g profile "$path" 2>/dev/null | grep -i profile || echo "No embedded color profile"
    echo ""

    # --- MiniMax Vision (if mmx-cli config exists) ---
    if [[ -f "$HOME/.mmx/config.json" ]]; then
        echo "=== MiniMax Vision AI Description ==="
        local mmx_desc
        mmx_desc=$(npx -y mmx-cli vision describe --file "$path" 2>/dev/null)
        if [[ $? -eq 0 && -n "$mmx_desc" && "$mmx_desc" != *"error"* ]]; then
            echo "$mmx_desc"
        else
            echo "(MiniMax vision failed)"
        fi
        echo ""
    fi

    # --- OCR via Swift Vision framework (fallback) ---
    echo "=== Extracted Text (OCR) ==="
    local ocr_text
    ocr_text=$(swift "$(dirname "$0")/ocr.swift" "$path" 2>/dev/null | grep -A 100 "EXTRACTED TEXT")
    if [[ -n "$ocr_text" ]]; then
        echo "$ocr_text"
    else
        echo "(No text detected or OCR failed)"
    fi
    echo ""
}

# -------- Main --------

main() {
    local input="$1"

    if [[ -z "$input" ]]; then
        echo "Usage: analyze-image.sh <image-url-or-path>" >&2
        echo "Example: analyze-image.sh https://example.com/screenshot.png" >&2
        exit 1
    fi

    if [[ "$input" =~ ^https?:// ]]; then
        download_image "$input"
        analyze_image "$IMAGE_PATH"
    else
        if [[ ! -f "$input" ]]; then
            echo "ERROR: File not found: $input" >&2
            exit 1
        fi
        IMAGE_PATH="$input"
        SOURCE_URL="local file"
        analyze_image "$IMAGE_PATH"
    fi
}

main "$@"
