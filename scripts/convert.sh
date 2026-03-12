#!/bin/bash
# Convert JSON reports to Markdown

INPUT_DIR="../reports"
OUTPUT_DIR="../markdown_reports"

mkdir -p "$OUTPUT_DIR"

for json in $INPUT_DIR/*.json; do
    [ -f "$json" ] || continue
    
    basename=$(basename "$json" .json)
    output="$OUTPUT_DIR/${basename}.md"
    
    python3 << EOF
import json
import sys

with open("$json", "r") as f:
    data = json.load(f)

points = data.get("points", [])
sources = data.get("sources", [])
generated = data.get("generatedAt", "")

date = "$basename".split("-")[0:3]
date_formatted = "-".join(date)

md = f"""---
title: "AI Daily Report"
date: "{date_formatted}"
---

# AI Daily Report - {date_formatted} 📰

Generated at: {generated}

---

"""

for i, point in enumerate(points, 1):
    md += f"{i}. {point}\n"

md += "\n## Sources\n"
for src in sources:
    md += f"- {src}\n"

with open("$output", "w") as f:
    f.write(md)

print(f"Created: $output")
EOF
done