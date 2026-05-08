# ClaudeCode MiniMax Vision + macOS Vision Skill 🎨

> **Give your Claude Code the power to "see" images!** This skill lets Claude analyze any image you share — whether it's from a website, uploaded directly, or saved on your computer.

## What Does This Do? 🤔

Normally, Claude Code can only read text — it can't look at pictures. This skill fixes that! It works like a translator between images and Claude:

- You share an image 📷
- The skill analyzes it (using AI and OCR) 🧠
- Claude sees a detailed description and can answer questions about it 💬

## What It Can Analyze

| Type | Example | How to Use |
|------|---------|------------|
| **🌐 Image URLs** | Screenshots from websites | Paste a link like `https://example.com/photo.png` |
| **📤 Uploaded Images** | Photos, diagrams, memes | Drag & drop or paste directly into chat |
| **💾 Local Files** | Images on your Mac | Enter the file path like `/Users/name/photo.png` |

## Quick Install ⚡

> **Note:** These commands go in your Mac's Terminal app. Don't worry if that sounds scary — it's just a text-based way to run commands!

```bash
git clone https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill.git
cd claudecode-mmxclivision-macosvision-skill
chmod +x install.sh
./install.sh
```

Then **restart Claude Code** (close it completely and reopen it).

## How to Use It 🚀

### Example 1: Analyzing an Image URL
```
You: "Look at this screenshot: https://example.com/screenshot.png"
```

Claude automatically sees:
```
=== IMAGE ANALYSIS ===
Source: screenshot.png
Dimensions: 1200 x 800

MiniMax Vision AI Description:
A screenshot showing a terminal window with code...

=== Extracted Text (OCR) ===
git status
npm run build
./deploy.sh

---
Original user request:
Look at this image: https://example.com/screenshot.png
```

### Example 2: Uploading an Image Directly
Just drag & drop an image into the chat window, then ask your question. The skill detects it automatically — no extra commands needed!

### Example 3: A Local File on Your Mac
```
You: "What's in this photo? /Users/josh/Pictures/vacation.png"
```

## Features ✨

| Feature | What It Does | Works Offline? |
|---------|--------------|----------------|
| **🤖 AI Vision** | Gets detailed AI-powered descriptions of your images | ❌ Requires internet |
| **📝 OCR Text Extraction** | Pulls out any text visible in the image | ✅ Yes! |
| **📋 Metadata** | Shows file type, dimensions, color info | ✅ Yes! |
| **🔄 Auto-Detection** | Finds images automatically in your messages | ✅ Yes! |

## What You Need 📋

- ✅ **macOS** (Mac computer) — this skill uses built-in Apple tools
- ✅ **Claude Code** installed
- 🌐 **Internet** — needed for AI descriptions
- 🔑 **MiniMax API Key** — optional but recommended for best results

### Getting a MiniMax API Key (Optional but Recommended)

Without this key, you still get OCR text extraction (it works offline). But for full AI-powered descriptions, you'll need a key:

1. Sign up at MiniMax's website to get an API key
2. Run this command in Terminal:
   ```bash
   npx mmx-cli config set api-key YOUR_KEY
   ```

## Troubleshooting 🛠️

Having issues? Check out these guides:

- [Installation Guide](docs/INSTALLATION.md) — Step-by-step setup help
- [Capabilities](docs/CAPABILITIES.md) — What this skill can and can't do
- [Troubleshooting](docs/TROUBLESHOOTING.md) — Common problems and solutions
- [Architecture](docs/ARCHITECTURE.md) — Technical details (for the curious!)

## License 📄

MIT — free to use, modify, and share!
