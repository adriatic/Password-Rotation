#!/bin/zsh

echo "🧹 Cleaning Next.js environment..."

# -------------------------------------------------------
# Kill ANY process using port 3000 (Next.js default)
# -------------------------------------------------------

PIDS=$(lsof -ti tcp:3000)

if [ -n "$PIDS" ]; then
  echo "🔪 Killing processes on port 3000: $PIDS"
  kill -9 $PIDS
else
  echo "✔ No process running on port 3000."
fi

# -------------------------------------------------------
# Remove build artifacts
# -------------------------------------------------------
echo "🗑 Removing .next build directory..."
rm -rf apps/web/.next

echo "🔒 Removing stale lock files..."
rm -f apps/web/.next/dev/lock

# -------------------------------------------------------
# Remove caches (Node, Turbopack)
# -------------------------------------------------------
echo "🧽 Cleaning caches..."
rm -rf node_modules/.cache 2>/dev/null || true
rm -rf apps/web/node_modules/.cache 2>/dev/null || true

# -------------------------------------------------------
# Reinstall dependencies
# -------------------------------------------------------
echo "📦 Reinstalling dependencies..."
npm install

# -------------------------------------------------------
# Start dev server
# -------------------------------------------------------
echo "🚀 Starting dev server..."
npm --workspace web run dev
