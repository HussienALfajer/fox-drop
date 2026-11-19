import { Injectable, type OnModuleInit } from '@nestjs/common';
import { MerchantsService } from '../merchants/index.js';
import { AlertsService } from './alerts.service.js';

// AP §9.1.3 «تغيير أسعار كبير», RA §9.4 (slice 2.32a): raised in the
// transaction of a restaurant's own price edit or bulk change that moved a
// price by more than merchant.price_change_alert_pct, one alert per change
// (its own subject), with the restaurant for «فتح سجل الأسعار».
@Injectable()
export class LargePriceChangeAlerts implements OnModuleInit {
  constructor(
    private readonly merchants: MerchantsService,
    private readonly alerts: AlertsService,
  ) {}

  onModuleInit(): void {
    this.merchants.onLargePriceChange(async (tx, change) => {
      await this.alerts.sync(
        tx,
        {
          type: 'price_change',
          id: change.changeId,
          cityId: change.cityId,
          details: { restaurantId: change.restaurantId, restaurantName: change.restaurantName },
        },
        ['large_price_change'],
        ['large_price_change'],
        change.at,
      );
    });
  }
}
