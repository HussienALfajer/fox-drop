import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { CommandStatus } from './restaurant-menu-status.js';
import {
  groupBody,
  type GroupForm,
  groupFormOf,
  type GroupOption,
  type Menu,
  moved,
  type OptionForm,
  optionBody,
  optionFormOf,
  type OptionGroup,
  toggled,
  useMenuCommand,
} from './restaurant-menu.js';

// AP §9.6.6 «مجموعات الخيارات» and «الإضافات» (slice 2.31): each group with
// its choices, its options with their price deltas and switches, and the
// items it is linked to, chosen many at once. Unstyled until the design.
export function OptionGroupsSection(props: {
  restaurantId: string;
  menu: Menu;
  currency: string | null;
  editable: boolean;
}) {
  const { t } = useTranslation();
  const [adding, setAdding] = useState<string | null>(null);
  return (
    <section aria-label={t('menu.groups.title')}>
      <h3>{t('menu.groups.title')}</h3>
      <p>{t('menu.groups.explain')}</p>
      {props.menu.optionGroups.length === 0 && <p>{t('menu.groups.none')}</p>}
      {props.menu.optionGroups.map((group) => (
        <GroupSection
          key={group.id}
          restaurantId={props.restaurantId}
          menu={props.menu}
          group={group}
          currency={props.currency}
          editable={props.editable}
        />
      ))}
      {props.editable &&
        (adding === null ? (
          <button type="button" onClick={() => setAdding(crypto.randomUUID())}>
            {t('menu.groups.add')}
          </button>
        ) : (
          <GroupEditor
            key={adding}
            restaurantId={props.restaurantId}
            groupId={adding}
            group={null}
            nameMax={props.menu.nameMax}
            onDone={() => setAdding(null)}
          />
        ))}
    </section>
  );
}

