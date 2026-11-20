import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { decimalOf } from './format.js';
import {
  type Menu,
  type MenuCategory,
  type MenuCommand,
  type MenuGroup,
  type MenuItem,
  type SwitchedOff,
  type Availability,
  groupBodyOf,
  groupFormOf,
  type GroupForm,
  pendingOf,
  photoRefusal,
  priceOf,
  refusalKey,
  timeOfMinute,
  usePhotoUpload,
  useAvailability,
  useMenuCommand,
  windowOf,
} from './menu.js';

// RA §9.2–9.5 (slice 2.45b): the owner's menu forms in the portal. Each
// sends one command and closes on its answer; a refusal is explained.
// Unstyled until the design.

type Run = (command: MenuCommand) => Promise<boolean>;

// Sends a command; true once the server took it. The message of a refusal
// (or a failure) shows under the form.
export function useRun(request = false, onRefused?: (refusal: string) => void) {
  const command = useMenuCommand();
  const [problem, setProblem] = useState<string | null>(null);
  const run: Run = async (next) => {
    setProblem(null);
    try {
      const answer = await command.mutateAsync(next);
      if (answer.status === 'done') return true;
      onRefused?.(answer.refusal);
      setProblem(refusalKey(answer.refusal, request));
    } catch {
      setProblem('saveFailed');
    }
    return false;
  };
  return { run, pending: command.isPending, problem };
}

export function Problem({ problem }: { problem: string | null }) {
  const { t } = useTranslation();
  return problem === null ? null : (
    <p role="alert">{t(`menu.refusal.${problem}` as 'menu.refusal.saveFailed')}</p>
  );
}

// RA §9.3: a row's own switch: on, or off «حتى الغد» (the default, first)
// or «حتى أعيده».
export function AvailabilityControl(props: {
  type: Availability['type'];
  id: string;
  switchedOff: SwitchedOff;
}) {
  const { t } = useTranslation();
  const availability = useAvailability();
  const [problem, setProblem] = useState<string | null>(null);
  function change(next: Availability) {
    setProblem(null);
    availability
      .mutateAsync(next)
      .then((answer) => setProblem(answer.status === 'done' ? null : refusalKey(answer.refusal)))
      .catch(() => setProblem('saveFailed'));
  }
  const { type, id } = props;
  return (
    <span>
      {props.switchedOff === null ? (
        <>
          <button
            type="button"
            disabled={availability.isPending}
            onClick={() => change({ type, id, available: false, until: 'tomorrow' })}
          >
            {t('menu.offTomorrow')}
          </button>{' '}
          <button
            type="button"
            disabled={availability.isPending}
            onClick={() => change({ type, id, available: false, until: 'turned_back_on' })}
          >
            {t('menu.offUntilBack')}
          </button>
        </>
      ) : (
        <button
          type="button"
          disabled={availability.isPending}
          onClick={() => change({ type, id, available: true })}
        >
          {t('menu.turnOn')}
        </button>
      )}
      <Problem problem={problem} />
    </span>
  );
}

