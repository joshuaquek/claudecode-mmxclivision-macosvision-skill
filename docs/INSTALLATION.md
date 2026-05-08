# Installation Guide
<!-- updated: 2026-05-08_19:30:00 -->

## Prerequisites

Before installing, make sure you have:

- **macOS** (this skill only works on macOS)
- **Claude Code** installed
- **Internet connection** (for downloading mmx-cli and MiniMax API)

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill.git
cd claudecode-mmxclivision-macosvision-skill
chmod +x install.sh
./install.sh
```

The wizard will guide you through the setup.

## Step-by-Step Instructions

### Step 1: Download the Repo

Option A: Clone with git
```bash
git clone https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill.git
cd claudecode-mmxclivision-macosvision-skill
```

Option B: Download as ZIP
1. Go to the GitHub repo
2. Click the green "Code" button
3. Click "Download ZIP"
4. Unzip and open the folder in Terminal

### Step 2: Run the Installer

```bash
chmod +x install.sh
./install.sh
```

### Step 3: Follow the Wizard

The installer will:

1. **Check your system** - Verify you're on macOS with required tools
2. **Ask for MiniMax API key** (optional)
   - You can press Enter to skip
   - Without it, OCR text extraction still works
3. **Install files** - Copies scripts to your Claude Code directories
4. **Configure settings** - Updates your Claude Code settings
5. **Verify** - Tests that everything is working

### Step 4: Restart Claude Code

Close and reopen Claude Code for the changes to take effect.

## Getting a MiniMax API Key (Optional)

MiniMax Vision provides AI-powered image descriptions. Without it, you still get OCR text extraction.

1. Sign up at [MiniMax](https://minimax.io) (or your MiniMax provider)
2. Get your API key
3. If you skipped during install, run:
   ```bash
   mmx-cli config set api-key YOUR_API_KEY
   ```

## Verifying Installation

After restarting Claude Code, try sending this message:

```
Look at this image: https://example.com/test.png
```

(Replace with any real image URL)

You should see the image analysis auto-injected before your message.

## What Gets Installed

| Path | What |
|------|------|
| `~/.claude/skills/analyze-image/analyze-image.sh` | Main analysis script |
| `~/.claude/skills/analyze-image/ocr.swift` | Swift OCR helper |
| `~/.claude/hooks/analyze-image-on-url.sh` | Auto-analysis hook |
| `~/.mmx/config.json` | MiniMax API key (if provided) |

## Uninstallation

To remove:
```bash
rm -rf ~/.claude/skills/analyze-image
rm ~/.claude/hooks/analyze-image-on-url.sh
```

Then manually edit `~/.claude/settings.json` to remove the `UserPromptSubmit` hook.
