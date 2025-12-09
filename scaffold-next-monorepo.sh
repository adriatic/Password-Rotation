#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# scaffold-next-monorepo.sh
#
# Run this from the root of your repo (e.g. Password-Rotation/)
# It will create:
#   - package.json (if missing) with workspaces: apps/web, apps/api
#   - turbo.json
#   - tsconfig.json
#   - apps/web  (Next.js app: TS, Tailwind, ESLint, src/, @/*, App Router)
#   - apps/api  (Next.js app: TS, ESLint, src/, @/*, App Router, no Tailwind)
# ------------------------------------------------------------------------------

ROOT_DIR="$(pwd)"
APPS_DIR="$ROOT_DIR/apps"
WEB_DIR="$APPS_DIR/web"
API_DIR="$APPS_DIR/api"

echo "🧱 Root directory: $ROOT_DIR"

# ------------------------------------------------------------------------------
# 1. Check for node & npm
# ------------------------------------------------------------------------------
if ! command -v node >/dev/null 2>&1; then
  echo "❌ node is not installed or not on PATH."
  echo "   Please install Node 20 via nvm (e.g. nvm install 20) and try again."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "❌ npm is not installed or not on PATH."
  exit 1
fi

NODE_VERSION="$(node -v)"
echo "✅ Using Node ${NODE_VERSION}"

# NOTE: We trust you've set up nvm to use Node >= 20.9.0

# ------------------------------------------------------------------------------
# 2. Ensure apps/ and subfolders exist before modifying workspaces
# ------------------------------------------------------------------------------
echo "📁 Ensuring workspace folder structure exists..."

mkdir -p "$APPS_DIR"
mkdir -p "$WEB_DIR"
mkdir -p "$API_DIR"

# We don't care if they are empty — they MUST exist before npm sees them.
echo "   - Created apps/, apps/web/, apps/api/ (if missing)"


# ------------------------------------------------------------------------------
# 3. Ensure root package.json exists before workspace config
# ------------------------------------------------------------------------------
if [ ! -f "$ROOT_DIR/package.json" ]; then
  echo "📦 No package.json found at repo root. Initializing..."
  npm init -y
else
  echo "📦 Root package.json already exists."
fi

npm pkg set private=true


# ------------------------------------------------------------------------------
# 4. Configure npm workspaces (no warnings because folders now exist)
# ------------------------------------------------------------------------------
echo "🧩 Configuring npm workspaces for apps/web and apps/api ..."

npm pkg set "workspaces[0]"="apps/web"
npm pkg set "workspaces[1]"="apps/api"


# ------------------------------------------------------------------------------
# 5. Install Turbo & create turbo.json
# ------------------------------------------------------------------------------
if [ ! -f "$ROOT_DIR/turbo.json" ]; then
  echo "🚀 Installing Turbo and creating turbo.json ..."
  npm install --save-dev turbo

  cat > "$ROOT_DIR/turbo.json" << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "dist/**"]
    },
    "dev": {
      "cache": false
    },
    "lint": {
      "outputs": []
    }
  }
}
EOF
else
  echo "🚀 turbo.json already exists. Skipping creation."
fi


# ------------------------------------------------------------------------------
# 6. Create root tsconfig.json only if missing
# ------------------------------------------------------------------------------
if [ ! -f "$ROOT_DIR/tsconfig.json" ]; then
  echo "🧠 Creating root tsconfig.json with project references ..."
  cat > "$ROOT_DIR/tsconfig.json" << 'EOF'
{
  "files": [],
  "references": [
    { "path": "apps/web" },
    { "path": "apps/api" }
  ]
}
EOF
else
  echo "🧠 tsconfig.json already exists. Leaving as-is."
fi


# ------------------------------------------------------------------------------
# 7. Create apps/web only if empty
# ------------------------------------------------------------------------------
if [ -z "$(ls -A "$WEB_DIR")" ]; then
  echo "🌐 Creating Next.js app in apps/web ..."
  npx create-next-app@latest "apps/web" \
    --ts \
    --tailwind \
    --eslint \
    --src-dir \
    --import-alias "@/*" \
    --app
else
  echo "🌐 apps/web already exists and is not empty — skipping scaffold."
fi


# ------------------------------------------------------------------------------
# 8. Create apps/api only if empty
# ------------------------------------------------------------------------------
if [ -z "$(ls -A "$API_DIR")" ]; then
  echo "🔌 Creating Next.js app in apps/api ..."
  npx create-next-app@latest "apps/api" \
    --ts \
    --eslint \
    --src-dir \
    --import-alias "@/*" \
    --app
else
  echo "🔌 apps/api already exists and is not empty — skipping scaffold."
fi
