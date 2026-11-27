// Measures how this project's Claude Code sessions spend tokens, from the
// transcripts Claude Code keeps under ~/.claude/projects/<project>/.
//
//   node scripts/claude-audit.mjs [--since=YYYY-MM-DD] [--session=<id>] [--dir=<transcripts>]
import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';

/** The words of each command of a shell line, split at `;`, `&&`, `||`, `|` and newlines. */
function commands(line) {
  return line
    .split(/;|&&|\|\||\||\n/)
    .map((part) => part.trim().split(/\s+/).filter(Boolean))
    .filter((words) => words.length > 0);
}

// USD per million tokens, API list prices (2026-11): only to weigh one cost
// against another. Cache writes: 1.25 × input for 5 minutes, 2 × for 1 hour.
const PRICES = {
  'claude-opus-5-5': { input: 4, output: 20, read: 0.2 },
  'claude-sonnet-5-5': { input: 2, output: 10, read: 0.1 },
  'claude-haiku-5-5': { input: 0.1, output: 0.5, read: 0.01 },
  'claude-fable-5-2': { input: 8, output: 40, read: 0.2 },
};

const args = Object.fromEntries(
  process.argv.slice(2).map((arg) => {
    const [key, ...value] = arg.replace(/^--/, '').split('=');
    return [key, value.join('=')];
  }),
);
const projectSlug = process.cwd().replace(/[:\\/]/g, '-');
const dir = args.dir ?? path.join(os.homedir(), '.claude', 'projects', projectSlug);
if (!existsSync(dir)) {
  console.error(`No transcripts in ${dir}. Pass --dir=<folder>.`);
  process.exit(1);
}
const since = args.since ? new Date(args.since) : new Date(0);

function readLines(file) {
  return readFileSync(file, 'utf8')
    .split('\n')
    .filter(Boolean)
    .flatMap((line) => {
      try {
        return [JSON.parse(line)];
      } catch {
        return [];
      }
    });
}

/** The API requests of one transcript: one per message id, with its usage and tool calls. */
function requestsOf(lines) {
  const byId = new Map();
  for (const line of lines) {
    if (line.type !== 'assistant' || !line.message?.id || line.message.model === '<synthetic>')
      continue;
    const request = byId.get(line.message.id) ?? {
      model: line.message.model,
      tools: [],
      effort: line.effort,
    };
    request.usage = line.message.usage;
    for (const block of line.message.content ?? [])
      if (block.type === 'tool_use') request.tools.push({ name: block.name, input: block.input });
    byId.set(line.message.id, request);
  }
  return [...byId.values()].filter((request) => request.usage);
}

function costOf({ model, usage }) {
  const price = PRICES[model] ?? PRICES['claude-opus-5-5'];
  const write1h = usage.cache_creation?.ephemeral_1h_input_tokens ?? 0;
  const write5m = (usage.cache_creation_input_tokens ?? 0) - write1h;
  const million = 1_000_000;
  return {
    input: ((usage.input_tokens ?? 0) * price.input) / million,
    read: ((usage.cache_read_input_tokens ?? 0) * price.read) / million,
    write: (write5m * price.input * 1.25 + write1h * price.input * 2) / million,
    output: ((usage.output_tokens ?? 0) * price.output) / million,
  };
}

const contextOf = ({ usage }) =>
  (usage.input_tokens ?? 0) +
  (usage.cache_read_input_tokens ?? 0) +
  (usage.cache_creation_input_tokens ?? 0);

