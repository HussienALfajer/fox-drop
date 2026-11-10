import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import type { OrderDetail } from './order-detail.js';
import { responsibleKeys } from './order-detail.js';
import {
  type AddedLine,
  AFTER_PICKUP_PARTIES,
  type AfterPickupLine,
  afterPickupLines,
  type EditChange,
  type EditChoices,
  type EditForm,
  type EditPreview,
  type EditRefusal,
  editBody,
  editPreviewQuery,
  editRequest,
  initialForm,
  MAX_QUANTITY,
  needsExtraPrep,
  optionsFit,
  useEditOrder,
} from './order-edit.js';

const refusalKeys = {
  order_state_changed: 'order.edit.stateChanged',
  pickup_request_open: 'order.edit.pickupOpen',
  invalid_edit: 'order.edit.invalid',
} as const satisfies Record<EditRefusal, string>;

const sideKeys = [
  ['itemsValue', 'order.itemsValue'],
  ['deliveryFee', 'order.deliveryFee'],
  ['total', 'order.total'],
  ['commission', 'order.edit.commission'],
  ['merchantNet', 'order.edit.merchantNet'],
] as const;

// One change as the restaurant and the timeline name it.
export function EditChangeText({ change }: { change: EditChange }) {
  const { t } = useTranslation();
  const name = [change.name, ...change.options].join('، ');
  if (change.kind === 'added') {
    return <>{t('order.edit.added', { quantity: change.quantity, name })}</>;
  }
  if (change.kind === 'removed') {
    return <>{t('order.edit.removed', { quantity: change.quantity, name })}</>;
  }
  return (
    <>
      {t('order.edit.quantity', {
        name,
        before: change.quantityBefore ?? change.quantity,
        after: change.quantity,
      })}
    </>
  );
}

