import { Inject, Injectable, Logger, Module, type OnApplicationShutdown } from '@nestjs/common';
import { Valkey } from 'iovalkey';

// The injection token of the process's Valkey client (architecture §5.7).
export const VALKEY = Symbol('VALKEY');

function valkeyFromEnvironment(): Valkey {
  const url = process.env.VALKEY_URL;
  if (!url) throw new Error('VALKEY_URL is not set');
  const valkey = new Valkey(url);
  // A lost connection emits an error; without a listener it would crash the
  // process. The client reconnects on its own.
  const logger = new Logger('Valkey');
  valkey.on('error', (error) => logger.error({ err: error }, 'valkey connection failed'));
  return valkey;
}

@Injectable()
class ValkeyShutdown implements OnApplicationShutdown {
  constructor(@Inject(VALKEY) private readonly valkey: Valkey) {}

  async onApplicationShutdown(): Promise<void> {
    await this.valkey.quit();
  }
}

// Imported by every module that caches, locks or limits in Valkey. Nest
// creates one client per process and closes it after the modules have stopped.
// Everything in Valkey can be rebuilt from PostgreSQL (architecture §5.7).
@Module({
  providers: [{ provide: VALKEY, useFactory: valkeyFromEnvironment }, ValkeyShutdown],
  exports: [VALKEY],
})
export class ValkeyModule {}
