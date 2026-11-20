import { useQuery } from '@tanstack/react-query';
import { useTranslation } from 'react-i18next';
import { callLink, contactQuery, whatsappLink } from './session.js';
import { whatsappAbout } from './support.js';

// RA §15: «اتصال بالعمليات» and «واتساب العمليات», from the top bar and from
// every order (the WhatsApp text then names it, as the app's); a number
// Content lacks hides its link.
export function ContactLinks({ orderNumber }: { orderNumber?: string }) {
  const { t } = useTranslation();
  const contact = useQuery(contactQuery);
  const whatsapp = contact.data?.whatsapp;
  return (
    <span>
      {contact.data?.phone && <a href={callLink(contact.data.phone)}>{t('support.call')}</a>}{' '}
      {whatsapp && (
        <a
          href={
            orderNumber === undefined
              ? whatsappLink(whatsapp)
              : whatsappAbout(
                  whatsappLink(whatsapp),
                  t('support.whatsappAboutOrder', { number: orderNumber }),
                )
          }
          target="_blank"
          rel="noreferrer"
        >
          {t('support.whatsapp')}
        </a>
      )}
    </span>
  );
}