// AP §9.3.3 «تعديل الطلب» before the pickup: each line's quantity (0
// removes it), lines added from the restaurant's current menu with their
// options, a new delivery fee, the extra prep time when items are added to a
// ready order, operations' required note, and the before-and-after money
// preview before the confirm. After the pickup (slice 2.10b): only lowering
// quantities and the fee, the responsible party, and the entries it posts
// with the new amount to collect.
export function EditOrder({
  orderId,
  detail,
  choices,
  time,
}: {
  orderId: string;
  detail: OrderDetail;
  choices: EditChoices;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  const title = useId();
  const { lines, status, version } = detail;
  const currency = detail.money.currency;
  const [form, setForm] = useState<EditForm>(() => initialForm(lines));
  const { afterPickup } = choices;
  const request = editRequest(
    form,
    lines,
    status,
    currency,
    choices.extraPrepMaxMin,
    afterPickup ? { deliveryFee: detail.money.deliveryFee } : null,
  );
  const preview = useQuery(editPreviewQuery(orderId, version, request));
  const edit = useEditOrder(orderId);
  const body = editBody(request, form.reason, version);
  const shown = preview.data?.status === 'preview' ? preview.data.preview : null;
  const entryLines = shown && afterPickup ? afterPickupLines(shown) : [];
  const ready =
    body !== null &&
    shown !== null &&
    !preview.isPlaceholderData &&
    !preview.isFetching &&
    (!afterPickup ||
      (form.responsible !== null && !entryLines.some((line) => line.key === 'unknown')));
  const money = (amount: string) => formatMoney({ amount, currency });
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!ready || !body) return;
    edit.mutate(body, {
      onSuccess: (result) => {
        if (result.status === 'done') setForm(initialForm(lines));
      },
    });
  };
  const result = edit.data;
  const refusal =
    result?.status === 'refused'
      ? result.refusal
      : preview.data?.status === 'refused'
        ? preview.data.refusal
        : null;
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.edit.title')}</h3>
      {afterPickup && <p>{t('order.edit.afterPickupHint')}</p>}
      <fieldset>
        <legend>{t('order.edit.lines')}</legend>
        {lines.map((line) => (
          <p key={line.position}>
            <label>
              {[line.name, ...line.options.map((option) => option.name)].join('، ')}{' '}
              <input
                type="number"
                min={0}
                max={afterPickup ? line.quantity : MAX_QUANTITY}
                step={1}
                value={form.quantities[line.position] ?? line.quantity}
                onChange={(event) =>
                  setForm({
                    ...form,
                    quantities: { ...form.quantities, [line.position]: event.target.valueAsNumber },
                  })
                }
              />
            </label>{' '}
            <button
              type="button"
              onClick={() =>
                setForm({ ...form, quantities: { ...form.quantities, [line.position]: 0 } })
              }
            >
              {t('order.edit.remove')}
            </button>
          </p>
        ))}
        {!afterPickup && <p>{t('order.edit.optionsHint')}</p>}
      </fieldset>
      {!afterPickup && (
        <AddLine
          items={choices.items}
          currency={currency}
          onAdd={(line) => setForm({ ...form, added: [...form.added, line] })}
        />
      )}
      {form.added.length > 0 && (
        <ul>
          {form.added.map((line, index) => {
            const item = choices.items.find((entry) => entry.id === line.itemId);
            const options = item?.optionGroups
              .flatMap((group) => group.options)
              .filter((option) => line.optionIds.includes(option.id))
              .map((option) => option.name);
            return (
              <li key={index}>
                {t('order.edit.added', {
                  quantity: line.quantity,
                  name: [item?.name ?? '', ...(options ?? [])].join('، '),
                })}{' '}
                <button
                  type="button"
                  onClick={() =>
                    setForm({ ...form, added: form.added.filter((_, each) => each !== index) })
                  }
                >
                  {t('order.edit.remove')}
                </button>
              </li>
            );
          })}
        </ul>
      )}
      <label>
        {t(afterPickup ? 'order.edit.lowerFee' : 'order.edit.fee', {
          fee: money(detail.money.deliveryFee),
        })}
        <input
          inputMode="decimal"
          value={form.fee}
          onChange={(event) => setForm({ ...form, fee: event.target.value })}
        />
      </label>
      {needsExtraPrep(status, form, lines) && (
        <label>
          {t('order.edit.extraPrep', { max: choices.extraPrepMaxMin })}
          <input
            type="number"
            min={1}
            max={choices.extraPrepMaxMin}
            step={1}
            value={Number.isNaN(form.extraPrepMin) ? '' : form.extraPrepMin}
            onChange={(event) => setForm({ ...form, extraPrepMin: event.target.valueAsNumber })}
          />
        </label>
      )}
      {afterPickup && (
        <fieldset>
          <legend>{t('order.edit.responsible')}</legend>
          {AFTER_PICKUP_PARTIES.map((party) => (
            <label key={party}>
              <input
                type="radio"
                name="responsible"
                checked={form.responsible === party}
                onChange={() => setForm({ ...form, responsible: party })}
              />
              {t(responsibleKeys[party])}
            </label>
          ))}
        </fieldset>
      )}
      <label>
        {t('order.edit.note')}
        <textarea
          maxLength={500}
          value={form.reason}
          onChange={(event) => setForm({ ...form, reason: event.target.value })}
        />
      </label>
      {request === null && <p>{t('order.edit.incomplete')}</p>}
      {shown && <PreviewSection preview={shown} money={money} time={time} />}
      {shown && afterPickup && (
        <section aria-live="polite">
          <h4>{t('order.cancel.preview')}</h4>
          {form.responsible === null ? (
            <p>{t('order.cancel.pickResponsible')}</p>
          ) : (
            <ul>
              {entryLines.map((line, index) => (
                <li key={index}>
                  <EntryText line={line} />
                </li>
              ))}
            </ul>
          )}
          <p>{t('order.edit.newCollect', { amount: money(shown.after.total) })}</p>
        </section>
      )}
      <button type="submit" disabled={edit.isPending || !ready}>
        {t('order.edit.confirm')}
      </button>
      {(edit.isError || preview.isError) && <p role="alert">{t('common.failed')}</p>}
      {refusal && <p role="alert">{t(refusalKeys[refusal])}</p>}
      {result?.status === 'done' && <p role="status">{t('order.edit.done')}</p>}
    </form>
  );
}

