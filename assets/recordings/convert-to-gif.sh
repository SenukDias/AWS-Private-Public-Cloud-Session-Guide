#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
  echo "Usage: ./convert-to-gif.sh <input.mp4> [output.gif]"
  echo "Example: ./convert-to-gif.sh my-video.mp4"
  exit 1
fi

INPUT_FILE="$1"
# If no output file is provided, use the input filename with a .gif extension
OUTPUT_FILE="${2:-${INPUT_FILE%.*}.gif}"

echo "🔄 Converting '$INPUT_FILE' to high-quality GIF -> '$OUTPUT_FILE'..."

# The magic ffmpeg command with custom palette generation
ffmpeg -y -i "$INPUT_FILE" -vf "fps=15,scale=1080:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
  echo "✅ Success! Saved as $OUTPUT_FILE"
else
  echo "❌ Conversion failed. Make sure ffmpeg is installed."
fi
