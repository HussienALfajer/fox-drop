import { readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

// A killed run's containers are removed by the next run only when they carry
// the run's label (src/database/test-containers.ts), so every Testcontainers
// container the tests start sets it: inject('testRun') in a test file, the
// labels passed in by the global setup.
const serverRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const startsContainer = /new \w*Container\(/g;
const labelled = /\.withLabels\(/g;

function sourceFiles(directory: string): string[] {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const file = path.join(directory, entry.name);
    if (entry.isDirectory()) return sourceFiles(file);
    return file.endsWith('.ts') ? [file] : [];
  });
}

describe('the test containers', () => {
  it('label every container a test run starts', () => {
    const files = sourceFiles(path.join(serverRoot, 'src')).map((file) => ({
      file: path.relative(serverRoot, file).split(path.sep).join('/'),
      source: readFileSync(file, 'utf8'),
    }));
    const starting = files.filter(({ source }) => source.match(startsContainer));
    expect(starting.map(({ file }) => file)).toContain('src/valkey/test-valkey.ts');
    const unlabelled = starting
      .filter(
        ({ source }) =>
          (source.match(labelled)?.length ?? 0) < (source.match(startsContainer)?.length ?? 0),
      )
      .map(({ file }) => file);
    expect(unlabelled).toEqual([]);
  });
});
