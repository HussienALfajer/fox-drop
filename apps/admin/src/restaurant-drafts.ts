import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { decimalOf, minorOf } from './format.js';
import { minuteOf, timeOf } from './peak-bonus.js';
import { fileRefusal, type ImageRefusal, uploadImage } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

// «إضافة مطعم» (AP §9.6.3 steps 1–6; slice 2.30a): who does each step
// (AP §6.2–6.3). The server checks every one.
export const RESTAURANTS_READ = 'restaurants.read';
export const RESTAURANTS_CREATE = 'restaurants.create';
export const RESTAURANTS_MANAGE = 'restaurants.manage';
export const RESTAURANTS_COMMISSION = 'restaurants.commission';
export const RESTAURANTS_OWNER_ACCOUNTS = 'restaurants.owner_accounts';

export function canSeeDrafts(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_READ) || can(session, RESTAURANTS_CREATE);
}

export type Draft = components['schemas']['AdminRestaurantDraftDto_Output'];
export type DraftSummary =
  components['schemas']['AdminRestaurantDraftsDto_Output']['drafts'][number];
export type DraftChoices = components['schemas']['AdminRestaurantDraftChoicesDto_Output'];
export type RestaurantAccount =
  components['schemas']['AdminRestaurantAccountsDto_Output']['accounts'][number];
type Period = Draft['operations']['periods'][number];
type BasicsBody = components['schemas']['AdminDraftBasicsDto'];
type LocationBody = components['schemas']['AdminDraftLocationDto'];
type OperationsBody = components['schemas']['AdminDraftOperationsDto'];
type CommissionBody = components['schemas']['AdminDraftCommissionDto'];
type ContractBody = components['schemas']['AdminDraftContractDto'];
type AccountBody = components['schemas']['AdminNewRestaurantAccountDto'];

// The wizard's steps in order. Step 7 (the menu) and 8 (activation) come
// with slice 2.30b.
export const STEPS = [
  'basics',
  'location',
  'operations',
  'commission',
  'contract',
  'accounts',
] as const;
export type Step = (typeof STEPS)[number];

export function isStep(value: unknown): value is Step {
  return typeof value === 'string' && (STEPS as readonly string[]).includes(value);
}

// Who may save each step; reading needs canSeeDrafts.
export function canSaveStep(session: AdminSession | null | undefined, step: Step): boolean {
  switch (step) {
    case 'commission':
      return can(session, RESTAURANTS_COMMISSION);
    case 'accounts':
      return can(session, RESTAURANTS_OWNER_ACCOUNTS);
    default:
      return can(session, RESTAURANTS_CREATE);
  }
}

// OWN and OPS confirm the contract with the pledge.
// Who reads step 6's accounts (DATA does not: AP §6.2).
export function canReadAccounts(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_READ) || can(session, RESTAURANTS_OWNER_ACCOUNTS);
}

export function canConfirmContract(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_MANAGE);
}

// Which steps are done: the server's, and step 6 with an owner account.
export function stepsDone(
  draft: Draft | null,
  accounts: RestaurantAccount[],
): Record<Step, boolean> {
  return {
    basics: draft?.steps.basics ?? false,
    location: draft?.steps.location ?? false,
    operations: draft?.steps.operations ?? false,
    commission: draft?.steps.commission ?? false,
    contract: draft?.steps.contract ?? false,
    accounts: accounts.some((account) => account.role === 'owner'),
  };
}

