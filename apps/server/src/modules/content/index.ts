import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { FilesModule } from '../files/index.js';
import { AdminContentController } from './admin-content.controller.js';
import {
  CaptainContentController,
  CustomerCategoriesController,
  CustomerContentController,
  MerchantContentController,
} from './app-content.controller.js';
import {
  CaptainContactController,
  CustomerContactController,
  MerchantContactController,
} from './contact.js';
import { CategoriesService } from './categories.service.js';
import { ContentService } from './content.service.js';
import { NotificationTexts } from './notification-texts.service.js';
import {
  AdminTermsController,
  CaptainTermsController,
  CustomerTermsController,
  MerchantTermsController,
} from './terms.controller.js';
import { TermsService } from './terms.service.js';

// The content module (architecture §4.2): the texts and reason lists of AP
// §9.13, edited in the panel and read by the apps. Other modules check a
// chosen reason and read a customer text through ContentService.
@Module({
  imports: [DatabaseModule, AuditModule, FilesModule],
  controllers: [
    MerchantContactController,
    CaptainContactController,
    CustomerContactController,
    MerchantContentController,
    CaptainContentController,
    CustomerContentController,
    CustomerCategoriesController,
    AdminContentController,
    MerchantTermsController,
    CaptainTermsController,
    CustomerTermsController,
    AdminTermsController,
  ],
  providers: [CategoriesService, ContentService, NotificationTexts, TermsService],
  exports: [CategoriesService, ContentService, NotificationTexts, TermsService],
})
export class ContentModule {}

export { CategoriesService, type Category } from './categories.service.js';
export {
  ContentRefusedError,
  ContentService,
  type ChosenReason,
  type ContentRefusal,
} from './content.service.js';
export { GENERIC_CUSTOMER_TEXT, NOTE_MAX, type ReasonList } from './lists.js';
export { NotificationTexts, type RenderedNotification } from './notification-texts.service.js';
export {
  costReportLabels,
  dailyReportLabels,
  orderHistoryLabels,
  reportLabels,
  restaurantStatementLabels,
} from './export-labels.js';
export {
  applicationDocumentLabels,
  formatDate,
  formatDay,
  formatMoney,
  formatTime,
  receiptTypeLabels,
} from './push-format.js';
export {
  type NotificationLevel,
  type NotificationPriority,
  notificationTemplate,
} from './notification-templates.js';
export { type TermsAudience, termsAudiences } from './lists.js';
export { TermsService, type TermsVersion } from './terms.service.js';
