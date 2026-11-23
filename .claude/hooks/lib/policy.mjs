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
// edit them (docs/process/development-workflow.md §10). `.gitignore` and the CI secret scan
// still keep them out of git.

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
const DIRS = SOURCE_DIRS.map((d) => d.replace('.', '\\.')).join('|');
// Optional prefix ending in a separator, then the folder name. `docs/myapps/` does not match,
// because the prefix must end exactly before the folder name.
const PATH_INTO_SRC = String.raw`["']?(?:[^\s"'|;&<>]*?[\\/])?(?:${DIRS})[\\/]`;
const SRC = String.raw`(?:^|[\s"'=(])${PATH_INTO_SRC}`;
const SRC_AFTER_OP = String.raw`\s*${PATH_INTO_SRC}`;

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
      String.raw`(?:^|[\s;|(])(Set-Content|Add-Content|Out-File|sc|ac)\b[^|;]*${SRC}`,
      'i',
    ),
    why: 'PowerShell writes into a source folder bypass the edit hooks; use the Edit or Write tool.',
  },
  { re: /\s--no-verify\b/, why: 'Skipping git hooks (--no-verify) is not allowed.' },
  {
    re: /\bgit\s+push\b[^|;&]*(\s(-f|--force|--force-with-lease)\b|\s\+)/,
    why: 'Force-pushing is not allowed.',
  },
  {
    re: /\bgit\s+push\b[^|;&]*\s(\S+:)?(refs\/heads\/)?main(\s|$)/,
    why: '`main` changes only through a pull request; push the branch instead.',
  },
  {
    re: /(--dangerously-skip-permissions|--permission-mode[\s=]+bypassPermissions)/,
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
];

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

/** The program a word names: no path, no .cmd/.exe/.ps1, no `@version` (`pnpm@9.0.0`). */
const programName = (word) =>
  (word ?? '')
    .split(/[\\/]/)
    .pop()
    .replace(/\.(cmd|exe|ps1)$/i, '')
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
  if (program === 'npm') return args.some((a) => ['exec', 'x'].includes(a));
  if (program === 'pnpm' || program === 'yarn' || program === 'bun') {
    return args.includes('dlx') || (program === 'bun' && args.includes('x'));
  }
  if (program !== 'npx') return false;
  // `npx <local bin>` runs what the lockfile installed. npx's own options come before the
  // command; `-y`, `--package` or a versioned or `skills` command fetch from the registry.
  for (const a of args) {
    if (a.startsWith('-')) {
      if (/^(-y|--yes|-p|--package(=.*)?)$/.test(a)) return true;
      continue;
    }
    return /^skills(@.*)?$/.test(a) || /^(@[\w.-]+\/)?[\w.-]+@[^\s/]*$/.test(a);
  }
  return false;
}

/** @returns {string | null} reason the command is blocked */
export function checkBash(command) {
  const cmd = stripPayload(command);
  for (const rule of BASH_RULES) {
    if (rule.re ? rule.re.test(cmd) : rule.test(cmd)) return rule.why;
  }
  return null;
}
