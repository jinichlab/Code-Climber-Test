// ─── Code Climber backend ─── upsert Submissions and Roster.
//
// Paste this into a Google Apps Script attached to a Google Sheet
// (Extensions → Apps Script in the bound Sheet). Then:
//   Deploy → New deployment → Web app
//     Execute as: Me
//     Who has access: Anyone
// Copy the resulting URL into the `BACKEND_URL` constant in
// codeclimber_rdkit.html.
//
// Sheets created on first request:
//   Roster       — one row per student (key: Google `sub` ID)
//   Submissions  — one row per (sub, hold) successful pass; also character_chosen audit rows

const ROSTER_SHEET = 'Roster';
const SUBMISSIONS_SHEET = 'Submissions';

function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    if (!data.event || !data.sub) {
      return jsonResponse_({ ok: false, error: 'missing event or sub' });
    }
    const ss = SpreadsheetApp.getActive();
    ensureSheets_(ss);
    const now = new Date();

    if (data.event === 'signed_in') {
      upsertRoster_(ss, {
        sub: data.sub,
        email: data.email || '',
        name: data.name || '',
        last_active: now,
        character: data.character || '',
      });
    } else if (data.event === 'character_chosen') {
      upsertRoster_(ss, {
        sub: data.sub,
        email: data.email || '',
        name: data.name || '',
        last_active: now,
        character: data.character || '',
      });
      // Audit-log every character pick as a Submissions row. Uses hold = 0 so
      // these rows don't collide with the (sub, hold>=1) key used by hold_passed
      // upserts; hold_title carries the chosen character for easy filtering.
      appendSubmissionRaw_(ss, {
        timestamp: now,
        sub: data.sub,
        email: data.email || '',
        name: data.name || '',
        hold: 0,
        hold_title: 'character_chosen: ' + (data.character || ''),
        attempts: 0,
        code: '',
      });
    } else if (data.event === 'hold_passed') {
      upsertSubmission_(ss, {
        timestamp: now,
        sub: data.sub,
        email: data.email || '',
        name: data.name || '',
        hold: Number(data.hold) || 0,
        hold_title: data.hold_title || '',
        attempts: Number(data.attempts) || 1,
        code: data.code || '',
      });
      upsertRoster_(ss, {
        sub: data.sub,
        email: data.email || '',
        name: data.name || '',
        last_active: now,
        max_hold: Number(data.hold) || 0,
        increment_passes: 1,
        character: data.character || '',
      });
    } else {
      return jsonResponse_({ ok: false, error: 'unknown event ' + data.event });
    }
    return jsonResponse_({ ok: true });
  } catch (err) {
    return jsonResponse_({ ok: false, error: String(err) });
  }
}

function doGet() {
  return jsonResponse_({ ok: true, message: 'Code Climber backend is alive.' });
}

function jsonResponse_(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}

function ensureSheets_(ss) {
  if (!ss.getSheetByName(ROSTER_SHEET)) {
    const sh = ss.insertSheet(ROSTER_SHEET);
    sh.appendRow(['sub', 'email', 'name', 'max_hold', 'holds_passed',
                  'created_at', 'last_active', 'character']);
    sh.setFrozenRows(1);
  }
  if (!ss.getSheetByName(SUBMISSIONS_SHEET)) {
    const sh = ss.insertSheet(SUBMISSIONS_SHEET);
    sh.appendRow(['timestamp', 'sub', 'email', 'name', 'hold', 'hold_title',
                  'attempts', 'code']);
    sh.setFrozenRows(1);
  }
}

function findRowBySub_(sh, sub) {
  const last = sh.getLastRow();
  if (last < 2) return -1;
  const subs = sh.getRange(2, 1, last - 1, 1).getValues();
  for (let i = 0; i < subs.length; i++) {
    if (subs[i][0] === sub) return i + 2;
  }
  return -1;
}

function upsertRoster_(ss, info) {
  const sh = ss.getSheetByName(ROSTER_SHEET);
  const row = findRowBySub_(sh, info.sub);
  if (row === -1) {
    sh.appendRow([
      info.sub,
      info.email,
      info.name,
      info.max_hold || 0,
      info.increment_passes || 0,
      new Date(),
      info.last_active,
      info.character || '',
    ]);
  } else {
    const cur = sh.getRange(row, 1, 1, 8).getValues()[0];
    const curMax = Number(cur[3]) || 0;
    const curPasses = Number(cur[4]) || 0;
    const newMax = info.max_hold ? Math.max(curMax, info.max_hold) : curMax;
    const newPasses = curPasses + (info.increment_passes || 0);
    sh.getRange(row, 1, 1, 8).setValues([[
      info.sub,
      info.email || cur[1],
      info.name || cur[2],
      newMax,
      newPasses,
      cur[5],
      info.last_active,
      info.character || cur[7] || '',
    ]]);
  }
}

// Upsert keyed on (sub, hold) — re-passing the same hold overwrites the row
// so the latest successful code is what's stored.
function upsertSubmission_(ss, s) {
  const sh = ss.getSheetByName(SUBMISSIONS_SHEET);
  const last = sh.getLastRow();
  let rowIdx = -1;
  if (last >= 2) {
    const data = sh.getRange(2, 2, last - 1, 4).getValues();
    for (let i = 0; i < data.length; i++) {
      if (data[i][0] === s.sub && Number(data[i][3]) === Number(s.hold)) {
        rowIdx = i + 2;
        break;
      }
    }
  }
  const row = [
    s.timestamp, s.sub, s.email, s.name,
    s.hold, s.hold_title, s.attempts, s.code,
  ];
  if (rowIdx === -1) {
    sh.appendRow(row);
  } else {
    sh.getRange(rowIdx, 1, 1, row.length).setValues([row]);
  }
}

// Pure append — used for non-hold events (e.g. character_chosen) so they
// don't collide with the upsert key used by hold_passed.
function appendSubmissionRaw_(ss, s) {
  const sh = ss.getSheetByName(SUBMISSIONS_SHEET);
  sh.appendRow([
    s.timestamp, s.sub, s.email, s.name,
    s.hold, s.hold_title, s.attempts, s.code,
  ]);
}
