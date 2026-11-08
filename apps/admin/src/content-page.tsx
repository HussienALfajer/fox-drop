import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  CONTENT_FAQS,
  CONTENT_MANAGE,
  CONTENT_READ,
  type ContentRefusal,
  type EditResult,
  type FaqAudience,
  type FaqItem,
  moved,
  noteMode,
  type NoteMode,
  type ReasonEntry,
  type ReasonListEntry,
  useAddReason,
  useFaqs,
  useReasonLists,
  useReorder,
  useTexts,
  useUpdateContact,
  useUpdateFaq,
  useUpdateReason,
  useUpdateWorkRules,
  byAudience,
  type NotificationText,
  useNotificationTexts,
  useUpdateNotificationText,
} from './content.js';
import { can } from './session.js';

const signedIn = getRouteApi('/signed-in');

const refusalKeys = {
  list_closed: 'content.refused.listClosed',
  reason_fixed: 'content.refused.reasonFixed',
  customer_text_not_allowed: 'content.refused.customerTextNotAllowed',
  duplicate_label: 'content.refused.duplicateLabel',
  invalid_order: 'content.refused.invalidOrder',
  invalid_value: 'content.refused.invalidValue',
  unknown_variable: 'content.notifications.unknownVariable',
} as const satisfies Record<ContentRefusal, string>;

const audienceKeys = {
  customer: 'content.faq.customer',
  captain: 'content.faq.captain',
  merchant: 'content.faq.merchant',
} as const satisfies Record<FaqAudience, string>;

function Outcome({ result, failed }: { result: EditResult | undefined; failed: boolean }) {
  const { t } = useTranslation();
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (!result) return null;
  if (result.status === 'saved') return <p role="status">{t('content.saved')}</p>;
  return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
}

// AP §9.13 «المحتوى»: the reason lists, the customer texts, the preset notes,
// the FAQs, the captain work rules and the contact info. OWN edits, OPS
// reads, SUP edits the FAQs (AP §6.2). Unstyled until the design.
export function ContentPage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const manage = can(session, CONTENT_MANAGE);
  const read = can(session, CONTENT_READ);
  const faqs = can(session, CONTENT_FAQS);
  return (
    <main>
      <h1>{t('content.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {read && <ReasonLists manage={manage} />}
      {(read || faqs) && <Faqs edit={faqs} />}
      {read && <Texts manage={manage} />}
      {read && <NotificationTexts manage={manage} />}
    </main>
  );
}

function ReasonLists({ manage }: { manage: boolean }) {
  const { t } = useTranslation();
  const lists = useReasonLists();
  if (lists.isPending) return <p role="status">{t('status.loading')}</p>;
  if (lists.isError) return <p role="alert">{t('common.failed')}</p>;
  return (
    <section>
      <h2>{t('content.reasons.title')}</h2>
      <p>{t('content.reasons.explain')}</p>
      {lists.data.map((entry) => (
        <ReasonList key={entry.list} entry={entry} manage={manage} />
      ))}
    </section>
  );
}

function ReasonList({ entry, manage }: { entry: ReasonListEntry; manage: boolean }) {
  const { t } = useTranslation();
  const reorder = useReorder();
  const codes = entry.reasons.map((reason) => reason.code);
  return (
    <section>
      <h3>{t(`content.list.${entry.list}`)}</h3>
      <ul>
        {entry.reasons.map((reason) => (
          <li key={reason.code}>
            <ReasonRow list={entry} reason={reason} manage={manage} />
            {manage && (
              <>
                <button
                  type="button"
                  disabled={reorder.isPending}
                  onClick={() =>
                    reorder.mutate({ list: entry.list, codes: moved(codes, reason.code, -1) })
                  }
                >
                  {t('content.up')}
                </button>
                <button
                  type="button"
                  disabled={reorder.isPending}
                  onClick={() =>
                    reorder.mutate({ list: entry.list, codes: moved(codes, reason.code, 1) })
                  }
                >
                  {t('content.down')}
                </button>
              </>
            )}
          </li>
        ))}
      </ul>
      <Outcome result={reorder.data} failed={reorder.isError} />
      {manage && !entry.closed && <AddReason list={entry} />}
    </section>
  );
}

function ReasonRow({
  list,
  reason,
  manage,
}: {
  list: ReasonListEntry;
  reason: ReasonEntry;
  manage: boolean;
}) {
  const { t } = useTranslation();
  const update = useUpdateReason();
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    update.mutate({
      list: list.list,
      code: reason.code,
      label: String(form.get('label')),
      customerText: String(form.get('customerText') ?? ''),
      note: noteMode(form.get('note')),
      active: form.get('active') === 'on',
    });
  }
  return (
    <form onSubmit={submit}>
      <fieldset disabled={!manage || update.isPending}>
        <label>
          {t('content.label')}
          <input name="label" defaultValue={reason.label} required maxLength={100} />
        </label>
        {list.customerText && (
          <label>
            {t('content.customerText')}
            <input
              name="customerText"
              defaultValue={reason.customerText ?? ''}
              maxLength={300}
              placeholder={t('content.genericApology')}
            />
          </label>
        )}
        {!list.closed && <NoteSelect value={reason.note} />}
        <label>
          <input
            type="checkbox"
            name="active"
            defaultChecked={reason.active}
            disabled={reason.fixed}
          />
          {reason.fixed ? t('content.fixed') : t('content.active')}
        </label>
        {/* A fixed reason's checkbox is disabled, so it is sent as active. */}
        {reason.fixed && <input type="hidden" name="active" value="on" />}
        {manage && <button type="submit">{t('content.save')}</button>}
      </fieldset>
      <Outcome result={update.data} failed={update.isError} />
    </form>
  );
}

