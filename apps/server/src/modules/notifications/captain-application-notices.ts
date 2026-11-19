import { Injectable, type OnModuleInit } from '@nestjs/common';
import {
  type ApplicationChange,
  type ApplicationNotice,
  ApplicationsService,
} from '../captains/index.js';
import {
  applicationDocumentLabels,
  formatDate,
  formatDay,
  formatTime,
  NotificationTexts,
} from '../content/index.js';
import { AlertsService } from './alerts.service.js';
import { PushDevices } from './push-devices.js';
import { PushQueue, type QueuedPush } from './push-queue.js';

// AP §9.7.1, §9.1.3, CA §5.4, §14 #29 (slice 2.34b): in the transaction of
// every change of a sent captain application,
// - «طلب انضمام كابتن» (information, OWN and OPS) is open while the
//   application is «جديد», so it resolves at the panel's first action;
// - the applicant hears what changed, silently, in the status page's words
//   (a stage, a document asked for, a rejected document's #27), on their
//   account's devices (an applicant has no captain yet). Once per event.
@Injectable()
export class CaptainApplicationNotices implements OnModuleInit {
  constructor(
    private readonly applications: ApplicationsService,
    private readonly alerts: AlertsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
    private readonly devices: PushDevices,
  ) {}

  onModuleInit(): void {
    this.applications.onChanged(async (tx, change) => {
      await this.alerts.sync(
        tx,
        {
          type: 'captain_application',
          id: change.applicationId,
          cityId: change.cityId,
          // The applicant's name, as an alert about a captain shows it; the
          // application is the subject (its «مراجعة» opens it).
          details: { captainName: change.fullName },
        },
        ['captain_application'],
        change.stage === 'new' ? ['captain_application'] : [],
        change.at,
      );
      // «مفعّل» (slice 2.35a): the account's devices are the captain's now.
      if (change.captainId !== null && change.stage === 'active') {
        await this.devices.bindCaptain(tx, change.accountId, change.captainId);
      }
      const pushes: QueuedPush[] = [];
      for (const notice of change.notices) {
        const push = await this.push(tx, change, notice);
        if (push !== null) pushes.push(push);
      }
      if (pushes.length > 0) await this.pushes.enqueue(tx, pushes, change.at);
    });
  }

  private async push(
    tx: Parameters<NotificationTexts['render']>[2],
    change: ApplicationChange,
    notice: ApplicationNotice,
  ): Promise<QueuedPush | null> {
    const message = this.message(change, notice);
    if (message === null) return null;
    const rendered = await this.texts.render(message.templateKey, message.values, tx);
    return {
      source: `captain:${message.templateKey}:${change.eventId}`,
      recipient:
        change.captainId === null
          ? { party: 'applicant', accountId: change.accountId }
          : { party: 'captain', captainId: change.captainId },
      templateKey: message.templateKey,
      body: rendered.body,
      level: rendered.level,
      priority: rendered.priority,
      data: { target: change.captainId === null ? 'application' : 'home' },
      at: change.at,
    };
  }

  private message(
    change: ApplicationChange,
    notice: ApplicationNotice,
  ): { templateKey: string; values: Record<string, string> } | null {
    if (notice.kind === 'submitted') return null;
    if (notice.kind === 'document_requested') {
      return {
        templateKey: 'captain.application_document_requested',
        values: { المستند: applicationDocumentLabels[notice.document], السبب: notice.reason },
      };
    }
    if (notice.kind === 'document_rejected') {
      return {
        templateKey: 'captain.document_rejected',
        values: { المستند: applicationDocumentLabels[notice.document], السبب: notice.reason },
      };
    }
    switch (notice.stage) {
      case 'under_review':
        return { templateKey: 'captain.application_under_review', values: {} };
      case 'interview':
        return change.interview === null
          ? null
          : {
              templateKey: 'captain.application_interview',
              values: {
                اليوم: formatDay(change.interview.at, change.timeZone),
                الساعة: formatTime(change.interview.at, change.timeZone),
                المكان: change.interview.place,
              },
            };
      case 'awaiting_kit':
        return { templateKey: 'captain.application_awaiting_kit', values: {} };
      case 'waitlist':
        return { templateKey: 'captain.application_waitlist', values: {} };
      case 'active':
        return { templateKey: 'captain.application_active', values: {} };
      case 'rejected':
        return change.rejection === null
          ? null
          : {
              templateKey: 'captain.application_rejected',
              values: {
                السبب: change.rejection.reason,
                التاريخ: formatDate(change.rejection.reapplyFrom, change.timeZone),
              },
            };
      default:
        return null;
    }
  }
}
