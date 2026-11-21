// What scripts/verify.mjs and the Claude Code hooks share: the lock that keeps
// two checks from running at once in one folder, and the pinned Flutter SDK.
import { spawnSync } from 'node:child_process';
import { existsSync, linkSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';

/** Whether a process with this id is running. */
export function processAlive(pid) {
  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    return error.code === 'EPERM';
  }
}

/**
 * Takes the lock file for this process: { taken: true }, or { taken: false,
 * holder } while another running process holds it. The file appears whole or
 * not at all (a hard link of a written file), so a reader never sees it half
 * written. A lock is stale, and taken over, when its process is gone or it is
 * older than any check (a hard kill skips the release, and Windows soon gives
 * its process id to another process).
 */
export function takeLock(
  file,
  { pid = process.pid, command = '', isAlive = processAlive, now = Date.now() } = {},
) {
  const pending = `${file}.${pid}`;
  writeFileSync(pending, JSON.stringify({ pid, command, started: new Date(now).toISOString() }));
  try {
    for (let attempt = 0; attempt < 3; attempt++) {
      try {
        linkSync(pending, file);
        return { taken: true };
      } catch (error) {
        if (error.code !== 'EEXIST') throw error;
      }
      const seen = readText(file);
      if (seen === null) continue; // released meanwhile: link again
      const holder = parse(seen);
      const age = now - Date.parse(holder?.started ?? '');
      if (holder && isAlive(holder.pid) && age < STALE_AFTER_MS) return { taken: false, holder };
      // Remove the stale lock only if it is still the one read, not a fresh one.
      if (readText(file) === seen) rmSync(file, { force: true });
    }
    return { taken: false, holder: parse(readText(file)) };
  } finally {
    rmSync(pending, { force: true });
  }
}

// The Stop hook gives a check 10 minutes and a full check takes under one hour.
const STALE_AFTER_MS = 3 * 60 * 60 * 1000;

/** Removes the lock file if this process holds it. */
export function releaseLock(file, pid = process.pid) {
  if (parse(readText(file))?.pid === pid) rmSync(file, { force: true });
}

function readText(file) {
  try {
    return readFileSync(file, 'utf8');
  } catch {
    return null;
  }
}

function parse(text) {
  try {
    return JSON.parse(text);
  } catch {
    return null;
  }
}

/** This folder's own git directory (a worktree has its own), where the lock lives. */
export function gitDir(cwd = '.') {
  return gitPath(['rev-parse', '--path-format=absolute', '--git-dir'], cwd);
}

function gitCommonDir(cwd) {
  return gitPath(['rev-parse', '--path-format=absolute', '--git-common-dir'], cwd);
}

function gitPath(args, cwd) {
  const result = spawnSync('git', args, { cwd, encoding: 'utf8' });
  return result.status === 0 ? path.resolve(result.stdout.trim()) : null;
}

/**
 * The bin folder of the Flutter pinned in .fvmrc: this checkout's
 * .fvm/flutter_sdk (`fvm install` links it), else the main checkout's when
 * this is a worktree, which `fvm install` never ran in. Null when neither has
 * one (CI puts the pinned Flutter on PATH instead).
 */
export function pinnedFlutterBin(root, commonDirOf = gitCommonDir) {
  const own = path.join(root, '.fvm', 'flutter_sdk', 'bin');
  if (existsSync(own)) return own;
  const commonDir = commonDirOf(root);
  if (!commonDir) return null;
  const main = path.join(path.dirname(commonDir), '.fvm', 'flutter_sdk', 'bin');
  return existsSync(main) ? main : null;
}
