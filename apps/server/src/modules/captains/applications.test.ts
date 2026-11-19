import { describe, expect, it } from 'vitest';
import {
  addMonths,
  cityDay,
  criminalRecordExpiry,
  fileCountAllowed,
  missing,
  normaliseFullName,
  normaliseIdNumber,
  normalisePlate,
  oldEnough,
  requiredDocuments,
} from './applications.js';

// The application form's rules (CA §5.2–5.3, AP §9.7.1; slice 2.34a).
describe('the application rules', () => {
  it('asks the vehicle papers of a motor vehicle only (CA §5.3)', () => {
    expect(requiredDocuments('motorbike')).toContain('vehicle_papers');
    expect(requiredDocuments('car')).toContain('vehicle_papers');
    expect(requiredDocuments('bicycle')).not.toContain('vehicle_papers');
    expect(requiredDocuments('walking')).not.toContain('vehicle_papers');
    expect(requiredDocuments(null)).not.toContain('driving_licence');
  });

  it('takes the ID front and back, and one or two pages of the others', () => {
    expect([1, 2, 3].map((count) => fileCountAllowed('national_id', count))).toEqual([
      false,
      true,
      false,
    ]);
    expect([0, 1, 2, 3].map((count) => fileCountAllowed('civil_registry', count))).toEqual([
      false,
      true,
      true,
      false,
    ]);
  });

  it('lists what the application still needs, an expired criminal record included (C18)', () => {
    const today = '2026-11-19';
    expect(missing({ vehicle: null, documents: [], termsPending: true, today })).toEqual([
      'vehicle',
      'document:national_id',
      'document:personal_photo',
      'document:civil_registry',
      'document:criminal_record',
      'terms',
    ]);
    const documents = [
      { kind: 'national_id' as const, expiresOn: null },
      { kind: 'personal_photo' as const, expiresOn: null },
      { kind: 'civil_registry' as const, expiresOn: null },
      { kind: 'criminal_record' as const, expiresOn: '2027-01-01' },
    ];
    expect(missing({ vehicle: 'walking', documents, termsPending: false, today })).toEqual([]);
    expect(missing({ vehicle: 'car', documents, termsPending: false, today })).toEqual([
      'document:vehicle_papers',
    ]);
    const expired = documents.map((each) =>
      each.kind === 'criminal_record' ? { ...each, expiresOn: today } : each,
    );
    expect(missing({ vehicle: 'walking', documents: expired, termsPending: false, today })).toEqual(
      ['document:criminal_record'],
    );
  });

  it('wants a three-part name, a plate and an ID number in their forms', () => {
    expect(normaliseFullName('  محمد   أحمد العلي ')).toBe('محمد أحمد العلي');
    expect(normaliseFullName('محمد العلي')).toBeNull();
    expect(normaliseFullName(`${'أ'.repeat(40)} ${'ب'.repeat(40)} ج`)).toBeNull();
    expect(normalisePlate(' 12345  حلب ')).toBe('12345 حلب');
    expect(normalisePlate('   ')).toBeNull();
    expect(normalisePlate('x'.repeat(21))).toBeNull();
    expect(normaliseIdNumber('0123-456 789')).toBe('0123456789');
    expect(normaliseIdNumber('12a45')).toBeNull();
    expect(normaliseIdNumber('1234')).toBeNull();
  });

  it('counts the age and the criminal record by calendar months', () => {
    expect(oldEnough('2008-11-19', 18, '2026-11-19')).toBe(true);
    expect(oldEnough('2008-11-20', 18, '2026-11-19')).toBe(false);
    // Born on 29 February: of age on 28 February of a common year.
    expect(oldEnough('2008-02-29', 18, '2026-02-28')).toBe(true);
    expect(criminalRecordExpiry('2026-01-31', 12)).toBe('2027-01-31');
    expect(addMonths('2026-01-31', 1)).toBe('2026-02-28');
    expect(addMonths('2025-12-15', 2)).toBe('2026-02-15');
  });

  it("reads the day on the city's clock", () => {
    expect(cityDay(new Date('2026-11-18T21:30:00Z'), 'Asia/Damascus')).toBe('2026-11-19');
  });
});
