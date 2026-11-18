import { createLogger } from '../logging/logger-options.js';
import { mapsPublishFromEnvironment, publishMaps } from './maps-publish.js';

// `run --rm maps-publish` after the map build (infra/server/maps-build.sh),
// and `pnpm --filter @fox-drop/server maps:publish` in development.
const logger = createLogger();
try {
  const files = await publishMaps(mapsPublishFromEnvironment());
  logger.info({ files }, 'map published to public-maps');
} catch (error) {
  logger.fatal({ err: error }, 'map publishing failed');
  process.exit(1);
}
