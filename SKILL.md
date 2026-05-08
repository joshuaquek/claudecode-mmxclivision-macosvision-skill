---
name: analyze-image
description: Analyze images using CLI tools when MiniMax M2.7 can't natively see images. Downloads image, extracts metadata, OCR text, and visual AI description.
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
2. Using macOS CLI tools to extract metadata, text (OCR)
3. Using MiniMax Vision AI (if `mmx-cli` is configured) for visual description
4. Returning a text report that Claude Code can understand

## Usage

```
/analyze-image <image-url-or-path>
```

## Tool Stack (Layered)

| Tool | Purpose | Requirement |
|------|---------|-------------|
| `file`, `sips`, `mdls`, `curl` | Metadata extraction | Built-in to macOS |
| `mmx-cli vision` | Visual AI description | Optional: install via `npm install -g mmx-cli` |
| Swift Vision framework | OCR (text extraction) | Built-in to macOS |

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
<visual description from AI>

=== Extracted Text (OCR) ===
<any text found in image>

=== File Info / Metadata ===
<technical details>
```

## Files

- `scripts/analyze-image.sh` — Main script
- `scripts/ocr.swift` — Swift Vision OCR helper
- `hooks/analyze-image-on-url.sh` — Claude Code UserPromptSubmit hook (auto-analyzes image URLs)
