# ClaudeCode MiniMax Vision Skill 🎨

> Image analysis for Claude Code with MiniMax M2.7 — works exactly like Claude Code with Opus 4.6. Just attach an image and chat normally.

## Why Does This Exist?
When using [Minimax M2.7 with Claude Code](https://platform.minimax.io/docs/guides/quickstart-preparation), you lose the built-in image analysis that Opus 4.6 has with Claude Code, simply because MiniMax M2.7 is a text-only model. This skill restores that functionality by integrating [MiniMax CLI's vision capabilities](https://github.com/MiniMax-AI/cli#features) and a fallback [MacOS-native OCR solution](https://developer.apple.com/documentation/vision/recognizing-text-in-images). This actually works beyond Minimax M2.7, so you can use it with any text-based model in Claude Code on MacOS.

## Install ⚡

```bash
git clone https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill.git
cd claudecode-mmxclivision-macosvision-skill
chmod +x install.sh
./install.sh
```

Restart Claude Code.

## Requirements 📋

- macOS
- Claude Code on MiniMax M2.7
- MiniMax API key (`npx mmx-cli config set api-key YOUR_KEY`)

## Documentation 📖

- [Usage Guide](docs/USAGE.md) — How to use the skill (it just works!)
- [Installation Guide](docs/INSTALLATION.md) — Step-by-step setup
- [Capabilities](docs/CAPABILITIES.md) — What the skill can do
- [Troubleshooting](docs/TROUBLESHOOTING.md) — Common issues and fixes
- [Changelog](docs/CHANGELOG.md) — What's new
- [Architecture](docs/ARCHITECTURE.md) — Technical details

## License 📄

MIT
