import { readFileSync } from 'node:fs';
import path from 'node:path';
import { expect, it } from 'vitest';
import { MIGRATIONS_FOLDER } from './migrate.js';

interface JournalEntry {
  idx: number;
  when: number;
  tag: string;
}

// Drizzle applies only migrations newer than the last applied one, by `when`.
// A migration generated on a branch before another that merged first would be
// skipped silently on every database that already has the other one.
it('orders the migrations by creation time', () => {
  const journal = JSON.parse(
    readFileSync(path.join(MIGRATIONS_FOLDER, 'meta', '_journal.json'), 'utf8'),
  ) as { entries: JournalEntry[] };

  let previous: JournalEntry | undefined;
  journal.entries.forEach((entry, position) => {
    expect(entry.idx, entry.tag).toBe(position);
    if (previous) {
      expect(
        entry.when,
        `${entry.tag} is older than the migration before it: regenerate it after the rebase`,
      ).toBeGreaterThan(previous.when);
    }
    previous = entry;
  });
});
