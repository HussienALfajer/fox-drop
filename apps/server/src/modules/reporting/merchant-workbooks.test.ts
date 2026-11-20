import ExcelJS from 'exceljs';
import { describe, expect, it } from 'vitest';
import type { MerchantStatementRead } from '../cashdesk/index.js';
import type { OrderView } from '../ordering/index.js';
import { merchantHistoryWorkbook, merchantStatementWorkbook } from './merchant-workbooks.js';

// The portal's Excel files (RA §17, slice 2.45d): what each row holds.
const decimals = new Map([['TRY', 2]]);

async function rowsOf(file: Buffer): Promise<unknown[][]> {
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(new Uint8Array(file).buffer);
  expect(workbook.worksheets[0]!.views[0]).toMatchObject({ rightToLeft: true });
  const rows: unknown[][] = [];
  workbook.worksheets[0]!.eachRow((row) => rows.push((row.values as unknown[]).slice(1)));
  return rows;
}

describe('«السجل»’s file', () => {
  it('writes each order with the owner’s money lines, on the city’s clock', async () => {
    const order = {
      id: 'a',
      number: 10_001n,
      status: 'delivered',
      testOrder: true,
      redelivery: null,
      currency: 'TRY',
      placedAt: new Date('2026-11-20T10:30:00Z'),
      lines: [{ quantity: 2 }, { quantity: 1 }],
      money: { itemsValue: 24_000n },
    } as unknown as OrderView;
    const cancelled = {
      ...order,
      id: 'b',
      number: 10_002n,
      status: 'cancelled',
      testOrder: false,
    } as unknown as OrderView;
    const rows = await rowsOf(
      await merchantHistoryWorkbook(
        {
          fromDay: '2026-11-20',
          toDay: '2026-11-20',
          timeZone: 'Asia/Damascus',
          orders: [order, cancelled],
          dayOf: () => '2026-11-20',
          owner: new Map([
            ['a', { commission: 3_600n, discountShare: 0n, merchantNet: 20_400n }],
            ['b', null],
          ]),
        },
        decimals,
      ),
    );
    expect(rows[3]).toEqual([
      '10001',
      '2026-11-20 13:30',
      '2026-11-20',
      'تم التسليم',
      3,
      240,
      36,
      0,
      204,
      'طلب تجريبي',
    ]);
    // A cancelled order has no money lines but its items value.
    expect(rows[4]).toEqual([
      '10002',
      '2026-11-20 13:30',
      '2026-11-20',
      'ملغى',
      3,
      240,
      undefined,
      undefined,
      undefined,
      '',
    ]);
  });
});

describe('a weekly statement’s file', () => {
  it('writes the totals and each line with who decided it', async () => {
    const statement = {
      id: 's',
      cityId: 'c',
      restaurantId: 'r',
      restaurantName: 'مطعم',
      cutoff: new Date('2026-11-21T04:00:00Z'),
      periodFrom: new Date('2026-11-14T04:00:00Z'),
      createdAt: new Date('2026-11-21T04:00:00Z'),
      currency: 'TRY',
      orders: 1,
      itemsValue: 24_000n,
      commission: 3_600n,
      discountShare: 0n,
      exceptions: 1_000n,
      weekTotal: 4_600n,
      previousDue: 0n,
      paid: 0n,
      earlierUnpaid: 0n,
      totalDue: 4_600n,
      status: 'partly_paid',
      unpaid: 2_000n,
      lines: [
        {
          kind: 'order',
          position: 0,
          at: new Date('2026-11-20T10:30:00Z'),
          orderId: 'o',
          orderNumber: 10_001n,
          itemsValue: 24_000n,
          pickupLines: [{ currency: 'TRY', amount: 24_000n }],
          commission: 3_600n,
          discountShare: 0n,
          decidedBy: null,
        },
        {
          kind: 'exception',
          position: 1,
          at: new Date('2026-11-20T11:00:00Z'),
          orderId: null,
          orderNumber: null,
          cause: 'adjustment',
          amount: 1_000n,
          reason: 'فرق جرد',
          journalId: 'j',
          decidedBy: { type: 'admin', name: null },
        },
      ],
    } as unknown as MerchantStatementRead;
    const rows = await rowsOf(
      await merchantStatementWorkbook(statement, 'Asia/Damascus', decimals),
    );
    expect(rows).toContainEqual(['الفترة', '2026-11-14 07:00 - 2026-11-21 07:00']);
    expect(rows).toContainEqual(['الحالة', 'مسدّد جزئياً']);
    expect(rows).toContainEqual(['المجموع المستحق', 46]);
    expect(rows).toContainEqual(['غير المسدّد منه', 20]);
    expect(rows).toContainEqual([
      '2026-11-20 13:30',
      'طلب',
      '10001',
      240,
      '240.00 TRY',
      36,
      0,
      36,
      '',
      '',
    ]);
    // An admin without a name reads «FOX DROP».
    expect(rows).toContainEqual([
      '2026-11-20 14:00',
      'تسوية يدوية',
      '',
      undefined,
      '',
      undefined,
      undefined,
      10,
      'فرق جرد',
      'FOX DROP',
    ]);
  });
});
