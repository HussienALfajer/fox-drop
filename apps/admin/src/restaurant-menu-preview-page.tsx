import { useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { timeOf } from './peak-bonus.js';
import { menuPreviewQuery } from './restaurant-menu-preview.js';

// AP §9.6.6 «معاينة كما يراها الزبون» (slice 2.31): the customer's restaurant
// page menu, read only, opened on demand. Unstyled until the design.
export function MenuPreviewSection(props: { restaurantId: string }) {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);
  return (
    <section aria-label={t('menu.preview.title')}>
      <h3>{t('menu.preview.title')}</h3>
      <button type="button" onClick={() => setOpen(!open)}>
        {open ? t('menu.preview.close') : t('menu.preview.open')}
      </button>
      {open && <Preview restaurantId={props.restaurantId} />}
    </section>
  );
}

function Preview(props: { restaurantId: string }) {
  const { t } = useTranslation();
  const preview = useQuery(menuPreviewQuery(props.restaurantId));
  if (preview.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!preview.data) return <p role="status">{t('status.loading')}</p>;
  if (preview.data.length === 0) return <p>{t('menu.preview.empty')}</p>;
  return (
    <>
      {preview.data.map((category) => (
        <section key={category.id} aria-label={category.name}>
          <h4>{category.name}</h4>
          <ul>
            {category.items.map((item) => (
              <li key={item.id}>
                <p>
                  {item.fromPrice === null
                    ? t('menu.preview.item', { name: item.name, price: formatMoney(item.price) })
                    : t('menu.preview.itemFrom', {
                        name: item.name,
                        price: formatMoney(item.fromPrice),
                      })}
                </p>
                {item.description !== null && <p>{item.description}</p>}
                {item.unavailableReason !== null && (
                  <p>
                    {item.unavailableReason === 'window' && category.window !== null
                      ? t('menu.preview.window', { time: timeOf(category.window.startsAt) })
                      : t(`menu.preview.reason.${item.unavailableReason}`)}
                  </p>
                )}
                {item.optionGroups.map((group) => (
                  <p key={group.id}>
                    {t(group.minChoices > 0 ? 'menu.preview.required' : 'menu.preview.optional', {
                      name: group.name,
                      options: group.options
                        .map((option) =>
                          /^0+$/.test(option.priceDelta.amount)
                            ? option.name
                            : t('menu.preview.option', {
                                name: option.name,
                                delta: formatMoney(option.priceDelta),
                              }),
                        )
                        .join('، '),
                    })}
                  </p>
                ))}
              </li>
            ))}
          </ul>
        </section>
      ))}
    </>
  );
}
