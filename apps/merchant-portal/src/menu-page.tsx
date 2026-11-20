import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import {
  AvailabilityControl,
  CategoryForm,
  GroupForm,
  NewItemForm,
  PhotoForm,
  PriceForm,
  Problem,
  TextForm,
  WindowForm,
  useRun,
} from './menu-forms.js';
import {
  type Menu,
  type MenuCategory,
  type MenuGroup,
  type MenuItem,
  type MenuOption,
  type Pending,
  type SwitchedOff,
  isNew,
  mediaUrl,
  menuCurrency,
  menuQuery,
  moved,
  timeOfMinute,
} from './menu.js';

// RA §9, §17 (slice 2.45b): «القائمة» for the owner in the portal, as in the
// restaurant app: availability, prices, hiding, order and windows publish
// at once; new rows, names, descriptions, photos and option groups wait for
// review (§9.2). Unstyled until the design.

// What the page's one open form edits.
type Editing =
  | { kind: 'add_category' }
  | { kind: 'rename_category'; category: MenuCategory }
  | { kind: 'window'; category: MenuCategory }
  | { kind: 'add_item'; categoryId: string | null }
  | { kind: 'edit_new_item'; item: MenuItem; categoryId: string }
  | { kind: 'text'; item: MenuItem }
  | { kind: 'photo'; item: MenuItem }
  | { kind: 'item_price'; item: MenuItem }
  | { kind: 'option_price'; option: MenuOption }
  | { kind: 'add_group' }
  | { kind: 'edit_group'; group: MenuGroup };

export function MenuPage() {
  const { t } = useTranslation();
  const menu = useQuery(menuQuery);
  const [editing, setEditing] = useState<Editing | null>(null);

  if (menu.isPending) return <p>{t('app.loading')}</p>;
  if (menu.isError) return <p role="alert">{t('menu.failed')}</p>;
  if (menu.data === 'terminated') return <p role="alert">{t('menu.refusal.terminated')}</p>;
  const data = menu.data;
  const currency = menuCurrency(data);
  const close = () => setEditing(null);

  return (
    <main>
      <h1>{t('menu.title')}</h1>
      <nav>
        <Link to="/menu/quick-edit">{t('menu.quickEdit')}</Link>{' '}
        <Link to="/menu/bulk-price">{t('menu.bulk.title')}</Link>{' '}
        <Link to="/menu/price-log">{t('menu.priceLog.title')}</Link>{' '}
        <Link to="/menu/preview">{t('menu.preview.title')}</Link>
      </nav>
      <p>
        <button type="button" onClick={() => setEditing({ kind: 'add_category' })}>
          {t('menu.addCategory')}
        </button>{' '}
        {currency !== null && data.categories.length > 0 && (
          <button type="button" onClick={() => setEditing({ kind: 'add_item', categoryId: null })}>
            {t('menu.addItem')}
          </button>
        )}
      </p>
      {editing && <EditingForm editing={editing} menu={data} currency={currency} onDone={close} />}
      {data.categories.length === 0 && <p>{t('menu.empty')}</p>}
      {data.categories.map((category) => (
        <CategorySection key={category.id} menu={data} category={category} edit={setEditing} />
      ))}
      <GroupsSection menu={data} edit={setEditing} />
    </main>
  );
}

function EditingForm(props: {
  editing: Editing;
  menu: Menu;
  currency: string | null;
  onDone: () => void;
}) {
  const { editing, menu, onDone } = props;
  const currency = props.currency ?? '';
  switch (editing.kind) {
    case 'add_category':
      return <CategoryForm category={null} onDone={onDone} />;
    case 'rename_category':
      return <CategoryForm category={editing.category} onDone={onDone} />;
    case 'window':
      return <WindowForm category={editing.category} onDone={onDone} />;
    case 'add_item':
      return (
        <NewItemForm
          menu={menu}
          item={null}
          categoryId={editing.categoryId}
          currency={currency}
          onDone={onDone}
        />
      );
    case 'edit_new_item':
      return (
        <NewItemForm
          menu={menu}
          item={editing.item}
          categoryId={editing.categoryId}
          currency={currency}
          onDone={onDone}
        />
      );
    case 'text':
      return <TextForm item={editing.item} onDone={onDone} />;
    case 'photo':
      return <PhotoForm item={editing.item} onDone={onDone} />;
    case 'item_price':
      return (
        <PriceForm
          target={{ kind: 'item', itemId: editing.item.id }}
          price={editing.item.price}
          onDone={onDone}
        />
      );
    case 'option_price':
      return (
        <PriceForm
          target={{ kind: 'option', optionId: editing.option.id }}
          price={editing.option.priceDelta}
          onDone={onDone}
        />
      );
    case 'add_group':
      return <GroupForm menu={menu} group={null} currency={currency} onDone={onDone} />;
    case 'edit_group':
      return <GroupForm menu={menu} group={editing.group} currency={currency} onDone={onDone} />;
  }
}

