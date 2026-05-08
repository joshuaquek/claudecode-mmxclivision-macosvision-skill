---
name: analyze-image
description: Analyze images using macOS Vision framework for OCR and MiniMax Vision AI for visual description. Always runs both tools in parallel — OCR for text extraction, mmx-cli for visual understanding.
model: haiku
effort: low
allowed-tools: Bash, Read, Write
argument-hint: <image-url-or-path>
---

# Image Analysis CLI Skill

Analyzes images using pure CLI tools when the text-only model needs to understand image content.

## How It Works

MiniMax M2.7 is a text-only model. This skill works around that by:
1. Saving the image to a temp location
2. Running **both** tools in parallel:
   - MiniMax Vision AI for visual description (requires API key)
   - Swift Vision OCR for text extraction (always runs, no API key needed)
3. Returning a combined text report that Claude Code can understand

## Usage

```
/analyze-image <image-url-or-path>
```

## Tool Stack

| Tool | Purpose | Requirement |
|------|---------|-------------|
| `file`, `sips`, `mdls`, `curl`, `qlmanage` | Metadata extraction | Built-in to macOS |
| `mmx-cli vision` | Visual AI description | Optional: `npm install -g mmx-cli` |
| Swift Vision framework | OCR (text extraction) | Built-in to macOS, always available |

Both analysis tools run **simultaneously** — OCR does not depend on mmx-cli and vice versa.

## MiniMax CLI Setup (Optional)

```bash
sudo npm install -g mmx-cli
mmx-cli config set api-key YOUR_API_KEY
```

The API key is stored in `~/.mmx/config.json` — not hardcoded anywhere.

## Analysis Output

```
IMAGE ANALYSIS REPORT
====================
Source: <url-or-path>
Dimensions: <width>x<height>
File Size: <size KB>

=== MiniMax Vision AI Description ===
<visual description from AI, or install hint if not configured>

=== Extracted Text (OCR) ===
<text extracted from image, or no-text message>

=== File Info / Metadata ===
<technical details>
```

## Files

- `scripts/analyze-image.sh` — Main script (orchestrates all tools)
- `scripts/ocr.swift` — Swift Vision OCR helper
- `hooks/analyze-image-on-url.sh` — Claude Code UserPromptSubmit hook
