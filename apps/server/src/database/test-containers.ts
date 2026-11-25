import { hostname } from 'node:os';
import { getContainerRuntimeClient } from 'testcontainers';

// Every container a server test run starts carries this label, whose value
// names the run's Vitest process: `<host>/<pid>`. Ryuk removes a run's
// containers once the run is gone, but a Ryuk that died with it (a Docker
// Desktop restart, a killed session) leaves them behind; the next run's
// global setup then removes those of a process that no longer runs.
export const TEST_RUN_LABEL = 'fox-drop.server-test-run';

declare module 'vitest' {
  export interface ProvidedContext {
    // The run's labels, for the containers a test file starts.
    testRun: Record<string, string>;
  }
}

// The labels of a run whose Vitest process is `pid` on this machine. A test
// file reads its run's with inject('testRun').
export const testRunLabels = (pid: number): Record<string, string> => ({
  [TEST_RUN_LABEL]: `${hostname()}/${pid}`,
});

function running(pid: number): boolean {
  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    // EPERM: the process exists but belongs to someone else.
    return (error as NodeJS.ErrnoException).code === 'EPERM';
  }
}

// Removes, with their anonymous volumes, the containers of earlier runs on
// this machine whose Vitest process has ended. A run still going (another
// worktree, another session) keeps its own.
export async function removeLeftoverContainers(): Promise<number> {
  const docker = (await getContainerRuntimeClient()).container.dockerode;
  const containers = await docker.listContainers({
    all: true,
    filters: { label: [TEST_RUN_LABEL] },
  });
  const host = `${hostname()}/`;
  const leftovers = containers.filter((container) => {
    const run = container.Labels[TEST_RUN_LABEL] ?? '';
    return run.startsWith(host) && !running(Number(run.slice(host.length)));
  });
  await Promise.all(
    leftovers.map((container) =>
      docker
        .getContainer(container.Id)
        .remove({ force: true, v: true })
        // Ryuk or another run may remove it first.
        .catch(() => undefined),
    ),
  );
  return leftovers.length;
}
