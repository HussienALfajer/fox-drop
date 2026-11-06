import { Injectable } from '@nestjs/common';
import { realtimeConfigFromEnvironment } from './realtime-config.js';

// A publication Centrifugo did not take. answered is true when Centrifugo
// refused it, false when it could not be reached or did not answer in time.
export class PublishFailedError extends Error {
  constructor(
    message: string,
    readonly answered: boolean,
  ) {
    super(message);
  }
}

const PUBLISH_TIMEOUT_MS = 2000;

interface CentrifugoReply {
  error?: { code: number; message: string };
  result?: { responses?: { error?: { code: number; message: string } }[] };
}

// Publishes to Centrifugo's channels through its HTTP API (architecture
// §6.1). Centrifugo drops a repeat of the same idempotency key for a few
// minutes, so a relay that publishes a row again after a lost answer sends
// it once.
@Injectable()
export class RealtimePublisher {
  get enabled(): boolean {
    return realtimeConfigFromEnvironment() !== null;
  }

  async broadcast(channels: string[], data: object, idempotencyKey: string): Promise<void> {
    const config = realtimeConfigFromEnvironment();
    if (!config) throw new PublishFailedError('real time is not configured', false);
    let response: Response;
    try {
      response = await fetch(`${config.apiUrl}/broadcast`, {
        method: 'POST',
        headers: { 'content-type': 'application/json', 'x-api-key': config.apiKey },
        body: JSON.stringify({ channels, data, idempotency_key: idempotencyKey }),
        signal: AbortSignal.timeout(PUBLISH_TIMEOUT_MS),
      });
    } catch (error) {
      throw new PublishFailedError(`Centrifugo unreachable: ${String(error)}`, false);
    }
    if (!response.ok) throw new PublishFailedError(`Centrifugo answered ${response.status}`, true);
    const reply = (await response.json()) as CentrifugoReply;
    const refused = reply.error ?? reply.result?.responses?.find((each) => each.error)?.error;
    if (refused) {
      throw new PublishFailedError(`Centrifugo refused: ${refused.code} ${refused.message}`, true);
    }
  }
}
