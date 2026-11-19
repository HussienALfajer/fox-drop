import { desc, eq } from 'drizzle-orm';
import type { Database } from '../../database/database.js';
import { applicationDocuments, applications } from './schema.js';

type Executor = Pick<Database['db'], 'select'>;

// CA §12.2, K6 (slice 2.35a): a captain's documents are the uploads of the
// application that made it, the latest activated; none for a captain the
// seed made.
export async function captainUploads(
  executor: Executor,
  captainId: string,
): Promise<{
  application: typeof applications.$inferSelect;
  uploads: (typeof applicationDocuments.$inferSelect)[];
} | null> {
  const [application] = await executor
    .select()
    .from(applications)
    .where(eq(applications.captainId, captainId))
    .orderBy(desc(applications.activatedAt))
    .limit(1);
  if (!application) return null;
  const uploads = await executor
    .select()
    .from(applicationDocuments)
    .where(eq(applicationDocuments.applicationId, application.id))
    .orderBy(desc(applicationDocuments.createdAt));
  return { application, uploads };
}
