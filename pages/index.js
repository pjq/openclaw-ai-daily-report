import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import React, { useState } from 'react';
import ReactMarkdown from 'react-markdown';
import { Analytics } from '@vercel/analytics/next';

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

// Cyberpunk theme colors
const theme = {
  bg: '#0a0a0f',
  cardBg: '#12121a',
  border: '#1f1f3a',
  primary: '#00ffff',
  secondary: '#ff00ff',
  accent: '#39ff14',
  text: '#e0e0e0',
  muted: '#8888aa',
  gradient: 'linear-gradient(135deg, #00ffff 0%, #ff00ff 100%)',
};

// Responsive styles
const styles = {
  container: {
    maxWidth: '1200px',
    margin: '0 auto',
    padding: '30px',
    position: 'relative',
  },
  header: {
    borderBottom: `2px solid ${theme.border}`,
    paddingBottom: '25px',
    marginBottom: '30px',
    position: 'relative',
  },
  title: {
    margin: 0,
    fontSize: '2.5rem',
    background: theme.gradient,
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    textShadow: 'none',
    filter: 'drop-shadow(0 0 10px rgba(0,255,255,0.5))',
    letterSpacing: '4px',
  },
  subtitle: {
    color: theme.muted,
    margin: '10px 0 0',
    fontSize: '0.9rem',
    letterSpacing: '2px',
  },
  statusIndicator: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
  },
  statusDot: {
    width: '8px',
    height: '8px',
    borderRadius: '50%',
    background: theme.accent,
    boxShadow: `0 0 10px ${theme.accent}`,
    animation: 'pulse 2s infinite',
  },
  statusText: {
    color: theme.accent,
    fontSize: '0.8rem',
  },
  mainGrid: {
    display: 'grid',
    gridTemplateColumns: '280px 1fr',
    gap: '30px',
  },
  sidebar: {
    background: theme.cardBg,
    border: `1px solid ${theme.border}`,
    borderRadius: '8px',
    padding: '20px',
    height: 'fit-content',
  },
  sidebarTitle: {
    marginTop: 0,
    color: theme.secondary,
    fontSize: '0.85rem',
    letterSpacing: '3px',
    borderBottom: `1px solid ${theme.border}`,
    paddingBottom: '15px',
    marginBottom: '15px',
  },
  navButton: {
    width: '100%',
    textAlign: 'left',
    padding: '12px',
    border: '1px solid transparent',
    background: 'transparent',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '13px',
    color: theme.text,
    fontFamily: 'inherit',
    transition: 'all 0.2s',
  },
  navButtonActive: {
    border: `1px solid ${theme.primary}`,
    background: 'rgba(0,255,255,0.1)',
    color: theme.primary,
    boxShadow: `0 0 15px rgba(0,255,255,0.2)`,
  },
  article: {
    background: theme.cardBg,
    border: `1px solid ${theme.border}`,
    borderRadius: '8px',
    padding: '30px',
    position: 'relative',
    overflow: 'hidden',
  },
  articleTitle: {
    marginTop: 0,
    color: theme.primary,
    fontSize: '1.8rem',
    textShadow: `0 0 20px ${theme.primary}`,
    letterSpacing: '2px',
    borderBottom: `1px solid ${theme.border}`,
    paddingBottom: '15px',
    marginBottom: '20px',
  },
  articleMeta: {
    color: theme.secondary,
    fontSize: '0.85rem',
    letterSpacing: '2px',
    marginBottom: '25px',
  },
  articleContent: {
    lineHeight: '1.8',
    padding: '20px',
    background: 'rgba(0,0,0,0.3)',
    borderRadius: '6px',
    border: `1px solid ${theme.border}`,
    fontSize: '15px',
  },
  footer: {
    marginTop: '40px',
    paddingTop: '20px',
    borderTop: `1px solid ${theme.border}`,
    textAlign: 'center',
    color: theme.muted,
    fontSize: '0.8rem',
    letterSpacing: '2px',
  },
  mobileMenuBtn: {
    display: 'none',
    position: 'fixed',
    bottom: '20px',
    right: '20px',
    width: '50px',
    height: '50px',
    borderRadius: '25px',
    background: theme.gradient,
    border: 'none',
    color: '#fff',
    fontSize: '24px',
    cursor: 'pointer',
    zIndex: 1001,
    boxShadow: `0 0 20px ${theme.primary}`,
  },
};

