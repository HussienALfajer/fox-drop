import { Get, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { Public } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import { type PlatformApp, updateNeed } from './app-versions.js';
import { SettingsService } from './settings.service.js';

// CU §4.2 and §4.7, RA §4.2 and §4.10, CA §4.2 and §4.8: the settings each app
// reads at launch, when it comes back to the foreground and when a failed
// check succeeds again (AP §9.14 «التطبيقات», Appendix A app.<app>.*). Public:
// the update and maintenance screens come before sign-in.

class PlatformQueryDto extends createZodDto(
  z.object({
    // Not refused when malformed: such a version is below any minimum
    // (versionBelow), so the app shows its update screen.
    version: z.string().min(1).max(40).describe('The app version, such as 1.4.0.'),
  }),
) {}

// Optional rather than nullable: Nest's document reads a top-level nullable
// type as a list.
class PlatformDto extends createZodDto(
  z.object({
    // Not `update`: the Dart client's built_value models have an update().
    updateNeed: z
      .enum(['required', 'suggested', 'none'])
      .describe(
        'required: below the min_version setting of the app, the blocking update screen; suggested: below its latest_version, a dismissible banner.',
      ),
    // No angle brackets in descriptions: the Dart client's doc comments read
    // them as HTML (unintended_html_in_doc).
    updateMessage: z
      .string()
      .optional()
      .describe('The update_message setting of the app, when set.'),
    maintenance: z
      .boolean()
      .describe('The maintenance setting of the app: the blocking maintenance screen.'),
    maintenanceMessage: z.string().optional().describe('The maintenance message, when set.'),
  }),
) {}

async function read(settings: SettingsService, app: PlatformApp, version: string) {
  const target = { parameter: app };
  const [minVersion, latestVersion, updateMessage, maintenance] = await Promise.all([
    settings.get('app.<app>.min_version', target),
    settings.get('app.<app>.latest_version', target),
    settings.get('app.<app>.update_message', target),
    settings.get('app.<app>.maintenance', target),
  ]);
  return {
    updateNeed: updateNeed(version, { minVersion, latestVersion }),
    ...(updateMessage === null ? {} : { updateMessage }),
    maintenance: maintenance.enabled,
    ...(maintenance.message === null ? {} : { maintenanceMessage: maintenance.message }),
  } as PlatformDto;
}

@CustomerController('platform')
export class CustomerPlatformController {
  constructor(private readonly settings: SettingsService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: PlatformDto })
  get(@Query() query: PlatformQueryDto) {
    return read(this.settings, 'customer', query.version);
  }
}

@MerchantController('platform')
export class MerchantPlatformController {
  constructor(private readonly settings: SettingsService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: PlatformDto })
  get(@Query() query: PlatformQueryDto) {
    return read(this.settings, 'merchant', query.version);
  }
}

@CaptainController('platform')
export class CaptainPlatformController {
  constructor(private readonly settings: SettingsService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: PlatformDto })
  get(@Query() query: PlatformQueryDto) {
    return read(this.settings, 'captain', query.version);
  }
}
