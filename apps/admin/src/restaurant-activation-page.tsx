import { useQuery } from '@tanstack/react-query';
import { useTranslation } from 'react-i18next';
import { formatDateTime } from './format.js';
import {
  canActivate,
  canWaiveImages,
  type ActivationResult,
  checklistQuery,
  useActivationCommand,
} from './restaurant-activation.js';
import type { AdminSession } from './session.js';

// The wizard's step 8 «المراجعة والتفعيل» (AP §9.6.3; slice 2.30b): each item
// of the checklist with its state, OWN's waiver of the image rule, then
// «تشغيل الوضع التجريبي» and «تفعيل وإظهار للزبائن». Unstyled until the design.
export function ActivationStep(props: {
  restaurantId: string;
  timeZone: string;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const checklist = useQuery(checklistQuery(props.restaurantId));
  const command = useActivationCommand(props.restaurantId);
  if (checklist.isError) return <p role="alert">{t('common.failed')}</p>;
  if (checklist.data === undefined) return <p role="status">{t('status.loading')}</p>;
  if (checklist.data === null) return <p role="alert">{t('drafts.refused.unknown_restaurant')}</p>;
  const { data } = checklist;
  const onboarding = data.accountStatus === 'draft' || data.accountStatus === 'test';
  return (
    <section aria-label={t('drafts.step.activation')}>
      <p>{t(`activation.status.${data.accountStatus}`)}</p>
      <ul aria-label={t('activation.checklist')}>
        {data.items.map((item) => (
          <li key={item.code}>
            {t('activation.line', {
              item: t(`activation.item.${item.code}`, { pct: data.images.requiredPct }),
              state: t(`activation.state.${item.state}`),
            })}
            {item.code === 'menu_images' && (
              <>
                {' '}
                {t('activation.images', {
                  withPhoto: data.images.withPhoto,
                  total: data.images.total,
                  pct: data.images.requiredPct,
                })}
              </>
            )}
            {item.state === 'missing' && <p>{t(`activation.missing.${item.code}`)}</p>}
          </li>
        ))}
      </ul>
      {data.imagesWaiver !== null && (
        <p>
          {t('activation.waivedAt', {
            time: formatDateTime(data.imagesWaiver.at, props.timeZone),
          })}
        </p>
      )}
      {onboarding && canWaiveImages(props.session) && (
        <button
          type="button"
          disabled={command.isPending}
          onClick={() => command.mutate({ kind: 'waiver', waived: data.imagesWaiver === null })}
        >
          {data.imagesWaiver === null ? t('activation.waive') : t('activation.unwaive')}
        </button>
      )}
      {canActivate(props.session) && data.accountStatus === 'draft' && (
        <p>
          <button
            type="button"
            disabled={command.isPending || !data.canStartTest}
            onClick={() => command.mutate({ kind: 'test' })}
          >
            {t('activation.startTest')}
          </button>
        </p>
      )}
      {data.accountStatus === 'test' && <p>{t('activation.testExplain')}</p>}
      {canActivate(props.session) && data.accountStatus === 'test' && (
        <p>
          <button
            type="button"
            disabled={command.isPending || !data.canActivate}
            onClick={() => command.mutate({ kind: 'activate' })}
          >
            {t('activation.activate')}
          </button>
        </p>
      )}
      {!canActivate(props.session) && onboarding && <p>{t('activation.opsOnly')}</p>}
      <ActivationStatus
        pending={command.isPending}
        failed={command.isError}
        result={command.data}
      />
    </section>
  );
}

function ActivationStatus(props: {
  pending: boolean;
  failed: boolean;
  result: ActivationResult | undefined;
}) {
  const { t } = useTranslation();
  if (props.pending) return <p role="status">{t('drafts.saving')}</p>;
  if (props.failed) return <p role="alert">{t('common.failed')}</p>;
  if (props.result?.status === 'refused') {
    return (
      <p role="alert">
        {t(
          `activation.refused.${props.result.refusal}` as 'activation.refused.checklist_incomplete',
          {
            defaultValue: t('drafts.refused.invalid'),
          },
        )}
      </p>
    );
  }
  return null;
}
