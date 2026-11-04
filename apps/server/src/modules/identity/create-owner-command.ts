// Creates the first OWN account (AP §5.3) and prints its one-time setup link.
// Run during deployment, with DATABASE_URL, IDENTITY_ENCRYPTION_KEY and
// ADMIN_PANEL_URL set:
//   node dist/modules/identity/create-owner-command.js --email <email> --phone <+E.164 phone>
// Either flag alone works too. Run again with the same name while the owner is
// still pending, it replaces the setup link.
import { createDatabase } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { createFirstOwner, FirstOwnerExistsError } from './first-owner.js';
import { parseOwnerArguments } from './owner-arguments.js';
import { identitySecretsFromEnvironment } from './secrets.js';
import { setupLinkUrl } from './setup-link-url.js';

function fail(message: string): never {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

const name = parseOwnerArguments(process.argv.slice(2));
if (typeof name === 'string') fail(name);
const panelUrl = process.env.ADMIN_PANEL_URL ?? fail('ADMIN_PANEL_URL is not set');
const databaseUrl = process.env.DATABASE_URL ?? fail('DATABASE_URL is not set');
const secrets = identitySecretsFromEnvironment();
const database = createDatabase(databaseUrl);
try {
  const owner = await createFirstOwner(
    { db: database.db, audit: new AuditService(database), secrets },
    name,
  );
  // Printed, never logged: the link is the only copy of its token.
  process.stdout.write(
    `${owner.reissued ? 'A new setup link replaces the earlier one of' : 'Created'} the OWN account ${owner.accountId}.\n` +
      `Setup link, valid until ${owner.setupExpiresAt.toISOString()}:\n` +
      `${setupLinkUrl(panelUrl, owner.setupToken)}\n`,
  );
} catch (error) {
  if (error instanceof FirstOwnerExistsError) {
    fail('An OWN account already exists. Only a pending owner with the same name gets a new link.');
  }
  throw error;
} finally {
  await database.pool.end();
}
