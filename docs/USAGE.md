# Usage Guide
<!-- updated: 2026-05-09 -->

## How It Works — The Seamless Experience

MiniMax M2.7 is a **text-only model** — it can't see images by itself. This skill acts as a bridge:

1. **Intercept** — Detects when you share an image (URL, upload, or local path)
2. **Analyze** — Runs **both** MiniMax Vision AI (for description) **and** macOS Vision OCR (for text) simultaneously
3. **Inject** — Adds the combined analysis as text context before Claude sees your message
4. **Respond** — Claude responds naturally, seeing the image description and extracted text

**The result:** It feels exactly like using Claude Code with Opus 4.6. You just attach an image and chat normally.

## Just Chat with Images

### Attach an Image and Ask

Just drag & drop an image into the chat, or paste it, then ask your question:

```
You: "What does this screenshot show?"
[attach image]
Claude: [describes the screenshot]
```

No commands. No special syntax. It just works.

### Image URLs

Paste a URL directly in your message:

```
You: "Look at this: https://example.com/photo.png"
Claude: [analyzes the image]
```

### Local Files

Reference a file path on your Mac:

```
You: "What's in this photo? /Users/name/Pictures/vacation.png"
Claude: [analyzes the image]
```

## What Happens Behind the Scenes

When you share an image, the hook automatically:

1. Detects the image in your message (URL, upload, or path)
2. Downloads/analyzes the image
3. Gets AI description from MiniMax Vision (if API key configured)
4. Extracts text via OCR using macOS Vision (always works, even offline)
5. Injects combined results before your message

Claude Code sees something like:

```
=== IMAGE ANALYSIS ===
Source: screenshot.png
Dimensions: 1200 x 800

MiniMax Vision AI Description:
A terminal window showing git status output...

=== Extracted Text (OCR) ===
git status
npm run build

---
Original user request:
What does this screenshot show?
```

## Supported Image Types

PNG, JPEG, GIF, WebP, BMP, TIFF

## Without a MiniMax API Key

OCR text extraction still works offline using macOS Vision. You'll get:

- Extracted text from the image
- File metadata (dimensions, type, etc.)
- An install hint for mmx-cli

With a MiniMax API key, you also get:

- Detailed AI-powered visual descriptions

## Privacy

| Data | Where It Goes |
|------|---------------|
| Image content | Sent to MiniMax Vision API for analysis |
| API key | Stored locally in `~/.mmx/config.json` |

All API calls use HTTPS. Images are not stored after processing.
