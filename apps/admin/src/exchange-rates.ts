import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { minorOf } from './format.js';

// AP §6.3: OWN and FIN edit the rates; finance.read reads them.
export const EDIT_RATES = 'fx.edit_rates';

export type ExchangeRates = components['schemas']['AdminExchangeRatesDto_Output'];
export type RateRow = ExchangeRates['currencies'][number];
export type RateVersion = NonNullable<RateRow['rate']>;
export type Direction = components['schemas']['AdminSetExchangeRateDto']['direction'];
export type RoundingMode = RateRow['roundingMode'];

// The places a rate shows: enough for «1 TRY = 0.024272 USD».
const RATE_PLACES = 6;

// An exact fraction as a decimal to `places`, half up, trailing zeros
// dropped, with no float on the way.
export function fractionText(numerator: string, denominator: string, places = RATE_PLACES): string {
  const scale = 10n ** BigInt(places);
  const n = BigInt(numerator) * scale;
  const d = BigInt(denominator);
  const scaled = (n * 2n + d) / (d * 2n);
  const whole = scaled / scale;
  const fraction = (scaled % scale).toString().padStart(places, '0').replace(/0+$/, '');
  return fraction ? `${whole}.${fraction}` : `${whole}`;
}

// The rate both ways, as the screen states it (AP §8.6): «1 USD = 41.2 TRY»
// and «1 TRY = 0.024272 USD».
export function rateLines(currency: string, rate: RateVersion) {
  return {
    basePerUnit: fractionText(rate.numerator, rate.denominator),
    unitsPerBase: fractionText(rate.denominator, rate.numerator),
    currency,
    base: rate.baseCurrency,
  };
}

// The rounding unit, kept in minor units, in the currency's major units.
export function unitText(minor: string | null, decimals: number): string | null {
  if (minor === null) return null;
  return fractionText(minor, (10n ** BigInt(decimals)).toString(), decimals);
}

const ratesKey = (cityId: string) => ['exchange-rates', cityId] as const;

export function useExchangeRates(cityId: string | undefined) {
  return useQuery({
    queryKey: ratesKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async (): Promise<ExchangeRates> => {
      const { data } = await api.GET('/v1/admin/exchange-rates', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The exchange rates read failed.');
      return data;
    },
  });
}

export function useRateHistory(cityId: string, currency: string | null) {
  return useQuery({
    queryKey: ['exchange-rates', cityId, 'history', currency],
    enabled: currency !== null,
    queryFn: async (): Promise<RateVersion[]> => {
      const { data } = await api.GET('/v1/admin/exchange-rates/history', {
        params: { query: { cityId, currency: currency! } },
      });
      if (!data) throw new Error('The rate history read failed.');
      return data.versions;
    },
  });
}

export interface RateEdit {
  currency: string;
  value: string;
  direction: Direction;
  reason: string;
  confirmLargeChange: boolean;
}

// What the edit answered: saved, a large change to confirm a second time
// (AP §8.6), or a value the server refused.
export type RateEditResult =
  { status: 'saved' } | { status: 'confirm' } | { status: 'refused'; refusal: string };

export function useSetRate(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (edit: RateEdit): Promise<RateEditResult> => {
      const { data, error, response } = await api.PUT('/v1/admin/exchange-rates', {
        body: {
          cityId,
          currency: edit.currency,
          value: edit.value.trim(),
          direction: edit.direction,
          reason: edit.reason.trim() || null,
          confirmLargeChange: edit.confirmLargeChange,
        },
      });
      if (data) {
        queryClient.setQueryData(ratesKey(cityId), data);
        await queryClient.invalidateQueries({ queryKey: ['exchange-rates', cityId, 'history'] });
        return { status: 'saved' };
      }
      const refusal = (error as { error?: string } | undefined)?.error ?? '';
      if (response.status === 409 && refusal === 'large_change_unconfirmed') {
        return { status: 'confirm' };
      }
      if (response.status === 400) return { status: 'refused', refusal };
      throw new Error(`The rate edit failed with ${response.status}.`);
    },
  });
}

export interface RoundingEdit {
  currency: string;
  // In the currency's major units, as typed.
  unit: string;
  mode: RoundingMode;
  reason: string;
}

export type RoundingResult = { status: 'saved' } | { status: 'refused' };

// D14: the rounding unit and mode are the settings currency.<code>.*, saved
// through the settings routes (their history and reasons stay there).
export function useSaveRounding(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      row,
      edit,
    }: {
      row: RateRow;
      edit: RoundingEdit;
    }): Promise<RoundingResult> => {
      const minor = minorOf(edit.unit, row.currency, row.decimals);
      if (minor === null || /^0+$/.test(minor) || !edit.reason.trim()) {
        return { status: 'refused' };
      }
      // The mode first: if the unit then fails, the unit in force stays.
      const changes: { key: string; value: unknown }[] = [];
      if (edit.mode !== row.roundingMode) {
        changes.push({ key: `currency.${row.currency}.rounding_mode`, value: edit.mode });
      }
      if (minor !== row.roundingUnitMinor) {
        changes.push({
          key: `currency.${row.currency}.rounding_unit`,
          value: { amountMinor: Number(minor) },
        });
      }
      try {
        for (const { key, value } of changes) {
          const { error, response } = await api.PUT('/v1/admin/settings/{key}', {
            params: { path: { key } },
            body: { cityId, value, reason: edit.reason.trim() },
          });
          const status: number = response.status;
          if (status === 400) return { status: 'refused' };
          if (error !== undefined) throw new Error(`Setting ${key} failed with ${status}.`);
        }
        return { status: 'saved' };
      } finally {
        await queryClient.invalidateQueries({ queryKey: ratesKey(cityId) });
      }
    },
  });
}
