import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'AI Daily Report',
  description: '每日AI简报',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="zh-CN">
      <body>{children}</body>
    </html>
  )
}
