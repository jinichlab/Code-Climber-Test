# Code Climber — Module 3

A climbing-themed cheminformatics game. You scale a 12-hold rock wall by solving Python challenges that walk you through:

- Parsing molecules from SMILES with **RDKit**
- Computing molecular descriptors (molecular weight, atom counts)
- Building **Morgan fingerprints** and computing **Tanimoto similarity**
- Filtering chemical datasets with pandas + RDKit
- Train/test splits and regression metrics for QSAR models
- Preparing molecular graphs for **Graph Neural Networks** (PyTorch)

Made for chemistry and biochemistry students learning Python alongside the science. **No coding background required.**

---

## Two ways to play

### 🚀 Option A — just click a link (recommended for everyone)

> Once this repo is published on GitHub Pages, the game is a single URL. You don't install anything on your computer. You only need a free Google account (which you already have if you've used Gmail or Drive).

1. Open the game: **`https://jinichlab.github.io/Code-Climber-Test/codeclimber_rdkit.html`**
2. **Sign in with Google** when prompted. The game records your name, email, the holds you complete, and your final code per hold to the instructor's grade sheet — see [What we record](#what-we-record) below.
3. **Pick your climber** — five legendary climbers to choose from (Tommy Caldwell, Alex Honnold, Emily Harrington, Lynn Hill, Dean Potter), each with their own quirks. Tommy is the default; you can change later via the *Change climber* link in the intro modal.
4. **Holds 1–3** run in your browser, no setup needed.
5. **Holds 4–12** need a real Python kernel for RDKit and PyTorch. The game will prompt you when you reach hold 4. Click the **colab: connect** pill in the top right and follow the on-screen instructions:
   - The modal opens a Colab notebook for you in a new tab
   - In Colab: **Runtime → Run all** (about 1–3 minutes the first time while it installs RDKit, PyTorch, etc.)
   - The last cell prints a **URL** and a **Token** — copy both back into the game and click **Test & Save**
6. Climb. **Three wrong answers** on a hold and your climber falls. Lose all your lives and the climber dies — your *Best* hold (top score) resets, but the holds you've already passed in the backend remain on your record.

That's it. Total setup: open a link, sign in, click "Run all," copy two strings.

### 💻 Option B — run on your own computer

Use this if you want to play offline, or if you don't trust hosted services. You'll need Python 3 (most computers have it).

#### One-line install (Mac / Linux)

