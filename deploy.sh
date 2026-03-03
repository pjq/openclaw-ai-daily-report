#!/bin/bash
# AI Daily Report - Deploy to Vercel via GitHub
# Generates index.html showing latest 10 reports on home page

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

# Get latest 10 report files sorted by name (newest first)
LATEST_REPORTS=$(ls -1t "$REPORT_DIR/reports/"*.json 2>/dev/null | head -10)

if [ -z "$LATEST_REPORTS" ]; then
    echo "No report files found."
    exit 0
fi

# Get the most recent one for the "latest" display
LATEST_REPORT=$(echo "$LATEST_REPORTS" | head -1)
GENERATED_AT=$(cat "$LATEST_REPORT" | jq -r '.generatedAt // "00:00"')

echo "Using latest report: $LATEST_REPORT"

# Generate index.html (use unquoted EOF to allow variable expansion)
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
    .report-section h3 { font-size: 1rem; color: #2c3e50; margin-bottom: 0.5rem; }
    .report-section ul { list-style: none; padding-left: 0; }
    .report-section li { padding: 0.4rem 0; padding-left: 1.2rem; position: relative; font-size: 0.95rem; }
    .report-section li::before { content: "•"; position: absolute; left: 0; color: #0066cc; font-weight: bold; }
    .sources { display: flex; flex-wrap: wrap; gap: 0.4rem; }
    .sources a { background: #f0f0f0; padding: 0.2rem 0.6rem; border-radius: 15px; font-size: 0.75rem; color: #555; text-decoration: none; }
    .sources a:hover { background: #e0e0e0; }
    .mini-report { background: white; border-radius: 8px; padding: 1rem; margin-bottom: 0.8rem; box-shadow: 0 1px 4px rgba(0,0,0,0.06); border-left: 3px solid #0066cc; }
    .mini-report:last-child { margin-bottom: 0; }
    .mini-report .time { font-size: 0.8rem; color: #0066cc; font-weight: 500; }
    .mini-report .summary { font-size: 0.85rem; color: #666; margin-top: 0.3rem; }
    .deep-card { border-left: 4px solid #0066cc; padding: 1rem; margin-bottom: 1rem; background: #fafafa; border-radius: 0 8px 8px 0; }
    .deep-card:last-child { margin-bottom: 0; }
    .deep-card h4 { font-size: 1rem; color: #1a1a1a; margin-bottom: 0.5rem; }
    .deep-card h4 a { color: #0066cc; text-decoration: none; font-weight: 600; }
    .deep-card h4 a:hover { text-decoration: underline; }
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
      <a href="./">📰 最新简报</a>
      <a href="./archive/">📚 全部存档</a>
      <a href="./deep-research/" class="secondary">🔬 深度研究</a>
    </div>
    
    <div class="report-card">
      <div class="report-date">最新更新: ${TODAY} ${GENERATED_AT}</div>
      
      <div class="report-section">
        <h2>📰 最近 10 条简报</h2>
EOF

# Add latest 10 reports as mini cards
count=0
while IFS= read -r report_file; do
    if [ -f "$report_file" ]; then
        report_name=$(basename "$report_file" .json)
        report_time=$(echo "$report_name" | grep -oE '[0-9]{4}$')
        if [ -n "$report_time" ]; then
            display_time="${report_time:0:2}:${report_time:2:2}"
        else
            display_time="00:00"
        fi
        summary=$(cat "$report_file" | jq -r '.points[0]' | cut -c1-60)
        if [ ${#summary} -gt 57 ]; then
            summary="${summary}..."
        fi
        echo "        <div class=\"mini-report\">" >> "$REPORT_DIR/index.html"
        echo "          <div class=\"time\">$display_time</div>" >> "$REPORT_DIR/index.html"
        echo "          <div class=\"summary\">$summary <a href=\"./reports/$report_name.html\" style=\"color:#0066cc;font-size:0.8rem;\">[查看详情 →]</a></div>" >> "$REPORT_DIR/index.html"
        echo "        </div>" >> "$REPORT_DIR/index.html"
        count=$((count + 1))
    fi
done <<< "$LATEST_REPORTS"

cat >> "$REPORT_DIR/index.html" << 'EOF'
      </div>
    </div>
    
    <div class="report-card">
      <div class="report-section">
        <h2>📚 深度研究</h2>
EOF

# List deep research articles
for article in "$REPORT_DIR/deep-research"/*.html; do
    if [ -f "$article" ] && [ "$(basename "$article")" != "index.html" ]; then
        filename=$(basename "$article")
        title=$(grep -o '<title>[^<]*</title>' "$article" | sed 's/<title>//;s/<\/title>//' | sed 's/ - 2026//')
        if [ -z "$title" ]; then
            title="$filename"
        fi
        echo "        <div class=\"deep-card\">" >> "$REPORT_DIR/index.html"
        echo "          <h4><a href=\"./deep-research/$filename\">→ $title</a></h4>" >> "$REPORT_DIR/index.html"
        echo "        </div>" >> "$REPORT_DIR/index.html"
    fi
done

cat >> "$REPORT_DIR/index.html" << 'EOF'
      </div>
    </div>
    
    <footer>
      <p>🤖 OpenClaw AI | Updated: ${TODAY}</p>
    </footer>
  </div>
</body>
</html>
EOF

echo "Generated index.html with latest 10 reports"

# Generate archive page
mkdir -p "$REPORT_DIR/archive"
cat > "$REPORT_DIR/archive/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>全部存档 - AI Daily Report</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; background: #f5f5f5; min-height: 100vh; }
    .container { max-width: 800px; margin: 0 auto; padding: 2rem; }
    header { text-align: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid #e0e0e0; }
    header h1 { font-size: 2rem; color: #1a1a1a; margin-bottom: 0.5rem; }
    header p { color: #666; font-size: 0.9rem; }
    .back { display: inline-block; margin-bottom: 1rem; color: #0066cc; text-decoration: none; }
    .back:hover { text-decoration: underline; }
    .archive-list { background: white; border-radius: 12px; padding: 1.5rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .archive-item { padding: 1rem 0; border-bottom: 1px solid #eee; }
    .archive-item:last-child { border-bottom: none; }
    .archive-item a { font-size: 1.1rem; color: #0066cc; text-decoration: none; font-weight: 500; }
    .archive-item a:hover { text-decoration: underline; }
    .archive-item .date { font-size: 0.85rem; color: #888; margin-top: 0.3rem; }
    footer { text-align: center; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid #e0e0e0; color: #888; font-size: 0.85rem; }
  </style>
</head>
<body>
  <div class="container">
    <a href="../" class="back">← 返回首页</a>
    
    <header>
      <h1>📚 全部存档</h1>
      <p>AI Daily Report Archive</p>
    </header>
    
    <div class="archive-list">
EOF

# List all reports (newest first)
for report_file in $(ls -1t "$REPORT_DIR/reports/"*.json 2>/dev/null); do
    report_name=$(basename "$report_file" .json)
    report_date=$(echo "$report_name" | cut -d'-' -f1-3)
    report_time=$(echo "$report_name" | grep -oE '[0-9]{4}$')
    if [ -n "$report_time" ]; then
        display_time="${report_time:0:2}:${report_time:2:2}"
    else
        display_time=""
    fi
    summary=$(cat "$report_file" | jq -r '.points[0]' | cut -c1-50)
    if [ ${#summary} -gt 47 ]; then
        summary="${summary}..."
    fi
    echo "      <div class=\"archive-item\">" >> "$REPORT_DIR/archive/index.html"
    echo "        <a href=\"../reports/$report_name.html\">$report_date $display_time</a>" >> "$REPORT_DIR/archive/index.html"
    echo "        <div class=\"date\">$summary</div>" >> "$REPORT_DIR/archive/index.html"
    echo "      </div>" >> "$REPORT_DIR/archive/index.html"
done

cat >> "$REPORT_DIR/archive/index.html" << 'EOF'
    </div>
    
    <footer>
      <p>🤖 OpenClaw AI</p>
    </footer>
  </div>
</body>
</html>
EOF

echo "Generated archive/index.html"

# Generate individual report pages
for report_file in "$REPORT_DIR/reports"/*.json; do
    if [ -f "$report_file" ]; then
        report_name=$(basename "$report_file" .json)
        report_date=$(echo "$report_name" | cut -d'-' -f1-3)
        report_time=$(echo "$report_name" | grep -oE '[0-9]{4}$')
        if [ -n "$report_time" ]; then
            display_time="${report_time:0:2}:${report_time:2:2}"
        else
            display_time="$report_date"
        fi
        report_points=$(cat "$report_file" | jq -r '.points[]')
        report_sources=$(cat "$report_file" | jq -r '.sources[]')
        
        cat > "$REPORT_DIR/reports/$report_name.html" << EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI Daily Report - $display_time</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; background: #f5f5f5; min-height: 100vh; }
    .container { max-width: 800px; margin: 0 auto; padding: 2rem; }
    header { text-align: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid #e0e0e0; }
    header h1 { font-size: 2rem; color: #1a1a1a; margin-bottom: 0.5rem; }
    .back { display: inline-block; margin-bottom: 1rem; color: #0066cc; text-decoration: none; margin-right: 1rem; }
    .back:hover { text-decoration: underline; }
    .report-card { background: white; border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .report-date { font-size: 0.85rem; color: #888; margin-bottom: 1rem; }
    .report-section { margin-bottom: 1.5rem; }
    .report-section h2 { font-size: 1.1rem; color: #2c3e50; margin-bottom: 0.75rem; padding-bottom: 0.5rem; border-bottom: 1px solid #eee; }
    .report-section ul { list-style: none; padding-left: 0; }
    .report-section li { padding: 0.5rem 0; padding-left: 1.5rem; position: relative; }
    .report-section li::before { content: "•"; position: absolute; left: 0; color: #0066cc; font-weight: bold; }
    .sources { display: flex; flex-wrap: wrap; gap: 0.5rem; }
    .sources a { background: #f0f0f0; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; color: #555; text-decoration: none; }
    .sources a:hover { background: #e0e0e0; }
    footer { text-align: center; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid #e0e0e0; color: #888; font-size: 0.85rem; }
  </style>
</head>
<body>
  <div class="container">
    <a href="../archive/" class="back">← 返回</a>
    <a href="../../" class="back">首页</a>
    
    <header>
      <h1>🤖 AI Daily Report</h1>
    </header>
    
    <div class="report-card">
      <div class="report-date">$display_time</div>
      
      <div class="report-section">
        <h2>📰 热点要点</h2>
        <ul>
EOF

        while IFS= read -r point; do
            echo "          <li>$point</li>" >> "$REPORT_DIR/reports/$report_name.html"
        done <<< "$report_points"

        cat >> "$REPORT_DIR/reports/$report_name.html" << 'EOF'
        </ul>
      </div>
      
      <div class="report-section">
        <h2>🔗 来源</h2>
        <div class="sources">
EOF

        while IFS= read -r source; do
            hostname=$(echo "$source" | sed 's|https://||' | cut -d'/' -f1)
            echo "          <a href=\"$source\" target=\"_blank\">$hostname</a>" >> "$REPORT_DIR/reports/$report_name.html"
        done <<< "$report_sources"

        cat >> "$REPORT_DIR/reports/$report_name.html" << 'EOF'
        </div>
      </div>
    </div>
    
    <footer>
      <p>🤖 OpenClaw AI</p>
    </footer>
  </div>
</body>
</html>
EOF
    fi
done

echo "Generated individual report pages"

# Commit and push
cd "$REPORT_DIR"
git add index.html archive/ reports/
git commit -m "Update: home shows latest 10 reports $TODAY" || echo "No changes"
git push origin main

echo "=== Done! Vercel will auto-deploy ==="
