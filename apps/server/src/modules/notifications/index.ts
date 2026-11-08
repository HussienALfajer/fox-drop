import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { CaptainsModule } from '../captains/index.js';
import { GeoModule } from '../geo/index.js';
import { IdentityModule, OpenAppSessionsModule, OtpSenderPoolModule } from '../identity/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminAlertsController } from './alerts.controller.js';
import { AlertsService } from './alerts.service.js';
import { AlertsRelay, AlertsRelayWorker } from './alerts-relay.js';
import { AlertsSweep, AlertsSweepWorker } from './alerts-sweep.js';
import { CustomerNotificationsController } from './customer-notifications.controller.js';
import { PUSH_SENDER, pushSenderFromEnvironment } from './fcm-sender.js';
import { AppChangeBroadcasts, PlatformBroadcasts } from './platform-broadcasts.js';
import { PlatformRelay, PlatformRelayWorker } from './platform-relay.js';
import { PushDevices } from './push-devices.js';
import { PushQueue } from './push-queue.js';
import { PushRelay, PushRelayWorker } from './push-relay.js';
import {
  CaptainPushTokenController,
  CustomerPushTokenController,
  MerchantPushTokenController,
} from './push-token.controller.js';
import { RealtimeAccess } from './realtime-access.js';
import { RealtimePublisher } from './realtime-publisher.js';
import { RealtimeSessions } from './realtime-sessions.js';
import { RealtimeTokens } from './realtime-tokens.js';
import {
  AdminRealtimeController,
  CaptainRealtimeController,
  CustomerRealtimeController,
  MerchantRealtimeController,
} from './realtime.controller.js';

// The notifications module (architecture §4.2): so far real-time publishing
// through Centrifugo (§6), its connection tokens and its subscription proxy,
// and the panel's alerts (AP §7.3, §9.1.3). Push, in-app messages and sound
// levels join with their slices.
@Module({
  imports: [DatabaseModule, IdentityModule, OpenAppSessionsModule, MerchantsModule, SettingsModule],
  controllers: [
    MerchantRealtimeController,
    CustomerRealtimeController,
    CaptainRealtimeController,
    AdminRealtimeController,
    AdminAlertsController,
    CustomerPushTokenController,
    MerchantPushTokenController,
    CaptainPushTokenController,
    CustomerNotificationsController,
  ],
  providers: [
    RealtimeTokens,
    RealtimeAccess,
    RealtimePublisher,
    RealtimeSessions,
    AlertsService,
    PushDevices,
    PushQueue,
    PlatformBroadcasts,
    AppChangeBroadcasts,
  ],
  exports: [RealtimeAccess, RealtimePublisher, AlertsService, PushQueue, PlatformBroadcasts],
})
export class NotificationsModule {}

// The worker publishes and syncs alerts and serves no route, so it needs no
// identity.
@Module({
  imports: [DatabaseModule],
  providers: [RealtimePublisher, AlertsService, PushQueue, PlatformBroadcasts],
  exports: [RealtimePublisher, AlertsService, PushQueue, PlatformBroadcasts],
})
export class NotificationsWorkerModule {}

// The worker's push relay (architecture §8.1): sends the queued pushes
// through FCM to the live devices of their recipients.
@Module({
  imports: [DatabaseModule, OpenAppSessionsModule],
  providers: [
    { provide: PUSH_SENDER, useFactory: () => pushSenderFromEnvironment() },
    PushDevices,
    PushRelay,
    PushRelayWorker,
  ],
})
export class PushWorkerModule {}

// The worker's sweep of the alerts no transaction raises (alerts-sweep.ts),
// and the relay of every alert change to the panel (alerts-relay.ts).
@Module({
  imports: [DatabaseModule, CaptainsModule, GeoModule, OtpSenderPoolModule],
  providers: [
    AlertsService,
    AlertsSweep,
    AlertsSweepWorker,
    RealtimePublisher,
    AlertsRelay,
    AlertsRelayWorker,
  ],
})
export class AlertsWorkerModule {}

// The worker's relay of the platform broadcasts (platform-relay.ts) to the
// restaurants', captains' and panel's channels.
@Module({
  imports: [DatabaseModule, CaptainsModule, GeoModule, MerchantsModule],
  providers: [RealtimePublisher, PlatformRelay, PlatformRelayWorker],
})
export class PlatformRelayWorkerModule {}

export { captainChannel, merchantChannel, opsChannel, orderChannel } from './channels.js';
export { type ChannelCheck, RealtimeAccess } from './realtime-access.js';
export { requireRealtime } from './realtime-config.js';
export { PlatformRelay } from './platform-relay.js';
export { PublishFailedError, RealtimePublisher } from './realtime-publisher.js';
export { type AlertCode, alertCodes } from './alert-rules.js';
export { type PushRecipient } from './push-devices.js';
export { PushQueue, type QueuedPush } from './push-queue.js';
export { AlertsService, type AlertSubjectRef } from './alerts.service.js';
export {
  type BroadcastApp,
  type PlatformBroadcast,
  PlatformBroadcasts,
} from './platform-broadcasts.js';
