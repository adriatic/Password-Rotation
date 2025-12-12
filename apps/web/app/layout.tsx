import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Prototype B1",
  description: "ChatGPT Clone – Redwood/Next | Prototype B1",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