function GroupSection(props: {
  restaurantId: string;
  menu: Menu;
  group: OptionGroup;
  currency: string | null;
  editable: boolean;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [editing, setEditing] = useState(false);
  const [linking, setLinking] = useState(false);
  const [adding, setAdding] = useState<string | null>(null);
  const { group } = props;
  const optionIds = group.options.map((option) => option.id);
  const items = props.menu.categories.flatMap((category) => category.items);
  return (
    <section aria-label={group.name}>
      <h4>{group.name}</h4>
      <p>
        {group.minChoices === 0
          ? t('menu.groups.addOns', { max: group.maxChoices })
          : t('menu.groups.required', { min: group.minChoices, max: group.maxChoices })}
      </p>
      <p>
        {group.itemIds.length === 0
          ? t('menu.groups.noItems')
          : t('menu.groups.items', {
              names: group.itemIds
                .map((id) => items.find((item) => item.id === id)?.name ?? '')
                .join('، '),
            })}
      </p>
      {props.editable && (
        <p>
          <button type="button" onClick={() => setEditing(!editing)}>
            {t('menu.groups.edit')}
          </button>{' '}
          <button type="button" onClick={() => setLinking(!linking)}>
            {t('menu.groups.link')}
          </button>
        </p>
      )}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
      {editing && (
        <GroupEditor
          restaurantId={props.restaurantId}
          groupId={group.id}
          group={group}
          nameMax={props.menu.nameMax}
          onDone={() => setEditing(false)}
        />
      )}
      {linking && (
        <LinkItems
          restaurantId={props.restaurantId}
          menu={props.menu}
          group={group}
          onDone={() => setLinking(false)}
        />
      )}
      {group.options.length === 0 ? (
        <p>{t('menu.groups.noOptions')}</p>
      ) : (
        <ul>
          {group.options.map((option) => (
            <OptionRow
              key={option.id}
              restaurantId={props.restaurantId}
              menu={props.menu}
              group={group}
              option={option}
              currency={props.currency}
              editable={props.editable}
              onMove={(step) =>
                command.mutate({
                  kind: 'optionOrder',
                  groupId: group.id,
                  optionIds: moved(optionIds, option.id, step),
                })
              }
            />
          ))}
        </ul>
      )}
      {props.editable &&
        props.currency !== null &&
        !props.menu.pricesLocked &&
        (adding === null ? (
          <button type="button" onClick={() => setAdding(crypto.randomUUID())}>
            {t('menu.groups.addOption')}
          </button>
        ) : (
          <OptionEditor
            key={adding}
            restaurantId={props.restaurantId}
            menu={props.menu}
            groupId={group.id}
            optionId={adding}
            option={null}
            currency={props.currency}
            onDone={() => setAdding(null)}
          />
        ))}
    </section>
  );
}

function OptionRow(props: {
  restaurantId: string;
  menu: Menu;
  group: OptionGroup;
  option: GroupOption;
  currency: string | null;
  editable: boolean;
  onMove: (step: -1 | 1) => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [editing, setEditing] = useState(false);
  const { option } = props;
  const free = /^0+$/.test(option.priceDelta.amount);
  return (
    <li>
      <p>
        {free
          ? t('menu.groups.optionFree', { name: option.name })
          : t('menu.groups.optionLine', {
              name: option.name,
              delta: formatMoney(option.priceDelta),
            })}
        {option.switchedOff !== null && ` · ${t('menu.off')}`}
      </p>
      {props.editable && (
        <p>
          <button type="button" onClick={() => props.onMove(-1)}>
            {t('menu.up')}
          </button>{' '}
          <button type="button" onClick={() => props.onMove(1)}>
            {t('menu.down')}
          </button>{' '}
          <button type="button" onClick={() => setEditing(!editing)}>
            {t('menu.groups.editOption')}
          </button>{' '}
          <button
            type="button"
            disabled={command.isPending}
            onClick={() =>
              command.mutate({
                kind: 'availability',
                type: 'option',
                id: option.id,
                available: option.switchedOff !== null,
              })
            }
          >
            {option.switchedOff === null ? t('menu.switchOff') : t('menu.switchOn')}
          </button>{' '}
          <button
            type="button"
            disabled={command.isPending}
            onClick={() =>
              command.mutate({
                kind: 'option',
                groupId: props.group.id,
                id: option.id,
                body: {
                  name: option.name,
                  priceDelta: option.priceDelta,
                  removed: true,
                },
              })
            }
          >
            {t('menu.groups.removeOption')}
          </button>
        </p>
      )}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
      {editing && props.currency !== null && (
        <OptionEditor
          restaurantId={props.restaurantId}
          menu={props.menu}
          groupId={props.group.id}
          optionId={option.id}
          option={option}
          currency={props.currency}
          onDone={() => setEditing(false)}
        />
      )}
    </li>
  );
}

function GroupEditor(props: {
  restaurantId: string;
  groupId: string;
  group: OptionGroup | null;
  nameMax: number;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [form, setForm] = useState<GroupForm>(groupFormOf(props.group));
  const [problem, setProblem] = useState<string | null>(null);
  const change = (next: Partial<GroupForm>) => setForm({ ...form, ...next });
  const save = (event: FormEvent) => {
    event.preventDefault();
    const body = groupBody(form, props.nameMax);
    if ('problem' in body) return setProblem(body.problem);
    setProblem(null);
    command.mutate(
      { kind: 'group', id: props.groupId, body },
      { onSuccess: (result) => result.status === 'saved' && props.onDone() },
    );
  };
  return (
    <form onSubmit={save} aria-label={t('menu.groups.form')}>
      <label>
        {t('menu.groups.name')}
        <input value={form.name} onChange={(event) => change({ name: event.target.value })} />
      </label>
      <label>
        {t('menu.groups.min')}
        <input
          inputMode="numeric"
          value={form.minChoices}
          onChange={(event) => change({ minChoices: event.target.value })}
        />
      </label>
      <label>
        {t('menu.groups.max')}
        <input
          inputMode="numeric"
          value={form.maxChoices}
          onChange={(event) => change({ maxChoices: event.target.value })}
        />
      </label>
      <button type="submit" disabled={command.isPending}>
        {t('drafts.save')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
      {problem !== null && (
        <p role="alert">{t(`menu.problem.${problem}` as 'menu.problem.name')}</p>
      )}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
    </form>
  );
}

function OptionEditor(props: {
  restaurantId: string;
  menu: Menu;
  groupId: string;
  optionId: string;
  option: GroupOption | null;
  currency: string;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [form, setForm] = useState<OptionForm>(optionFormOf(props.option));
  const [problem, setProblem] = useState<string | null>(null);
  const change = (next: Partial<OptionForm>) => setForm({ ...form, ...next });
  const save = (event: FormEvent) => {
    event.preventDefault();
    const body = optionBody(form, props.currency, props.menu.nameMax);
    if ('problem' in body) return setProblem(body.problem);
    setProblem(null);
    command.mutate(
      { kind: 'option', groupId: props.groupId, id: props.optionId, body },
      { onSuccess: (result) => result.status === 'saved' && props.onDone() },
    );
  };
  return (
    <form onSubmit={save} aria-label={t('menu.groups.optionForm')}>
      <label>
        {t('menu.groups.optionName')}
        <input value={form.name} onChange={(event) => change({ name: event.target.value })} />
      </label>
      <label>
        {t('menu.groups.delta', { currency: props.currency })}
        <input
          inputMode="decimal"
          value={form.delta}
          readOnly={props.menu.pricesLocked}
          onChange={(event) => change({ delta: event.target.value })}
        />
      </label>
      <button type="submit" disabled={command.isPending}>
        {t('drafts.save')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
      {problem !== null && (
        <p role="alert">{t(`menu.problem.${problem}` as 'menu.problem.name')}</p>
      )}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
    </form>
  );
}

// «ربط بعدة أصناف»: every item of the menu, ticked when linked.
function LinkItems(props: {
  restaurantId: string;
  menu: Menu;
  group: OptionGroup;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [itemIds, setItemIds] = useState<string[]>(props.group.itemIds);
  const save = (event: FormEvent) => {
    event.preventDefault();
    command.mutate(
      { kind: 'groupItems', groupId: props.group.id, itemIds },
      { onSuccess: (result) => result.status === 'saved' && props.onDone() },
    );
  };
  return (
    <form onSubmit={save} aria-label={t('menu.groups.link')}>
      {props.menu.categories.map((category) => (
        <fieldset key={category.id}>
          <legend>{category.name}</legend>
          {category.items.map((item) => (
            <label key={item.id}>
              <input
                type="checkbox"
                checked={itemIds.includes(item.id)}
                onChange={(event) => setItemIds(toggled(itemIds, item.id, event.target.checked))}
              />
              {item.name}
            </label>
          ))}
        </fieldset>
      ))}
      <button type="submit" disabled={command.isPending}>
        {t('drafts.save')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('menu.cancel')}
      </button>
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
    </form>
  );
}
