# Changelog
<!-- updated: 2026-05-09 -->

## [1.2.0] - 2026-05-09

### Fixed
- **ocr.swift semaphore bug**: `try? handler.perform([request])` could throw silently, preventing the semaphore from signaling and causing OCR to return empty results. Fixed with proper try-catch that always signals the semaphore.
- **analyze-image.sh error handling**: OCR call was discarding stderr with `2>/dev/null` and not properly capturing exit codes. Changed to `2>&1; exit ${PIPESTATUS[0]}` to properly capture errors.
- **Both tools now run simultaneously**: Previously OCR ran only if mmx-cli failed. Now both MiniMax Vision AI and Swift OCR run in parallel — OCR always runs, and mmx-cli runs if available.

### Changed
- OCR section now always prints even if mmx-cli is not installed (shows install hint instead of failing)
- Error messages now visible instead of being swallowed

## [1.1.0] - 2026-05-09

### Added
- Project-level MEMORY.md integration via hook - auto-adds skill directive on first image analysis
- Global npm install of mmx-cli (`sudo npm install -g mmx-cli`)

### Changed
- MiniMax Vision AI runs first, OCR is fallback

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
