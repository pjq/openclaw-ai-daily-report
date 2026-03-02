import fs from 'fs'
import path from 'path'

interface Report {
  date: string
  title: string
  points: string[]
  sources: string[]
}

function getLatestReport(): Report | null {
  const reportsDir = path.join(process.cwd(), 'public/reports')
  
  if (!fs.existsSync(reportsDir)) {
    return null
  }
  
  const files = fs.readdirSync(reportsDir)
    .filter(f => f.endsWith('.json'))
    .sort()
    .reverse()
  
  if (files.length === 0) {
    return null
  }
  
  const latestFile = files[0]
  const content = fs.readFileSync(path.join(reportsDir, latestFile), 'utf-8')
  return JSON.parse(content)
}

export default function Home() {
  const report = getLatestReport()
  
  if (!report) {
    return (
      <div className="container">
        <header>
          <h1>AI Daily Report</h1>
          <p>每日AI简报</p>
        </header>
        <div className="report-card">
          <p style={{textAlign: 'center', color: '#888'}}>
            暂无报告
          </p>
        </div>
      </div>
    )
  }
  
  return (
    <div className="container">
      <header>
        <h1>AI Daily Report</h1>
        <p>每日AI简报</p>
      </header>
      
      <div className="report-card">
        <div className="report-date">{report.date}</div>
        
        <div className="report-section">
          <h2>📰 热点要点</h2>
          <ul>
            {report.points.map((point, i) => (
              <li key={i}>{point}</li>
            ))}
          </ul>
        </div>
        
        <div className="report-section">
          <h2>🔗 来源</h2>
          <div className="sources">
            {report.sources.map((source, i) => (
              <a key={i} href={source} target="_blank" rel="noopener noreferrer">
                {new URL(source).hostname}
              </a>
            ))}
          </div>
        </div>
      </div>
      
      <footer>
        <p>Powered by OpenClaw 🤖</p>
      </footer>
    </div>
  )
}
