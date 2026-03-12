#!/bin/bash
# AI Daily Report Generator - Outputs Markdown directly
# Run this to generate today's report as .md file

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPORT_DIR="$SCRIPT_DIR/.."
TODAY=$(date +%Y-%m-%d)
TIME=$(date +%H%M)

echo "Generating AI Daily Report for $TODAY..."

# Search for AI news
NEWS=$(tavily_search --query "AI tech news $TODAY" --count 5 --include_answer true 2>/dev/null)

# Create markdown report
cat > "$REPORT_DIR/reports/${TODAY}-${TIME}.md" << 'EOF'
---
title: "AI Daily Report"
date: "DATE_PLACEHOLDER"
---

# AI Daily Report - DATE_PLACEHOLDER 📰

## Today's AI Highlights

EOF

# Add the news (simplified)
if [ -n "$NEWS" ]; then
    echo "$NEWS" | while read -r line; do
        echo "- $line" >> "$REPORT_DIR/reports/${TODAY}-${TIME}.md"
    done
else
    echo "- AI领域最新动态" >> "$REPORT_DIR/reports/${TODAY}-${TIME}.md"
fi

# Add footer
cat >> "$REPORT_DIR/reports/${TODAY}-${TIME}.md" << EOF

---

*Generated at ${TIME}*

## Sources
- https://techcrunch.com/category/ai/
- https://www.theverge.com/ai
EOF

# Replace date placeholder
sed -i "s/DATE_PLACEHOLDER/$TODAY/g" "$REPORT_DIR/reports/${TODAY}-${TIME}.md"

echo "Created: $REPORT_DIR/reports/${TODAY}-${TIME}.md"