import { Get, HttpCode, NotFoundException, Param, Post, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, SignedIn } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import { alertCodes, alertSeverities, alertSubjects } from './alert-rules.js';
import { type Alert, AlertNotFoundError, AlertsService } from './alerts.service.js';

class AlertsQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    state: z
      .enum(['open', 'closed'])
      .default('open')
      .describe('open: the alerts list (AP §9.1.3); closed: the latest 100 of the history.'),
  }),
) {}

class AlertParamsDto extends createZodDto(z.object({ alertId: z.uuid() })) {}

class AdminAlertDto extends createZodDto(
  z.object({
    id: z.uuid(),
    code: z.enum(alertCodes).describe('The rule of AP §9.1.3.'),
    severity: z
      .enum(alertSeverities)
      .describe(
        'critical repeats its sound until acknowledged, warning plays once, information is silent (AP §7.3).',
      ),
    subjectType: z.enum(alertSubjects),
    subjectId: z.string().describe('The order, captain or sending number it is about.'),
    orderNumber: z.string().nullable().describe('For an alert about an order.'),
    captainName: z.string().nullable().describe('For an alert about a captain.'),
    restaurantName: z.string().nullable().describe('For an alert about a restaurant.'),
    raisedAt: z.iso.datetime(),
    acknowledged: z
      .object({ at: z.iso.datetime(), byId: z.uuid(), byName: z.string().nullable() })
      .nullable()
      .describe('«استلام»: who took it, which every recipient sees.'),
    resolvedAt: z.iso.datetime().nullable(),
  }),
) {}

class AdminAlertsDto extends createZodDto(z.object({ alerts: z.array(AdminAlertDto.schema) })) {}

// AP §7.3, §9.1.3: the alerts a signed-in user's roles receive, and «استلام».
// Any signed-in user may call them; the roles decide what they answer.
@AdminController('alerts')
export class AdminAlertsController {
  constructor(
    private readonly alerts: AlertsService,
    private readonly sessions: AdminSessionsService,
  ) {}

  @Get()
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminAlertsDto })
  async list(@Query() query: AlertsQueryDto, @CurrentAdminSession() session: AdminSession) {
    const alerts = await this.alerts.list(query.cityId, session.roles, query.state === 'closed');
    return { alerts: await this.bodies(alerts) };
  }

  // 404 for an alert the roles do not receive. Taking an alert someone took
  // already answers it with who took it.
  @Post(':alertId/acknowledge')
  @HttpCode(200)
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminAlertDto })
  async acknowledge(@Param() params: AlertParamsDto, @CurrentAdminSession() session: AdminSession) {
    try {
      const alert = await this.alerts.acknowledge(
        params.alertId,
        session.accountId,
        session.roles,
        new Date(),
      );
      const [body] = await this.bodies([alert]);
      return body!;
    } catch (error) {
      if (error instanceof AlertNotFoundError) throw new NotFoundException();
      throw error;
    }
  }

  private async bodies(alerts: Alert[]): Promise<AdminAlertDto[]> {
    const names = await this.sessions.names(
      alerts.flatMap((alert) => (alert.acknowledgedBy ? [alert.acknowledgedBy] : [])),
    );
    return alerts.map((alert) => ({
      id: alert.id,
      code: alert.code,
      severity: alert.severity,
      subjectType: alert.subjectType,
      subjectId: alert.subjectId,
      orderNumber: alert.details.orderNumber ?? null,
      captainName: alert.details.captainName ?? null,
      restaurantName: alert.details.restaurantName ?? null,
      raisedAt: alert.raisedAt.toISOString(),
      acknowledged:
        alert.acknowledgedAt && alert.acknowledgedBy
          ? {
              at: alert.acknowledgedAt.toISOString(),
              byId: alert.acknowledgedBy,
              byName: names.get(alert.acknowledgedBy) ?? null,
            }
          : null,
      resolvedAt: alert.resolvedAt?.toISOString() ?? null,
    }));
  }
}
