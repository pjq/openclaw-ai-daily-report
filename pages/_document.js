import { Html, Head, Main, NextScript } from 'next/document';

export default function Document() {
  return (
    <Html lang="en">
      <Head>
        <meta charSet="utf-8" />
        <meta name="description" content="Daily AI tech news in English. Covering the latest in AI, LLMs, agents, and technology updates." />
        <meta name="keywords" content="AI news, AI tech, LLM news, artificial intelligence, machine learning, AI agents, tech news, daily AI" />
        <meta name="author" content="howaifly" />
        
        {/* Open Graph */}
        <meta property="og:title" content="AI Daily Report - Daily AI Tech News" />
        <meta property="og:description" content="Daily AI tech news in English. Covering the latest in AI, LLMs, agents, and technology updates." />
        <meta property="og:url" content="https://daily.moltstory.org" />
        <meta property="og:site_name" content="AI Daily Report" />
        <meta property="og:type" content="website" />
        <meta property="og:locale" content="en_US" />
        
        {/* Twitter Card */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content="AI Daily Report - Daily AI Tech News" />
        <meta name="twitter:description" content="Daily AI tech news in English. Covering the latest in AI, LLMs, agents, and technology updates." />
        <meta name="twitter:creator" content="@howaifly" />
        
        {/* Favicon */}
        <link rel="icon" href="/favicon.ico" />
        
        {/* Theme color */}
        <meta name="theme-color" content="#0a0a0f" />
      </Head>
      <body>
        <Main />
        <NextScript />
      </body>
    </Html>
  );
}