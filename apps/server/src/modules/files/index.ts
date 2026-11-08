import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AdminUploadsController } from './admin-uploads.controller.js';
import { FilesService } from './files.service.js';

// The files module (architecture §4.2, §5.8): uploads to the object storage
// and their checks. A module that links a file to its record imports
// FilesModule and calls FilesService.claim in its own transaction.
@Module({
  imports: [DatabaseModule],
  controllers: [AdminUploadsController],
  providers: [FilesService],
  exports: [FilesService],
})
export class FilesModule {}

export {
  FilesRefusedError,
  type FilesExecutor,
  type FilesRefusal,
  FilesService,
  MAX_IMAGE_BYTES,
} from './files.service.js';
export type { ImageType, UploadPurpose } from './schema.js';
