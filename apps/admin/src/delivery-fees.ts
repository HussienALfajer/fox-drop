import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';

// AP §9.12.3, §6.2: zones and pricing are read by OWN, OPS and FIN
// (zones.read) and changed by OWN (zones.manage).
export const ZONES_MANAGE = 'zones.manage';

export type DeliveryFees = components['schemas']['AdminDeliveryFeesDto_Output'];
export type FeeVersion = DeliveryFees['versions'][number];
export type FeeRule = FeeVersion['rule'];
export type FeeRestaurant = DeliveryFees['restaurants'][number];
export type FeePreview = components['schemas']['AdminDeliveryFeePreviewDto_Output'];
type SetCityRule = components['schemas']['AdminSetDeliveryFeeDto'];
type RuleBody = SetCityRule['rule'];

// A band as the form edits it: its upper edge in km and its fee in major
// units, as typed. The last band has no edge.
export interface BandForm {
  upToKm: string;
  fee: string;
}

export interface RuleForm {
  kind: 'flat' | 'distance_bands';
  flatFee: string;
  bands: BandForm[];
  minimumFee: string;
  freeDeliveryFrom: string;
}

export const emptyRule: RuleForm = {
  kind: 'flat',
  flatFee: '',
  bands: [
    { upToKm: '', fee: '' },
    { upToKm: '', fee: '' },
  ],
  minimumFee: '',
  freeDeliveryFrom: '',
};

// Whole metres as km for the form («2.5»), and km typed as whole metres
// (null when not a distance above 0 to the metre).
export function kmOf(metres: number): string {
  return String(metres / 1000);
}

export function metresOf(typed: string): number | null {
  const match = /^(\d{1,4})(?:\.(\d{1,3}))?$/.exec(typed.trim());
  if (!match) return null;
  const metres = Number(match[1]) * 1000 + Number((match[2] ?? '').padEnd(3, '0'));
  return metres > 0 ? metres : null;
}

// The form of a rule, empty without one.
export function ruleFormOf(rule: FeeRule | null): RuleForm {
  if (rule === null) return emptyRule;
  const money = (minor: string | null) => (minor === null ? '' : decimalOf(minor, rule.currency));
  return {
    kind: rule.kind,
    flatFee: rule.kind === 'flat' ? money(rule.flatFee) : '',
    bands:
      rule.kind === 'distance_bands'
        ? rule.bands.map((band) => ({
            upToKm: band.upToMetres === null ? '' : kmOf(band.upToMetres),
            fee: money(band.fee),
          }))
        : emptyRule.bands,
    minimumFee: money(rule.minimumFee),
    freeDeliveryFrom: money(rule.freeDeliveryFrom),
  };
}

export type RuleProblem = 'fee' | 'band_fee' | 'band_edge' | 'minimum' | 'threshold';

// The rule to send, or the first problem (with the band's index); the
// server checks again.
export function ruleRequestOf(
  form: RuleForm,
  currency: string,
): { rule: RuleBody } | { problem: RuleProblem; band?: number } {
  const optional = (typed: string) => (typed.trim() === '' ? null : minorOf(typed, currency));
  const minimumFee = optional(form.minimumFee);
  if (form.minimumFee.trim() !== '' && minimumFee === null) return { problem: 'minimum' };
  const freeDeliveryFrom = optional(form.freeDeliveryFrom);
  if (
    form.freeDeliveryFrom.trim() !== '' &&
    (freeDeliveryFrom === null || /^0+$/.test(freeDeliveryFrom))
  ) {
    return { problem: 'threshold' };
  }
  const common = { currency, minimumFee, freeDeliveryFrom };
  if (form.kind === 'flat') {
    const flatFee = minorOf(form.flatFee, currency);
    if (flatFee === null) return { problem: 'fee' };
    return { rule: { kind: 'flat', flatFee, ...common } };
  }
  const bands: { upToMetres: number | null; fee: string }[] = [];
  let previous = 0;
  for (const [index, band] of form.bands.entries()) {
    const fee = minorOf(band.fee, currency);
    if (fee === null) return { problem: 'band_fee', band: index };
    const last = index === form.bands.length - 1;
    if (last) {
      bands.push({ upToMetres: null, fee });
      break;
    }
    const upToMetres = metresOf(band.upToKm);
    if (upToMetres === null || upToMetres <= previous) {
      return { problem: 'band_edge', band: index };
    }
    previous = upToMetres;
    bands.push({ upToMetres, fee });
  }
  return { rule: { kind: 'distance_bands', bands, ...common } };
}