/** A Bash command's kind: its first command (after cd), with the flag or subcommand that matters. */
function bashKind(command) {
  for (const each of commands(command ?? '')) {
    const words = each
      .filter((word) => !/^\w+=/.test(word))
      .map((word) => word.replace(/^["']|["']$/g, ''));
    const name = path.basename(words[0] ?? '').replace(/\.exe$/, '');
    if (['cd', 'eval', 'fnm', 'builtin', 'export', ''].includes(name)) continue;
    if (name === 'sed') return words.some((word) => /^-[^-]*i/.test(word)) ? 'sed -i' : 'sed -n';
    if (/^python3?$|^node$/.test(name))
      return words[1] === '-' || words[1] === '-c' || words[1] === '-e' ? `${name} inline` : name;
    if (['git', 'pnpm', 'gh', 'docker', 'dart', 'flutter'].includes(name))
      return `${name} ${words[1] ?? ''}`.trim();
    return name;
  }
  return '(cd only)';
}

const sessions = readdirSync(dir)
  .filter((file) => file.endsWith('.jsonl'))
  .map((file) => ({ id: file.slice(0, -'.jsonl'.length), file: path.join(dir, file) }))
  .filter(({ id, file }) =>
    args.session ? id.startsWith(args.session) : statSync(file).mtime >= since,
  );

const totals = { main: [], sub: [], subRuns: 0, deltas: { mcp: [], tools: [] }, sessionSizes: [] };
for (const session of sessions) {
  const lines = readLines(session.file);
  const requests = requestsOf(lines);
  if (requests.length === 0) continue;
  totals.main.push(...requests);
  totals.sessionSizes.push(requests.length);
  for (const line of lines) {
    const size = JSON.stringify(line.attachment ?? '').length;
    if (line.attachment?.type === 'mcp_instructions_delta') totals.deltas.mcp.push(size);
    if (line.attachment?.type === 'deferred_tools_delta') totals.deltas.tools.push(size);
  }
  const subDir = path.join(dir, session.id, 'subagents');
  if (!existsSync(subDir)) continue;
  for (const file of readdirSync(subDir).filter((each) => each.endsWith('.jsonl'))) {
    const subRequests = requestsOf(readLines(path.join(subDir, file)));
    if (subRequests.length === 0) continue;
    totals.subRuns++;
    totals.sub.push(...subRequests);
  }
}

const sum = (values) => values.reduce((a, b) => a + b, 0);
const usd = (value) => `${value.toFixed(2)} USD`;
const pct = (part, whole) => `${whole ? ((100 * part) / whole).toFixed(1) : '0.0'}%`;
const median = (values) => [...values].sort((a, b) => a - b)[Math.floor(values.length / 2)] ?? 0;
const table = (rows) => rows.map(([label, value]) => `  ${label.padEnd(40)} ${value}`).join('\n');

function costSplit(requests) {
  const costs = requests.map(costOf);
  return Object.fromEntries(
    ['read', 'write', 'output', 'input'].map((kind) => [kind, sum(costs.map((c) => c[kind]))]),
  );
}

const main = totals.main;
const mainCost = costSplit(main);
const subCost = costSplit(totals.sub);
const mainTotal = sum(Object.values(mainCost));
const subTotal = sum(Object.values(subCost));
const byModel = {};
for (const request of [...main, ...totals.sub]) {
  const cost = sum(Object.values(costOf(request)));
  byModel[request.model] = (byModel[request.model] ?? 0) + cost;
}

const withTools = main.filter((request) => request.tools.length > 0);
const single = withTools.filter((request) => request.tools.length === 1);
const singleBash = single.filter((request) => request.tools[0].name === 'Bash');
const toolCounts = {};
const bashCounts = {};
for (const request of main)
  for (const tool of request.tools) {
    toolCounts[tool.name] = (toolCounts[tool.name] ?? 0) + 1;
    if (tool.name === 'Bash') {
      const kind = bashKind(tool.input?.command);
      bashCounts[kind] = (bashCounts[kind] ?? 0) + 1;
    }
  }
const top = (counts, n) =>
  Object.entries(counts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, n);
const effortHigh = main.filter((request) =>
  ['high', 'xhigh', 'max'].includes(request.effort),
).length;

console.log(`Claude Code audit: ${dir}`);
console.log(
  args.session
    ? `Session ${args.session}`
    : `Sessions modified since ${since.toISOString().slice(0, 10)}`,
);
console.log('\nSessions and requests');
console.log(
  table([
    ['sessions', totals.sessionSizes.length],
    ['main requests', main.length],
    ['requests a session, median', median(totals.sessionSizes)],
    ['sessions past 200 requests', totals.sessionSizes.filter((n) => n > 200).length],
    [
      'context a main request, mean',
      `${Math.round(sum(main.map(contextOf)) / (main.length || 1) / 1000)}K tokens`,
    ],
    [
      'context a main request, peak',
      `${Math.round(Math.max(0, ...main.map(contextOf)) / 1000)}K tokens`,
    ],
    ['main requests at high effort or more', pct(effortHigh, main.length)],
    ['subagent runs', totals.subRuns],
    ['subagent requests', totals.sub.length],
  ]),
);
console.log('\nCost (API list prices)');
console.log(
  table([
    ['main sessions', usd(mainTotal)],
    ...Object.entries(mainCost).map(([kind, value]) => [
      `  cache ${kind}`.replace('cache input', 'uncached input').replace('cache output', 'output'),
      pct(value, mainTotal),
    ]),
    ['subagents', `${usd(subTotal)} (${pct(subTotal, mainTotal + subTotal)} of all)`],
    ...top(byModel, 6).map(([model, value]) => [`  ${model}`, pct(value, mainTotal + subTotal)]),
  ]),
);
console.log('\nTool calls in main sessions');
console.log(
  table([
    ['messages with tool calls', withTools.length],
    ['  with exactly one', pct(single.length, withTools.length)],
    [
      '  with one Bash call only',
      `${singleBash.length} (${pct(singleBash.length, main.length)} of requests)`,
    ],
    ...top(toolCounts, 8).map(([name, n]) => [name, n]),
  ]),
);
console.log('\nBash by command');
console.log(table(top(bashCounts, 15)));
console.log('\nContext that grows by itself');
console.log(
  table([
    [
      'MCP instruction deltas',
      `${totals.deltas.mcp.length}, ${Math.round(sum(totals.deltas.mcp) / (totals.deltas.mcp.length || 1) / 1024)} KB each`,
    ],
    [
      'tool-name deltas',
      `${totals.deltas.tools.length}, ${Math.round(sum(totals.deltas.tools) / (totals.deltas.tools.length || 1) / 1024)} KB each`,
    ],
  ]),
);