function SwitchText({ switchedOff }: { switchedOff: SwitchedOff }) {
  const { t } = useTranslation();
  return (
    <span>
      {switchedOff === null
        ? t('menu.available')
        : switchedOff.until === null
          ? t('menu.offUntilBackShown')
          : t('menu.offTomorrowShown')}
    </span>
  );
}

// RA §9.5: each pending request with what it asks and «سحب الطلب».
function PendingLines(props: { pending: readonly Pending[]; menu: Menu }) {
  const { t } = useTranslation();
  const { run, pending, problem } = useRun(true);
  if (props.pending.length === 0) return null;
  const items = new Map(
    props.menu.categories.flatMap((category) => category.items).map((item) => [item.id, item.name]),
  );
  return (
    <ul aria-label={t('menu.pendingReview')}>
      {props.pending.map((each) => (
        <li key={each.requestId}>
          {t('menu.pendingReview')} <PendingText pending={each} items={items} />{' '}
          <button
            type="button"
            disabled={pending}
            onClick={() => void run({ kind: 'withdraw', requestId: each.requestId })}
          >
            {t('menu.withdraw')}
          </button>
        </li>
      ))}
      <Problem problem={problem} />
    </ul>
  );
}

function PendingText(props: { pending: Pending; items: Map<string, string> }) {
  const { t } = useTranslation();
  const { pending } = props;
  switch (pending.field) {
    case 'created':
      return <span>{t('menu.pending.created')}</span>;
    case 'rename':
      return <span>{t('menu.pending.rename', { name: pending.name ?? '' })}</span>;
    case 'description':
      return (
        <span>
          {pending.description === null
            ? t('menu.pending.noDescription')
            : t('menu.pending.description', { description: pending.description })}
        </span>
      );
    case 'photo':
      return <span>{t('menu.pending.photo')}</span>;
    case 'choices':
      return (
        <span>
          {t('menu.pending.choices', { min: pending.minChoices, max: pending.maxChoices })}
        </span>
      );
    case 'items':
      return (
        <span>
          {pending.itemIds === null || pending.itemIds.length === 0
            ? t('menu.pending.noItems')
            : t('menu.pending.items', {
                items: pending.itemIds
                  .map((id) => props.items.get(id) ?? '')
                  .join(t('menu.listSeparator')),
              })}
        </span>
      );
    default:
      return null;
  }
}

function MoveButtons(props: { onMove: (step: -1 | 1) => void; disabled: boolean }) {
  const { t } = useTranslation();
  return (
    <>
      <button type="button" disabled={props.disabled} onClick={() => props.onMove(-1)}>
        {t('menu.moveUp')}
      </button>{' '}
      <button type="button" disabled={props.disabled} onClick={() => props.onMove(1)}>
        {t('menu.moveDown')}
      </button>
    </>
  );
}

function CategorySection(props: {
  menu: Menu;
  category: MenuCategory;
  edit: (editing: Editing) => void;
}) {
  const { t } = useTranslation();
  const { category, menu, edit } = props;
  const { run, pending, problem } = useRun();
  const fresh = isNew(category.pending);

  function move(step: -1 | 1) {
    const categoryIds = moved(menu.categories, category.id, step);
    if (categoryIds) void run({ kind: 'category_order', categoryIds });
  }

  return (
    <section aria-label={category.name}>
      <h2>{category.name}</h2>
      <PendingLines pending={category.pending} menu={menu} />
      {!fresh && (
        <p>
          <SwitchText switchedOff={category.switchedOff} />{' '}
          {category.hidden && <span>{t('menu.hidden')}</span>}{' '}
          <span>
            {category.window === null
              ? t('menu.windowAllDay')
              : t('menu.windowShown', {
                  from: timeOfMinute(category.window.startsAt),
                  to: timeOfMinute(category.window.endsAt),
                })}
          </span>
        </p>
      )}
      <p>
        {!fresh && (
          <>
            <AvailabilityControl
              type="category"
              id={category.id}
              switchedOff={category.switchedOff}
            />{' '}
            <button
              type="button"
              disabled={pending}
              onClick={() =>
                void run({
                  kind: 'category_hidden',
                  categoryId: category.id,
                  hidden: !category.hidden,
                })
              }
            >
              {category.hidden ? t('menu.show') : t('menu.hide')}
            </button>{' '}
            <MoveButtons onMove={move} disabled={pending} />{' '}
            <button type="button" onClick={() => edit({ kind: 'window', category })}>
              {t('menu.setWindow')}
            </button>{' '}
          </>
        )}
        <button type="button" onClick={() => edit({ kind: 'rename_category', category })}>
          {fresh ? t('menu.editRequest') : t('menu.rename')}
        </button>{' '}
        <button type="button" onClick={() => edit({ kind: 'add_item', categoryId: category.id })}>
          {t('menu.addItem')}
        </button>
      </p>
      <Problem problem={problem} />
      {category.items.length === 0 && <p>{t('menu.noItems')}</p>}
      <ul>
        {category.items.map((item) => (
          <ItemRow key={item.id} menu={menu} category={category} item={item} edit={edit} />
        ))}
      </ul>
    </section>
  );
}

