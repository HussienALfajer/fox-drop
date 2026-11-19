import { useTranslation } from 'react-i18next';
import type { MenuResult } from './restaurant-menu.js';

// A menu command's state under its button: saving, failed, or the refusal's
// sentence.
export function CommandStatus(props: {
  pending: boolean;
  failed: boolean;
  result: MenuResult | undefined;
}) {
  const { t } = useTranslation();
  if (props.pending) return <p role="status">{t('drafts.saving')}</p>;
  if (props.failed) return <p role="alert">{t('common.failed')}</p>;
  if (props.result?.status === 'refused') {
    return (
      <p role="alert">
        {t(`menu.refused.${props.result.refusal}` as 'menu.refused.invalid_menu', {
          defaultValue: t('drafts.refused.invalid'),
        })}
      </p>
    );
  }
  return null;
}
