// The pinned Flutter and Dart (`.fvmrc`, linked at `.fvm/flutter_sdk`, the main checkout's in a
// worktree) for the hooks: format.mjs and the Stop hook call its Dart directly, the SessionStart
// hook puts it first on PATH for the session's Bash commands. The PATH's own Flutter
// (`C:\flutter`) is another version and formats differently.
import { existsSync } from 'node:fs';
import path from 'node:path';

import { pinnedFlutterBin } from '../../../scripts/verify-support.mjs';

/** The Dart executable inside a Flutter `bin` folder: `dart.exe`, never `dart.bat` (1.1 s a call). */
export function dartOf(flutterBin, platform = process.platform) {
  const dirs = [flutterBin, 'cache', 'dart-sdk', 'bin'];
  return platform === 'win32'
    ? path.win32.join(...dirs, 'dart.exe')
    : path.posix.join(...dirs, 'dart');
}

/** The pinned Dart executable for a checkout, or null when the pinned Flutter is missing. */
export function pinnedDart(root) {
  const bin = pinnedFlutterBin(root);
  if (!bin) return null;
  const dart = dartOf(bin);
  return existsSync(dart) ? dart : null;
}

/** A Windows path as Git Bash writes it (`D:\fox-drop` → `/d/fox-drop`); POSIX paths unchanged. */
export function bashPath(p, platform = process.platform) {
  if (platform !== 'win32') return p;
  return p.replaceAll('\\', '/').replace(/^([A-Za-z]):/, (_, drive) => `/${drive.toLowerCase()}`);
}

/**
 * The line the SessionStart hook appends to CLAUDE_ENV_FILE, which each later Bash command runs
 * first: the pinned Dart SDK, then the pinned Flutter, before the rest of PATH.
 */
export function pathExport(flutterBin, platform = process.platform) {
  const quote = (p) => bashPath(p, platform).replace(/(["$`\\])/g, '\\$1');
  const dartBin = path[platform === 'win32' ? 'win32' : 'posix'].dirname(
    dartOf(flutterBin, platform),
  );
  return `export PATH="${quote(dartBin)}:${quote(flutterBin)}:$PATH"\n`;
}
