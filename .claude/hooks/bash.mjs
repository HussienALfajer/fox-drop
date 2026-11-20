// PreToolUse hook on Bash (docs/claude-code-workflow.md, phase 2). Every Bash
// call is a request that resends the whole context, so:
// - reading a tracked file with cat, head, tail or sed -n, or editing one with
//   sed -i, perl -i or an inline script, is refused with the tool to use
//   (in observe mode it is only logged to .claude/bash-guard.log instead);
// - a test command's output is cut to its failures and its summary.
import { spawnSync } from 'node:child_process';
import { appendFileSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// 'observe' logs what would be refused; 'enforce' refuses it.
const MODE = 'enforce';

/** Splits a command line into pipelines of stages; each stage is { words, heredoc }. */
export function parse(command) {
  const pipelines = [[]];
  let stage = { words: [], heredoc: '' };
  let word = null;
  let pendingHeredocs = [];
  const endWord = () => {
    if (word !== null) stage.words.push(word);
    word = null;
  };
  const endStage = () => {
    endWord();
    if (stage.words.length > 0) pipelines.at(-1).push(stage);
    stage = { words: [], heredoc: '' };
  };
  const endPipeline = () => {
    endStage();
    if (pipelines.at(-1).length > 0) pipelines.push([]);
  };
  for (let i = 0; i < command.length; i++) {
    const c = command[i];
    if (c === "'" || c === '"') {
      const close = command.indexOf(c, i + 1);
      const end = close === -1 ? command.length : close;
      word = (word ?? '') + command.slice(i + 1, end);
      i = end;
    } else if (c === '\\' && i + 1 < command.length) {
      word = (word ?? '') + command[++i];
    } else if (c === '<' && command.startsWith('<<', i) && command[i + 2] !== '<') {
      endWord();
      const match = /^<<-?\s*(['"]?)([\w.-]+)\1/.exec(command.slice(i));
      if (match) {
        pendingHeredocs.push({ stage, delimiter: match[2] });
        i += match[0].length - 1;
      } else i++;
    } else if (c === '\n') {
      if (pendingHeredocs.length > 0) {
        for (const { stage: owner, delimiter } of pendingHeredocs) {
          const lines = command.slice(i + 1).split('\n');
          const last = lines.findIndex((line) => line.trim() === delimiter);
          const body = lines.slice(0, last === -1 ? lines.length : last);
          owner.heredoc += body.join('\n');
          i += body.reduce((sum, line) => sum + line.length + 1, 0) + delimiter.length + 1;
        }
        pendingHeredocs = [];
      }
      endPipeline();
    } else if (c === '&' && /[<>]/.test(command[i - 1] ?? '')) {
      word = (word ?? '') + c; // 2>&1, >&2
    } else if (c === ';' || (c === '&' && command[i + 1] === '&')) {
      if (c === '&') i++;
      endPipeline();
    } else if (c === '|' && command[i + 1] === '|') {
      i++;
      endPipeline();
    } else if (c === '|') {
      endStage();
    } else if (c === '&' && command[i + 1] !== '>') {
      endPipeline();
    } else if (/\s/.test(c)) {
      endWord();
    } else {
      word = (word ?? '') + c;
    }
  }
  endPipeline();
  return pipelines.filter((stages) => stages.length > 0);
}

/** The command name and its arguments, without environment assignments and redirections. */
function commandOf(words) {
  const rest = [...words];
  while (rest.length > 0 && /^\w+=/.test(rest[0])) rest.shift();
  while (['builtin', 'command', 'time', 'env', 'exec', 'sudo'].includes(rest[0])) rest.shift();
  const args = [];
  for (let i = 1; i < rest.length; i++) {
    const redirection = /^(\d*|&)(>>?|<)(&\d*)?/.exec(rest[i]);
    if (redirection && redirection[0].length > 0) {
      if (redirection[0] === rest[i] && !redirection[3]) i++;
      continue;
    }
    args.push(rest[i]);
  }
  return { name: path.basename(rest[0] ?? '').replace(/\.exe$/, ''), args };
}

/** The file arguments of a reading or editing command, and whether it edits in place. */
function fileArgs(name, args) {
  const files = [];
  let inPlace = false;
  let script = name === 'sed' || name === 'perl';
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--') continue;
    if (arg.startsWith('-') && arg !== '-') {
      if (name === 'sed' && (/^-[^-]*i/.test(arg) || arg.startsWith('--in-place'))) inPlace = true;
      if (name === 'perl' && /^-[^-]*i/.test(arg)) inPlace = true;
      if ((name === 'sed' || name === 'perl') && /^-[^-]*[ef]$/.test(arg)) {
        i++;
        script = false;
      } else if (name === 'perl' && /^-[^-]*e/.test(arg)) script = false;
      if ((name === 'head' || name === 'tail') && /^-[nc]$/.test(arg)) i++;
      continue;
    }
    if (script) {
      script = false;
      continue;
    }
    files.push(arg);
  }
  return { files, inPlace };
}

const READERS = new Set(['cat', 'head', 'tail', 'sed']);
const INTERPRETERS = new Set(['python', 'python3', 'py', 'node', 'deno', 'bun']);
const WRITES =
  /write_text|write_bytes|writeFileSync|writeFile\(|\.write\(|open\([^)]*['"][wa]\+?b?['"]/;
const SCRATCH = /scratchpad|[\\/]te?mp[\\/]|AppData[\\/]Local[\\/]Temp/i;

/** Turns /d/fox-drop and ~ into paths Node resolves on Windows too. */
function nativePath(file) {
  if (file.startsWith('~'))
    file = path.join(process.env.HOME ?? process.env.USERPROFILE ?? '', file.slice(1));
  if (process.platform === 'win32') file = file.replace(/^\/([a-zA-Z])(\/|$)/, '$1:/');
  return file;
}

/**
 * What the guard would refuse in a command: [{ rule, file?, reason }].
 * isTracked(file, cwd) says whether git tracks that file.
 */
export function check(command, cwd, isTracked) {
  const findings = [];
  for (const stages of parse(command)) {
    for (const stage of stages) {
      const { name, args } = commandOf(stage.words);
      if (name === 'cd' && stages.length === 1) {
        cwd = path.resolve(cwd, nativePath(args[0] ?? '~'));
        continue;
      }
      if (READERS.has(name) || name === 'perl') {
        const { files, inPlace } = fileArgs(name, args);
        const tracked = files.find((file) => isTracked(nativePath(file), cwd));
        if (!tracked) continue;
        if (inPlace)
          findings.push({
            rule: 'edit',
            file: tracked,
            reason: `Edit ${tracked} with the Edit tool, not \`${name} -i\`.`,
          });
        else if (name !== 'perl')
          findings.push({
            rule: 'read',
            file: tracked,
            reason: `Read ${tracked} with the Read tool (offset and limit for a line range) or search it with Grep, not \`${name}\`.`,
          });
      } else if (INTERPRETERS.has(name)) {
        const inline = args.findIndex((arg) => /^-[ce]$/.test(arg));
        const body =
          inline !== -1
            ? (args[inline + 1] ?? '')
            : args.length === 0 || args[0] === '-'
              ? stage.heredoc
              : '';
        if (WRITES.test(body) && !SCRATCH.test(body))
          findings.push({
            rule: 'edit',
            reason: `Edit files with the Edit tool, not an inline \`${name}\` script; a script that must run goes in the scratchpad.`,
          });
      }
    }
  }
  return findings;
}

// A test command: `pnpm verify`, `pnpm test`, vitest, Playwright, Dart and Flutter tests.
const TEST_COMMAND =
  /^(pnpm|npx|npm|yarn)\b.*\b(verify|test|test:[\w:-]+|vitest|playwright)\b|^(vitest|playwright)\b|^node\s+scripts\/verify\.mjs\b|^(dart|flutter)\s+test\b|^dart\s+run\s+melos\s+run\s+test:/;

// What may come with a test command: it runs nothing else.
const HARMLESS = /^(cd|export|echo|printf|true)\b|^node\s+(-v|--version)$/;

/**
 * The command with its output cut to failures and summary, or null when it is
 * not only test commands (and `cd`, `export`, `echo`), or already filters or
 * redirects its output. The hook allows the rewritten command, so a command
 * substitution, which could run anything, is never rewritten.
 */
export function summarized(command, filterPath, nodePath) {
  if (/(^|[^2])>|\|/.test(command.replace(/2>&1/g, '')) || /<<|\$\(|`/.test(command)) return null;
  let hasTest = false;
  for (const stages of parse(command)) {
    const words = stages[0].words;
    if (stages.length !== 1) return null;
    if (HARMLESS.test(words.join(' '))) continue;
    if (!TEST_COMMAND.test(words.join(' '))) return null;
    hasTest = true;
  }
  if (!hasTest) return null;
  const node = nodePath.replaceAll('\\', '/');
  const filter = filterPath.replaceAll('\\', '/');
  return `{ ${command.trim()}\n} 2>&1 | "${node}" "${filter}"; (exit \${PIPESTATUS[0]})`;
}

function isTrackedByGit(file, cwd) {
  const result = spawnSync('git', ['ls-files', '--error-unmatch', '--', file], {
    cwd,
    stdio: 'ignore',
  });
  return result.status === 0;
}

function main() {
  const input = JSON.parse(readFileSync(0, 'utf8'));
  const command = input.tool_input?.command;
  if (typeof command !== 'string') return;
  const root = process.env.CLAUDE_PROJECT_DIR ?? input.cwd;
  const findings = check(command, input.cwd ?? root, isTrackedByGit);
  if (findings.length > 0) {
    if (MODE === 'enforce') {
      const reason = [...new Set(findings.map((each) => each.reason))].join(' ');
      process.stdout.write(
        JSON.stringify({
          hookSpecificOutput: {
            hookEventName: 'PreToolUse',
            permissionDecision: 'deny',
            permissionDecisionReason: `${reason} Each Bash call is a request that resends the whole context; send independent tool calls in one message.`,
          },
        }),
      );
      return;
    }
    const line = {
      time: new Date().toISOString(),
      session: input.session_id,
      findings,
      command: command.slice(0, 500),
    };
    appendFileSync(path.join(root, '.claude', 'bash-guard.log'), `${JSON.stringify(line)}\n`);
  }
  const filter = path.join(path.dirname(fileURLToPath(import.meta.url)), 'test-summary.mjs');
  const rewritten = summarized(command, filter, process.execPath);
  if (rewritten)
    process.stdout.write(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: 'PreToolUse',
          permissionDecision: 'allow',
          permissionDecisionReason: 'Test output cut to its failures and summary.',
          updatedInput: { ...input.tool_input, command: rewritten },
        },
      }),
    );
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
