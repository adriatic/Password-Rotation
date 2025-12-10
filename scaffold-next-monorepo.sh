#!/bin/zsh

set -e

############################################################
# NODE.JS AUTO-DETECTION AND PATH REPAIR
############################################################

echo "🔍 Checking Node.js environment..."

# 1. Try standard PATH
if command -v node >/dev/null 2>&1; then
  echo "✔ Node detected: $(node -v)"
else
  echo "⚠️ Node not found in PATH. Attempting recovery..."

  # 2. Try Homebrew Node
  if [ -x "/opt/homebrew/bin/node" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    echo "✔ Loaded Homebrew Node: $(node -v)"
  else
    echo "ℹ️ Homebrew Node not found."
  fi

  # 3. Try loading nvm
  export NVM_DIR="$HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "🔁 Loading nvm..."
    . "$NVM_DIR/nvm.sh"

    if command -v node >/dev/null 2>&1; then
      echo "✔ Node detected via nvm: $(node -v)"
    else
      echo "⚠️ nvm loaded, but node still not found."
    fi
  else
    echo "ℹ️ nvm is not installed or cannot be located."
  fi
fi

# Final check
if ! command -v node >/dev/null 2>&1; then
  echo ""
  echo "❌ ERROR: Node.js is not installed or not accessible."
  echo "Please install Node before running this script:"
  echo ""
  echo "   Homebrew: brew install node"
  echo "   or NVM:   brew install nvm; nvm install --lts"
  echo ""
  exit 1
fi

echo "✔ Node environment OK"
echo ""


############################################################
# VERIFY GIT REPO
############################################################

echo "🚀 Setting up Next.js Monorepo inside EXISTING Git repo..."

if [ ! -d ".git" ]; then
  echo "❌ ERROR: This directory is not a Git repository."
  exit 1
fi

echo "✔ Git repo detected. Remote stays untouched."

if [ -n "$(git status --porcelain)" ]; then
  echo "⚠️  WARNING: You have uncommitted changes."
  echo "It is recommended to commit or stash before running this script."
  read -q "REPLY?Continue anyway? (y/n) "
  echo
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

############################################################
# CREATE ROOT WORKSPACES
############################################################

echo "📁 Creating workspace folders (apps/, packages/, backend/)..."

mkdir -p apps
mkdir -p packages
mkdir -p backend


############################################################
# ROOT CONFIGURATION FILES
############################################################

echo "📝 Creating root-level package.json, tsconfig.json, Tailwind preset..."

cat << 'EOF' > package.json
{
  "name": "password-rotation-monorepo",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*",
    "backend/*"
  ],
  "scripts": {
    "build": "npm run build:packages && npm run build:apps",
    "build:packages": "npm -w @password-rotation/ui run build && npm -w @password-rotation/auth run build && npm -w @password-rotation/api run build",
    "build:apps": "npm -w web run build"
  }
}
EOF

cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "strict": true,
    "jsx": "preserve"
  }
}
EOF

cat << 'EOF' > tailwind.workspace.preset.js
module.exports = {
  theme: { extend: {} },
  plugins: []
};
EOF


############################################################
# CREATE NEXT.JS APP
############################################################

echo "🌐 Creating Next.js app inside apps/web ..."

cd apps

if [ -d "web" ]; then
  echo "❌ ERROR: apps/web already exists. Remove or rename it first."
  exit 1
fi

npm create next-app@latest web --typescript --eslint --app --tailwind --src-dir --no-import-alias

cd web

echo "🛠 Adjusting Tailwind config for monorepo..."

cat << 'EOF' > tailwind.config.js
const preset = require('../../../tailwind.workspace.preset');

module.exports = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "../../../packages/ui/src/**/*.{ts,tsx}"
  ],
  presets: [preset],
};
EOF


############################################################
# CREATE APP ROUTES
############################################################

cat << 'EOF' > app/layout.tsx
import "../styles/globals.css";
import { AuthProvider } from "@password-rotation/auth/auth-provider";

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
EOF

cat << 'EOF' > app/page.tsx
import Link from "next/link";

export default function Home() {
  return (
    <main className="flex flex-col items-center mt-20">
      <h1 className="text-4xl font-bold mb-4">Password Rotation UI</h1>
      <Link href="/dashboard" className="text-blue-600 underline">
        Go to Dashboard →
      </Link>
    </main>
  );
}
EOF