// The reads.
export const draftsQuery = (cityId: string) =>
  queryOptions({
    queryKey: ['restaurant-drafts', cityId],
    queryFn: async (): Promise<DraftSummary[]> => {
      const { data } = await api.GET('/v1/admin/restaurant-drafts', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The drafts read failed.');
      return data.drafts;
    },
  });

export const draftChoicesQuery = (cityId: string) =>
  queryOptions({
    queryKey: ['restaurant-draft-choices', cityId],
    queryFn: async (): Promise<DraftChoices> => {
      const { data } = await api.GET('/v1/admin/restaurant-drafts/choices', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The choices read failed.');
      return data;
    },
  });

const draftKey = (restaurantId: string) => ['restaurant-draft', restaurantId] as const;

// A draft, or null before step 1 is saved (the id the panel just named).
export const draftQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: draftKey(restaurantId),
    queryFn: async (): Promise<Draft | null> => {
      const { data, response } = await api.GET('/v1/admin/restaurant-drafts/{restaurantId}', {
        params: { path: { restaurantId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error('The draft read failed.');
      return data;
    },
    // The scans' signed links last 10 minutes: read them again before.
    refetchInterval: 5 * 60_000,
  });

const accountsKey = (restaurantId: string) => ['restaurant-accounts', restaurantId] as const;

export const accountsQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: accountsKey(restaurantId),
    queryFn: async (): Promise<RestaurantAccount[]> => {
      const { data, response } = await api.GET('/v1/admin/restaurants/{restaurantId}/accounts', {
        params: { path: { restaurantId } },
      });
      if (response.status === 404) return [];
      if (!data) throw new Error('The accounts read failed.');
      return data.accounts;
    },
  });

// Step 1.
export interface BasicsForm {
  nameAr: string;
  nameEn: string;
  categoryIds: string[];
  description: string;
}

export function basicsFormOf(draft: Draft | null): BasicsForm {
  return {
    nameAr: draft?.basics.nameAr ?? '',
    nameEn: draft?.basics.nameEn ?? '',
    categoryIds: draft?.basics.categoryIds ?? [],
    description: draft?.basics.description ?? '',
  };
}

const blankToNull = (typed: string) => (typed.trim() === '' ? null : typed.trim());

export function basicsBody(form: BasicsForm, cityId: string): BasicsBody | null {
  if (form.nameAr.trim() === '') return null;
  return {
    cityId,
    nameAr: form.nameAr.trim(),
    nameEn: blankToNull(form.nameEn),
    categoryIds: form.categoryIds,
    description: blankToNull(form.description),
  };
}

// Step 2: the pin as typed degrees (the map writes them too).
export interface LocationForm {
  latitude: string;
  longitude: string;
  address: string;
  phone: string;
  ownerName: string;
}

export function locationFormOf(draft: Draft | null): LocationForm {
  const at = draft?.location.location;
  return {
    latitude: at ? String(at.latitude) : '',
    longitude: at ? String(at.longitude) : '',
    address: draft?.location.address ?? '',
    phone: draft?.location.phone ?? '',
    ownerName: draft?.location.ownerName ?? '',
  };
}

// A decimal degree as typed, within its range; null otherwise.
export function degreesOf(typed: string, limit: number): number | null {
  if (!/^-?\d{1,3}(\.\d+)?$/.test(typed.trim())) return null;
  const value = Number(typed.trim());
  return Math.abs(value) <= limit ? value : null;
}

// A number as the panel takes it: E.164, a Turkish mobile typed from 0
// (0532 111 2233, 11 digits), or a Syrian one typed from 0 (0944 123 456 or
// 021 123 4567). Spaces are dropped; null when unreadable.
export function phoneOf(typed: string): string | null {
  const digits = typed.replace(/[\s-]/g, '');
  if (/^\+[1-9]\d{7,14}$/.test(digits)) return digits;
  if (/^05\d{9}$/.test(digits)) return `+90${digits.slice(1)}`;
  if (/^0[1-9]\d{7,9}$/.test(digits)) return `+963${digits.slice(1)}`;
  return null;
}

export type LocationProblem = 'pin' | 'phone';

export function locationBody(
  form: LocationForm,
): { body: LocationBody } | { problem: LocationProblem } {
  const latitude = degreesOf(form.latitude, 90);
  const longitude = degreesOf(form.longitude, 180);
  if (latitude === null || longitude === null) return { problem: 'pin' };
  const phone = form.phone.trim() === '' ? null : phoneOf(form.phone);
  if (phone === null && form.phone.trim() !== '') return { problem: 'phone' };
  return {
    body: {
      location: { latitude, longitude },
      address: blankToNull(form.address),
      phone,
      ownerName: blankToNull(form.ownerName),
    },
  };
}

// Step 3. The weekdays of the server (0 Sunday to 6 Saturday), from
// Saturday, the Syrian week; each day holds its periods as «10:00».
export const weekDays = [6, 0, 1, 2, 3, 4, 5] as const;
export type WeekDay = (typeof weekDays)[number];

export interface PeriodForm {
  from: string;
  to: string;
}

export interface OperationsForm {
  days: Record<WeekDay, PeriodForm[]>;
  defaultPrepMin: string;
  minimumOrder: string;
  coverage: 'radius' | 'zones';
  radiusKm: string;
  zoneIds: string[];
}

export function operationsFormOf(draft: Draft | null, choices: DraftChoices): OperationsForm {
  const periods = draft?.operations.periods ?? [];
  const days = Object.fromEntries(
    weekDays.map((day) => [
      day,
      periods
        .filter((period) => period.weekday === day)
        .map((period) => ({ from: timeOf(period.opensAt), to: timeOf(period.closesAt % 1440) })),
    ]),
  ) as Record<WeekDay, PeriodForm[]>;
  const coverage = draft?.operations.coverage ?? null;
  const minimum = draft?.operations.minimumOrder ?? choices.defaultMinimumOrder;
  return {
    days,
    defaultPrepMin: String(draft?.operations.defaultPrepMin ?? choices.defaultPrepMin),
    minimumOrder: minimum ? decimalOf(minimum.amount, minimum.currency) : '',
    coverage: coverage?.kind ?? 'radius',
    radiusKm: coverage?.kind === 'radius' ? String(coverage.radiusMetres / 1000) : '',
    zoneIds: coverage?.kind === 'zones' ? coverage.zoneIds : [],
  };
}

export type OperationsProblem =
  | { problem: 'hours'; day: WeekDay }
  | { problem: 'no_hours' | 'prep' | 'minimum' | 'radius' | 'zones' | 'no_base' };

// The body to save, or the first problem; the server checks the rest
// (periods of 30 minutes or more that never overlap, the prep bounds).
export function operationsBody(
  form: OperationsForm,
  baseCurrency: string | null,
): { body: OperationsBody } | OperationsProblem {
  const periods: Period[] = [];
  for (const day of weekDays) {
    for (const each of form.days[day]) {
      const opensAt = minuteOf(each.from);
      const typed = minuteOf(each.to);
      // 00:00 as the end is the day's end; another end at or before the
      // start runs past midnight.
      const closesAt = typed === 0 ? 1440 : typed;
      if (opensAt === null || closesAt === null || opensAt === closesAt) {
        return { problem: 'hours', day };
      }
      periods.push({ weekday: day, opensAt, closesAt });
    }
  }
  if (periods.length === 0) return { problem: 'no_hours' };
  if (!/^\d{1,3}$/.test(form.defaultPrepMin.trim())) return { problem: 'prep' };
  if (baseCurrency === null) return { problem: 'no_base' };
  const minimum = minorOf(form.minimumOrder, baseCurrency);
  if (minimum === null) return { problem: 'minimum' };
  let coverage: OperationsBody['coverage'];
  if (form.coverage === 'radius') {
    if (!/^\d{1,3}(\.\d{1,3})?$/.test(form.radiusKm.trim())) return { problem: 'radius' };
    const radiusMetres = Math.round(Number(form.radiusKm.trim()) * 1000);
    if (radiusMetres < 1 || radiusMetres > 100_000) return { problem: 'radius' };
    coverage = { kind: 'radius', radiusMetres };
  } else {
    if (form.zoneIds.length === 0) return { problem: 'zones' };
    coverage = { kind: 'zones', zoneIds: form.zoneIds };
  }
  return {
    body: {
      periods,
      defaultPrepMin: Number(form.defaultPrepMin.trim()),
      minimumOrder: { amount: minimum, currency: baseCurrency },
      coverage,
    },
  };
}

// Step 4: percentages as typed («15» or «12.5»); the launch rate's end is a
// date on the city's clock, from whose start the standard rate applies.
export interface CommissionForm {
  rate: string;
  launch: boolean;
  launchRate: string;
  standardFrom: string;
}

export function percentOf(basisPoints: number): string {
  return String(basisPoints / 100);
}

export function basisPointsOf(typed: string): number | null {
  if (!/^\d{1,3}(\.\d{1,2})?$/.test(typed.trim())) return null;
  const value = Math.round(Number(typed.trim()) * 100);
  return value <= 10_000 ? value : null;
}

// The date of a moment on the city's clock, as «2027-02-01».
function dateIn(at: string, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(new Date(at));
}

export function commissionFormOf(
  draft: Draft | null,
  choices: DraftChoices,
  timeZone: string,
): CommissionForm {
  const commission = draft?.commission ?? null;
  return {
    rate: percentOf(commission?.rateBp ?? choices.defaultCommissionBp),
    launch: commission?.launch != null,
    launchRate: commission?.launch ? percentOf(commission.launch.rateBp) : '',
    standardFrom: commission?.launch ? dateIn(commission.launch.until, timeZone) : '',
  };
}

export type CommissionProblem = 'rate' | 'launch_rate' | 'standard_from';

export function commissionBody(
  form: CommissionForm,
  timeZone: string,
): { body: CommissionBody } | { problem: CommissionProblem } {
  const rateBp = basisPointsOf(form.rate);
  if (rateBp === null) return { problem: 'rate' };
  if (!form.launch) return { body: { rateBp, launch: null } };
  const launchBp = basisPointsOf(form.launchRate);
  if (launchBp === null) return { problem: 'launch_rate' };
  const until = /^\d{4}-\d{2}-\d{2}$/.test(form.standardFrom)
    ? zonedToUtc(`${form.standardFrom}T00:00`, timeZone)
    : null;
  if (until === null) return { problem: 'standard_from' };
  return { body: { rateBp, launch: { rateBp: launchBp, until } } };
}

// Step 5: the scans are files chosen on the page, uploaded when the step is
// saved.
export interface ContractForm {
  signedOn: string;
  durationMonths: string;
  contractFile: File | null;
  licenceFile: File | null;
}

export function contractFormOf(draft: Draft | null): ContractForm {
  return {
    signedOn: draft?.contract?.signedOn ?? '',
    durationMonths: draft?.contract?.durationMonths ? String(draft.contract.durationMonths) : '',
    contractFile: null,
    licenceFile: null,
  };
}

export type ContractProblem = 'signed_on' | 'duration' | 'scan';

export function contractProblem(form: ContractForm): ContractProblem | null {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(form.signedOn)) return 'signed_on';
  const months = Number(form.durationMonths.trim());
  if (!/^\d{1,3}$/.test(form.durationMonths.trim()) || months < 1 || months > 120) {
    return 'duration';
  }
  for (const file of [form.contractFile, form.licenceFile]) {
    if (file !== null && fileRefusal(file) !== null) return 'scan';
  }
  return null;
}

// Step 6.
export interface AccountForm {
  role: 'owner' | 'cashier';
  name: string;
  phone: string;
}

// A Syrian or Turkish mobile, as the restaurant app signs in with.
export function accountBody(form: AccountForm): AccountBody | null {
  const phone = phoneOf(form.phone);
  if (form.name.trim() === '' || phone === null) return null;
  if (!/^(\+9639\d{8}|\+905\d{9})$/.test(phone)) return null;
  return { role: form.role, name: form.name.trim(), phone };
}

// A save's answer: the draft after it, or the server's refusal code.
export type SaveResult = { status: 'saved'; draft: Draft } | { status: 'refused'; refusal: string };

type Answer = { data?: Draft; error?: unknown; response: Response };

function outcome(answer: Answer): SaveResult {
  if (answer.data) return { status: 'saved', draft: answer.data };
  const status = answer.response.status;
  if (status === 400 || status === 404 || status === 409) {
    const refusal = (answer.error as { error?: unknown } | undefined)?.error;
    return { status: 'refused', refusal: typeof refusal === 'string' ? refusal : 'invalid' };
  }
  throw new Error(`The draft save failed (${status}).`);
}

export type StepSave =
  | { step: 'basics'; body: BasicsBody }
  | { step: 'location'; body: LocationBody }
  | { step: 'operations'; body: OperationsBody }
  | { step: 'commission'; body: CommissionBody }
  | { step: 'contract'; form: ContractForm }
  | { step: 'confirm' };

async function run(restaurantId: string, save: StepSave): Promise<SaveResult> {
  const path = { restaurantId };
  switch (save.step) {
    case 'basics':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/basics', {
          params: { path },
          body: save.body,
        }),
      );
    case 'location':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/location', {
          params: { path },
          body: save.body,
        }),
      );
    case 'operations':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/operations', {
          params: { path },
          body: save.body,
        }),
      );
    case 'commission':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/commission', {
          params: { path },
          body: save.body,
        }),
      );
    case 'contract': {
      const upload = async (
        purpose: 'restaurant_contract' | 'restaurant_licence',
        file: File | null,
      ) => (file === null ? null : uploadImage(purpose, file));
      const contractUploadId = await upload('restaurant_contract', save.form.contractFile);
      const licenceUploadId = await upload('restaurant_licence', save.form.licenceFile);
      if (
        (save.form.contractFile !== null && contractUploadId === null) ||
        (save.form.licenceFile !== null && licenceUploadId === null)
      ) {
        return { status: 'refused', refusal: 'upload_failed' };
      }
      const body: ContractBody = {
        signedOn: save.form.signedOn,
        durationMonths: Number(save.form.durationMonths.trim()),
        contractUploadId,
        licenceUploadId,
      };
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/contract', {
          params: { path },
          body,
        }),
      );
    }
    case 'confirm':
      return outcome(
        await api.POST('/v1/admin/restaurant-drafts/{restaurantId}/contract/confirm', {
          params: { path },
          body: { parityPledge: true },
        }),
      );
  }
}

