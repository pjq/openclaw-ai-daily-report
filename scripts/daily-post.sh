#!/bin/bash
# AI Daily Report - Daily Markdown generator (English)
# Run at 7:30 AM daily to generate and push report

BLOG_DIR="/home/pjq/clawd/ai-daily-report"
cd "$BLOG_DIR" || exit 1

TODAY=$(date +%Y-%m-%d)
TIME=$(date +%H%M)

echo "=== AI Daily Report Generator ==="
echo "Date: $TODAY $TIME"

# Check if report already exists for today (check for any report today)
EXISTING=$(ls reports/${TODAY}-*.md 2>/dev/null | head -1)
if [ -n "$EXISTING" ]; then
    echo "Report already exists: $EXISTING"
else
    echo "Generating new report for $TODAY..."
    
    # Create markdown report
    cat > "reports/${TODAY}-${TIME}.md" << 'EOF'
---
title: "AI Daily Report"
date: "DATE_PLACEHOLDER"
---

# AI Daily Report - DATE_PLACEHOLDER 📰

---

EOF

    # Add a note that fresh news is being fetched
    cat >> "reports/${TODAY}-${TIME}.md" << EOF

## Today's AI Highlights

*Fetching latest AI news...*

## Key Trends

- AI agents and autonomous systems
- LLM improvements and new releases
- Enterprise AI deployment
- AI governance and regulation

---

*Generated at ${TIME}*

## Sources
- https://techcrunch.com/category/ai/
- https://www.theverge.com/ai
- https://wired.com/tag/artificial-intelligence
EOF

    # Replace date placeholder
    sed -i "s/DATE_PLACEHOLDER/$TODAY/g" "reports/${TODAY}-${TIME}.md"
    
    echo "Created: reports/${TODAY}-${TIME}.md"
fi

# Commit and push
git add reports/
git commit -m "Daily AI report: $TODAY" 2>/dev/null || echo "No changes to commit"
git push origin main 2>/dev/null || echo "Push failed"

echo "Done!"