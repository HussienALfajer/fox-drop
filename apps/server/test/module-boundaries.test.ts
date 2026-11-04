import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { ESLint } from 'eslint';
import { describe, expect, it } from 'vitest';

// Proves the boundary rule of eslint.config.mjs on a fixture with two
// modules, ledger and ordering (architecture §4.3 item 4).
const serverRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const fixtureRoot = path.join(serverRoot, 'test', 'fixtures', 'boundaries');

async function boundaryErrors(file: string): Promise<string[]> {
  const eslint = new ESLint({
    cwd: fixtureRoot,
    overrideConfigFile: path.join(serverRoot, 'eslint.config.mjs'),
    ignore: false,
    overrideConfig: { settings: { 'boundaries/root-path': fixtureRoot } },
  });
  const [result] = await eslint.lintFiles([path.join(fixtureRoot, file)]);
  return (result?.messages ?? [])
    .filter((message) => message.ruleId === 'boundaries/dependencies')
    .map((message) => message.message);
}

// The first lint loads the TypeScript resolver, which takes seconds when the
// database tests run beside it.
describe('module boundaries', { timeout: 60_000 }, () => {
  it("allow a module's own files and another module's public entry", async () => {
    expect(await boundaryErrors('src/modules/ordering/allowed.ts')).toEqual([]);
  });

  it("fail an import of another module's internal file", async () => {
    expect(await boundaryErrors('src/modules/ordering/forbidden.ts')).toEqual([
      expect.stringContaining('ledger is reached only through src/modules/ledger/index.ts'),
    ]);
  });

  it('fail it from outside the modules too', async () => {
    expect(await boundaryErrors('src/main.ts')).toEqual([
      expect.stringContaining('ledger is reached only through src/modules/ledger/index.ts'),
    ]);
  });
});
