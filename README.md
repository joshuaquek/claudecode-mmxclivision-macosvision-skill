# ClaudeCode MiniMax Vision + macOS Vision Skill

Enable image analysis for text-only Claude Code models using MiniMax Vision AI and built-in macOS tools.

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill.git
cd claudecode-mmxclivision-macosvision-skill
chmod +x install.sh
./install.sh
```

Then restart Claude Code.

## What It Does

Works with **image URLs, uploaded images, and local file paths**:

1. **Image URLs** - `https://example.com/screenshot.png`
2. **Uploaded images** - Just paste or upload an image in Claude Code
3. **Local paths** - `/path/to/image.png`

The hook automatically detects images, analyzes them, and injects results before your message.

**Example (URL):**
```
Look at this image: https://example.com/screenshot.png
```

**Automatically becomes:**
```
=== IMAGE ANALYSIS ===
Source: screenshot.png
Dimensions: 1200 x 800

MiniMax Vision AI Description:
A screenshot showing a terminal window with...

=== Extracted Text (OCR) ===
git status
npm run build
./deploy.sh

---
Original user request:
Look at this image: https://example.com/screenshot.png
```

**Example (upload):**
Just drag & drop or paste an image and ask your question. The hook detects the upload and analyzes it automatically — no commands needed.

## Features

| Feature | Description |
|---------|-------------|
| **AI Vision** | Detailed image descriptions (requires MiniMax API) |
| **OCR** | Extract text from screenshots (works offline) |
| **Metadata** | File type, dimensions, EXIF, color profile |
| **Auto-Hook** | Detects URLs, uploads, and local paths automatically |
| **Offline Mode** | OCR works without internet or API key |

## Requirements

- macOS
- Claude Code

## Optional: MiniMax API Key

Without an API key, OCR text extraction still works. To enable AI vision descriptions:

1. Get a MiniMax API key
2. Run: `npx mmx-cli config set api-key YOUR_KEY`

## Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Capabilities](docs/CAPABILITIES.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Architecture](docs/ARCHITECTURE.md)

## License

MIT
