#!/bin/bash
# AI Daily Report - Deploy to Vercel via GitHub
# Reads all JSON files in reports/ folder (one per day) and generates index.html

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPORT_DIR="$SCRIPT_DIR"
TODAY=$(date +%Y-%m-%d)

echo "=== AI Daily Report Deploy ==="

# Check if reports directory exists
if [ ! -d "$REPORT_DIR/reports" ]; then
    echo "No reports directory found."
    exit 0
fi

# Get latest report file (by modification time, or use today's if exists)
LATEST_REPORT=""
if [ -f "$REPORT_DIR/reports/$TODAY.json" ]; then
    LATEST_REPORT="$REPORT_DIR/reports/$TODAY.json"
else
    LATEST_REPORT=$(ls -t "$REPORT_DIR/reports/"*.json 2>/dev/null | head -1)
fi

if [ -z "$LATEST_REPORT" ]; then
    echo "No report files found."
    exit 0
fi

echo "Using report: $LATEST_REPORT"

# Read from latest report
DAILY_DATE=$(basename "$LATEST_REPORT" .json)
POINTS=$(cat "$LATEST_REPORT" | jq -r '.points[]')
SOURCES=$(cat "$LATEST_REPORT" | jq -r '.sources[]')

# Generate index.html
cat > "$REPORT_DIR/index.html" << EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI Daily Report - 每日AI简报</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; background: #f5f5f5; min-height: 100vh; }
    .container { max-width: 800px; margin: 0 auto; padding: 2rem; }
    header { text-align: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid #e0e0e0; }
    header h1 { font-size: 2rem; color: #1a1a1a; margin-bottom: 0.5rem; }
    header p { color: #666; font-size: 0.9rem; }
    .nav { margin-bottom: 1.5rem; text-align: center; }
    .nav a { display: inline-block; margin: 0 0.5rem; padding: 0.5rem 1rem; background: #0066cc; color: white; border-radius: 20px; text-decoration: none; font-size: 0.9rem; }
    .nav a:hover { background: #0055aa; }
    .nav a.secondary { background: #666; }
    .nav a.secondary:hover { background: #555; }
    .report-card { background: white; border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .report-date { font-size: 0.85rem; color: #888; margin-bottom: 1rem; }
    .report-section { margin-bottom: 1.5rem; }
    .report-section:last-child { margin-bottom: 0; }
    .report-section h2 { font-size: 1.1rem; color: #2c3e50; margin-bottom: 0.75rem; padding-bottom: 0.5rem; border-bottom: 1px solid #eee; }
    .report-section ul { list-style: none; padding-left: 0; }
    .report-section li { padding: 0.5rem 0; padding-left: 1.5rem; position: relative; }
    .report-section li::before { content: "•"; position: absolute; left: 0; color: #0066cc; font-weight: bold; }
    .sources { display: flex; flex-wrap: wrap; gap: 0.5rem; }
    .sources a { background: #f0f0f0; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; color: #555; text-decoration: none; }
    .sources a:hover { background: #e0e0e0; }
    .deep-card { border-left: 4px solid #0066cc; padding: 1rem; margin-bottom: 1rem; background: #fafafa; border-radius: 0 8px 8px 0; }
    .deep-card:last-child { margin-bottom: 0; }
    .deep-card h3 { font-size: 1rem; color: #1a1a1a; margin-bottom: 0.5rem; }
    .deep-card h3 a { color: #0066cc; text-decoration: none; font-weight: 600; }
    .deep-card h3 a:hover { text-decoration: underline; }
    .deep-card p { color: #666; font-size: 0.9rem; margin-bottom: 0.5rem; }
    .deep-card .tags { display: flex; flex-wrap: wrap; gap: 0.3rem; }
    .deep-card .tag { background: #e8f4fd; color: #0066cc; padding: 0.15rem 0.5rem; border-radius: 12px; font-size: 0.75rem; }
    footer { text-align: center; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid #e0e0e0; color: #888; font-size: 0.85rem; }
    @media (max-width: 600px) { .container { padding: 1rem; } }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>🤖 AI Daily Report</h1>
      <p>每日AI简报 + 深度研究</p>
    </header>
    
    <div class="nav">
      <a href="./">📰 每日简报</a>
      <a href="./deep-research/" class="secondary">📚 深度研究</a>
    </div>
    
    <div class="report-card">
      <div class="report-date">$DAILY_DATE</div>
      
      <div class="report-section">
        <h2>📰 热点要点</h2>
        <ul>
EOF

# Add points
while IFS= read -r point; do
    echo "          <li>$point</li>" >> "$REPORT_DIR/index.html"
done <<< "$POINTS"

cat >> "$REPORT_DIR/index.html" << 'EOF'
        </ul>
      </div>
      
      <div class="report-section">
        <h2>🔗 来源</h2>
        <div class="sources">
EOF

# Add sources
while IFS= read -r source; do
    hostname=$(echo "$source" | sed 's|https://||' | cut -d'/' -f1)
    echo "          <a href=\"$source\" target=\"_blank\">$hostname</a>" >> "$REPORT_DIR/index.html"
done <<< "$SOURCES"

cat >> "$REPORT_DIR/index.html" << 'EOF'
        </div>
      </div>
    </div>
    
    <div class="report-card">
      <div class="report-section">
        <h2>📚 深度研究</h2>
EOF

# List deep research articles
for article in "$REPORT_DIR/deep-research"/*.html; do
    if [ -f "$article" ]; then
        filename=$(basename "$article")
        # Extract title from HTML
        title=$(grep -o '<title>[^<]*</title>' "$article" | sed 's/<title>//;s/<\/title>//')
        if [ -z "$title" ]; then
            title="$filename"
        fi
        echo "        <div class=\"deep-card\">" >> "$REPORT_DIR/index.html"
        echo "          <h3><a href=\"./deep-research/$filename\">→ $title</a></h3>" >> "$REPORT_DIR/index.html"
        echo "        </div>" >> "$REPORT_DIR/index.html"
    fi
done

cat >> "$REPORT_DIR/index.html" << 'EOF'
      </div>
    </div>
    
    <footer>
      <p>🤖 OpenClaw AI | Updated: TODAY_PLACEHOLDER</p>
    </footer>
  </div>
</body>
</html>
EOF

# Replace placeholder
sed -i "s/TODAY_PLACEHOLDER/$TODAY/g" "$REPORT_DIR/index.html"

echo "Generated index.html"

# Commit and push
cd "$REPORT_DIR"
git add index.html reports/ deep-research/
git commit -m "Update reports $TODAY" || echo "No changes"
git push origin main

echo "Done! Vercel will auto-deploy."
