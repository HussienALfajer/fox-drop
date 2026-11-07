import { Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { reportError } from '../../observability/error-tracking.js';
import { AdminSessionsService, AppSessionsService } from '../identity/index.js';
import { ACCESS_CHANGED, RealtimePublisher, SESSION_ENDED } from './realtime-publisher.js';

// CU §5.4, RA §5.1: a sign-out applies at once on every device, so the
// connections of a session that ends are dropped as soon as its end commits
// (a panel session's too, on its sign-out);
// a client that reconnects with its token is refused by the proxy. The
// sign-out never waits for it or fails with it.
@Injectable()
export class RealtimeSessions implements OnModuleInit {
  private readonly logger = new Logger('RealtimeSessions');

  constructor(
    private readonly sessions: AppSessionsService,
    private readonly adminSessions: AdminSessionsService,
    private readonly publisher: RealtimePublisher,
  ) {}

  onModuleInit(): void {
    const disconnect = (
      sessionIds: string[],
      reason: typeof SESSION_ENDED | typeof ACCESS_CHANGED = SESSION_ENDED,
    ) => {
      if (!this.publisher.enabled) return;
      for (const sessionId of sessionIds) {
        this.publisher.disconnectSession(sessionId, reason).catch((error: unknown) => {
          this.logger.error({ err: error, sessionId }, 'could not disconnect an ended session');
          reportError(error);
        });
      }
    };
    this.sessions.onEnded(disconnect);
    this.adminSessions.onEnded(disconnect);
    // AP §6.1: the panel reconnects, and the proxy checks the new roles.
    this.adminSessions.onAccessChanged((sessionIds) => disconnect(sessionIds, ACCESS_CHANGED));
  }
}
