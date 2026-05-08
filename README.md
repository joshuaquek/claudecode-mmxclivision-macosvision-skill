# ClaudeCode MiniMax Vision + macOS Vision Skill 🎨

> **Give your Claude Code the power to "see" images!** This skill enables image analysis for Claude Code by using MiniMax Vision AI and built-in macOS tools.

## Why Do You Need This? 🤔

Claude Code with MiniMax M2.7 is a **text-only model** — it can't see images by itself. This skill bridges that gap by:

1. Detecting when you share an image 🖼️
2. Analyzing it with MiniMax Vision AI (which CAN see) 🤖
3. Injecting the analysis results so Claude can respond 💬

## What It Can Analyze

| Type | Example | How to Use |
|------|---------|------------|
| **🌐 Image URLs** | Screenshots from websites | Paste a link like `https://example.com/photo.png` |
| **📤 Uploaded Images** | Photos, diagrams, memes | Drag & drop or paste directly into chat |
| **💾 Local Files** | Images on your Mac | Enter the file path like `/Users/name/photo.png` |

## Quick Install ⚡

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

- ✅ **macOS** (Mac computer)
- ✅ **Claude Code** running MiniMax M2.7
- 🌐 **Internet** — needed for AI descriptions
- 🔑 **MiniMax API Key** — required for AI vision features

### Setting Up Your MiniMax API Key

1. Get your API key from [MiniMax Platform](https://platform.minimax.io/docs)
2. Run this command in Terminal:
   ```bash
   npx mmx-cli config set api-key YOUR_KEY
   ```

## How It Works (Technical Details) ⚙️

This skill uses a hook that:

1. **Intercepts your messages** before Claude processes them
2. **Detects images** (URLs, uploads, or local file paths)
3. **Sends to MiniMax Vision AI** for analysis (AI description + OCR)
4. **Injects the results** into your message as context
5. **Claude receives** a text description instead of an image

## Troubleshooting 🛠️

Having issues? Check out these guides:

- [Installation Guide](docs/INSTALLATION.md) — Step-by-step setup help
- [Capabilities](docs/CAPABILITIES.md) — What this skill can and can't do
- [Troubleshooting](docs/TROUBLESHOOTING.md) — Common problems and solutions
- [Architecture](docs/ARCHITECTURE.md) — Technical details

## License 📄

MIT — free to use, modify, and share!
