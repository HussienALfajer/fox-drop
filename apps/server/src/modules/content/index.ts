import { Module } from '@nestjs/common';
import {
  CaptainContactController,
  CustomerContactController,
  MerchantContactController,
} from './contact.js';

// The content module (architecture §4.2): texts, terms versions and reason
// lists (AP §9.13). So far only the support contact numbers the apps read.
@Module({
  controllers: [MerchantContactController, CaptainContactController, CustomerContactController],
})
export class ContentModule {}
