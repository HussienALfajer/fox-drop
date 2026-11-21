// Prints only what an agent needs of a test command's output, which the shell
// has already written whole to the file named on the command line (bash.mjs):
// short output whole; long output cut to the step headers, the failures with
// their context, and the summary at the end, with the file's path. The shell
// writes the file, not this script, so the whole output is kept even if this
// script fails (a Node crash reading a pipe once lost a check's output).
import { readFileSync } from 'node:fs';
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
// The log of the server a Playwright run starts (`[WebServer] … http proxy
// error … ECONNREFUSED` for every API call the smoke test leaves unanswered):
// never a failure of its own. A server that fails to start is reported by
// Playwright itself, on a line without the prefix.
const SERVER_LOG = /\[WebServer\]/;

const isFailure = (line) => FAILURE.test(line) && !NOISE.test(line) && !SERVER_LOG.test(line);

/** The lines to show of a test command's output, with a note of what was cut. */
export function cut(text, savedTo) {
  const lines = text.replace(ANSI, '').replace(/\r/g, '').split('\n');
  if (lines.length <= WHOLE_UP_TO) return lines.join('\n');
  const keep = new Set();
  lines.forEach((line, i) => {
    if (HEADER.test(line)) keep.add(i);
    else if (isFailure(line))
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
  const savedTo = process.argv[2];
  process.stdout.write(`${cut(readFileSync(savedTo, 'utf8'), savedTo)}\n`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
