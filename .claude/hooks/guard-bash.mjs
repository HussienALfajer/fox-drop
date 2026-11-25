#!/usr/bin/env node
// PreToolUse (Bash|PowerShell): refuses shell writes into source folders, skipping git hooks,
// force pushes, pushes to main, permission bypasses, run-time package fetches, installs outside
// pnpm, the unpinned Flutter, removing a worktree before its SDK link, `fvm install` in a
// worktree, and a bare dart or flutter in PowerShell (lib/policy.mjs). Fails closed: any
// unexpected error blocks the call, a broken import included (the modules load inside the try).
try {
  const { block, projectDir, readEvent } = await import('./lib/io.mjs');
  const { checkBash, checkFvmInWorktree, checkPinnedSdk } = await import('./lib/policy.mjs');
  const event = await readEvent({ failClosed: true });
  const command = event.tool_input?.command;
  if (typeof command !== 'string') process.exit(0);
  const reason = checkBash(command) ?? checkFvmInWorktree(command, event.cwd);
  if (reason) block(reason);
  if (event.tool_name === 'PowerShell' && /\b(?:dart|flutter)\b/i.test(command)) {
    // Only then the PATH line is worked out: it costs a git call.
    const { pinnedFlutterBin } = await import('../../scripts/verify-support.mjs');
    const { dartOf } = await import('./lib/sdk.mjs');
    const { dirname } = await import('node:path');
    const bin = pinnedFlutterBin(projectDir(event));
    const prefix = bin
      ? `$env:PATH = "${dirname(dartOf(bin, 'win32'))};${bin};$env:PATH"; `
      : '(the pinned Flutter is missing: tell the owner; `fvm install` in the main checkout installs it)';
    const sdk = checkPinnedSdk(command, { tool: event.tool_name, prefix });
    if (sdk) block(sdk);
  }
} catch (err) {
  process.stderr.write(
    `the shell guard failed (${err instanceof Error ? err.message : String(err)}), so the call is refused.\n`,
  );
  process.exit(2);
}
