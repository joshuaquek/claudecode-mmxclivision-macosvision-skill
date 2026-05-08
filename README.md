# ClaudeCode MiniMax Vision Skill
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=joshuaquek_claudecode-mmxclivision-macosvision-skill&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=joshuaquek_claudecode-mmxclivision-macosvision-skill) [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=joshuaquek_claudecode-mmxclivision-macosvision-skill&metric=bugs)](https://sonarcloud.io/summary/new_code?id=joshuaquek_claudecode-mmxclivision-macosvision-skill) [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=joshuaquek_claudecode-mmxclivision-macosvision-skill&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=joshuaquek_claudecode-mmxclivision-macosvision-skill) [![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=joshuaquek_claudecode-mmxclivision-macosvision-skill&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=joshuaquek_claudecode-mmxclivision-macosvision-skill)

> Image analysis for Claude Code with MiniMax M2.7 — works exactly like Claude Code with Opus 4.6. Just attach an image and chat normally.

## Why Does This Exist?

When using [Minimax M2.7 with Claude Code](https://platform.minimax.io/docs/guides/quickstart-preparation), you lose the built-in image analysis that Opus 4.6 has with Claude Code, simply because MiniMax M2.7 is a text-only model. This skill restores that functionality by integrating [MiniMax CLI's vision capabilities](https://github.com/MiniMax-AI/cli#features) and a fallback [MacOS-native OCR solution](https://developer.apple.com/documentation/vision/recognizing-text-in-images). This actually works beyond Minimax M2.7, so you can use it with any text-based model in Claude Code on MacOS.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill.git
cd claudecode-mmxclivision-macosvision-skill
chmod +x install.sh
./install.sh
```

Restart Claude Code.

## Requirements

- macOS
- Claude Code on MiniMax M2.7
- MiniMax API key (`mmx-cli config set api-key YOUR_KEY`) — optional, OCR works without it

## Features

| Feature | Description | Requires API Key |
|---------|-------------|-----------------|
| **Visual Description** | AI-powered description of what's in the image | Yes |
| **Text Extraction (OCR)** | Extract visible text from screenshots, documents | No |
| **Metadata Extraction** | File type, dimensions, color profile, EXIF data | No |
| **Thumbnail Generation** | Creates a preview thumbnail | No |

Both tools run **in parallel** — OCR results and Vision AI descriptions are both included in the analysis report.

## Documentation

- [Usage Guide](docs/USAGE.md) — How to use the skill
- [Installation Guide](docs/INSTALLATION.md) — Step-by-step setup
- [Capabilities](docs/CAPABILITIES.md) — What the skill can do
- [Troubleshooting](docs/TROUBLESHOOTING.md) — Common issues and fixes
- [Changelog](docs/CHANGELOG.md) — What's new
- [Architecture](docs/ARCHITECTURE.md) — Technical details

## License

MIT
