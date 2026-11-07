import { Injectable } from '@nestjs/common';
import { publishingConfig } from './realtime-config.js';

// A call Centrifugo did not take. answered is true when Centrifugo refused
// it, false when it could not be reached, failed or did not answer in time.
export class PublishFailedError extends Error {
  constructor(
    message: string,
    readonly answered: boolean,
  ) {
    super(message);
  }
}

const CALL_TIMEOUT_MS = 2000;

interface CentrifugoError {
  code: number;
  message: string;
}

interface CentrifugoReply {
  error?: CentrifugoError;
  result?: { responses?: { error?: CentrifugoError }[] };
}

// Disconnects whose client must not reconnect with the same token
// (4500 to 4999), the same as the proxy's answer to an ended session.
export const SESSION_ENDED = { code: 4501, reason: 'session ended' } as const;

// A disconnect whose client reconnects at once (4000 to 4499), so every
// subscription is checked again: a panel user's roles changed (AP §6.1).
export const ACCESS_CHANGED = { code: 4001, reason: 'access changed' } as const;

// Centrifugo's HTTP API (architecture §6.1): publishing to channels and
// disconnecting a session's connections.
@Injectable()
export class RealtimePublisher {
  get enabled(): boolean {
    return publishingConfig() !== null;
  }

  // Centrifugo drops a repeat of the same idempotency key for a few minutes,
  // so a relay that publishes a row again after a lost answer sends it once.
  async broadcast(channels: string[], data: object, idempotencyKey: string): Promise<void> {
    const reply = await this.call('broadcast', {
      channels,
      data,
      idempotency_key: idempotencyKey,
    });
    const refused = reply.result?.responses?.find((each) => each.error)?.error;
    if (refused) {
      throw new PublishFailedError(`Centrifugo refused: ${refused.code} ${refused.message}`, true);
    }
  }

  // Ends the connections of an app session (the connection token's subject),
  // so a device signed out stops receiving at once (CU §5.4, RA §5.1).
  async disconnectSession(
    sessionId: string,
    disconnect: typeof SESSION_ENDED | typeof ACCESS_CHANGED = SESSION_ENDED,
  ): Promise<void> {
    await this.call('disconnect', { user: sessionId, disconnect });
  }

  private async call(method: string, body: object): Promise<CentrifugoReply> {
    const config = publishingConfig();
    if (!config) throw new PublishFailedError('real time is not configured', false);
    let reply: CentrifugoReply;
    try {
      const response = await fetch(`${config.apiUrl}/${method}`, {
        method: 'POST',
        headers: { 'content-type': 'application/json', 'x-api-key': config.apiKey },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(CALL_TIMEOUT_MS),
      });
      // A server error or a wrong key is Centrifugo failing, not refusing
      // this call: the next call would fail alike.
      if (!response.ok) throw new Error(`Centrifugo answered ${response.status}`);
      reply = (await response.json()) as CentrifugoReply;
    } catch (error) {
      throw new PublishFailedError(`Centrifugo failed: ${String(error)}`, false);
    }
    if (reply.error) {
      throw new PublishFailedError(
        `Centrifugo refused: ${reply.error.code} ${reply.error.message}`,
        true,
      );
    }
    return reply;
  }
}
