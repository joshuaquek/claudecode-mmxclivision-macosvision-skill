# Changelog
<!-- updated: 2026-05-08_19:30:00 -->

## [1.0.0] - 2026-05-08

### Added
- Initial release
- `analyze-image.sh` - Main analysis script
- `ocr.swift` - Swift Vision framework OCR
- `analyze-image-on-url.sh` - Claude Code UserPromptSubmit hook
- `install.sh` - Wizard installer
- Comprehensive documentation

### Features
- Pure macOS CLI image analysis (no external dependencies)
- MiniMax Vision AI integration for visual descriptions
- Built-in Swift OCR for text extraction
- Automatic image URL detection in Claude Code messages
- Uploaded image detection (auto-detects when images are pasted/uploaded)
- Local file path detection
- Metadata extraction (file type, dimensions, EXIF, color profile)
- Thumbnail generation via qlmanage

### Requirements
- macOS (Darwin)
- Claude Code
- Optional: MiniMax API key for vision AI
