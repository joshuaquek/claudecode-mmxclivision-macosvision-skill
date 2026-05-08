# Capabilities
<!-- updated: 2026-05-09 -->

## What This Skill Can Do

### Image Analysis Features

| Feature | Description | Requirements |
|---------|-------------|--------------|
| **Visual Description** | AI-powered description of what's in the image | MiniMax API key |
| **Text Extraction (OCR)** | Extract visible text from screenshots, documents | None (works offline) |
| **Metadata Extraction** | File type, dimensions, color profile, EXIF data | None |
| **Thumbnail Generation** | Creates a preview thumbnail | None |

### Supported Image Types

PNG, JPEG, GIF, WebP, BMP, TIFF

### Use Cases

1. **Screenshot Analysis** - Describe what's shown in a screenshot
2. **Code/Error Screenshots** - Extract error messages from images
3. **Document Text Extraction** - Pull text from images of documents
4. **File Listings** - Extract text from screenshots of file explorers
5. **UI Screenshots** - Describe UI elements in app screenshots

## What This Skill Cannot Do

| Limitation | Reason |
|------------|--------|
| No real-time camera | Not supported by the architecture |
| No video analysis | Only still images supported |
| No image editing | Read-only analysis |
| No face recognition | Not included in the tools |
| No image generation | This is analysis only, not generation |

## How It Works

### Two Tools Running in Parallel

Unlike a fallback approach where one tool only runs if the other fails, this skill runs **both tools simultaneously**:

1. **MiniMax Vision AI** (if configured)
   - Sends image to MiniMax's vision model
   - Returns detailed visual description
   - Requires internet + API key
   - Shows install hint if not available

2. **Swift Vision OCR** (always runs)
   - Uses built-in macOS Vision framework
   - Extracts visible text from images
   - Works completely offline
   - No API key needed
   - Shows error message if it fails

### Auto-Hook Behavior

The hook detects images in **three ways**:

1. **Image URLs** - Any `https://example.com/image.png` in your message
2. **Local file paths** - Any `/path/to/image.png` in your message
3. **Uploaded image attachments** - Claude Code saves uploads to temp and includes paths in the JSON payload

**When you upload an image and ask a question:**
1. The hook intercepts your message
2. Detects the uploaded image path from the JSON payload
3. Analyzes the image automatically
4. Injects the analysis results before your message
5. Claude Code sees both the analysis and your question

## Privacy Notes

| Data | Where It Goes |
|------|---------------|
| Image URL | Sent to MiniMax (if using vision AI) |
| Image content | Processed locally or sent to MiniMax |
| API key | Stored in `~/.mmx/config.json` |

All processing uses HTTPS. Images are not stored by MiniMax after processing.

## Accuracy Notes

- **OCR**: High accuracy for clear, printed text. May struggle with handwriting or distorted text.
- **Vision AI**: Depends on MiniMax model capabilities. Generally good at describing objects, scenes, and text.
- **Metadata**: Always accurate (extracted directly from file)
