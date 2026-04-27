#!/usr/bin/env bash
# Code Climber — one-line installer for Mac / Linux.
# Downloads the game files, starts a local web server, opens the browser.
#
# Run with:
#   bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USER/codeclimber/main/Module_3/install.sh)

set -euo pipefail

REPO_BASE="https://raw.githubusercontent.com/YOUR_USER/codeclimber/main/Module_3"
TARGET="${HOME}/codeclimber"
PORT="${CC_PORT:-8765}"
PAGE="codeclimber_rdkit.html"

say() { printf "\033[1;33m▸\033[0m %s\n" "$*"; }
die() { printf "\033[1;31m✗\033[0m %s\n" "$*" >&2; exit 1; }

# 1. Python check
say "Checking for Python 3…"
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1 && python -c 'import sys; sys.exit(0 if sys.version_info[0] >= 3 else 1)'; then
  PY=python
else
  die "Python 3 not found. Install it from https://www.python.org/downloads/ and re-run this script."
fi
say "Found $($PY --version)"

# 2. Download files
say "Setting up $TARGET …"
mkdir -p "$TARGET"
cd "$TARGET"

for FILE in codeclimber.html codeclimber_rdkit.html runner.ipynb README.md; do
  say "Downloading $FILE…"
  curl -fsSL "$REPO_BASE/$FILE" -o "$FILE" \
    || die "Failed to download $FILE. Check your internet connection or the repo URL."
done

# 3. Open the browser shortly after the server starts
say "Starting local web server on port $PORT…"
URL="http://localhost:${PORT}/${PAGE}"

(
  sleep 1
  if command -v open >/dev/null 2>&1; then          # macOS
    open "$URL"
  elif command -v xdg-open >/dev/null 2>&1; then    # Linux
    xdg-open "$URL"
  else
    say "Could not auto-open browser; visit: $URL"
  fi
) &

echo
echo "════════════════════════════════════════════════════════════════"
echo "  Code Climber is running at: $URL"
echo "  Press Ctrl+C in this window to stop the server."
echo "════════════════════════════════════════════════════════════════"
echo

# 4. Run the server in foreground so Ctrl+C cleanly stops it
exec "$PY" -m http.server "$PORT"