// Whether the choice takes a note; a closed list's reasons take none.
function NoteSelect({ value }: { value: NoteMode }) {
  const { t } = useTranslation();
  return (
    <label>
      {t('content.note.label')}
      <select name="note" defaultValue={value}>
        <option value="none">{t('content.note.none')}</option>
        <option value="optional">{t('content.note.optional')}</option>
        <option value="required">{t('content.note.required')}</option>
      </select>
    </label>
  );
}

function AddReason({ list }: { list: ReasonListEntry }) {
  const { t } = useTranslation();
  const add = useAddReason();
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const element = event.currentTarget;
    const form = new FormData(element);
    add.mutate(
      {
        list: list.list,
        label: String(form.get('label')),
        customerText: String(form.get('customerText') ?? ''),
        note: noteMode(form.get('note')),
      },
      { onSuccess: (result) => result.status === 'saved' && element.reset() },
    );
  }
  return (
    <form onSubmit={submit}>
      <fieldset disabled={add.isPending}>
        <legend>{t('content.add')}</legend>
        <label>
          {t('content.label')}
          <input name="label" required maxLength={100} />
        </label>
        {list.customerText && (
          <label>
            {t('content.customerText')}
            <input name="customerText" maxLength={300} placeholder={t('content.genericApology')} />
          </label>
        )}
        <NoteSelect value="none" />
        <button type="submit">{t('content.add')}</button>
      </fieldset>
      <Outcome result={add.data} failed={add.isError} />
    </form>
  );
}

function Faqs({ edit }: { edit: boolean }) {
  const { t } = useTranslation();
  const faqs = useFaqs(true);
  if (faqs.isPending) return <p role="status">{t('status.loading')}</p>;
  if (faqs.isError) return <p role="alert">{t('common.failed')}</p>;
  return (
    <section>
      <h2>{t('content.faq.title')}</h2>
      {(['customer', 'captain', 'merchant'] as const).map((audience) => (
        <FaqSet key={audience} audience={audience} items={faqs.data[audience]} edit={edit} />
      ))}
    </section>
  );
}

function FaqSet({
  audience,
  items,
  edit,
}: {
  audience: FaqAudience;
  items: FaqItem[];
  edit: boolean;
}) {
  const { t } = useTranslation();
  const update = useUpdateFaq();
  // One empty pair at the end adds a question; a pair left empty is dropped.
  const [rows, setRows] = useState<FaqItem[]>([...items, { question: '', answer: '' }]);
  function change(index: number, field: keyof FaqItem, value: string) {
    setRows((current) =>
      current.map((row, at) => (at === index ? { ...row, [field]: value } : row)),
    );
  }
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    update.mutate({ audience, items: rows });
  }
  return (
    <form onSubmit={submit}>
      <fieldset disabled={!edit || update.isPending}>
        <legend>{t(audienceKeys[audience])}</legend>
        {rows.map((row, index) => (
          <p key={index}>
            <label>
              {t('content.faq.question')}
              <input
                value={row.question}
                maxLength={200}
                onChange={(event) => change(index, 'question', event.target.value)}
              />
            </label>
            <label>
              {t('content.faq.answer')}
              <textarea
                value={row.answer}
                maxLength={2000}
                onChange={(event) => change(index, 'answer', event.target.value)}
              />
            </label>
          </p>
        ))}
        {edit && (
          <>
            <button
              type="button"
              onClick={() => setRows((current) => [...current, { question: '', answer: '' }])}
            >
              {t('content.faq.addQuestion')}
            </button>
            <button type="submit">{t('content.save')}</button>
          </>
        )}
      </fieldset>
      <Outcome result={update.data} failed={update.isError} />
    </form>
  );
}

