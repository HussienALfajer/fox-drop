#!/usr/bin/env node
// PreToolUse (Bash|PowerShell): refuses shell writes into source folders, skipping git hooks,
// force pushes, pushes to main, permission bypasses, run-time package fetches, installs outside
// pnpm, the unpinned Flutter, removing a worktree before its SDK link, `fvm install` in a
// worktree, a bare dart or flutter in PowerShell, and `gh pr create` or `gh pr ready` while the
// tree's image baselines are unchecked (lib/policy.mjs). Fails closed: any unexpected error
// blocks the call, a broken import included (the modules load inside the try). The image check's
// own helper failing is the exception: it warns and allows (imageCheckDecision says why).
try {
  const { block, projectDir, readEvent } = await import('./lib/io.mjs');
  const { checkBash, checkFvmInWorktree, checkPinnedSdk, imageCheckDecision, pullRequestCommand } =
    await import('./lib/policy.mjs');
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
  const pr = pullRequestCommand(command);
  if (pr) {
    // Only for these two commands: the status costs a git diff (under a second, no Docker). The
    // checkout's own script runs, so a branch from before it existed is allowed with a warning.
    const { spawnSync } = await import('node:child_process');
    const { existsSync } = await import('node:fs');
    const { join } = await import('node:path');
    const root = projectDir(event);
    const script = join(root, 'scripts', 'baselines.mjs');
    let result = { missing: true };
    if (existsSync(script)) {
      const run = spawnSync(process.execPath, [script, '--status'], {
        cwd: root,
        encoding: 'utf8',
        timeout: 10_000,
        windowsHide: true,
      });
      result = {
        status: run.status,
        stdout: run.stdout,
        stderr: run.stderr,
        error: run.error?.code,
      };
    }
    const decision = imageCheckDecision(pr, result);
    if (decision.block) block(decision.block);
    if (decision.warn)
      process.stdout.write(`${JSON.stringify({ systemMessage: decision.warn })}\n`);
  }
} catch (err) {
  process.stderr.write(
    `the shell guard failed (${err instanceof Error ? err.message : String(err)}), so the call is refused.\n`,
  );
  process.exit(2);
}
