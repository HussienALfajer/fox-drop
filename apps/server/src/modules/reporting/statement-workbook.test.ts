import ExcelJS from 'exceljs';
import { describe, expect, it } from 'vitest';
import type { RestaurantPeriodStatement } from '../cashdesk/index.js';
import { decimalOf, majorOf, statementWorkbook } from './statement-workbook.js';

// Architecture §5.9, AP §9.10.5 (slice 2.19g): the Excel file of a
// restaurant's statement for a period.
describe('majorOf', () => {
  it('writes minor units as major units from their digits', () => {
    expect(majorOf(123_45n, 2)).toBe(123.45);
    expect(majorOf(-5n, 2)).toBe(-0.05);
    expect(majorOf(0n, 2)).toBe(0);
    expect(majorOf(500n, 0)).toBe(500);
    expect(decimalOf(10_50n, 2)).toBe('10.50');
    expect(decimalOf(-5n, 2)).toBe('-0.05');
  });
});

const statement: RestaurantPeriodStatement = {
  restaurantId: '0190f0a0-0000-7000-8000-000000000001',
  restaurantName: 'مطعم الاختبار',
  cityId: '0190f0a0-0000-7000-8000-000000000002',
  currency: 'TRY',
  fromDay: '2026-11-01',
  toDay: '2026-11-30',
  from: new Date('2026-11-01T03:00:00Z'),
  to: new Date('2026-12-01T03:00:00Z'),
  opening: 1_000_00n,
  orders: 1,
  itemsValue: 400_00n,
  commission: 60_00n,
  discountShare: 5_00n,
  exceptions: -20_00n,
  paid: 900_00n,
  closing: 145_00n,
  lines: [
    {
      kind: 'order',
      at: new Date('2026-11-05T10:30:00Z'),
      orderId: '0190f0a0-0000-7000-8000-000000000003',
      orderNumber: 1042n,
      itemsValue: 400_00n,
      pickupLines: [
        { currency: 'TRY', amount: 200_00n },
        { currency: 'USD', amount: 5_00n },
      ],
      commission: 60_00n,
      discountShare: 5_00n,
      receipt: null,
    },
    {
      kind: 'exception',
      at: new Date('2026-11-06T09:00:00Z'),
      orderId: null,
      orderNumber: null,
      cause: 'adjustment',
      amount: -20_00n,
      reason: 'تصحيح',
      journalId: '0190f0a0-0000-7000-8000-000000000004',
      receipt: null,
    },
    {
      kind: 'payment',
      at: new Date('2026-11-08T12:00:00Z'),
      orderId: null,
      orderNumber: null,
      cause: null,
      amount: -900_00n,
      reason: null,
      journalId: '0190f0a0-0000-7000-8000-000000000005',
      receipt: { id: '0190f0a0-0000-7000-8000-000000000006', number: 'AZ-2026-000012' },
    },
  ],
};

async function read(buffer: Buffer) {
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(new Uint8Array(buffer).buffer);
  const sheet = workbook.worksheets[0]!;
  const rows: unknown[][] = [];
  sheet.eachRow({ includeEmpty: true }, (row) => {
    rows.push((row.values as unknown[]).slice(1));
  });
  return { sheet, rows };
}

describe('statementWorkbook', () => {
  it('writes the header, the summary and every line on a right-to-left sheet', async () => {
    const buffer = await statementWorkbook(
      statement,
      'Asia/Damascus',
      new Map([
        ['TRY', 2],
        ['USD', 2],
      ]),
    );
    const { sheet, rows } = await read(buffer);
    expect(sheet.views[0]?.rightToLeft).toBe(true);
    expect(rows[1]).toEqual(['المطعم', 'مطعم الاختبار']);
    expect(rows[2]).toEqual(['الفترة', 'من 2026-11-01 إلى 2026-11-30']);
    expect(rows).toContainEqual(['الرصيد الافتتاحي', 1000]);
    expect(rows).toContainEqual(['الرصيد الختامي', 145]);
    expect(rows).toContainEqual([
      '2026-11-05 13:30',
      'طلب',
      '1042',
      400,
      '200.00 TRY + 5.00 USD',
      60,
      5,
      65,
      '',
      '',
    ]);
    expect(rows).toContainEqual([
      '2026-11-06 12:00',
      'تسوية يدوية',
      '',
      undefined,
      '',
      undefined,
      undefined,
      -20,
      'تصحيح',
      '',
    ]);
    expect(rows.at(-1)).toEqual([
      '2026-11-08 15:00',
      'دفعة',
      '',
      undefined,
      '',
      undefined,
      undefined,
      -900,
      '',
      'AZ-2026-000012',
    ]);
  });
});
