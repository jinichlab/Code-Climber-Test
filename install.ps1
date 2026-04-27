# Code Climber - one-line installer for Windows.
# Downloads the game files, starts a local web server, opens the browser.
#
# Run from PowerShell:
#   iex (iwr -useb https://raw.githubusercontent.com/jinichlab/Code-Climber-Test/main/install.ps1)

$ErrorActionPreference = "Stop"

$RepoBase = "https://raw.githubusercontent.com/jinichlab/Code-Climber-Test/main"
$Target   = Join-Path $env:USERPROFILE "codeclimber"
$Port     = if ($env:CC_PORT) { $env:CC_PORT } else { "8765" }
$Page     = "codeclimber_rdkit.html"

function Say($msg) { Write-Host "> $msg" -ForegroundColor Yellow }
function Die($msg) { Write-Host "x $msg" -ForegroundColor Red; exit 1 }

# 1. Python check
Say "Checking for Python 3..."
$Python = $null
foreach ($cand in @("python", "py", "python3")) {
  $cmd = Get-Command $cand -ErrorAction SilentlyContinue
  if ($cmd) {
    $ver = & $cand --version 2>&1
    if ($ver -match "Python 3") {
      $Python = $cand
      Say "Found $ver"
      break
    }
  }
}
if (-not $Python) {
  Die "Python 3 not found. Install it from https://www.python.org/downloads/ (tick 'Add Python to PATH' during install) and re-run."
}

# 2. Download files
Say "Setting up $Target ..."
New-Item -ItemType Directory -Force -Path $Target | Out-Null
Set-Location $Target

foreach ($file in @("codeclimber.html", "codeclimber_rdkit.html", "runner.ipynb", "README.md")) {
  Say "Downloading $file..."
  try {
    Invoke-WebRequest -Uri "$RepoBase/$file" -OutFile $file -UseBasicParsing
  } catch {
    Die "Failed to download $file. Check your internet connection or that the repo is public."
  }
}

# 3. Start server + open browser
Say "Starting local web server on port $Port..."
$Url = "http://localhost:$Port/$Page"

# Open browser shortly after the server starts
Start-Job -ScriptBlock {
  param($u)
  Start-Sleep -Seconds 1
  Start-Process $u
} -ArgumentList $Url | Out-Null

Write-Host ""
Write-Host "================================================================"
Write-Host "  Code Climber is running at: $Url"
Write-Host "  Close this window (or press Ctrl+C) to stop the server."
Write-Host "================================================================"
Write-Host ""

& $Python -m http.server $Port
