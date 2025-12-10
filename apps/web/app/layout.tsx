import "./globals.css";
import { AuthProvider } from "@password-rotation/auth";

export const metadata = {
  title: "Password Rotation UI",
  description: "Dashboard for automated password rotation"
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  );
}
