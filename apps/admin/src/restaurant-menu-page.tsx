import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { timeOf } from './peak-bonus.js';
import { ImageField } from './restaurant-images-page.js';
import { MenuImportSection } from './restaurant-menu-import-page.js';
import {
  BulkAvailabilitySection,
  BulkPriceSection,
  PriceLogSection,
} from './restaurant-menu-bulk-page.js';
import { CommandStatus } from './restaurant-menu-status.js';
import { OptionGroupsSection } from './restaurant-option-groups-page.js';
import {
  BADGES,
  type Badge,
  canEditMenu,
  categoryBody,
  type CategoryForm,
  categoryFormOf,
  itemBody,
  type ItemForm,
  itemFormOf,
  type Menu,
  type MenuCategory,
  type MenuItem,
  menuQuery,
  moved,
  toggled,
  useMenuCommand,
} from './restaurant-menu.js';
import type { AdminSession } from './session.js';

// «القائمة» (AP §9.6.3, §9.6.6): the wizard's step 7 (slice 2.30b) and the
// profile's tab past it (slice 2.31): categories and items in order, each
// edited in place, then the option groups. Up and down stand for the drag
// until the design. Past test mode the prices are read only without
// `menus.edit_prices` (`pricesLocked`). Unstyled until the design.
export function MenuStep(props: {
  restaurantId: string;
  currency: string | null;
  timeZone: string;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const menu = useQuery(menuQuery(props.restaurantId));
  const command = useMenuCommand(props.restaurantId);
  const [adding, setAdding] = useState<string | null>(null);
  if (menu.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!menu.data) return <p role="status">{t('status.loading')}</p>;
  const editable = menu.data.editable && canEditMenu(props.session);
  const categoryIds = menu.data.categories.map((category) => category.id);
  return (
    <section aria-label={t('drafts.step.menu')}>
      <p>{t('menu.explain')}</p>
      {!menu.data.editable && <p>{t('menu.locked')}</p>}
      {menu.data.editable && menu.data.pricesLocked && <p>{t('menu.pricesLocked')}</p>}
      {props.currency === null && <p role="alert">{t('drafts.problem.no_base')}</p>}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
      {menu.data.categories.length === 0 && <p>{t('menu.none')}</p>}
      {menu.data.categories.map((category) => (
        <CategorySection
          key={category.id}
          restaurantId={props.restaurantId}
          menu={menu.data}
          category={category}
          currency={props.currency}
          editable={editable}
          photos={canEditMenu(props.session)}
          busy={command.isPending}
          onMove={(step) =>
            command.mutate({
              kind: 'categoryOrder',
              categoryIds: moved(categoryIds, category.id, step),
            })
          }
        />
      ))}
      {editable &&
        (adding === null ? (
          <button type="button" onClick={() => setAdding(crypto.randomUUID())}>
            {t('menu.addCategory')}
          </button>
        ) : (
          <CategoryEditor
            key={adding}
            restaurantId={props.restaurantId}
            categoryId={adding}
            category={null}
            nameMax={menu.data.nameMax}
            onDone={() => setAdding(null)}
          />
        ))}
      <OptionGroupsSection
        restaurantId={props.restaurantId}
        menu={menu.data}
        currency={props.currency}
        editable={editable}
      />
      {editable && menu.data.categories.length > 0 && (
        <>
          {props.currency !== null && !menu.data.pricesLocked && (
            <BulkPriceSection
              restaurantId={props.restaurantId}
              menu={menu.data}
              currency={props.currency}
            />
          )}
          <BulkAvailabilitySection restaurantId={props.restaurantId} menu={menu.data} />
        </>
      )}
      {editable && props.currency !== null && (
        <MenuImportSection restaurantId={props.restaurantId} currency={props.currency} />
      )}
      <PriceLogSection restaurantId={props.restaurantId} timeZone={props.timeZone} />
    </section>
  );
}

function CategorySection(props: {
  restaurantId: string;
  menu: Menu;
  category: MenuCategory;
  currency: string | null;
  editable: boolean;
  // «الصور» (slice 2.5): the photos stay editable past test mode.
  photos: boolean;
  busy: boolean;
  onMove: (step: -1 | 1) => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [editing, setEditing] = useState(false);
  const [adding, setAdding] = useState<string | null>(null);
  const { category } = props;
  const itemIds = category.items.map((item) => item.id);
  return (
    <section aria-label={category.name}>
      <h3>{category.name}</h3>
      <p>
        {category.window === null
          ? t('menu.allDay')
          : t('menu.window', {
              from: timeOf(category.window.startsAt),
              to: timeOf(category.window.endsAt % 1440),
            })}
        {category.hidden && ` · ${t('menu.hidden')}`}
        {category.switchedOff !== null && ` · ${t('menu.off')}`}
      </p>
      {props.editable && (
        <p>
          <button type="button" onClick={() => props.onMove(-1)} disabled={props.busy}>
            {t('menu.up')}
          </button>{' '}
          <button type="button" onClick={() => props.onMove(1)} disabled={props.busy}>
            {t('menu.down')}
          </button>{' '}
          <button type="button" onClick={() => setEditing(!editing)}>
            {t('menu.editCategory')}
          </button>{' '}
          <button
            type="button"
            disabled={command.isPending}
            onClick={() =>
              command.mutate({
                kind: 'availability',
                type: 'category',
                id: category.id,
                available: category.switchedOff !== null,
              })
            }
          >
            {category.switchedOff === null ? t('menu.switchOff') : t('menu.switchOn')}
          </button>
        </p>
      )}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
      {editing && (
        <CategoryEditor
          restaurantId={props.restaurantId}
          categoryId={category.id}
          category={category}
          nameMax={props.menu.nameMax}
          onDone={() => setEditing(false)}
        />
      )}
      {category.items.length === 0 ? (
        <p>{t('menu.noItems')}</p>
      ) : (
        <ul>
          {category.items.map((item) => (
            <ItemRow
              key={item.id}
              restaurantId={props.restaurantId}
              menu={props.menu}
              categoryId={category.id}
              item={item}
              currency={props.currency}
              editable={props.editable}
              photos={props.photos}
              onMove={(step) =>
                command.mutate({
                  kind: 'itemOrder',
                  categoryId: category.id,
                  itemIds: moved(itemIds, item.id, step),
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
            {t('menu.addItem')}
          </button>
        ) : (
          <ItemEditor
            key={adding}
            restaurantId={props.restaurantId}
            menu={props.menu}
            itemId={adding}
            item={null}
            categoryId={category.id}
            currency={props.currency}
            onDone={() => setAdding(null)}
          />
        ))}
    </section>
  );
}

function ItemRow(props: {
  restaurantId: string;
  menu: Menu;
  categoryId: string;
  item: MenuItem;
  currency: string | null;
  editable: boolean;
  photos: boolean;
  onMove: (step: -1 | 1) => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [editing, setEditing] = useState(false);
  const { item } = props;
  return (
    <li>
      <p>
        {t('menu.itemLine', { code: item.code, name: item.name, price: formatMoney(item.price) })}
        {item.badge !== null && ` · ${t(`menu.badge.${item.badge}`)}`}
        {item.hidden && ` · ${t('menu.hidden')}`}
        {item.switchedOff !== null && ` · ${t('menu.off')}`}
      </p>
      {item.description !== null && <p>{item.description}</p>}
      {item.optionGroupIds.length > 0 && (
        <p>
          {t('menu.groups.list', {
            names: item.optionGroupIds
              .map((id) => props.menu.optionGroups.find((group) => group.id === id)?.name ?? '')
              .join('، '),
          })}
        </p>
      )}
      <ImageField
        label={t('menu.photo', { name: item.name })}
        imageKey={item.photoKey}
        width={160}
        target={{ kind: 'item', restaurantId: props.restaurantId, itemId: item.id }}
        editable={props.photos}
      />
      {props.editable && (
        <p>
          <button type="button" onClick={() => props.onMove(-1)}>
            {t('menu.up')}
          </button>{' '}
          <button type="button" onClick={() => props.onMove(1)}>
            {t('menu.down')}
          </button>{' '}
          <button type="button" onClick={() => setEditing(!editing)}>
            {t('menu.editItem')}
          </button>{' '}
          <button
            type="button"
            disabled={command.isPending}
            onClick={() =>
              command.mutate({
                kind: 'availability',
                type: 'item',
                id: item.id,
                available: item.switchedOff !== null,
              })
            }
          >
            {item.switchedOff === null ? t('menu.switchOff') : t('menu.switchOn')}
          </button>
        </p>
      )}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
      {editing && props.currency !== null && (
        <ItemEditor
          restaurantId={props.restaurantId}
          menu={props.menu}
          itemId={item.id}
          item={item}
          categoryId={props.categoryId}
          currency={props.currency}
          onDone={() => setEditing(false)}
        />
      )}
    </li>
  );
}

function CategoryEditor(props: {
  restaurantId: string;
  categoryId: string;
  category: MenuCategory | null;
  nameMax: number;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [form, setForm] = useState<CategoryForm>(categoryFormOf(props.category));
  const [problem, setProblem] = useState<string | null>(null);
  const change = (next: Partial<CategoryForm>) => setForm({ ...form, ...next });
  const save = (event: FormEvent) => {
    event.preventDefault();
    const body = categoryBody(form, props.nameMax);
    if ('problem' in body) return setProblem(body.problem);
    setProblem(null);
    command.mutate(
      { kind: 'category', id: props.categoryId, body },
      { onSuccess: (result) => result.status === 'saved' && props.onDone() },
    );
  };
  return (
    <form onSubmit={save} aria-label={t('menu.categoryForm')}>
      <label>
        {t('menu.categoryName')}
        <input value={form.name} onChange={(event) => change({ name: event.target.value })} />
      </label>
      <label>
        <input
          type="checkbox"
          checked={form.hidden}
          onChange={(event) => change({ hidden: event.target.checked })}
        />
        {t('menu.hide')}
      </label>
      <label>
        <input
          type="checkbox"
          checked={form.windowOn}
          onChange={(event) => change({ windowOn: event.target.checked })}
        />
        {t('menu.windowOn')}
      </label>
      {form.windowOn && (
        <>
          <label>
            {t('drafts.operations.from')}
            <input
              type="time"
              value={form.from}
              onChange={(event) => change({ from: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.operations.to')}
            <input
              type="time"
              value={form.to}
              onChange={(event) => change({ to: event.target.value })}
            />
          </label>
        </>
      )}
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

function ItemEditor(props: {
  restaurantId: string;
  menu: Menu;
  itemId: string;
  item: MenuItem | null;
  categoryId: string;
  currency: string;
  onDone: () => void;
}) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [form, setForm] = useState<ItemForm>(itemFormOf(props.item, props.categoryId));
  const [groupIds, setGroupIds] = useState<string[]>(props.item?.optionGroupIds ?? []);
  const [problem, setProblem] = useState<string | null>(null);
  const change = (next: Partial<ItemForm>) => setForm({ ...form, ...next });
  // The item first, then its groups when they changed (a new item exists
  // only once saved).
  const save = (event: FormEvent) => {
    event.preventDefault();
    const body = itemBody(form, props.currency, props.menu);
    if ('problem' in body) return setProblem(body.problem);
    setProblem(null);
    const groupsChanged = groupIds.join() !== (props.item?.optionGroupIds ?? []).join();
    command.mutate(
      { kind: 'item', id: props.itemId, body },
      {
        onSuccess: (result) => {
          if (result.status !== 'saved') return;
          if (!groupsChanged) return props.onDone();
          command.mutate(
            { kind: 'itemGroups', itemId: props.itemId, groupIds },
            { onSuccess: (next) => next.status === 'saved' && props.onDone() },
          );
        },
      },
    );
  };
  return (
    <form onSubmit={save} aria-label={t('menu.itemForm')}>
      <label>
        {t('menu.category')}
        <select
          value={form.categoryId}
          onChange={(event) => change({ categoryId: event.target.value })}
        >
          {props.menu.categories.map((category) => (
            <option key={category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('menu.code')}
        <input value={form.code} onChange={(event) => change({ code: event.target.value })} />
      </label>
      <label>
        {t('menu.itemName')}
        <input value={form.name} onChange={(event) => change({ name: event.target.value })} />
      </label>
      <label>
        {t('menu.description')}
        <textarea
          value={form.description}
          onChange={(event) => change({ description: event.target.value })}
        />
      </label>
      <label>
        {t('menu.price', { currency: props.currency })}
        <input
          inputMode="decimal"
          value={form.price}
          readOnly={props.menu.pricesLocked}
          onChange={(event) => change({ price: event.target.value })}
        />
      </label>
      {props.menu.optionGroups.length > 0 && (
        <fieldset>
          <legend>{t('menu.groups.ofItem')}</legend>
          {props.menu.optionGroups.map((group) => (
            <label key={group.id}>
              <input
                type="checkbox"
                checked={groupIds.includes(group.id)}
                onChange={(event) => setGroupIds(toggled(groupIds, group.id, event.target.checked))}
              />
              {group.name}
            </label>
          ))}
        </fieldset>
      )}
      <label>
        {t('menu.badgeLabel')}
        <select
          value={form.badge}
          onChange={(event) => change({ badge: event.target.value as Badge | '' })}
        >
          <option value="">{t('menu.noBadge')}</option>
          {BADGES.map((badge) => (
            <option key={badge} value={badge}>
              {t(`menu.badge.${badge}`)}
            </option>
          ))}
        </select>
      </label>
      <label>
        <input
          type="checkbox"
          checked={form.hidden}
          onChange={(event) => change({ hidden: event.target.checked })}
        />
        {t('menu.hide')}
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