function EntryText({ line }: { line: AfterPickupLine }) {
  const { t } = useTranslation();
  switch (line.key) {
    case 'merchantDebit':
      return (
        <>
          {t('order.edit.entry.merchantDebit', {
            name: line.name ?? '',
            amount: formatMoney(line.amount),
          })}
        </>
      );
    case 'commissionReversed':
      return <>{t('order.edit.entry.commissionReversed', { amount: formatMoney(line.amount) })}</>;
    case 'captainCharge':
      return (
        <>
          {t('order.edit.entry.captainCharge', {
            name: line.name ?? '',
            amount: formatMoney(line.amount),
          })}
        </>
      );
    case 'platformCost':
      return <>{t('order.cancel.entry.platformCost', { amount: formatMoney(line.amount) })}</>;
    default:
      return <>{t('order.cancel.entry.unknown')}</>;
  }
}

function PreviewSection({
  preview,
  money,
  time,
}: {
  preview: EditPreview;
  money: (amount: string) => string;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  return (
    <section aria-live="polite">
      <h4>{t('order.edit.preview')}</h4>
      <ul>
        {preview.changes.map((change, index) => (
          <li key={index}>
            <EditChangeText change={change} />
          </li>
        ))}
      </ul>
      <dl>
        {sideKeys.map(([field, key]) => (
          <div key={field}>
            <dt>{t(key)}</dt>
            <dd>
              {t('order.edit.beforeAfter', {
                before: money(preview.before[field]),
                after: money(preview.after[field]),
              })}
            </dd>
          </div>
        ))}
      </dl>
      {preview.addsItems && <p>{t('order.edit.mustAcknowledge')}</p>}
      {preview.backToPreparing && preview.promisedAt && (
        <p>{t('order.edit.backToPreparing', { time: time(preview.promisedAt) })}</p>
      )}
    </section>
  );
}

// A line from the menu: the item, its options within each group's limits,
// and the quantity.
function AddLine({
  items,
  currency,
  onAdd,
}: {
  items: EditChoices['items'];
  currency: string;
  onAdd: (line: AddedLine) => void;
}) {
  const { t } = useTranslation();
  const [itemId, setItemId] = useState('');
  const [optionIds, setOptionIds] = useState<string[]>([]);
  const [quantity, setQuantity] = useState(1);
  const item = items.find((entry) => entry.id === itemId);
  const fits =
    item !== undefined &&
    optionsFit(item, optionIds) &&
    Number.isInteger(quantity) &&
    quantity >= 1 &&
    quantity <= MAX_QUANTITY;
  return (
    <fieldset>
      <legend>{t('order.edit.add')}</legend>
      <label>
        {t('order.edit.item')}
        <select
          value={itemId}
          onChange={(event) => {
            setItemId(event.target.value);
            setOptionIds([]);
          }}
        >
          <option value="">{t('order.edit.pickItem')}</option>
          {items.map((entry) => (
            <option key={entry.id} value={entry.id}>
              {t('order.edit.menuItem', {
                category: entry.category,
                name: entry.name,
                price: formatMoney({ amount: entry.price, currency }),
              })}
            </option>
          ))}
        </select>
      </label>
      {item?.optionGroups.map((group) => (
        <fieldset key={group.id}>
          <legend>
            {t('order.edit.group', {
              name: group.name,
              min: group.minChoices,
              max: group.maxChoices,
            })}
          </legend>
          {group.options.map((option) => (
            <label key={option.id}>
              <input
                type="checkbox"
                checked={optionIds.includes(option.id)}
                onChange={(event) =>
                  setOptionIds(
                    event.target.checked
                      ? [...optionIds, option.id]
                      : optionIds.filter((id) => id !== option.id),
                  )
                }
              />
              {option.priceDelta === '0'
                ? option.name
                : t('order.edit.option', {
                    name: option.name,
                    price: formatMoney({ amount: option.priceDelta, currency }),
                  })}
            </label>
          ))}
        </fieldset>
      ))}
      <label>
        {t('order.edit.addQuantity')}
        <input
          type="number"
          min={1}
          max={MAX_QUANTITY}
          step={1}
          value={Number.isNaN(quantity) ? '' : quantity}
          onChange={(event) => setQuantity(event.target.valueAsNumber)}
        />
      </label>
      <button
        type="button"
        disabled={!fits}
        onClick={() => {
          onAdd({ itemId, optionIds, quantity });
          setItemId('');
          setOptionIds([]);
          setQuantity(1);
        }}
      >
        {t('order.edit.addConfirm')}
      </button>
    </fieldset>
  );
}
