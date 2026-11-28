// The paths outside a package that its code names: what a cache of the
// package's checks must hash besides the package itself. Used by
// turbo-inputs.test.mjs (Turborepo's inputs) and verify-support.test.mjs
// (the inputs of verify's Dart pass record). Over-approximated on purpose: a
// needless input costs a run, a missing one replays an old pass.
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import path from 'node:path';

export const tracked = spawnSync('git', ['-c', 'core.quotePath=false', 'ls-files'], {
  encoding: 'utf8',
})
  .stdout.split(/\r?\n/)
  .filter(Boolean);
export const trackedSet = new Set(tracked);
const trackedDirs = new Set(
  tracked.flatMap((file) =>
    file
      .split('/')
      .slice(0, -1)
      .map((_, i, all) => all.slice(0, i + 1).join('/')),
  ),
);
export const exists = (file) => trackedSet.has(file) || trackedDirs.has(file);

// A quoted string, a comment, and a code file (TypeScript, JavaScript, Dart).
const LITERAL = /'([^'\\\n]+)'|"([^"\\\n]+)"|`([^`\\\n]+)`/g;
const COMMENT = /\/\*[\s\S]*?\*\/|(^|\s)\/\/.*$/gm;
export const CODE = /\.(ts|tsx|mts|cts|js|mjs|cjs|dart)$/;

/**
 * The fixed part of a string that interpolates (`'../tokens/$file'`,
 * `` `${root}/x` ``): its folder up to the first `$`, or '' when nothing
 * before it names a folder.
 */
export function fixedPart(literal) {
  const at = literal.indexOf('$');
  if (at < 0) return literal;
  const slash = literal.lastIndexOf('/', at);
  return slash < 0 ? '' : literal.slice(0, slash + 1);
}

/**
 * The repository paths outside `dir` (a package) that a string in `file` may
 * name, and that exist and are not one of the package's parent folders: a
 * relative string (`../x`) taken from the file's folder and from each folder
 * above it up to the package's (`path.join(PACKAGE_DIR, '../x')`, or a Dart
 * test's `File('../x')` from the package folder it runs in), any other string
 * that looks like a path (a slash or a dot in it) taken from the root.
 */
export function outsidePaths(file, text, dir) {
  const literal = fixedPart(text);
  if (!literal) return new Set();
  const bases = [];
  if (/^\.\.?\//.test(literal)) {
    for (let from = path.posix.dirname(file); ; from = path.posix.dirname(from)) {
      bases.push(from);
      if (from === dir || from === '.') break;
    }
  } else if (/[/.]/.test(literal) && !/^[a-z]+:/i.test(literal)) {
    // A bare file name the package has itself (its package.json) is its own.
    if (
      literal.includes('/') ||
      !tracked.some((each) => each.startsWith(`${dir}/`) && each.endsWith(`/${literal}`))
    )
      bases.push('.');
  }
  const out = new Set();
  for (const from of bases) {
    const joined = path.posix
      .normalize(from === '.' ? literal : `${from}/${literal}`)
      .replace(/\/$/, '');
    const inside = joined === dir || joined.startsWith(`${dir}/`);
    const parent = joined === '.' || `${dir}/`.startsWith(`${joined}/`);
    if (!joined.startsWith('..') && !inside && !parent && exists(joined)) out.add(joined);
  }
  return out;
}

/**
 * The outside paths the strings of `file` name, and those named by the outside
 * code files among them (a test that runs scripts/countries.mjs reads what
 * that script reads), each once.
 */
export function readsOf(file, dir, seen = new Set()) {
  const out = new Set();
  const text = readFileSync(file, 'utf8').replace(COMMENT, '$1');
  for (const match of text.matchAll(LITERAL))
    for (const outside of outsidePaths(file, match[1] ?? match[2] ?? match[3], dir)) {
      out.add(outside);
      if (CODE.test(outside) && trackedSet.has(outside) && !seen.has(outside)) {
        seen.add(outside);
        for (const each of readsOf(outside, dir, seen)) out.add(each);
      }
    }
  return out;
}