// Mobile breakpoints
const mobileStyles = `
  @media (max-width: 768px) {
    .container { padding: 15px !important; }
    .title { font-size: 1.5rem !important; letter-spacing: 2px !important; }
    .subtitle { font-size: 0.7rem !important; }
    .status { display: none !important; }
    .grid { grid-template-columns: 1fr !important; gap: 15px !important; }
    .sidebar { position: fixed !important; top: 0 !important; left: 0 !important; width: 85% !important; height: 100vh !important; z-index: 1002 !important; border-radius: 0 !important; transform: translateX(-100%); transition: transform 0.3s ease; }
    .sidebar.open { transform: translateX(0); }
    .sidebar-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.8); z-index: 1001; }
    .sidebar-overlay.open { display: block; }
    .article { padding: 15px !important; }
    .article-title { font-size: 1.2rem !important; }
    .article-content { padding: 12px !important; font-size: 14px !important; }
    .footer { font-size: 0.65rem !important; }
    .mobile-menu-btn { display: flex !important; align-items: center; justify-content: center; }
    .nav-title { font-size: 0.75rem !important; }
    .nav-btn { font-size: 12px !important; padding: 10px !important; }
    .nav-date { font-size: 10px !important; }
  }
`;

export default function Home({ reports = [] }) {
  const [selected, setSelected] = useState(reports[0]?.slug || null);
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const currentReport = reports.find(r => r.slug === selected) || reports[0];

  const handleNavClick = (slug) => {
    setSelected(slug);
    setSidebarOpen(false);
  };

  if (!reports.length) {
    return (
      <div style={{
        background: theme.bg,
        minHeight: '100vh',
        color: theme.text,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontFamily: "'Courier New', monospace",
        padding: '20px',
      }}>
        <div style={{ textAlign: 'center' }}>
          <h1 style={{ color: theme.primary, textShadow: `0 0 20px ${theme.primary}`, fontSize: '1.5rem' }}>
            ═══ NO DATA ═══
          </h1>
          <p style={{ color: theme.muted, fontSize: '0.9rem' }}>// System awaiting input...</p>
        </div>
      </div>
    );
  }

  return (
    <div style={{
      background: theme.bg,
      minHeight: '100vh',
      color: theme.text,
      fontFamily: "'Courier New', 'Consolas', monospace",
    }}>
      <Analytics />
      
      {/* Scanline overlay */}
      <div style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        background: 'repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,255,255,0.03) 2px, rgba(0,255,255,0.03) 4px)',
        pointerEvents: 'none',
        zIndex: 1000,
      }} />

      {/* Mobile menu button */}
      <button
        className="mobile-menu-btn"
        style={styles.mobileMenuBtn}
        onClick={() => setSidebarOpen(!sidebarOpen)}
      >
        ☰
      </button>

      {/* Sidebar overlay for mobile */}
      <div
        className={`sidebar-overlay ${sidebarOpen ? 'open' : ''}`}
        onClick={() => setSidebarOpen(false)}
        style={{
          display: sidebarOpen ? 'block' : 'none',
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'rgba(0,0,0,0.8)',
          zIndex: 1001,
        }}
      />

      <div className="container" style={styles.container}>
        {/* Header */}
        <header style={styles.header}>
          <div style={{
            position: 'absolute',
            top: -10,
            left: 0,
            right: 0,
            height: '2px',
            background: theme.gradient,
            opacity: 0.7,
          }} />
          
          <h1 className="title" style={styles.title}>
            ◇ AI DAILY REPORT
          </h1>
          <p style={styles.subtitle}>
            // DAILY AI INTELLIGENCE BRIEF
          </p>
          
          <div className="status" style={{
            position: 'absolute',
            top: 0,
            right: 0,
            ...styles.statusIndicator,
          }}>
            <span style={styles.statusDot} />
            <span style={styles.statusText}>ONLINE</span>
          </div>
        </header>

        {/* Main content */}
        <div className="grid" style={styles.mainGrid}>
          {/* Sidebar */}
          <nav
            className={`sidebar ${sidebarOpen ? 'open' : ''}`}
            style={{
              ...styles.sidebar,
              position: 'fixed',
              top: 0,
              left: 0,
              width: '280px',
              height: '100vh',
              zIndex: 1002,
              transform: sidebarOpen ? 'translateX(0)' : 'translateX(-100%)',
              transition: 'transform 0.3s ease',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
              <h3 className="nav-title" style={{ ...styles.sidebarTitle, marginBottom: 0, borderBottom: 'none', paddingBottom: 0 }}>
                ▸ TRANSMISSIONS
              </h3>
              <button
                onClick={() => setSidebarOpen(false)}
                style={{
                  background: 'none',
                  border: 'none',
                  color: theme.muted,
                  fontSize: '20px',
                  cursor: 'pointer',
                  display: 'none',
                }}
              >
                ✕
              </button>
            </div>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0, overflow: 'auto', maxHeight: 'calc(100vh - 120px)' }}>
              {reports.map((report) => (
                <li key={report.slug} style={{ marginBottom: '8px' }}>
                  <button
                    className="nav-btn"
                    onClick={() => handleNavClick(report.slug)}
                    style={{
                      ...styles.navButton,
                      ...(selected === report.slug ? styles.navButtonActive : {}),
                    }}
                  >
                    <div style={{
                      fontWeight: '600',
                      marginBottom: '4px',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                    }}>
                      <span style={{
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                        maxWidth: '180px',
                      }}>
                        {report.title}
                      </span>
                      <span style={{ color: theme.secondary, fontSize: '0.7rem' }}>
                        ◆
                      </span>
                    </div>
                    <div className="nav-date" style={{
                      fontSize: '11px',
                      color: theme.muted,
                      letterSpacing: '1px',
                    }}>
                      // {report.date}
                    </div>
                  </button>
                </li>
              ))}
            </ul>
          </nav>

          {/* Main content area */}
          <main>
            {currentReport && (
              <article style={styles.article}>
                {/* Corner decorations */}
                <div style={{ position: 'absolute', top: 0, left: 0, width: '20px', height: '20px', borderTop: `2px solid ${theme.primary}`, borderLeft: `2px solid ${theme.primary}` }} />
                <div style={{ position: 'absolute', top: 0, right: 0, width: '20px', height: '20px', borderTop: `2px solid ${theme.primary}`, borderRight: `2px solid ${theme.primary}` }} />
                <div style={{ position: 'absolute', bottom: 0, left: 0, width: '20px', height: '20px', borderBottom: `2px solid ${theme.primary}`, borderLeft: `2px solid ${theme.primary}` }} />
                <div style={{ position: 'absolute', bottom: 0, right: 0, width: '20px', height: '20px', borderBottom: `2px solid ${theme.primary}`, borderRight: `2px solid ${theme.primary}` }} />

                <h2 className="article-title" style={styles.articleTitle}>
                  {currentReport.title}
                </h2>
                
                <p style={styles.articleMeta}>
                  // TIMESTAMP: {currentReport.date} ◇ SYSTEM: ONLINE
                </p>
                
                <div className="article-content" style={styles.articleContent}>
                  <style>{mobileStyles}</style>
                  <style>{`
                    article a { color: ${theme.primary}; text-decoration: none; }
                    article a:hover { text-decoration: underline; }
                    article h1, article h2, article h3 { color: ${theme.accent}; }
                    article code { background: rgba(0,255,255,0.1); padding: 2px 6px; border-radius: 3px; }
                    article pre { background: #0a0a0f; padding: 15px; border-radius: 6px; overflow-x: auto; }
                    article ul, article ol { padding-left: 20px; }
                    article li { margin-bottom: 8px; }
                    @keyframes pulse {
                      0%, 100% { opacity: 1; }
                      50% { opacity: 0.5; }
                    }
                    @media (max-width: 768px) {
                      .sidebar { width: 85% !important; max-width: 300px; }
                    }
                  `}</style>
                  <ReactMarkdown>{currentReport.content}</ReactMarkdown>
                </div>
              </article>
            )}
          </main>
        </div>

        {/* Footer */}
        <footer style={styles.footer}>
          <span style={{ color: theme.primary }}>◇</span> AI DAILY REPORT v1.0 <span style={{ color: theme.secondary }}>//</span> DAILY TECH BRIEF <span style={{ color: theme.accent }}>//</span> EST. 2026
        </footer>
      </div>
    </div>
  );
}