function ItemRow(props: {
  menu: Menu;
  category: MenuCategory;
  item: MenuItem;
  edit: (editing: Editing) => void;
}) {
  const { t } = useTranslation();
  const { item, category, menu, edit } = props;
  const { run, pending, problem } = useRun();
  const fresh = isNew(item.pending);

  function move(step: -1 | 1) {
    const itemIds = moved(category.items, item.id, step);
    if (itemIds) void run({ kind: 'item_order', categoryId: category.id, itemIds });
  }

  return (
    <li aria-label={item.name}>
      {item.photoKey !== null && (
        <img src={mediaUrl(item.photoKey, 160)} alt={item.name} width={80} />
      )}
      <strong>{item.name}</strong>{' '}
      <span>{formatMoney(item.price.amount, item.price.currency)}</span>
      {item.description !== null && <p>{item.description}</p>}
      <PendingLines pending={item.pending} menu={menu} />
      {fresh ? (
        <p>
          <button
            type="button"
            onClick={() => edit({ kind: 'edit_new_item', item, categoryId: category.id })}
          >
            {t('menu.editRequest')}
          </button>
        </p>
      ) : (
        <>
          <p>
            <SwitchText switchedOff={item.switchedOff} />{' '}
            {item.switchedOff === null && !item.available && (
              <span>{t('menu.unavailableToCustomers')}</span>
            )}{' '}
            {item.hidden && <span>{t('menu.hidden')}</span>}
          </p>
          <p>
            <AvailabilityControl type="item" id={item.id} switchedOff={item.switchedOff} />{' '}
            <button type="button" onClick={() => edit({ kind: 'item_price', item })}>
              {t('menu.editPrice')}
            </button>{' '}
            <button
              type="button"
              disabled={pending}
              onClick={() =>
                void run({ kind: 'item_hidden', itemId: item.id, hidden: !item.hidden })
              }
            >
              {item.hidden ? t('menu.show') : t('menu.hide')}
            </button>{' '}
            <MoveButtons onMove={move} disabled={pending} />{' '}
            <button type="button" onClick={() => edit({ kind: 'text', item })}>
              {t('menu.editText')}
            </button>{' '}
            <button type="button" onClick={() => edit({ kind: 'photo', item })}>
              {t('menu.changePhoto')}
            </button>
          </p>
          <Problem problem={problem} />
          {item.optionGroups.map((group) => (
            <div key={group.id} aria-label={group.name}>
              <p>
                {t('menu.groupLine', {
                  name: group.name,
                  min: group.minChoices,
                  max: group.maxChoices,
                })}
              </p>
              <ul>
                {group.options.map((option) => (
                  <li key={option.id}>
                    {option.name}{' '}
                    <span>{formatMoney(option.priceDelta.amount, option.priceDelta.currency)}</span>{' '}
                    <SwitchText switchedOff={option.switchedOff} />{' '}
                    <AvailabilityControl
                      type="option"
                      id={option.id}
                      switchedOff={option.switchedOff}
                    />{' '}
                    <button type="button" onClick={() => edit({ kind: 'option_price', option })}>
                      {t('menu.editPrice')}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </>
      )}
    </li>
  );
}

// RA §9.1: «مجموعات الخيارات», every group with its linked items and
// options, the new ones waiting for review included.
function GroupsSection(props: { menu: Menu; edit: (editing: Editing) => void }) {
  const { t } = useTranslation();
  const { menu, edit } = props;
  const names = new Map(
    menu.categories.flatMap((category) => category.items).map((item) => [item.id, item.name]),
  );
  return (
    <section aria-label={t('menu.groups')}>
      <h2>{t('menu.groups')}</h2>
      {menuCurrency(menu) !== null && (
        <button type="button" onClick={() => edit({ kind: 'add_group' })}>
          {t('menu.addGroup')}
        </button>
      )}
      <ul>
        {menu.optionGroups.map((group) => (
          <li key={group.id} aria-label={group.name}>
            <strong>{group.name}</strong>{' '}
            <span>{t('menu.choices', { min: group.minChoices, max: group.maxChoices })}</span>
            <p>
              {t('menu.linkedItems', {
                items: group.itemIds.map((id) => names.get(id) ?? '').join(t('menu.listSeparator')),
              })}
            </p>
            <PendingLines pending={group.pending} menu={menu} />
            <ul>
              {group.options.map((option) => (
                <li key={option.id}>
                  {option.name}{' '}
                  <span>{formatMoney(option.priceDelta.amount, option.priceDelta.currency)}</span>
                  <PendingLines pending={option.pending} menu={menu} />
                </li>
              ))}
            </ul>
            <button type="button" onClick={() => edit({ kind: 'edit_group', group })}>
              {t('menu.editGroup')}
            </button>
          </li>
        ))}
      </ul>
    </section>
  );
}