mkdir -p app/dashboard
cat << 'EOF' > app/dashboard/page.tsx
"use client";

import { useAuth } from "@password-rotation/auth/use-auth";
import { Card } from "@password-rotation/ui/Card";

export default function Dashboard() {
  const { user } = useAuth();

  return (
    <div className="p-10">
      <Card>
        <h2 className="text-xl font-bold mb-4">Dashboard</h2>
        {user ? (
          <p>Welcome, {user.email}</p>
        ) : (
          <p>You are not logged in.</p>
        )}
      </Card>
    </div>
  );
}
EOF

mkdir -p app/login
cat << 'EOF' > app/login/page.tsx
"use client";

import { useAuth } from "@password-rotation/auth/use-auth";
import { Button } from "@password-rotation/ui/Button";

export default function Login() {
  const { login } = useAuth();
  return (
    <main className="flex flex-col mt-20 items-center">
      <Button onClick={() => login("test@example.com", "password")}>
        Fake Login
      </Button>
    </main>
  );
}
EOF

mkdir -p app/api/rotate
cat << 'EOF' > app/api/rotate/route.ts
import { NextResponse } from "next/server";

export async function POST() {
  return NextResponse.json({ status: "Rotation triggered" });
}
EOF

cd ../..


############################################################
# SHARED PACKAGES
############################################################

echo "📦 Creating shared packages (ui, auth, api)..."

mkdir -p packages/ui/src
mkdir -p packages/auth/src
mkdir -p packages/api/src


############################################################
# UI PACKAGE
############################################################

cat << 'EOF' > packages/ui/package.json
{
  "name": "@password-rotation/ui",
  "version": "0.1.0",
  "main": "src/index.ts",
  "types": "src/index.ts"
}
EOF

cat << 'EOF' > packages/ui/src/index.ts
export * from "./Button";
export * from "./Card";
export * from "./Input";
EOF

cat << 'EOF' > packages/ui/src/Button.tsx
export function Button({ children, ...props }) {
  return (
    <button
      className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      {...props}
    >
      {children}
    </button>
  );
}
EOF

cat << 'EOF' > packages/ui/src/Card.tsx
export function Card({ children }) {
  return (
    <div className="p-4 border rounded-xl bg-white shadow">
      {children}
    </div>
  );
}
EOF

cat << 'EOF' > packages/ui/src/Input.tsx
export function Input(props) {
  return (
    <input
      className="border rounded px-3 py-2 w-full"
      {...props}
    />
  );
}
EOF


############################################################
# AUTH PACKAGE
############################################################

cat << 'EOF' > packages/auth/package.json
{
  "name": "@password-rotation/auth",
  "version": "0.1.0",
  "main": "src/index.ts",
  "types": "src/index.ts"
}
EOF

cat << 'EOF' > packages/auth/src/index.ts
export * from "./auth-provider";
export * from "./use-auth";
export * from "./roles";
EOF

cat << 'EOF' > packages/auth/src/auth-provider.tsx
"use client";

import { createContext, useContext, useState } from "react";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);

  const login = (email: string) => setUser({ email });
  const logout = () => setUser(null);

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
EOF

cat << 'EOF' > packages/auth/src/roles.ts
export const Roles = {
  USER: "user",
  ADMIN: "admin"
};
EOF


############################################################
# API PACKAGE
############################################################

cat << 'EOF' > packages/api/package.json
{
  "name": "@password-rotation/api",
  "version": "0.1.0",
  "main": "src/index.ts",
  "types": "src/index.ts"
}
EOF

cat << 'EOF' > packages/api/src/index.ts
export * from "./rotate";
EOF

cat << 'EOF' > packages/api/src/rotate.ts
export async function rotateNow() {
  const res = await fetch("/api/rotate", { method: "POST" });
  return res.json();
}
EOF


############################################################
# INSTALL DEPENDENCIES
############################################################

echo "📦 Installing project dependencies..."
npm install

echo ""
echo "✨ Monorepo successfully scaffolded INSIDE your existing Git repo!"
echo ""
echo "👉 You may now commit all scaffolded files:"
echo ""
echo "   git add ."
echo "   git commit -m \"Scaffold Next.js monorepo structure\""
echo "   git push"
echo ""
echo "👉 Run the Next.js app with:"
echo ""
echo "   npm --workspace web run dev"
echo ""
