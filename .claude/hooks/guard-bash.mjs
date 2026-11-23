#!/usr/bin/env node
// PreToolUse (Bash|PowerShell): refuses shell writes into source folders, skipping git hooks,
// force pushes, pushes to main, permission bypasses, run-time package fetches and installs
// outside pnpm (lib/policy.mjs). Fails closed: any unexpected error blocks the call, a broken
// import included (the modules load inside the try).
try {
  const { block, readEvent } = await import('./lib/io.mjs');
  const { checkBash } = await import('./lib/policy.mjs');
  const event = await readEvent({ failClosed: true });
  const command = event.tool_input?.command;
  if (typeof command !== 'string') process.exit(0);
  const reason = checkBash(command);
  if (reason) block(reason);
} catch (err) {
  process.stderr.write(
    `the shell guard failed (${err instanceof Error ? err.message : String(err)}), so the call is refused.\n`,
  );
  process.exit(2);
}
