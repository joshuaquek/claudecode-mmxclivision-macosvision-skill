# Troubleshooting
<!-- updated: 2026-05-08_19:30:00 -->

## Common Issues

### "Permission denied" when running install.sh

```bash
chmod +x install.sh
./install.sh
```

### mmx-cli not found

If you see this error:
```
mmx-cli: command not found
```

**Fix:** Install it manually:
```bash
npm install -g mmx-cli
```

Or run via npx:
```bash
npx mmx-cli vision describe --file image.png
```

### "No API key" error from MiniMax

If MiniMax Vision returns:
```
{"error": {"code": 3, "message": "No API key found"}}
```

**Fix:** Configure your API key:
```bash
npx mmx-cli config set api-key YOUR_API_KEY
```

### Hook not triggering

If the image analysis isn't auto-running:

1. **Restart Claude Code** - The hook only loads on startup

2. **Check settings.json** - Verify the hook is registered:
   ```bash
   cat ~/.claude/settings.json | grep -A5 UserPromptSubmit
   ```

3. **Check the image format** - The hook detects:
   - URLs: `https://example.com/image.png`
   - Local paths: `/tmp/claude-images/photo.png`
   - Uploaded images: Detected automatically when you paste or upload

   Supported formats: `.png, .jpg, .jpeg, .gif, .webp, .bmp, .tiff`

4. **Check the hook is executable**:
   ```bash
   chmod +x ~/.claude/hooks/analyze-image-on-url.sh
   ```

5. **For uploaded images**: Make sure Claude Code saved the file to a path that exists. If you see "No such file" errors, the temp file may have been deleted.

### OCR not extracting text

OCR works best with:
- Clear, high-contrast text
- Horizontal text (not rotated)
- Standard fonts

If OCR returns "(No text detected)":
- The image may not contain readable text
- Try the MiniMax Vision AI for visual description instead

### "No such file or directory" for image

When downloading fails:
- Check the URL is correct
- Try opening the URL in a browser
- The image may require authentication

### Installation fails with "Missing required tools"

This skill requires these macOS built-in tools:
- `curl`
- `file`
- `sips`
- `mdls`
- `qlmanage`

These should all be present on any standard macOS installation. If any are missing:
1. Open Terminal
2. Run: `/usr/sbin/softwareupdate --install-all`
3. Restart and try again

## Diagnostic Commands

### Check installed files
```bash
ls -la ~/.claude/skills/analyze-image/
ls -la ~/.claude/hooks/
```

### Test the script manually
```bash
bash ~/.claude/skills/analyze-image/analyze-image.sh https://example.com/image.png
```

### Test the hook
```bash
echo '{"prompt": "test https://example.com/test.png"}' | bash ~/.claude/hooks/analyze-image-on-url.sh
```

### Check MiniMax config
```bash
cat ~/.mmx/config.json
```

## Getting Help

If you're still stuck:

1. Check the [GitHub Issues](https://github.com/YOUR_USERNAME/claudecode-mmxclivision-macosvision-skill/issues)
2. Include:
   - Your macOS version
   - Error message (exact)
   - Steps to reproduce
