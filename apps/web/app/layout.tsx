import "./globals.css";
import type { ReactNode } from "react";

export const metadata = {
  title: "Password Rotation App",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-gray-100">
        {children}
      </body>
    </html>
  );
}
