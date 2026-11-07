// Gives the test restaurant owner or test captain of development or staging a
// real number (slice 1.14, owner decision 2026-11-07), so the owner signs in
// on a real phone. Run with DATABASE_URL, IDENTITY_ENCRYPTION_KEY and
// FOX_DROP_ENVIRONMENT set:
//   echo "$number" | node dist/modules/identity/placeholder-phone-command.js --party merchant|captain --from <current number>
// The new number comes on standard input, so a real number stays out of the
// shell history and the process list (`--to` works too, for fake numbers).
// The placeholder numbers are +963900000001 (owner), +963900000002 (cashier)
// and +963900000003 (captain). Numbers are never printed.
import { text } from 'node:stream/consumers';
import { parseArgs } from 'node:util';
import { createDatabase } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { changePlaceholderPhone, PlaceholderPhoneRefusedError } from './placeholder-phone.js';
import { identitySecretsFromEnvironment } from './secrets.js';

function fail(message: string): never {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

const usage =
  'Usage: --party merchant|captain --from <+E.164 number>, with the new number on standard input';
let values: { party?: string; from?: string; to?: string };
try {
  ({ values } = parseArgs({
    args: process.argv.slice(2),
    options: { party: { type: 'string' }, from: { type: 'string' }, to: { type: 'string' } },
  }));
} catch {
  fail(usage);
}
const { party, from } = values;
if ((party !== 'merchant' && party !== 'captain') || !from) fail(usage);
const to = values.to ?? (await text(process.stdin)).trim();
if (!to) fail(usage);
const databaseUrl = process.env.DATABASE_URL ?? fail('DATABASE_URL is not set');
const secrets = identitySecretsFromEnvironment();
const database = createDatabase(databaseUrl);
try {
  const { accountId } = await changePlaceholderPhone(
    { db: database.db, audit: new AuditService(database), secrets },
    { party, from, to },
  );
  process.stdout.write(`The ${party} account ${accountId} now signs in with the new number.\n`);
} catch (error) {
  if (error instanceof PlaceholderPhoneRefusedError) fail(error.message);
  throw error;
} finally {
  await database.pool.end();
}
