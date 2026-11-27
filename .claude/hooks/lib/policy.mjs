// Pure policy for the Claude Code hooks (ported from the owner's Shifa project, 2026-11-23).
// No I/O here, so every rule is unit-tested (.claude/hooks/hooks.test.mjs). Each check returns
// null (allowed) or a reason string. The guards are a safety net for a well-meaning agent, not a
// sandbox against an attacker: they catch the common ways to slip past the edit hooks, and CI
// checks the rest.

import { posix } from 'node:path';

/**
 * Converts an absolute or relative path to a normalised forward-slash path relative to the
 * repository root (`..` resolved; root compared case-insensitively for Windows).
 */
export function toRepoPath(filePath, projectDir) {
  const norm = (p) => posix.normalize(p.trim().replaceAll('\\', '/')).replace(/\/+$/, '');
  const file = norm(filePath);
  const root = norm(projectDir);
  const rel = file.toLowerCase().startsWith(`${root.toLowerCase()}/`)
    ? file.slice(root.length + 1)
    : file;
  return rel.replace(/^\.\//, '');
}

// Secret files (.env, keys, signing files) are not guarded: the owner allows Claude to read and
// edit them (docs/process/development-workflow.md §10). `.gitignore` keeps them out of git; the
// CI secret scan catches a secret only after its push, which in this public repository has
// already published it.

// Files a generator writes: change the source and re-run the generator instead.
const GENERATED = [
  // design-tokens/generated, core_l10n/lib/src/generated
  /(^|\/)generated\//i,
  // the Dart API client: all of lib/ is replaced by `pnpm generate:api`
  /^packages\/core_api\/lib\//i,
  // the OpenAPI document and the TypeScript client's types
  /^packages\/api-schema\/openapi\.json$/i,
  /^packages\/api-schema\/src\/schema\.ts$/i,
  /(^|\/)pnpm-lock\.yaml$/i,
  /(^|\/)pubspec\.lock$/i,
  /\.g\.dart$/i,
  /\.freezed\.dart$/i,
  /\.mocks\.dart$/i,
  // drizzle-kit's snapshots and journal
  /(^|\/)migrations\/meta\/[^/]+\.json$/i,
];

// Read-only history: cite it, never edit it.
const ARCHIVES = [/^docs\/archive\//i, /^docs\/slice-notes\.md$/i];

/**
 * Decides whether Claude may create or change a file.
 * @param {string} repoPath normalised path relative to the repository root
 * @param {{ onMain: boolean, lockedTests: string[] }} ctx onMain: the file exists on main
 *   (merged work is protected, branch work is not)
 * @returns {string | null}
 */
export function checkEdit(repoPath, { onMain, lockedTests }) {
  if (GENERATED.some((re) => re.test(repoPath))) {
    return `${repoPath} is generated; change its source and re-run the generator instead.`;
  }
  if (ARCHIVES.some((re) => re.test(repoPath))) {
    return `${repoPath} is a read-only archive; write new hand-over notes in the slice file (docs/slices/) and open items in docs/backlog.md.`;
  }
  if (onMain && /(^|\/)migrations\/[^/]+\.sql$/i.test(repoPath)) {
    return `${repoPath} is a merged migration; add a new migration instead (expand, then contract).`;
  }
  if (lockedTests.some((t) => t.toLowerCase() === repoPath.toLowerCase())) {
    return `${repoPath} is a locked test for the current slice; make the implementation pass it, or ask the owner if the test is wrong.`;
  }
  return null;
}

/**
 * Removes text that is data, not command: heredoc bodies and the values of message, body and
 * title flags. Keeps the heredoc's first line, so `cat <<EOF > packages/x` is still checked.
 */
export function stripPayload(command) {
  let out = command;
  out = out.replace(/<<-?\s*(['"]?)(\w+)\1([^\n]*)\n[\s\S]*?\n\s*\2\s*(?=\n|$)/g, '<<$2$3');
  out = out.replace(
    /(\s(?:-m|-b|-t|--message|--body|--title|--notes|-Message|-Body))(\s+|=)("(?:[^"\\]|\\.)*"|'[^']*')/g,
    '$1$2""',
  );
  return out;
}

const SOURCE_DIRS = ['apps', 'packages', 'scripts', 'infra', '.claude'];
// A path into a source folder: relative (`apps/`, `./apps\`) or absolute
// (`D:\fox-drop\apps`, `/d/fox-drop/apps`, `$CLAUDE_PROJECT_DIR/apps`), with / or \ separators.
// `.claude/worktrees/` (checkouts, whose own source folders still count) and `.claude/state/`
// (the slice's markers) are not source.
const DIRS = SOURCE_DIRS.map((d) =>
  d === '.claude' ? String.raw`\.claude(?![\\/](?:worktrees|state)[\\/])` : d,
).join('|');
// Optional prefix ending in a separator, then the folder name. `docs/myapps/` does not match,
// because the prefix must end exactly before the folder name.
const PATH_INTO_SRC = String.raw`["']?(?:[^\s"'|;&<>]*?[\\/])?(?:${DIRS})[\\/]`;
const SRC = String.raw`(?:^|[\s"'=(])${PATH_INTO_SRC}`;
const SRC_AFTER_OP = String.raw`\s*${PATH_INTO_SRC}`;

// `git`, then its global options (`-C <dir>`, `-c <name>=<value>`, `--git-dir=x`), then the
// subcommand.
const GIT = String.raw`\bgit(?:\s+-[cC]\s+\S+|\s+-\S+)*\s+`;
const unquote = (cmd) => cmd.replace(/["']/g, '');

const BASH_RULES = [
  {
    re: new RegExp(String.raw`(?:^|[^0-9&>])>{1,2}${SRC_AFTER_OP}`),
    why: 'Shell redirection into a source folder bypasses the format and edit hooks; use the Edit or Write tool.',
  },
  {
    re: new RegExp(String.raw`\btee\b[^|;&]*${SRC}`),
    why: '`tee` into a source folder bypasses the edit hooks; use the Edit or Write tool.',
  },
  {
    re: new RegExp(String.raw`\b(sed|perl)\b[^|;&]*\s-[a-zA-Z]*i[^|;&]*${SRC}`),
    why: 'In-place shell edits of source files bypass the edit hooks; use the Edit tool.',
  },
  {
    re: new RegExp(
      // `sc` and `ac` count only as the first word of a command (`rg sc apps/` is a search).
      String.raw`(?:(?:^|[;|&(\n])\s*(?:sc|ac)\b|\b(?:Set-Content|Add-Content|Out-File)\b)[^|;&\n]*${SRC}`,
      'i',
    ),
    why: 'PowerShell writes into a source folder bypass the edit hooks; use the Edit or Write tool.',
  },
  { re: /\s--no-verify\b/, why: 'Skipping git hooks (--no-verify) is not allowed.' },
  {
    re: new RegExp(String.raw`${GIT}commit\b[^|;&\n]*\s-[a-zA-Z]*n[a-zA-Z]*(\s|$)`),
    why: 'Skipping git hooks (git commit -n) is not allowed.',
  },
  {
    re: new RegExp(
      String.raw`${GIT}push\b[^|;&\n]*(\s-[a-zA-Z]*f[a-zA-Z]*(\s|$)|\s--force(-with-lease)?(=\S*)?(\s|$)|\s\+)`,
    ),
    why: 'Force-pushing is not allowed.',
  },
  {
    // Quotes removed first, so `"main"` and `HEAD:'main'` count; an empty source deletes main.
    test: (cmd) =>
      new RegExp(
        String.raw`${GIT}push\b[^|;&\n]*(\s(\S*:)?(refs/heads/)?main(\s|$)|\s--(mirror|all)\b)`,
      ).test(unquote(cmd)),
    why: '`main` changes only through a pull request; push the branch instead.',
  },
  {
    test: (cmd) =>
      /(--dangerously-skip-permissions|--permission-mode[\s=]+bypassPermissions)/.test(
        unquote(cmd),
      ),
    why: 'Claude never starts a session that skips permissions; the owner chooses the permission mode.',
  },
  // Setup prompts in node_modules and on the web ask agents to fetch skills and packages at run
  // time, outside the lockfile.
  {
    test: (cmd) => commandSegments(cmd).some(fetchesAndRuns),
    why: 'Packages are not fetched and run at run time (npx -y, npx <pkg>@<version>, npm exec, pnpm/yarn dlx, bunx, pnpx, also behind pnpm exec, yarn exec or corepack); add an exact pin with pnpm, and write agent skills in this repository.',
  },
  {
    test: (cmd) => commandSegments(cmd).some(installsOutsidePnpm),
    why: 'Packages are installed with pnpm only (lockfile, exact pins); never npm, yarn or bun.',
  },
  {
    re: /(?:^|[\s"'=(&|;:,])(?:c:[\\/]+|\/c\/)flutter(?=[\\/"'\s;&|:]|$)/i,
    why: "`C:\\flutter` is Flutter 3.41.2, not the pinned SDK (.fvmrc). Use `.fvm/flutter_sdk` (the main checkout's in a worktree): in Bash it is already first on PATH; `pnpm verify` and the hooks use it by themselves.",
  },
  {
    test: removesWorktreeWithSdkLink,
    why: 'Removing a worktree before its `.fvm/flutter_sdk` link follows the link and empties the shared Flutter SDK (2026-11-25). Remove the link alone first, in the same command: Git Bash `rm -f "<worktree>/.fvm/flutter_sdk" && git worktree remove "<worktree>"`; PowerShell `cmd /c rmdir "<worktree>\\.fvm\\flutter_sdk"; git worktree remove "<worktree>"` (never Remove-Item on the link: Windows PowerShell 5.1 deletes what it points to).',
  },
];

// The root of a worktree under `.claude/worktrees/` (or the folder itself), not a path inside it.
const WORKTREE_ROOT = new RegExp(
  String.raw`\.claude[\\/]+worktrees(?:[\\/]+[^\s"'\\/*;&|]+)?[\\/]*\*?(?=["'\s;&|]|$)`,
  'i',
);
// Deletes only the link: `rm` without -r, `unlink`, `rmdir` without /s (also through `cmd /c`).
const UNLINKS_SDK =
  /(?:^|[\s"'(])(?:rm(?:\s+-f)?|unlink|rmdir)\s+["']?[^\s"']*\.fvm[\\/]+flutter_sdk[\\/]?["']?\s*$/i;

const SDK_LINK = /\.fvm[\\/]+flutter_sdk/i;

function removesWorktree(segment) {
  if (new RegExp(String.raw`${GIT}worktree\s+remove\b`).test(segment)) return true;
  const recursive =
    /\brm\s+(?:\S+\s+)*?(?:-[a-zA-Z]*[rR][a-zA-Z]*|--recursive)(?:\s|$)/.test(segment) ||
    /\b(?:Remove-Item|ri|rd|rmdir|del)\b[^\n]*(?:-Recurse\b|\/s\b)/i.test(segment);
  return recursive && WORKTREE_ROOT.test(segment);
}

// A delete that follows the link into the SDK: recursive, or PowerShell's Remove-Item.
const deletesThroughLink = (segment) =>
  SDK_LINK.test(segment) &&
  (/\brm\s+(?:\S+\s+)*?(?:-[a-zA-Z]*[rR][a-zA-Z]*|--recursive)(?:\s|$)/.test(segment) ||
    /\b(?:Remove-Item|ri|del)\b|\b(?:rd|rmdir)\b[^\n]*\/s\b/i.test(segment));

/**
 * True when the command removes a worktree (`git worktree remove`, or a recursive delete of
 * `.claude/worktrees/<name>`) without first removing a `.fvm/flutter_sdk` link on its own, or
 * deletes such a link in a way that follows it into the SDK.
 */
function removesWorktreeWithSdkLink(cmd) {
  let unlinked = false;
  for (const segment of cmd.split(/&&|\|\||[;|&\n]/)) {
    if (deletesThroughLink(segment)) return true;
    if (UNLINKS_SDK.test(segment.trim())) unlinked = true;
    else if (removesWorktree(segment) && !unlinked) return true;
  }
  return false;
}

/**
 * PowerShell commands never get the session's PATH from CLAUDE_ENV_FILE (Claude Code passes no
 * value with `/` or `\` to them on Windows), so a bare `dart` or `flutter` there would run the
 * PATH's own Flutter. Refuses one unless the command names the pinned SDK (`.fvm/flutter_sdk`).
 * @param {string} command
 * @param {{ tool?: string, prefix: string }} ctx prefix: the PowerShell line that puts the
 *   pinned SDK first on PATH
 * @returns {string | null}
 */
export function checkPinnedSdk(command, { tool, prefix }) {
  if (tool !== 'PowerShell') return null;
  const cmd = stripPayload(command);
  if (/\.fvm[\\/]+flutter_sdk/i.test(cmd)) return null;
  if (!commandSegments(cmd).some(({ program }) => program === 'dart' || program === 'flutter'))
    return null;
  return `A bare dart or flutter in PowerShell runs the PATH's Flutter (C:\\flutter, 3.41.2), not the pinned one. Start the command with: ${prefix}`;
}

/**
 * `fvm install` or `fvm use` inside a worktree links a second `.fvm/flutter_sdk` there, which a
 * later worktree removal follows into the shared SDK. A worktree uses the main checkout's.
 * @param {string} command
 * @param {string | undefined} cwd the event's working folder
 */
export function checkFvmInWorktree(command, cwd) {
  if (!cwd || !/[\\/]\.claude[\\/]+worktrees[\\/]/i.test(`${cwd}/`)) return null;
  const runsFvm = commandSegments(stripPayload(command)).some(
    ({ program, args }) => program === 'fvm' && ['install', 'use'].includes(args[0]),
  );
  return runsFvm
    ? "A worktree uses the main checkout's pinned Flutter (scripts/verify-support.mjs, pinnedFlutterBin); `fvm install` or `fvm use` here would link a second SDK that a worktree removal can empty. Run it in the main checkout, or ask the owner."
    : null;
}

const WRAPPERS = new Set(['sudo', 'command', 'exec', 'env', 'time', 'nice']);
// Programs that start another program: `corepack <pm>[@version]`, `pnpm exec|x`, `pnpm <tool>`
// (pnpm falls back to exec), `yarn exec`, `yarn workspace <w> exec`, `bun x`, `npx <pm>`,
// `timeout 60 …`, `nohup …`, `xargs …` and wrappers with options (`sudo -u root …`). Parsing
// every option of every version would fail open on the first unknown one, so the guard fails
// closed instead: after such a program, every later word that is not an option is checked again
// as a program with the words after it. `pnpm exec npx -y x` is refused like `npx -y x`;
// `pnpm exec tsc -p x` stays allowed, since neither `tsc` nor `x` fetch.
const RUNNERS = new Set([
  'pnpm',
  'yarn',
  'bun',
  'corepack',
  'npx',
  'timeout',
  'nohup',
  'xargs',
  'cross-env',
  ...WRAPPERS,
]);

/** The program a word names: no path, no .cmd/.bat/.exe/.ps1, no `@version` (`pnpm@9.0.0`). */
const programName = (word) =>
  (word ?? '')
    .split(/[\\/]/)
    .pop()
    .replace(/\.(cmd|bat|exe|ps1)$/i, '')
    .replace(/(?<=.)@.*$/, '')
    .toLowerCase();

/**
 * Each simple command of a shell line, with the programs a package manager may start: its program
 * and words. The words after a runner give extra entries marked `nested`.
 */
function commandSegments(cmd) {
  // A quoted string with spaces or separators is an argument (a grep pattern, a message), never
  // a command; a short quoted word ("npm", "skills@latest") stays, unquoted below.
  const masked = cmd.replace(/"[^"]*[\s;&|`(][^"]*"|'[^']*[\s;&|`(][^']*'/g, 'Q');
  return masked.split(/[;&|\n]+|\$\(|`|\(/).flatMap((segment) => {
    const words = segment
      .trim()
      .split(/\s+/)
      .filter(Boolean)
      .map((w) => w.replace(/^["']+|["']+$/g, ''));
    let i = 0;
    while (i < words.length && (/^\w+=/.test(words[i]) || WRAPPERS.has(words[i]))) i += 1;
    const program = programName(words[i]);
    const out = [{ program, args: words.slice(i + 1), nested: false }];
    // After a skipped wrapper (`sudo -u root …`) the "program" may be one of its options.
    if (!RUNNERS.has(program) && i === 0) return out;
    for (let j = i + 1; j < words.length; j += 1) {
      if (words[j].startsWith('-')) continue;
      out.push({ program: programName(words[j]), args: words.slice(j + 1), nested: true });
    }
    return out;
  });
}

const NPM_INSTALL = new Set([
  'i',
  'in',
  'ins',
  'inst',
  'insta',
  'instal',
  'install',
  'isnt',
  'isntall',
  'add',
  'ci',
  'it',
  'install-test',
  'install-ci-test',
  'install-clean',
  'isntall-clean',
]);

function installsOutsidePnpm({ program, args, nested }) {
  if (program === 'npm') return args.some((a) => NPM_INSTALL.has(a));
  // A bare `yarn` installs; a bare word `yarn` after a runner is more often a package name
  // (`pnpm why yarn`), so only the add and install subcommands count there.
  if (program === 'yarn')
    return (args.length === 0 && !nested) || args.some((a) => ['add', 'install'].includes(a));
  if (program === 'bun') return args.some((a) => ['add', 'install', 'i'].includes(a));
  return false;
}

function fetchesAndRuns({ program, args }) {
  if (program === 'bunx' || program === 'pnpx') return true;
  // `create <x>` (and `npm init <x>`) fetches and runs the create-<x> package.
  const first = args.find((a) => !a.startsWith('-'));
  if (['npm', 'pnpm', 'yarn', 'bun'].includes(program) && first === 'create') return true;
  if (program === 'npm') {
    if (first === 'init' && args.slice(args.indexOf('init') + 1).some((a) => !a.startsWith('-')))
      return true;
    return args.some((a) => ['exec', 'x'].includes(a));
  }
  if (program === 'pnpm' || program === 'yarn' || program === 'bun') {
    return args.includes('dlx') || (program === 'bun' && args.includes('x'));
  }
  if (program !== 'npx') return false;
  // `npx <local bin>` runs what the lockfile installed. npx's own options come before the
  // command; `-y`, `--package` or a package spec (versioned, scoped, a path, a URL, a git host,
  // create-*, skills) fetch from the registry.
  for (const a of args) {
    if (a.startsWith('-')) {
      if (/^(-y|--yes|-p.*|--package(=.*)?)$/.test(a)) return true;
      continue;
    }
    return /^(skills|create-[\w.-]+)(@.*)?$/.test(a) || /^@|.@|[:/]/.test(a);
  }
  return false;
}

// A shell started with a command string runs that string (`bash -c "npx -y x"`,
// `pwsh -Command '…'`, `cmd /c npx -y x`).
const SHELL_WITH_COMMAND = new RegExp(
  String.raw`\b(?:bash|sh|zsh|dash|pwsh|powershell|cmd)(?:\.exe)?\s+(?:-\w+\s+)*?(?:-\w*c|-Command|/c|/k)\s+("([^"]*)"|'([^']*)'|(.+))`,
  'gi',
);
const innerCommands = (cmd) =>
  [...cmd.matchAll(SHELL_WITH_COMMAND)].map((m) => m[2] ?? m[3] ?? m[4]);

/** @returns {string | null} reason the command is blocked */
export function checkBash(command, depth = 0) {
  const cmd = stripPayload(command);
  for (const rule of BASH_RULES) {
    if (rule.re ? rule.re.test(cmd) : rule.test(cmd)) return rule.why;
  }
  // The string a shell is started with is checked too.
  if (depth < 3) {
    for (const inner of innerCommands(cmd)) {
      const reason = checkBash(inner, depth + 1);
      if (reason) return reason;
    }
  }
  return null;
}

/**
 * Which pull request command the shell line runs: 'gh pr create' (a draft included) or
 * 'gh pr ready' (not `--undo`), else null. Text in messages, heredocs and quoted arguments is
 * not a command; the string a shell is started with is.
 * @param {string} command
 * @returns {string | null}
 */
export function pullRequestCommand(command, depth = 0) {
  const cmd = stripPayload(command);
  for (const { program, args } of commandSegments(cmd)) {
    if (program !== 'gh' || args.includes('--help') || args.includes('-h')) continue;
    const pr = args.indexOf('pr');
    const sub = pr >= 0 ? args[pr + 1] : undefined;
    if (sub === 'create' || (sub === 'ready' && !args.includes('--undo'))) return `gh pr ${sub}`;
  }
  if (depth < 3)
    for (const inner of innerCommands(cmd)) {
      const found = pullRequestCommand(inner, depth + 1);
      if (found) return found;
    }
  return null;
}

/**
 * Whether a pull request may be opened (or marked ready) on this tree, from the result of
 * `node scripts/baselines.mjs --status`: exit 0 when the tree's image baselines are checked or
 * the change cannot alter an image, 1 with one line saying what to run.
 *
 * Exit 1 refuses: a pull request with unchecked images fails CI's `visual` or `golden` job, and
 * its author knew it in advance. Anything else (the script missing on a branch from before it
 * existed, a crash, a timeout) allows the command with a warning: this rule saves a CI run, it
 * guards nothing a mistake could break, and a broken helper must not stop every pull request.
 * CI's image jobs stay the gate. (The guard's own errors still refuse the call: guard-bash.mjs.)
 * @param {string} what the pull request command (`pullRequestCommand`)
 * @param {{ missing?: boolean, status?: number | null, stdout?: string, stderr?: string,
 *   error?: string }} result missing: no scripts/baselines.mjs in the checkout; error: why it
 *   could not run (a spawn error code, ETIMEDOUT)
 * @returns {{ block?: string, warn?: string }}
 */
export function imageCheckDecision(what, result) {
  const unchecked = 'CI checks the images instead (the visual and golden jobs).';
  if (result.missing)
    return {
      warn: `${what}: this checkout has no scripts/baselines.mjs, so its image baselines were not checked; ${unchecked}`,
    };
  if (!result.error && result.status === 0) return {};
  const line = (text) => (text ?? '').trim().split(/\r?\n/).find(Boolean);
  // A crash exits 1 too, with a stack on stderr and no status line.
  const status = line(result.stdout);
  if (!result.error && result.status === 1 && status?.startsWith('baselines: '))
    return {
      block: `${status}. A pull request with unchecked images fails CI's visual or golden job, so ${what} waits for that run.`,
    };
  const why =
    result.error ?? `exit ${result.status}${line(result.stderr) ? `: ${line(result.stderr)}` : ''}`;
  return {
    warn: `${what}: the image check (node scripts/baselines.mjs --status) could not run (${why}), so the command is allowed; ${unchecked} Fix the helper.`,
  };
}
