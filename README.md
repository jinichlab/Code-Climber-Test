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
   *(Note: this URL only works once the repo is made public **or** the org has GitHub Pages enabled on a paid plan — see the "Private repo caveat" below.)*
2. **Holds 1–3** run in your browser, no setup needed.
3. **Holds 4–12** need a real Python kernel for RDKit and PyTorch. The game will prompt you when you reach hold 4. Click the **colab: connect** pill in the top right and follow the on-screen instructions:
   - The modal opens a Colab notebook for you in a new tab
   - In Colab: **Runtime → Run all** (about 1–3 minutes the first time while it installs RDKit, PyTorch, etc.)
   - The last cell prints a **URL** and a **Token** — copy both back into the game and click **Test & Save**
4. Climb. **Three wrong answers** on a hold and your climber falls back to base camp.

That's it. Total setup: open a link, click "Run all," copy two strings.

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

---

## Private repo caveat

This repo is currently **private**. Two distribution paths require either making it public or paying for GitHub Pro/Team:

1. **The GitHub Pages URL above** — Pages is free for public repos only. On a private free-plan repo it 404s.
2. **The one-click "Open notebook" link in Colab** (`https://colab.research.google.com/github/jinichlab/...`) — Colab can only auto-load notebooks from public repos, or after each user manually authenticates Colab to read your private repo.

While the repo is private, the working distribution path is:
- **Hand the files to students** (zip them up, share via Drive/email/Slack), and have them either run the **launch scripts** locally or **upload `runner.ipynb` to Colab manually** via *File → Upload notebook*.

Flip to public any time via *Settings → General → Danger Zone → Change visibility* — none of the code in this repo is sensitive, the curriculum is generic.

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

---

## Files in this folder

| File | What it is |
|------|------------|
| `codeclimber_rdkit.html` | The full RDKit-powered game (the one to play) |
| `codeclimber.html` | All-browser version, no Colab required (uses simplified equivalents) |
| `runner.ipynb` | Colab notebook that boots a Python kernel with RDKit + PyTorch |
| `README.md` | This file |
| `install.sh` / `install.ps1` | One-line installers for Mac/Linux/Windows |
| `launch.command` / `launch.bat` / `launch.sh` | Click-to-play after files are downloaded |
| `module_3_project_guide.docx` | Original course material (not needed to play) |
| `Shi_Karry_Module_3.ipynb` | Reference solution notebook |
| `rhea_steroid_smiles.txt` | Sample dataset referenced in some holds |
| `GNN_useful_links.docx` | Background reading on graph neural networks |
