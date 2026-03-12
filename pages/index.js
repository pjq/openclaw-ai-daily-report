import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import React, { useState } from 'react';
import ReactMarkdown from 'react-markdown';

const REPORTS_DIR = path.join(process.cwd(), 'reports');

export async function getStaticProps() {
  const files = fs.readdirSync(REPORTS_DIR).filter(f => f.endsWith('.md'));
  const reports = files.map(filename => {
    const slug = filename.replace('.md', '');
    const markdown = fs.readFileSync(path.join(REPORTS_DIR, filename), 'utf-8');
    const { data, content } = matter(markdown);
    return {
      slug,
      title: data.title || slug,
      date: data.date || '',
      ...data,
      content
    };
  }).sort((a, b) => new Date(b.date) - new Date(a.date));

  return { props: { reports } };
}

export default function Home({ reports = [] }) {
  const [selected, setSelected] = useState(reports[0]?.slug || null);
  
  // Ensure we have a selected report
  const currentReport = reports.find(r => r.slug === selected) || reports[0];

  if (!reports.length) {
    return (
      <div style={{ maxWidth: '900px', margin: '0 auto', padding: '20px', fontFamily: 'system-ui, sans-serif' }}>
        <h1>📰 AI Daily Report</h1>
        <p>No reports found. Run the conversion script to generate reports.</p>
      </div>
    );
  }

  return (
    <div style={{ maxWidth: '900px', margin: '0 auto', padding: '20px', fontFamily: 'system-ui, sans-serif' }}>
      <header style={{ borderBottom: '1px solid #eee', paddingBottom: '20px', marginBottom: '20px' }}>
        <h1 style={{ margin: 0 }}>📰 AI Daily Report</h1>
        <p style={{ color: '#666', margin: '5px 0 0' }}>每日AI技术要点</p>
      </header>

      <div style={{ display: 'grid', gridTemplateColumns: '250px 1fr', gap: '30px' }}>
        <nav>
          <h3 style={{ marginTop: 0, color: '#888', fontSize: '14px' }}>Reports</h3>
          <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
            {reports.map(report => (
              <li key={report.slug}>
                <button
                  onClick={() => setSelected(report.slug)}
                  style={{
                    width: '100%',
                    textAlign: 'left',
                    padding: '10px',
                    border: 'none',
                    background: selected === report.slug ? '#f0f0f0' : 'transparent',
                    borderRadius: '6px',
                    cursor: 'pointer',
                    fontSize: '14px'
                  }}
                >
                  <div style={{ fontWeight: '600' }}>{report.title}</div>
                  <div style={{ fontSize: '12px', color: '#888' }}>{report.date}</div>
                </button>
              </li>
            ))}
          </ul>
        </nav>

        <main>
          {currentReport && (
            <article key={currentReport.slug}>
              <h2 style={{ marginTop: 0 }}>{currentReport.title}</h2>
              <p style={{ color: '#888', fontSize: '14px' }}>{currentReport.date}</p>
              <div style={{ 
                lineHeight: '1.7', 
                padding: '20px', 
                background: '#fafafa', 
                borderRadius: '8px',
                overflowWrap: 'break-word'
              }}>
                <ReactMarkdown>{currentReport.content}</ReactMarkdown>
              </div>
            </article>
          )}
        </main>
      </div>
    </div>
  );
}