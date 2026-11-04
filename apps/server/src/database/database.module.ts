import { Inject, Injectable, Logger, Module, type OnApplicationShutdown } from '@nestjs/common';
import { createDatabase, type Database } from './database.js';

// The injection token of the application role's connection.
export const DATABASE = Symbol('DATABASE');

function databaseFromEnvironment(): Database {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error('DATABASE_URL is not set');
  const database = createDatabase(url);
  // An idle client that loses its connection emits an error; without a
  // listener it would crash the process. The pool replaces the client.
  const logger = new Logger('Database');
  database.pool.on('error', (error) => logger.error({ err: error }, 'idle database client failed'));
  return database;
}

@Injectable()
class DatabaseShutdown implements OnApplicationShutdown {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async onApplicationShutdown(): Promise<void> {
    await this.database.pool.end();
  }
}

// Imported by every module that reads or writes its tables. Nest creates one
// pool per process and closes it after the modules have stopped.
@Module({
  providers: [{ provide: DATABASE, useFactory: databaseFromEnvironment }, DatabaseShutdown],
  exports: [DATABASE],
})
export class DatabaseModule {}
