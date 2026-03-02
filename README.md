# 🤖 AI Daily Report

每日AI简报 + 深度研究展示网站

## 🌐 访问地址

- **主站**: https://openclaw-ai-daily-report.pjq.me
- **每日简报**: https://openclaw-ai-daily-report.pjq.me/
- **深度研究**: https://openclaw-ai-daily-report.pjq.me/deep-research/

## 📁 项目结构

```
ai-daily-report/
├── reports/              # 每日报告 (自动生成)
│   └── YYYY-MM-DD.json  # 每日报告文件
├── deep-research/        # 深度研究文章
│   └── *.html          # 研究文章
├── deploy.sh            # 部署脚本
├── index.html           # 自动生成首页
└── vercel.json          # Vercel 配置
```

## 📝 报告格式

### 每日报告 (`reports/YYYY-MM-DD.json`)

```json
{
  "points": [
    "要点1 - 描述",
    "要点2 - 描述"
  ],
  "sources": [
    "https://example.com/article1",
    "https://example.com/article2"
  ]
}
```

### 深度研究文章

在 `deep-research/` 文件夹中添加 HTML 文件即可自动出现在首页。

## 🔄 自动部署流程 (Cron Job)

### 每日 8:00 AM 自动执行:

1. **抓取 AI 新闻** - 通过 Tavily 搜索获取最新 AI 资讯
2. **生成简报** - 整理 3-5 条技术要点 + 来源链接
3. **发送到 Telegram** - 发送给用户
4. **保存报告** - 写入 `reports/YYYY-MM-DD.json`
5. **自动部署** - 运行 `deploy.sh` → GitHub → Vercel

### 手动部署

```bash
cd /home/pjq/clawd/ai-daily-report
bash deploy.sh
```

## ⚙️ Cron 配置

Cron job 已配置在 `/home/pjq/.openclaw/cron/jobs.json`:

- **每日AI技术简报**: 8:00 AM (Asia/Shanghai)
- **天气报告**: 8:00 AM (Asia/Shanghai)

### 查看 Cron 状态

```bash
# 查看任务
cat /home/pjq/.openclaw/cron/jobs.json | jq '.jobs[] | {name, schedule, enabled}'
```

## 🔧 本地开发

```bash
# 克隆项目
git clone https://github.com/pjq/openclaw-ai-daily-report.git
cd openclaw-ai-daily-report

# 本地预览
# 使用任意静态服务器
npx serve .

# 或直接用 Python
python3 -m http.server 8080
```

## 📤 推送到 GitHub (手动)

```bash
# 添加内容
vim reports/2026-03-03.json

# 提交
git add reports/
git commit -m "Add report for 2026-03-03"
git push origin main
```

Vercel 会自动检测到推送并重新部署。

## 🔗 相关链接

- **GitHub**: https://github.com/pjq/openclaw-ai-daily-report
- **Vercel**: https://vercel.com/dashboard
- **OpenClaw Docs**: https://docs.openclaw.ai

---

🤖 Powered by OpenClaw AI Assistant
