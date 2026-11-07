import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { AdminContentController } from './admin-content.controller.js';
import {
  CaptainContentController,
  CustomerContentController,
  MerchantContentController,
} from './app-content.controller.js';
import {
  CaptainContactController,
  CustomerContactController,
  MerchantContactController,
} from './contact.js';
import { ContentService } from './content.service.js';
import { NotificationTexts } from './notification-texts.service.js';

// The content module (architecture §4.2): the texts and reason lists of AP
// §9.13, edited in the panel and read by the apps. Other modules check a
// chosen reason and read a customer text through ContentService.
@Module({
  imports: [DatabaseModule, AuditModule],
  controllers: [
    MerchantContactController,
    CaptainContactController,
    CustomerContactController,
    MerchantContentController,
    CaptainContentController,
    CustomerContentController,
    AdminContentController,
  ],
  providers: [ContentService, NotificationTexts],
  exports: [ContentService, NotificationTexts],
})
export class ContentModule {}

export {
  ContentRefusedError,
  ContentService,
  type ChosenReason,
  type ContentRefusal,
} from './content.service.js';
export { GENERIC_CUSTOMER_TEXT, type ReasonList } from './lists.js';
export {
  NotificationTexts,
  type RenderedNotification,
} from './notification-texts.service.js';
export {
  type NotificationLevel,
  type NotificationPriority,
} from './notification-templates.js';
