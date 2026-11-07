import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { CaptainsModule } from '../captains/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule, OtpSenderPoolModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { AdminAlertsController } from './alerts.controller.js';
import { AlertsService } from './alerts.service.js';
import { AlertsSweep, AlertsSweepWorker } from './alerts-sweep.js';
import { RealtimeAccess } from './realtime-access.js';
import { RealtimePublisher } from './realtime-publisher.js';
import { RealtimeSessions } from './realtime-sessions.js';
import { RealtimeTokens } from './realtime-tokens.js';
import {
  CaptainRealtimeController,
  CustomerRealtimeController,
  MerchantRealtimeController,
} from './realtime.controller.js';

// The notifications module (architecture §4.2): so far real-time publishing
// through Centrifugo (§6), its connection tokens and its subscription proxy,
// and the panel's alerts (AP §7.3, §9.1.3). Push, in-app messages and sound
// levels join with their slices.
@Module({
  imports: [DatabaseModule, IdentityModule, MerchantsModule],
  controllers: [
    MerchantRealtimeController,
    CustomerRealtimeController,
    CaptainRealtimeController,
    AdminAlertsController,
  ],
  providers: [RealtimeTokens, RealtimeAccess, RealtimePublisher, RealtimeSessions, AlertsService],
  exports: [RealtimeAccess, RealtimePublisher, AlertsService],
})
export class NotificationsModule {}

// The worker publishes and syncs alerts and serves no route, so it needs no
// identity.
@Module({
  imports: [DatabaseModule],
  providers: [RealtimePublisher, AlertsService],
  exports: [RealtimePublisher, AlertsService],
})
export class NotificationsWorkerModule {}

// The worker's sweep of the alerts no transaction raises (alerts-sweep.ts).
@Module({
  imports: [DatabaseModule, CaptainsModule, GeoModule, OtpSenderPoolModule],
  providers: [AlertsService, AlertsSweep, AlertsSweepWorker],
})
export class AlertsWorkerModule {}

export { captainChannel, merchantChannel, orderChannel } from './channels.js';
export { type ChannelCheck, RealtimeAccess } from './realtime-access.js';
export { requireRealtime } from './realtime-config.js';
export { PublishFailedError, RealtimePublisher } from './realtime-publisher.js';
export { type AlertCode, alertCodes } from './alert-rules.js';
export { AlertsService, type AlertSubjectRef } from './alerts.service.js';
