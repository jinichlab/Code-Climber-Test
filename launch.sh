#!/usr/bin/env bash
# Click-to-launch for Linux. Run with: ./launch.sh

cd "$(dirname "$0")"

PORT="${CC_PORT:-8765}"
PAGE="codeclimber_rdkit.html"
URL="http://localhost:${PORT}/${PAGE}"

if command -v python3 >/dev/null 2>&1; then
  PY=python3
else
  echo "✗ Python 3 not found. Install with: sudo apt install python3   (or your distro's equivalent)"
  exit 1
fi

( sleep 1 && (xdg-open "$URL" 2>/dev/null || echo "Open this URL in your browser: $URL") ) &

echo "════════════════════════════════════════════════════════════════"
echo "  Code Climber is running at: $URL"
echo "  Press Ctrl+C to stop the server."
echo "════════════════════════════════════════════════════════════════"
echo

exec "$PY" -m http.server "$PORT"
