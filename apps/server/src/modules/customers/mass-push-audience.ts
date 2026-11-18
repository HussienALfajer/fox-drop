import { Injectable, type OnModuleInit } from '@nestjs/common';
import { CustomerAccountsService } from '../identity/index.js';
import { type MassPushAudience, MassPushesService } from '../marketing/index.js';
import { CustomersService } from './customers.service.js';

// AP §9.11.4 «الإشعارات الجماعية» (slice 2.27d, owner decisions
// 2026-11-18): who is in a mass push's audience, registered with marketing,
// which cannot import this module. Registered customers only (a profile,
// the account not closed): a guest is in none. `all` is every one of them,
// whatever their city (decided by us: accounts have no city; V1 has one);
// `zone` those with a saved address in the zone; `inactive` those whose
// latest delivered order in the city is older than the days; `never_ordered`
// those with no delivered order in the city.
@Injectable()
export class MassPushAudienceSource implements OnModuleInit {
  constructor(
    private readonly customers: CustomersService,
    private readonly accounts: CustomerAccountsService,
    private readonly pushes: MassPushesService,
  ) {}

  onModuleInit(): void {
    this.pushes.useAudience((cityId, audience, now) => this.members(cityId, audience, now));
  }

  async members(cityId: string, audience: MassPushAudience, now: Date): Promise<string[]> {
    const registered = await this.customers.registered();
    const states = await this.accounts.states(registered);
    const open = registered.filter((id) => states.get(id)?.status === 'active');
    switch (audience.kind) {
      case 'all':
        return open;
      case 'zone': {
        const inZone = await this.customers.withAddressIn(cityId, audience.zoneId!);
        return open.filter((id) => inZone.has(id));
      }
      case 'inactive': {
        const last = await this.customers.lastDeliveries(cityId);
        const since = now.getTime() - audience.inactiveDays! * 86_400_000;
        return open.filter((id) => {
          const at = last.get(id);
          return at !== undefined && at.getTime() < since;
        });
      }
      case 'never_ordered': {
        const last = await this.customers.lastDeliveries(cityId);
        return open.filter((id) => !last.has(id));
      }
    }
  }
}