// Saves a step; the draft it answers replaces the read, and the city's list
// of drafts is read again.
export function useSaveStep(restaurantId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (save: StepSave) => run(restaurantId, save),
    onSuccess: (result) => {
      if (result.status !== 'saved') return;
      queryClient.setQueryData(draftKey(restaurantId), result.draft);
      void queryClient.invalidateQueries({ queryKey: ['restaurant-drafts'] });
    },
  });
}

export type AccountsResult =
  { status: 'saved'; accounts: RestaurantAccount[] } | { status: 'refused'; refusal: string };

// Step 6: adds an account, or removes one by its id.
export function useAccountCommand(restaurantId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (
      command: { add: AccountBody } | { remove: string },
    ): Promise<AccountsResult> => {
      const answer =
        'add' in command
          ? await api.POST('/v1/admin/restaurants/{restaurantId}/accounts', {
              params: { path: { restaurantId } },
              body: command.add,
            })
          : await api.POST('/v1/admin/restaurants/{restaurantId}/accounts/{accountId}/remove', {
              params: { path: { restaurantId, accountId: command.remove } },
            });
      if (answer.data) return { status: 'saved', accounts: answer.data.accounts };
      const status = answer.response.status;
      if (status === 400 || status === 404 || status === 409) {
        const refusal = (answer.error as { error?: unknown } | undefined)?.error;
        return { status: 'refused', refusal: typeof refusal === 'string' ? refusal : 'invalid' };
      }
      throw new Error(`The account command failed (${status}).`);
    },
    onSuccess: (result) => {
      if (result.status === 'saved') {
        queryClient.setQueryData(accountsKey(restaurantId), result.accounts);
      }
    },
  });
}

export type { ImageRefusal };

// The map's style names the API host's /maps/ (written for the apps); the
// panel reads every map file from its own origin's /maps/, which nginx
// serves on every host, so the Content-Security-Policy's 'self' covers it.
// Every URL under the style's own /maps/ moves to `origin`.
export function localStyle<Style extends { glyphs?: string; sprite?: unknown; sources?: object }>(
  style: Style,
  origin: string,
): Style {
  const glyphs = style.glyphs ?? '';
  const at = glyphs.indexOf('/maps/');
  if (at < 0) return style;
  const base = glyphs.slice(0, at + '/maps'.length);
  const here = `${origin}/maps`;
  const swap = (value: unknown): unknown => {
    if (typeof value === 'string') return value.split(base).join(here);
    if (Array.isArray(value)) return value.map(swap);
    if (value !== null && typeof value === 'object') {
      return Object.fromEntries(Object.entries(value).map(([key, each]) => [key, swap(each)]));
    }
    return value;
  };
  return {
    ...style,
    glyphs: swap(style.glyphs),
    sprite: swap(style.sprite),
    sources: swap(style.sources),
  } as Style;
}
