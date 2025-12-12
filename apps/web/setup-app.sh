#!/bin/zsh

echo "-------------------------------------------"
echo " Rebuilding Next.js app/ structure (Prototype B1 - FIXED)"
echo " WARNING: This will DELETE the existing app/ folder!"
echo "-------------------------------------------"
read "?Proceed? (y/n) " confirm

if [[ "$confirm" != "y" ]]; then
  echo "Aborted."
  exit 0
fi

echo "Deleting existing app/ directory..."
rm -rf app

echo "Recreating folder structure..."
mkdir -p app/auth/{login,signup,forgot-password}
mkdir -p app/dashboard

echo "Creating files..."
touch app/auth/login/page.tsx
touch app/auth/signup/page.tsx
touch app/auth/forgot-password/page.tsx
touch app/dashboard/layout.tsx
touch app/dashboard/page.tsx
touch app/layout.tsx
touch app/globals.css

echo "Writing boilerplate..."

# Root layout
cat > app/layout.tsx << 'EOF'
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
EOF

# Globals
cat > app/globals.css << 'EOF'
/* Basic global styles for Prototype B1 */
html, body {
  margin: 0;
  padding: 0;
  background: #fafafa;
  font-family: system-ui, sans-serif;
}

main {
  padding: 2rem;
}
EOF

# Dashboard layout
cat > app/dashboard/layout.tsx << 'EOF'
export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <section style={{ padding: "2rem" }}>
      <h1>Dashboard</h1>
      {children}
    </section>
  );
}
EOF

# Dashboard page
cat > app/dashboard/page.tsx << 'EOF'
export default function DashboardHome() {
  return (
    <main>
      <p>Welcome to the Dashboard (Prototype B1)</p>
    </main>
  );
}
EOF

# Login page
cat > app/auth/login/page.tsx << 'EOF'
export default function LoginPage() {
  return (
    <main>
      <h2>Login</h2>
      <p>This will be replaced with ClerkAuth for Prototype B1.</p>
    </main>
  );
}
EOF

# Signup page
cat > app/auth/signup/page.tsx << 'EOF'
export default function SignupPage() {
  return (
    <main>
      <h2>Sign Up</h2>
      <p>This will be replaced with ClerkAuth for Prototype B1.</p>
    </main>
  );
}
EOF

# Forgot password
cat > app/auth/forgot-password/page.tsx << 'EOF'
export default function ForgotPasswordPage() {
  return (
    <main>
      <h2>Forgot Password</h2>
      <p>A Clerk-powered password reset flow will be added later.</p>
    </main>
  );
}
EOF

echo "-------------------------------------------"
echo " App structure rebuilt successfully!"
echo " You may now run:  npm run dev"
echo "-------------------------------------------"
