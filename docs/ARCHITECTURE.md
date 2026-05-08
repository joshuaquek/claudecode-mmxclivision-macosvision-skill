# Architecture
<!-- updated: 2026-05-08_19:30:00 -->

## Overview

This skill enables image analysis for Claude Code by combining:
- Built-in macOS tools for metadata and OCR
- MiniMax Vision AI for visual understanding
- Claude Code hooks for automatic intercept

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      User Message                             │
│  "describe this image: https://example.com/screenshot.png"   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│               Claude Code UserPromptSubmit Hook               │
│              (analyze-image-on-url.sh)                       │
│                                                              │
│  1. Parse JSON input to find image URLs                       │
│  2. For each URL, run analyze-image.sh                       │
│  3. Prepend analysis to prompt                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   analyze-image.sh                            │
│                                                              │
│  1. Download image to temp directory                          │
│  2. Extract metadata (file, sips, mdls)                       │
│  3. Call mmx-cli vision (if configured)                      │
│  4. Call ocr.swift for text extraction                        │
│  5. Return structured report                                 │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────────┐
│   mmx-cli (MiniMax)     │     │      ocr.swift             │
│                         │     │                             │
│  Vision AI Description  │     │  Swift Vision Framework    │
│  - Uses MiniMax API     │     │  - Local OCR               │
│  - Internet required    │     │  - No external deps        │
│  - Visual understanding │     │  - Text extraction only     │
└─────────────────────────┘     └─────────────────────────────┘
```

## File Structure

```
~/.claude/
├── skills/
│   └── analyze-image/
│       ├── analyze-image.sh    # Main orchestrator
│       └── ocr.swift           # Swift Vision OCR
├── hooks/
│   └── analyze-image-on-url.sh # UserPromptSubmit hook
└── settings.json               # Hook registration

~/.mmx/
└── config.json                 # MiniMax API key (if configured)
```

## Data Flow

### Image URL Detection (Hook)
```bash
# Regex pattern for image URLs:
https?://[^[:space:]]+\.(png|jpg|jpeg|gif|webp|bmp|tiff)(\?[^[:space:]]*)?
```

### Download & Analysis Flow
```bash
1. curl --url "$url" --output "$temp/image.png"
   │
2. file "$image"                    # File type info
   ├─ sips -g pixelHeight/Width    # Dimensions
   ├─ mdls "$image"                 # Spotlight metadata
   ├─ sips -g exif:*               # EXIF data
   ├─ qlmanage -t -s 400           # Thumbnail
   ├─ sips -g profile              # Color profile
   │
3. mmx-cli vision describe --file "$image"   # AI description
   │
4. swift ocr.swift "$image"        # OCR text extraction
```

## Key Design Decisions

### Why Bash + Swift?
- Bash for orchestration (download, pipes, file ops)
- Swift for Vision framework access (native macOS OCR)
- No external dependencies beyond what's built into macOS

### Why Two Analysis Methods?
- MiniMax Vision: Full visual understanding, requires API
- Swift OCR: Local, fast, no API needed, only text extraction
- Users can have basic functionality without API key

### Why Hook-Based?
- Automatic - no manual /analyze-image command needed
- Seamless - image analysis appears before user message
- Transparent - users don't need to know the mechanics

## Security Considerations

1. **API Key Storage**: Stored in `~/.mmx/config.json`, not in repo
2. **Temp Files**: Cleaned up automatically via trap
3. **URL Validation**: Only processes URLs with image extensions
4. **No Code Execution**: Hook only runs analyze-image.sh, not arbitrary code