// RA §9.4: an item's price (above 0) or an option's delta (0 or more), with
// the parity reminder.
export function PriceForm(props: {
  target: { kind: 'item'; itemId: string } | { kind: 'option'; optionId: string };
  price: { amount: string; currency: string };
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const { run, pending, problem } = useRun();
  const [typed, setTyped] = useState<string>(decimalOf(props.price.amount, props.price.currency));
  const [invalid, setInvalid] = useState(false);
  const option = props.target.kind === 'option';

  async function submit(event: FormEvent) {
    event.preventDefault();
    const amount = priceOf(typed, props.price.currency, option);
    setInvalid(amount === null);
    if (amount === null) return;
    const currency = props.price.currency;
    const done = await run(
      props.target.kind === 'item'
        ? { kind: 'item_price', itemId: props.target.itemId, amount, currency }
        : { kind: 'option_price', optionId: props.target.optionId, amount, currency },
    );
    if (done) props.onDone();
  }

  return (
    <form onSubmit={(event) => void submit(event)}>
      <p>{t('menu.parityReminder')}</p>
      <label>
        {t(option ? 'menu.priceDelta' : 'menu.price')}
        <input inputMode="decimal" value={typed} onChange={(e) => setTyped(e.target.value)} />
      </label>
      {invalid && <p role="alert">{t('menu.refusal.invalidPrice')}</p>}
      <Problem problem={problem} />
      <button type="submit" disabled={pending}>
        {t('menu.save')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}

// RA §9.1: a category's daily window on the city's clock, or all day.
export function WindowForm(props: { category: MenuCategory; onDone: () => void }) {
  const { t } = useTranslation();
  const { run, pending, problem } = useRun();
  const window = props.category.window;
  const [from, setFrom] = useState(window ? timeOfMinute(window.startsAt) : '');
  const [to, setTo] = useState(window ? timeOfMinute(window.endsAt) : '');
  const [invalid, setInvalid] = useState(false);

  async function save(next: { startsAt: number; endsAt: number } | null) {
    const done = await run({
      kind: 'category_window',
      categoryId: props.category.id,
      window: next,
    });
    if (done) props.onDone();
  }

  function submit(event: FormEvent) {
    event.preventDefault();
    const next = windowOf(from, to);
    setInvalid(next === null);
    if (next) void save(next);
  }

  return (
    <form onSubmit={submit}>
      <label>
        {t('menu.windowFrom')}
        <input type="time" required value={from} onChange={(e) => setFrom(e.target.value)} />
      </label>
      <label>
        {t('menu.windowTo')}
        <input type="time" required value={to} onChange={(e) => setTo(e.target.value)} />
      </label>
      {invalid && <p role="alert">{t('menu.invalidWindow')}</p>}
      <Problem problem={problem} />
      <button type="submit" disabled={pending}>
        {t('menu.save')}
      </button>{' '}
      <button type="button" disabled={pending} onClick={() => void save(null)}>
        {t('menu.windowClear')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}

// RA §9.2: a new category, or a category's new name, sent for review.
export function CategoryForm(props: { category: MenuCategory | null; onDone: () => void }) {
  const { t } = useTranslation();
  const { run, pending, problem } = useRun(true);
  const [id] = useState(() => props.category?.id ?? crypto.randomUUID());
  const [name, setName] = useState(
    props.category === null
      ? ''
      : (pendingOf(props.category.pending, 'rename')?.name ?? props.category.name),
  );

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (await run({ kind: 'request_category', categoryId: id, name: name.trim() })) props.onDone();
  }

  return (
    <form onSubmit={(event) => void submit(event)}>
      <p>{t('menu.reviewNote')}</p>
      <label>
        {t('menu.name')}
        <input required value={name} onChange={(e) => setName(e.target.value)} />
      </label>
      <Problem problem={problem} />
      <button type="submit" disabled={pending}>
        {t('menu.sendForReview')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}

function PhotoInput(props: { onChange: (file: File | null) => void; refused: string | null }) {
  const { t } = useTranslation();
  return (
    <>
      <label>
        {t('menu.choosePhoto')}
        <input
          type="file"
          accept="image/jpeg,image/png,image/webp"
          onChange={(e) => props.onChange(e.target.files?.[0] ?? null)}
        />
      </label>
      {props.refused !== null && (
        <p role="alert">{t(`menu.photoRefused.${props.refused}` as 'menu.photoRefused.type')}</p>
      )}
    </>
  );
}

// The chosen photo's upload id, null for none chosen, or 'failed'.
async function uploadOf(
  upload: (file: File) => Promise<string | null>,
  file: File | null,
): Promise<string | null | 'failed'> {
  if (file === null) return null;
  try {
    return (await upload(file)) ?? 'failed';
  } catch {
    return 'failed';
  }
}

// RA §9.2, §9.5: a new item (its price is part of the request), or the
// request of one not yet approved.
export function NewItemForm(props: {
  menu: Menu;
  item: MenuItem | null;
  categoryId: string | null;
  currency: string;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const photos = usePhotoUpload();
  const [file, setFile] = useState<File | null>(null);
  const { run, pending, problem } = useRun(true, (refusal) => {
    if (file) photos.refused(file, refusal);
  });
  const [id] = useState(() => props.item?.id ?? crypto.randomUUID());
  const [categoryId, setCategoryId] = useState(
    props.categoryId ?? props.menu.categories[0]?.id ?? '',
  );
  const [name, setName] = useState(props.item?.name ?? '');
  const [description, setDescription] = useState(props.item?.description ?? '');
  const [price, setPrice] = useState(
    props.item ? decimalOf(props.item.price.amount, props.item.price.currency) : '',
  );
  const [refused, setRefused] = useState<string | null>(null);
  const [invalidPrice, setInvalidPrice] = useState(false);

  function choose(chosen: File | null) {
    setRefused(chosen === null ? null : photoRefusal(chosen));
    setFile(chosen !== null && photoRefusal(chosen) === null ? chosen : null);
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    const amount = priceOf(price, props.currency, false);
    setInvalidPrice(amount === null);
    if (amount === null || categoryId === '') return;
    const uploadId = await uploadOf(photos.upload.mutateAsync, file);
    if (uploadId === 'failed') {
      setRefused('failed');
      return;
    }
    const trimmed = description.trim();
    const done = await run({
      kind: 'request_item',
      itemId: id,
      categoryId,
      name: name.trim(),
      description: trimmed === '' ? null : trimmed,
      amount,
      currency: props.currency,
      uploadId,
    });
    if (done) props.onDone();
  }

  return (
    <form onSubmit={(event) => void submit(event)}>
      <p>{t('menu.reviewNote')}</p>
      <label>
        {t('menu.category')}
        <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)}>
          {props.menu.categories.map((category) => (
            <option key={category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('menu.name')}
        <input required value={name} onChange={(e) => setName(e.target.value)} />
      </label>
      <label>
        {t('menu.description')}
        <textarea value={description} onChange={(e) => setDescription(e.target.value)} />
      </label>
      <p>{t('menu.parityReminder')}</p>
      <label>
        {t('menu.price')}
        <input
          inputMode="decimal"
          required
          value={price}
          onChange={(e) => setPrice(e.target.value)}
        />
      </label>
      {invalidPrice && <p role="alert">{t('menu.refusal.invalidPrice')}</p>}
      <PhotoInput onChange={choose} refused={refused} />
      <Problem problem={problem} />
      <button type="submit" disabled={pending || photos.upload.isPending}>
        {t('menu.sendForReview')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}

// RA §9.2: a published item's name and description, sent for review; each
// field starts from its pending value.
export function TextForm(props: { item: MenuItem; onDone: () => void }) {
  const { t } = useTranslation();
  const { run, pending, problem } = useRun(true);
  const asked = pendingOf(props.item.pending, 'description');
  const [name, setName] = useState(
    pendingOf(props.item.pending, 'rename')?.name ?? props.item.name,
  );
  const [description, setDescription] = useState(
    (asked ? asked.description : props.item.description) ?? '',
  );

  async function submit(event: FormEvent) {
    event.preventDefault();
    const trimmed = description.trim();
    const done = await run({
      kind: 'request_text',
      itemId: props.item.id,
      name: name.trim(),
      description: trimmed === '' ? null : trimmed,
    });
    if (done) props.onDone();
  }

  return (
    <form onSubmit={(event) => void submit(event)}>
      <p>{t('menu.reviewNote')}</p>
      <label>
        {t('menu.name')}
        <input required value={name} onChange={(e) => setName(e.target.value)} />
      </label>
      <label>
        {t('menu.description')}
        <textarea value={description} onChange={(e) => setDescription(e.target.value)} />
      </label>
      <Problem problem={problem} />
      <button type="submit" disabled={pending}>
        {t('menu.sendForReview')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}

// RA §9.2: a new or replaced photo; the old one stays until approved.
export function PhotoForm(props: { item: MenuItem; onDone: () => void }) {
  const { t } = useTranslation();
  const photos = usePhotoUpload();
  const [file, setFile] = useState<File | null>(null);
  const { run, pending, problem } = useRun(true, (refusal) => {
    if (file) photos.refused(file, refusal);
  });
  const [refused, setRefused] = useState<string | null>(null);
  const uploading = photos.upload.isPending;

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (file === null) return;
    const uploadId = await uploadOf(photos.upload.mutateAsync, file);
    if (uploadId === 'failed' || uploadId === null) {
      setRefused('failed');
      return;
    }
    if (await run({ kind: 'request_photo', itemId: props.item.id, uploadId })) props.onDone();
  }

  return (
    <form onSubmit={(event) => void submit(event)}>
      <p>{t('menu.reviewNote')}</p>
      <PhotoInput
        refused={refused}
        onChange={(chosen) => {
          const refusal = chosen === null ? null : photoRefusal(chosen);
          setRefused(refusal);
          setFile(refusal === null ? chosen : null);
        }}
      />
      <Problem problem={problem} />
      <button type="submit" disabled={pending || uploading || file === null}>
        {t('menu.sendForReview')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}

// RA §9.2: a new option group, or a group's name, choices, items and new
// options, sent for review. A published option's delta changes through
// «تعديل السعر» only, so it is shown read only here.
export function GroupForm(props: {
  menu: Menu;
  group: MenuGroup | null;
  currency: string;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const { run, pending, problem } = useRun(true);
  const [id] = useState(() => props.group?.id ?? crypto.randomUUID());
  const [form, setForm] = useState<GroupForm>(() => groupFormOf(props.group));
  const [invalid, setInvalid] = useState(false);
  const items = props.menu.categories.flatMap((category) => category.items);
  const set = (change: Partial<GroupForm>) => setForm({ ...form, ...change });

  async function submit(event: FormEvent) {
    event.preventDefault();
    const body = groupBodyOf(form, props.currency);
    setInvalid(body === null);
    if (body && (await run({ kind: 'request_group', groupId: id, body }))) props.onDone();
  }

  return (
    <form onSubmit={(event) => void submit(event)}>
      <p>{t('menu.reviewNote')}</p>
      <label>
        {t('menu.name')}
        <input required value={form.name} onChange={(e) => set({ name: e.target.value })} />
      </label>
      <label>
        {t('menu.minChoices')}
        <input
          type="number"
          min={0}
          max={50}
          value={form.minChoices}
          onChange={(e) => set({ minChoices: e.target.value })}
        />
      </label>
      <label>
        {t('menu.maxChoices')}
        <input
          type="number"
          min={1}
          max={50}
          value={form.maxChoices}
          onChange={(e) => set({ maxChoices: e.target.value })}
        />
      </label>
      <fieldset>
        <legend>{t('menu.groupItems')}</legend>
        {items.map((item) => (
          <label key={item.id}>
            <input
              type="checkbox"
              checked={form.itemIds.includes(item.id)}
              onChange={(e) =>
                set({
                  itemIds: e.target.checked
                    ? [...form.itemIds, item.id]
                    : form.itemIds.filter((each) => each !== item.id),
                })
              }
            />
            {item.name}
          </label>
        ))}
      </fieldset>
      <fieldset>
        <legend>{t('menu.options')}</legend>
        {form.options.map((option, index) => (
          <p key={option.id}>
            <label>
              {t('menu.optionName')}
              <input
                required
                value={option.name}
                onChange={(e) =>
                  set({
                    options: form.options.map((each, at) =>
                      at === index ? { ...each, name: e.target.value } : each,
                    ),
                  })
                }
              />
            </label>
            <label>
              {t('menu.priceDelta')}
              <input
                inputMode="decimal"
                readOnly={option.published}
                value={option.delta}
                onChange={(e) =>
                  set({
                    options: form.options.map((each, at) =>
                      at === index ? { ...each, delta: e.target.value } : each,
                    ),
                  })
                }
              />
            </label>
          </p>
        ))}
        <button
          type="button"
          onClick={() =>
            set({
              options: [
                ...form.options,
                { id: crypto.randomUUID(), name: '', delta: '0', published: false },
              ],
            })
          }
        >
          {t('menu.addOption')}
        </button>
      </fieldset>
      {invalid && <p role="alert">{t('menu.refusal.requestInvalid')}</p>}
      <Problem problem={problem} />
      <button type="submit" disabled={pending}>
        {t('menu.sendForReview')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
    </form>
  );
}
