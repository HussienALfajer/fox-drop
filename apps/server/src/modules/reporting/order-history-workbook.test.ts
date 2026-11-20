import ExcelJS from 'exceljs';
import { describe, expect, it } from 'vitest';
import type { AdminHistoryRow } from '../ordering/index.js';
import { orderHistoryWorkbook } from './order-history-workbook.js';

// Architecture §5.9, AP §9.5 (slice 2.40): the Excel file of «سجل الطلبات».
const row: AdminHistoryRow = {
  id: '0190f0a0-0000-7000-8000-000000000001',
  number: 10042n,
  placedAt: new Date('2026-11-05T10:30:00Z'),
  restaurantId: '0190f0a0-0000-7000-8000-000000000002',
  neighbourhood: 'المركز',
  captainId: '0190f0a0-0000-7000-8000-000000000003',
  status: 'failed',
  outcome: 'wrong_refused',
  responsible: 'customer',
  currency: 'TRY',
  total: 160_50n,
  promoCode: 'SAVE10',
  deliveryMinutes: null,
  testOrder: false,
  redelivery: false,
};

describe('orderHistoryWorkbook', () => {
  it('writes one right-to-left row per order with the panel’s words', async () => {
    const file = await orderHistoryWorkbook(
      {
        fromDay: '2026-11-01',
        toDay: '2026-11-30',
        timeZone: 'Asia/Damascus',
        rows: [
          row,
          {
            ...row,
            id: 'x',
            status: 'delivered',
            outcome: 'normal',
            testOrder: true,
            responsible: null,
            deliveryMinutes: 34,
            promoCode: null,
          },
        ],
        restaurantNames: new Map([[row.restaurantId, 'مطعم الاختبار']]),
        captainNames: new Map([[row.captainId!, 'كابتن']]),
      },
      new Map([['TRY', 2]]),
    );
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(file as unknown as ArrayBuffer);
    const sheet = workbook.worksheets[0]!;
    expect(sheet.views[0]?.rightToLeft).toBe(true);
    expect(sheet.getRow(4).getCell(1).value).toBe('الرقم');
    expect(sheet.getRow(5).values).toEqual([
      undefined,
      10042,
      '2026-11-05 13:30',
      'مطعم الاختبار',
      'المركز',
      'كابتن',
      'فشل التسليم',
      'خطأ ورفضه الزبون',
      'الزبون',
      160.5,
      '',
      'SAVE10',
      'حقيقي',
    ]);
    expect(sheet.getRow(6).getCell(6).value).toBe('تم التسليم');
    expect(sheet.getRow(6).getCell(10).value).toBe(34);
    expect(sheet.getRow(6).getCell(12).value).toBe('تجريبي');
  });
});