Open the **Terminal** app and paste this:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jinichlab/Code-Climber-Test/main/install.sh)
```

That command downloads the game into `~/codeclimber/`, starts a local web server, and opens your browser. You can stop the server later by closing the Terminal window.

#### One-line install (Windows)

Open **PowerShell** and paste this:

```powershell
iex (iwr -useb https://raw.githubusercontent.com/jinichlab/Code-Climber-Test/main/install.ps1)
```

#### Already downloaded the files?

Double-click the launch script for your platform:

- **Mac**: `launch.command` *(if it says "unidentified developer," right-click → Open the first time)*
- **Windows**: `launch.bat`
- **Linux**: `launch.sh`

It starts a local web server and opens the game in your browser.

---

## What we record

The game logs your progress to your instructor's Google Sheet so they can grade and see who's stuck. To avoid asking you to type your name and risking typos, we use **Sign in with Google** for identity. Specifically:

- **From your Google account**: your `sub` (a stable Google user ID), email, name, and profile picture. We do **not** see your password, contacts, or anything else in your Drive/Mail.
- **From the game**: which holds you've passed, your latest working code for each hold, how many tries each hold took, the climber you picked, and timestamps.

We do **not** record:
- Anything you type that doesn't successfully pass a hold (your draft code stays in your browser)
- Anything from your Google account beyond the four fields above

Click your identity pill (top-right of the header) and confirm to sign out. Sign-out clears your local session; previously logged progress on the instructor's Sheet stays.

---

## Lives, deaths, and characters

- **Tommy / Emily / Lynn**: 3 lives. Each fall adds visible damage (bandages, blood, torn clothes, dirt). The third fall is fatal — *YOU DIED* appears, your climber respawns at base camp with full lives, and the on-screen *Best* hold resets to 0 (your backend record is preserved).
- **Alex Honnold**: 1 life. Free-soloist — no rope, no helmet, every fall is a death.
- **Dean Potter**: ∞ lives. Carries his dog Whisper in a backpack with white BASE-jumping goggles, and a parachute deploys when he falls. Never dies.

---

## How the game works

Your climber starts at base camp (hold 1). Each hold is a small Python challenge:

- **Task** — what you have to write
- **Why this matters** — the chemical/biochemical context, so you know *why* you're doing this
- **Try asking an AI** — a copy-paste prompt for ChatGPT/Claude/etc. if you're stuck

You write code in the editor on the right. Press **Ctrl/Cmd + Enter** (or click "send it") to run it.

- ✓ **Correct** → climber moves up to the next hold
- ✗ **Wrong** → the climber loses one limb's grip (hand → foot → hand → fall)
- 💀 **3 wrong answers in a row** → the climber falls and you restart from base camp

You also have a **Hint** button (the `?` in the editor bar) if you want a nudge.

The route covers Module 3 of the cheminformatics curriculum:

| Holds | Topic | Runs on |
|------:|-------|---------|
| 1–3   | Parsing SMILES from text files | Browser (Pyodide) |
| 4–5   | RDKit molecules & molecular weight | Colab |
| 6–7   | Morgan fingerprints, Tanimoto similarity | Colab |
| 8     | Pandas + RDKit filtering pipelines | Colab |
| 9–10  | Train/test split, regression metrics | Colab |
| 11–12 | Edge indices & global pooling for GNNs | Colab |

---

## Troubleshooting

### "Pyodide failed to load" / Python pill stays red
Reload the page (Cmd-R / Ctrl-R). If it persists, check your internet connection — Pyodide downloads ~10 MB of WebAssembly the first time.

### "no response from that URL" when connecting Colab
Most often: **the Colab tab idle-disconnected.** Free Colab kicks idle sessions after ~90 minutes. Re-run all cells in the runner notebook → copy the *new* URL + token → click **Disconnect** in the game's modal → paste the new ones → **Test & Save**.

If your tab is still alive but the game can't reach it:
1. Open the URL with `/ping` appended in a new tab — e.g. `https://...trycloudflare.com/ping`. You should see `{"ok":true}`.
2. If you do, but the game still fails: you've opened the game via `file://` instead of `http://`. **Use Option A (the link) or Option B (the launch scripts)** — both serve the page over HTTP, which lets the browser fetch your Colab.

### The Colab notebook says "RDKit not found" / etc.
Re-run cell 1 (the install cell). The first run takes 1–3 minutes. If you closed and reopened the Colab tab, you'll need to do this again — the Colab session was torn down.

### My limbs come off but the climber doesn't fall
That's the design — you have **3 wrong answers** before falling. Hand-off at fail 1, foot-off at fail 2, fall at fail 3.

### The game looks tiny / cramped
The wall is designed for a wider browser window. Try expanding the window or reloading after resizing.

### "Access blocked: Authorization Error" / `origin_mismatch` on sign-in
The page's URL isn't registered as an authorized origin on the OAuth client. Instructors: open Google Cloud Console → Credentials → your OAuth client → *Authorized JavaScript origins* and add the exact origin the page is served from (e.g. `https://jinichlab.github.io` for Pages, `http://localhost:8765` for the launch scripts). Save, wait ~2 minutes, hard reload.

### Sign-in popup blocked / nothing happens when I click "Sign in with Google"
Allow popups for the page in your browser, or click the popup-blocked icon in your address bar to allow this one. If you've configured Sign in with Google in the past and chose "Disable Auto-Select," that may also intercept the flow — try a different browser to confirm.

### "Google sign-in is not configured" message in the modal
You're using a build of the HTML where `GOOGLE_CLIENT_ID` is empty. If you're an instructor forking this repo, see the [For instructors / forking this](#for-instructors--forking-this) section to set up your own OAuth client.

---

## For instructors / forking this

The game is one HTML file plus a Colab notebook:

- `codeclimber_rdkit.html` — the RDKit version (uses Colab for holds 4–12)
- `codeclimber.html` — an all-browser version (no Colab needed; uses simpler equivalents instead of real RDKit)
- `runner.ipynb` — the Colab notebook students run

To customize the curriculum, edit the `HOLDS` array near the top of either HTML file. Each hold has:

```js
{
  title: "...",
  tag: "EX 2 - RDKIT",
  runtime: "remote",          // "pyodide" | "remote"
  prompt: `<task description>`,
  why: `<biochemical context>`,
  aiPrompt: `<copy-paste AI prompt>`,
  starter: `<code template students start with>`,
  verify: `<Python that asserts the answer>`,
  hint: `<one-line nudge>`,
}
```

To deploy on GitHub Pages:

1. Push this folder to a public GitHub repo
2. Repo → **Settings → Pages → Source: Deploy from a branch**, pick `main` / `(root)` (or `/Module_3`)
3. Wait ~1 minute, GitHub gives you a URL like `https://jinichlab.github.io/Code-Climber-Test/codeclimber_rdkit.html`
4. **Update `COLAB_NOTEBOOK_URL` in the HTML** to point at your runner.ipynb on GitHub:
   ```js
   const COLAB_NOTEBOOK_URL =
     "https://colab.research.google.com/github/jinichlab/Code-Climber-Test/blob/main/runner.ipynb";
   ```
   This makes the "Open notebook" link in the connect modal a true one-click launcher.

### Setting up Google sign-in (your own OAuth client)

The HTML uses Google Identity Services to authenticate students. You need an OAuth Client ID, which is free and takes ~5 minutes:

1. Go to https://console.cloud.google.com/ → create a project (or pick an existing one).
2. **APIs & Services → OAuth consent screen** → External, fill in app name, user support email, developer email; save.
3. **APIs & Services → Credentials → Create Credentials → OAuth client ID** → *Web application*.
4. Under **Authorized JavaScript origins**, add every URL the game runs from. At minimum:
   - `https://YOUR-USERNAME.github.io` (your Pages origin, no trailing slash)
   - `http://localhost:8765` and `http://127.0.0.1:8765` (the launch scripts default to port 8765)
5. Copy the resulting Client ID (looks like `1234-abc.apps.googleusercontent.com`).
6. Open `codeclimber_rdkit.html` and replace the `GOOGLE_CLIENT_ID` constant near the top of the `<script>`:
   ```js
   const GOOGLE_CLIENT_ID = '1234-abc.apps.googleusercontent.com';
   ```
7. If you forget any origin you'll see `Error 400: origin_mismatch` on sign-in — just go back and add it. Changes take ~2 minutes to propagate.

### Setting up the grade-book backend (Google Sheet + Apps Script)

The game POSTs progress events to a Google Apps Script web app, which writes to a Google Sheet you own. Setup:

1. Create a new Google Sheet (anything, the script will create the `Roster` and `Submissions` tabs on first request).
2. **Extensions → Apps Script** in that Sheet. Replace the contents of `Code.gs` with the script bundled in this repo at [`apps_script/Code.gs`](apps_script/Code.gs) and save.
3. **Deploy → New deployment** → cog icon → **Web app**:
   - Execute as: **Me**
   - Who has access: **Anyone** (this is required so students who aren't signed into your Google account can POST progress; the URL is unguessable and only handled events are accepted)
4. Authorize the script when prompted (you'll see a "Google hasn't verified this app" warning — click *Advanced → Go to ... (unsafe)*; this is normal for personal Apps Script web apps).
5. Copy the deployment URL and paste it into the `BACKEND_URL` constant in `codeclimber_rdkit.html`:
   ```js
   const BACKEND_URL = 'https://script.google.com/macros/s/AKfy.../exec';
   ```
6. Sanity check: paste the URL into a browser. You should see `{"ok":true,"message":"Code Climber backend is alive."}`.

After deploying, **edit the existing deployment** (Manage deployments → pencil → New version → Deploy) for any future Apps Script updates so the URL stays the same. Creating a "New deployment" gives you a different URL and you'll have to update `BACKEND_URL` again.

### What the Sheet looks like

- **Roster** tab — one row per student, primary key is the Google `sub` ID. Columns: `sub | email | name | max_hold | holds_passed | created_at | last_active | character`. `max_hold` is the highest hold they've ever passed (Math.max — never decreases, even after death).
- **Submissions** tab — one row per (student, hold) successful pass. Columns: `timestamp | sub | email | name | hold | hold_title | attempts | code`. Re-passes overwrite the row, so the latest working code is what you see. Character changes are also logged here as `hold = 0` rows with `hold_title = "character_chosen: <name>"` for an audit trail; filter `hold > 0` to see only code submissions.

---

## Files in this folder

| File | What it is |
|------|------------|
| `codeclimber_rdkit.html` | The full RDKit-powered game (the one to play) |
| `codeclimber.html` | All-browser version, no Colab required (uses simplified equivalents) |
| `runner.ipynb` | Colab notebook that boots a Python kernel with RDKit + PyTorch |
| `apps_script/Code.gs` | The Google Apps Script that records progress to a Sheet (paste into Extensions → Apps Script of your bound Sheet) |
| `README.md` | This file |
| `install.sh` / `install.ps1` | One-line installers for Mac/Linux/Windows |
| `launch.command` / `launch.bat` / `launch.sh` | Click-to-play after files are downloaded |
| `module_3_project_guide.docx` | Original course material (not needed to play) |
| `Shi_Karry_Module_3.ipynb` | Reference solution notebook |
| `rhea_steroid_smiles.txt` | Sample dataset referenced in some holds |
| `GNN_useful_links.docx` | Background reading on graph neural networks |
