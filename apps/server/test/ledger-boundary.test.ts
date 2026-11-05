import { readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

// Money moves only through the ledger module (architecture §4.3 item 5). The
// boundary lint stops an import of its schema; this stops raw SQL on its
// tables from anywhere else. The database test of the migrations is the one
// exception: it proves what the application role is refused.
const serverRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const allowed = [
  path.join('src', 'modules', 'ledger') + path.sep,
  path.join('src', 'database', 'migrations.test.ts'),
];
// The tables and their partitions, such as ledger.entries_2026_11.
const ledgerTable = /\bledger\.(accounts|journals|entries)|"ledger"\./;

function sourceFiles(directory: string): string[] {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const file = path.join(directory, entry.name);
    if (entry.isDirectory()) return sourceFiles(file);
    return file.endsWith('.ts') ? [file] : [];
  });
}

describe('the ledger boundary', () => {
  it('keeps every query on the ledger tables inside the ledger module', () => {
    const offenders = sourceFiles(path.join(serverRoot, 'src'))
      .map((file) => path.relative(serverRoot, file))
      .filter((file) => !allowed.some((prefix) => file.startsWith(prefix)))
      .filter((file) => ledgerTable.test(readFileSync(path.join(serverRoot, file), 'utf8')));
    expect(offenders).toEqual([]);
  });
});