function Texts({ manage }: { manage: boolean }) {
  const { t } = useTranslation();
  const texts = useTexts(true);
  const rules = useUpdateWorkRules();
  const contact = useUpdateContact();
  if (texts.isPending) return <p role="status">{t('status.loading')}</p>;
  if (texts.isError) return <p role="alert">{t('common.failed')}</p>;
  function submitRules(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    rules.mutate(String(new FormData(event.currentTarget).get('workRules')));
  }
  function submitContact(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    contact.mutate({ phone: String(form.get('phone')), whatsapp: String(form.get('whatsapp')) });
  }
  return (
    <section>
      <h2>{t('content.workRules.title')}</h2>
      <form onSubmit={submitRules}>
        <fieldset disabled={!manage || rules.isPending}>
          <label>
            {t('content.workRules.explain')}
            <textarea
              name="workRules"
              defaultValue={texts.data.workRules}
              maxLength={10000}
              rows={12}
            />
          </label>
          {manage && <button type="submit">{t('content.save')}</button>}
        </fieldset>
        <Outcome result={rules.data} failed={rules.isError} />
      </form>
      <h2>{t('content.contact.title')}</h2>
      <form onSubmit={submitContact}>
        <fieldset disabled={!manage || contact.isPending}>
          <label>
            {t('content.contact.phone')}
            <input name="phone" dir="ltr" defaultValue={texts.data.contact.phone ?? ''} />
          </label>
          <label>
            {t('content.contact.whatsapp')}
            <input name="whatsapp" dir="ltr" defaultValue={texts.data.contact.whatsapp ?? ''} />
          </label>
          <p>{t('content.contact.explain')}</p>
          {manage && <button type="submit">{t('content.save')}</button>}
        </fieldset>
        <Outcome result={contact.data} failed={contact.isError} />
      </form>
    </section>
  );
}

// «نصوص الإشعارات» (AP §9.13): the text of every push, per app. Only the text
// is edited, within its variables; the sound and priority are fixed.
function NotificationTexts({ manage }: { manage: boolean }) {
  const { t } = useTranslation();
  const templates = useNotificationTexts();
  if (templates.isPending) return <p role="status">{t('status.loading')}</p>;
  if (templates.isError) return <p role="alert">{t('common.failed')}</p>;
  return (
    <section>
      <h2>{t('content.notifications.title')}</h2>
      <p>{t('content.notifications.explain')}</p>
      {byAudience(templates.data).map(({ audience, templates: entries }) => (
        <section key={audience}>
          <h3>{t(`content.notifications.audience.${audience}`)}</h3>
          {entries.map((template) => (
            <NotificationTextRow key={template.key} template={template} manage={manage} />
          ))}
        </section>
      ))}
    </section>
  );
}

function NotificationTextRow({
  template,
  manage,
}: {
  template: NotificationText;
  manage: boolean;
}) {
  const { t } = useTranslation();
  const update = useUpdateNotificationText();
  const [text, setText] = useState(template.current);
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    update.mutate({ key: template.key, text });
  }
  // The event's name, keyed by the template («content.notifications.event.<key>»);
  // a template the panel does not know yet shows its key.
  const event = t(`content.notifications.event.${template.key}` as never, {
    defaultValue: template.key,
  });
  return (
    <form onSubmit={submit}>
      <fieldset disabled={!manage || update.isPending}>
        <label>
          {event}
          <textarea
            name="text"
            value={text}
            onChange={(change) => setText(change.target.value)}
            required
            maxLength={300}
            rows={2}
          />
        </label>
        <p>
          {template.variables.length > 0
            ? t('content.notifications.variables', {
                variables: template.variables.map((name) => `{${name}}`).join(' '),
              })
            : t('content.notifications.noVariables')}
        </p>
        <p>{t('content.notifications.row', { row: template.row })}</p>
        {template.current !== template.text && (
          <p>{t('content.notifications.default', { text: template.text })}</p>
        )}
        {manage && <button type="submit">{t('content.save')}</button>}
        {manage && text !== template.text && (
          <button type="button" onClick={() => setText(template.text)}>
            {t('content.notifications.restoreDefault')}
          </button>
        )}
      </fieldset>
      <Outcome result={update.data} failed={update.isError} />
    </form>
  );
}
