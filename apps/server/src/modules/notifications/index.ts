import { Module } from '@nestjs/common';
import { IdentityModule } from '../identity/index.js';
import { RealtimeAccess } from './realtime-access.js';
import { RealtimePublisher } from './realtime-publisher.js';
import { RealtimeTokens } from './realtime-tokens.js';
import { CustomerRealtimeController, MerchantRealtimeController } from './realtime.controller.js';

// The notifications module (architecture §4.2): so far real-time publishing
// through Centrifugo (§6), its connection tokens and its subscription proxy.
// Push, in-app messages and sound levels join with their slices.
@Module({
  imports: [IdentityModule],
  controllers: [MerchantRealtimeController, CustomerRealtimeController],
  providers: [RealtimeTokens, RealtimeAccess, RealtimePublisher],
  exports: [RealtimeAccess, RealtimePublisher],
})
export class NotificationsModule {}

// The worker publishes and serves no route, so it needs no identity.
@Module({ providers: [RealtimePublisher], exports: [RealtimePublisher] })
export class NotificationsWorkerModule {}

export { merchantChannel, orderChannel } from './channels.js';
export { type ChannelCheck, RealtimeAccess } from './realtime-access.js';
export { PublishFailedError, RealtimePublisher } from './realtime-publisher.js';