// A rule as lines the page prints: each band's range from the edge before.
export interface BandLine {
  fromMetres: number;
  upToMetres: number | null;
  fee: string;
}

export function bandLines(rule: Extract<FeeRule, { kind: 'distance_bands' }>): BandLine[] {
  return rule.bands.map((band, index) => ({
    fromMetres: index === 0 ? 0 : (rule.bands[index - 1]!.upToMetres ?? 0),
    upToMetres: band.upToMetres,
    fee: band.fee,
  }));
}

const feesKey = (cityId: string) => ['delivery-fees', cityId] as const;

export function useDeliveryFees(cityId: string | undefined) {
  return useQuery({
    queryKey: feesKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/delivery-fees', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('delivery fees unavailable');
      return data;
    },
  });
}

// A 400 is a rule the server refused, a 409 one outside the base currency.
export type SaveResult =
  | { status: 'saved' }
  | { status: 'refused'; refusal: 'invalid_fee_rule' | 'fee_not_in_base_currency' };

function refusalOf(status: number): SaveResult | null {
  if (status === 400) return { status: 'refused', refusal: 'invalid_fee_rule' };
  if (status === 409) return { status: 'refused', refusal: 'fee_not_in_base_currency' };
  return null;
}

// Saves the city's rule, or a restaurant's own with `restaurantId` (a null
// rule returns it to the city's).
export function useSaveFeeRule(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (
      input:
        | { restaurantId: null; rule: RuleBody; reason: string | null }
        | { restaurantId: string; rule: RuleBody | null; reason: string | null },
    ): Promise<SaveResult> => {
      const { data, response } =
        input.restaurantId === null
          ? await api.PUT('/v1/admin/delivery-fees', {
              body: { cityId, rule: input.rule, reason: input.reason },
            })
          : await api.PUT('/v1/admin/delivery-fees/restaurants/{restaurantId}', {
              params: { path: { restaurantId: input.restaurantId } },
              body: { cityId, rule: input.rule, reason: input.reason },
            });
      const refused = refusalOf(response.status);
      if (refused) return refused;
      if (!data) throw new Error(`delivery fee failed with ${response.status}`);
      queryClient.setQueryData(feesKey(cityId), data);
      return { status: 'saved' };
    },
  });
}

export type PreviewResult =
  | { status: 'priced'; preview: FeePreview }
  | { status: 'unpriced'; refusal: 'no_fee_rule' | 'fee_not_in_base_currency' };

export interface PreviewInput {
  restaurantId: string;
  latitude: number;
  longitude: number;
  itemsValue: string;
}

// The preview calculator (AP §9.12.3): what the customer would pay.
export function usePreviewFee(cityId: string) {
  return useMutation({
    mutationFn: async (input: PreviewInput): Promise<PreviewResult> => {
      const { data, error, response } = await api.GET('/v1/admin/delivery-fees/preview', {
        params: { query: { cityId, ...input } },
      });
      if (response.status === 409) {
        const refusal = (error as { error?: string } | undefined)?.error;
        return {
          status: 'unpriced',
          refusal: refusal === 'no_fee_rule' ? 'no_fee_rule' : 'fee_not_in_base_currency',
        };
      }
      if (!data) throw new Error(`preview failed with ${response.status}`);
      return { status: 'priced', preview: data };
    },
  });
}
