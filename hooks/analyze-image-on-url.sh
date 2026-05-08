#!/bin/bash
# Claude Code UserPromptSubmit hook: analyze-image-on-url.sh
# Detects image URLs in submitted prompts and auto-runs analyze-image skill
# Injects image analysis results into Claude's context

set -e

# Read JSON input from stdin
INPUT=$(cat)

# Extract the user prompt text
USER_PROMPT=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # Try different possible structures
    prompt = data.get('prompt', '')
    if not prompt:
        prompt = data.get('text', '')
    if not prompt:
        prompt = data.get('message', '')
    print(prompt if prompt else '')
except:
    print('')
" 2>/dev/null || echo "")

if [[ -z "$USER_PROMPT" ]]; then
    echo "$INPUT"
    exit 0
fi

# Detect image URLs in the prompt text
IMAGE_URLS=$(echo "$USER_PROMPT" | grep -oE 'https?://[^[:space:]]+\.(png|jpg|jpeg|gif|webp|bmp|tiff)(\?[^[:space:]]*)?' || true)

# Detect local image file paths in the prompt text
LOCAL_IMAGES=$(echo "$USER_PROMPT" | grep -oE '/[^[:space:]]+\.(png|jpg|jpeg|gif|webp|bmp|tiff)(\?[^[:space:]]*)?' || true)

# Also scan the entire JSON payload for any image paths (catches attachments)
ALL_JSON_PATHS=$(echo "$INPUT" | grep -oE '"/?[^"]+\.(png|jpg|jpeg|gif|webp|bmp|tiff)(\?[^"]*)?"' | tr -d '"' | grep '^/' || true)

# Combine all found images
ALL_IMAGES="${IMAGE_URLS}
${LOCAL_IMAGES}
${ALL_JSON_PATHS}"

# Remove duplicates
ALL_IMAGES=$(echo "$ALL_IMAGES" | sort -u | grep -v '^$')

if [[ -z "$ALL_IMAGES" ]]; then
    # No images found, pass through unchanged
    echo "$INPUT"
    exit 0
fi

# For each image (URL or local path), run analyze-image and capture results
ANALYSIS_RESULTS=""
for IMAGE in $ALL_IMAGES; do
    ANALYSIS_RESULTS="${ANALYSIS_RESULTS}\n\n=== IMAGE ANALYSIS: ${IMAGE} ===\n"
    RESULT=$(bash ~/.claude/skills/analyze-image/analyze-image.sh "$IMAGE" 2>/dev/null)
    ANALYSIS_RESULTS="${ANALYSIS_RESULTS}${RESULT}"
done

# Inject the analysis results into the prompt
if [[ -n "$ANALYSIS_RESULTS" ]]; then
    echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)

# Inject analysis results
original_prompt = data.get('prompt', data.get('text', data.get('message', '')))
analysis = '''$ANALYSIS_RESULTS'''

# Prepend analysis to prompt
data['prompt'] = analysis + '\n\n---\n\nOriginal user request:\n' + original_prompt

print(json.dumps(data))
" 2>/dev/null || echo "$INPUT"
else
    echo "$INPUT"
fi
