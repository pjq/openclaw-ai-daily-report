# AI Daily Report

每日AI简报展示页面

## 部署到 Vercel

```bash
# 1. 克隆项目到 GitHub
cd ai-daily-report
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/pjq/ai-daily-report.git
git push -u origin main

# 2. 在 Vercel 上导入项目
# 访问 https://vercel.com/new 选择刚推送的仓库

# 3. 自动部署后访问
# https://ai-daily-report.vercel.app
```

## 更新每日报告

编辑 `public/reports/latest.json` 文件，然后提交推送：

```bash
# 编辑报告
vim public/reports/latest.json

# 提交并推送
git add .
git commit -m "Update daily report"
git push
```

Vercel 会自动重新部署。

## 报告格式

```json
{
  "date": "2026-03-02",
  "title": "AI Daily Report",
  "points": [
    "要点1",
    "要点2"
  ],
  "sources": [
    "https://example.com/1",
    "https://example.com/2"
  ]
}
```
