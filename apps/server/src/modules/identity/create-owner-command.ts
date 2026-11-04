// Creates the first OWN account (AP §5.3) and prints its one-time setup link.
// Run once per environment during deployment, with DATABASE_URL,
// IDENTITY_ENCRYPTION_KEY and ADMIN_PANEL_URL set:
//   node dist/modules/identity/create-owner-command.js --email <email>
//   node dist/modules/identity/create-owner-command.js --phone <+E.164 phone>
import { parseArgs } from 'node:util';
import { createDatabase } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { createFirstOwner, FirstOwnerExistsError } from './first-owner.js';
import { identitySecretsFromEnvironment } from './secrets.js';
import { normalizeEmail, normalizePhone, type SignInName } from './sign-in-name.js';
import { setupLinkUrl } from './setup-link-url.js';

function fail(message: string): never {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

function signInName(): SignInName {
  const { values } = parseArgs({
    options: { email: { type: 'string' }, phone: { type: 'string' } },
  });
  if (values.email !== undefined && values.phone === undefined) {
    const email = normalizeEmail(values.email);
    return email ? { email } : fail('Not an email address.');
  }
  if (values.phone !== undefined && values.email === undefined) {
    const phone = normalizePhone(values.phone);
    return phone ? { phone } : fail('Not an international phone number, such as +963944000000.');
  }
  return fail('Usage: create-owner-command.js --email <email> | --phone <+E.164 phone>');
}

const name = signInName();
const panelUrl = process.env.ADMIN_PANEL_URL ?? fail('ADMIN_PANEL_URL is not set');
const databaseUrl = process.env.DATABASE_URL ?? fail('DATABASE_URL is not set');
const database = createDatabase(databaseUrl);
try {
  const owner = await createFirstOwner(
    {
      db: database.db,
      audit: new AuditService(database),
      secrets: identitySecretsFromEnvironment(),
    },
    name,
  );
  // Printed, never logged: the link is the only copy of its token.
  process.stdout.write(
    `The OWN account ${owner.accountId} is created.\n` +
      `Setup link, valid until ${owner.setupExpiresAt.toISOString()}:\n` +
      `${setupLinkUrl(panelUrl, owner.setupToken)}\n`,
  );
} catch (error) {
  if (error instanceof FirstOwnerExistsError) fail('An OWN account already exists.');
  throw error;
} finally {
  await database.pool.end();
}
