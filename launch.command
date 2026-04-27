#!/usr/bin/env bash
# Click-to-launch for Mac. Double-click this file in Finder to start Code Climber.
# (If macOS says "unidentified developer," right-click → Open the first time.)

cd "$(dirname "$0")"

PORT="${CC_PORT:-8765}"
PAGE="codeclimber_rdkit.html"
URL="http://localhost:${PORT}/${PAGE}"

if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1 && python -c 'import sys; sys.exit(0 if sys.version_info[0] >= 3 else 1)'; then
  PY=python
else
  echo "✗ Python 3 not found. Install from https://www.python.org/downloads/"
  read -n 1 -s -r -p "Press any key to close…"
  exit 1
fi

# Open the browser after a short delay (server needs a moment to bind)
( sleep 1 && open "$URL" ) &

echo "════════════════════════════════════════════════════════════════"
echo "  Code Climber is running at: $URL"
echo "  Close this window to stop the server."
echo "════════════════════════════════════════════════════════════════"
echo

exec "$PY" -m http.server "$PORT"
