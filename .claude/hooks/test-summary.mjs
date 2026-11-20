// Reads a test command's output on stdin and prints only what an agent needs:
// short output whole; long output cut to the step headers, the failures with
// their context, and the summary at the end. The whole output is saved to a
// file whose path is printed. Used by bash.mjs.
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const WHOLE_UP_TO = 120;
const KEEP_AT_MOST = 300;
const BEFORE = 3;
const AFTER = 12;
const TAIL = 40;

// Terminal colours: ESC [ … letter.
const ANSI = new RegExp(`${String.fromCharCode(27)}\\[[0-9;?]*[A-Za-z]`, 'g');
const HEADER = /^=== /;
const FAILURE =
  /\b(FAIL|FAILED|failed|Error|ERR!|error|AssertionError|Expected|Received|Exception)\b|✗|×|✘|❌|^\s*\d+\) |\[E\]|Some tests failed|exited with code [1-9]/;
const NOISE = /\b(0 failed|failed: 0|no errors?)\b/i;

/** The lines to show of a test command's output, with a note of what was cut. */
export function cut(text, savedTo) {
  const lines = text.replace(ANSI, '').replace(/\r/g, '').split('\n');
  if (lines.length <= WHOLE_UP_TO) return lines.join('\n');
  const keep = new Set();
  lines.forEach((line, i) => {
    if (HEADER.test(line)) keep.add(i);
    else if (FAILURE.test(line) && !NOISE.test(line))
      for (let j = Math.max(0, i - BEFORE); j <= Math.min(lines.length - 1, i + AFTER); j++)
        keep.add(j);
  });
  const tailStart = Math.max(0, lines.length - TAIL);
  const body = [...keep].filter((i) => i < tailStart).sort((a, b) => a - b);
  const kept = body.slice(0, KEEP_AT_MOST - TAIL);
  const out = [];
  let previous = -1;
  for (const i of [...kept, ...lines.keys().filter((i) => i >= tailStart)]) {
    if (i > previous + 1) out.push(`[… ${i - previous - 1} lines …]`);
    out.push(lines[i]);
    previous = i;
  }
  const note =
    body.length > kept.length ? `, ${body.length - kept.length} failure lines over the limit` : '';
  out.push(`\n[Output cut from ${lines.length} lines${note}; the whole output is in ${savedTo}]`);
  return out.join('\n');
}

function main() {
  const text = readFileSync(0, 'utf8');
  const dir = path.join(os.tmpdir(), 'claude-test-output');
  mkdirSync(dir, { recursive: true });
  const savedTo = path
    .join(dir, `${new Date().toISOString().replace(/[:.]/g, '-')}.log`)
    .replaceAll('\\', '/');
  writeFileSync(savedTo, text);
  process.stdout.write(`${cut(text, savedTo)}\n`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
