import { Link } from '@tanstack/react-router';
import { type FormEvent, type ReactNode, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type Activation,
  canSetCashLimit,
  depositLeft,
  type ContractForm,
  contractProblem,
  type ContractProblem,
  kitBody,
  type KitLine,
  kitLinesOf,
  missingDocumentOf,
  missingKeys,
  phaseKeys,
  reviewKeys,
  useActivationCommand,
  useRecordContract,
} from './captain-activation.js';
import {
  type Application,
  type CommandResult,
  documentKindKeys,
  type DocumentKind,
  stageKeys,
} from './captain-applications.js';
import { CASH_DESK } from './cash-desk.js';
import { formatMoney } from './format.js';
import { IMAGE_TYPES } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';
import { useReasonLists } from './content.js';

// AP §9.7.1–9.7.2 (slice 2.35a): «بانتظار العدة» and «تفعيل», then the
// contract's phase and the probation's confirmation. Unstyled until the
// design.
export function ActivationSection(props: {
  application: Application;
  session: AdminSession;
  actions: ReadonlySet<string>;
  today: string;
  cityCode: string;
}) {
  const { t } = useTranslation();
  const { application, actions } = props;
  const activation = application.activation;
  if (application.stage !== 'awaiting_kit' && application.stage !== 'active') return null;
  return (
    <section aria-label={t('captainActivation.title')}>
      <h2>{t('captainActivation.title')}</h2>
      <KitPart application={application} canIssue={actions.has('issue_kit')} />
      <CashLimitPart
        application={application}
        canSet={application.stage === 'awaiting_kit' && canSetCashLimit(props.session)}
        cityCode={props.cityCode}
      />
      <ContractPart
        application={application}
        canRecord={actions.has('record_contract')}
        canConfirm={actions.has('confirm_probation')}
        today={props.today}
      />
      <DepositPart
        activation={activation}
        canRecord={application.stage === 'awaiting_kit' && can(props.session, CASH_DESK)}
        cityCode={props.cityCode}
      />
      {application.stage === 'awaiting_kit' && (
        <ActivatePart application={application} canActivate={actions.has('activate')} />
      )}
      {activation.activatedAt && (
        <p>{t('captainActivation.activatedAt', { day: activation.activatedAt.slice(0, 10) })}</p>
      )}
    </section>
  );
}

function KitPart(props: { application: Application; canIssue: boolean }) {
  const { t } = useTranslation();
  const { kit } = props.application.activation;
  return (
    <>
      <h3>{t('captainActivation.kit')}</h3>
      {kit ? (
        <ul>
          {kit.items.map((item) => (
            <li key={item.code}>
              {t('captainActivation.kitLine', {
                label: item.label,
                quantity: item.quantity,
                size: item.size ?? t('captainApplications.dash'),
              })}
            </li>
          ))}
        </ul>
      ) : (
        <p>{t('captainActivation.noKit')}</p>
      )}
      {props.canIssue && <KitForm application={props.application} />}
    </>
  );
}

function KitForm({ application }: { application: Application }) {
  const { t } = useTranslation();
  const lists = useReasonLists();
  const [lines, setLines] = useState<KitLine[] | null>(null);
  const [problem, setProblem] = useState(false);
  const command = useActivationCommand(application.id);
  if (lists.isError) return <p role="alert">{t('common.failed')}</p>;
  const reasons = lists.data?.find((list) => list.list === 'kit_item')?.reasons;
  if (!reasons) return <p role="status">{t('status.loading')}</p>;
  const shown = lines ?? kitLinesOf(reasons, application.activation.kit);
  const labelOf = (code: string) => reasons.find((reason) => reason.code === code)?.label ?? code;
  const change = (index: number, patch: Partial<KitLine>) =>
    setLines(shown.map((line, at) => (at === index ? { ...line, ...patch } : line)));
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const body = kitBody(shown);
    setProblem(body === null);
    if (body !== null) command.mutate({ action: 'issue_kit', body });
  };
  return (
    <form onSubmit={submit} aria-label={t('captainActivation.issueKit')}>
      {shown.map((line, index) => (
        <fieldset key={line.code}>
          <label>
            <input
              type="checkbox"
              checked={line.picked}
              onChange={(event) => change(index, { picked: event.target.checked })}
            />
            {labelOf(line.code)}
          </label>
          <label>
            {t('captainActivation.size')}
            <input
              value={line.size}
              maxLength={20}
              onChange={(event) => change(index, { size: event.target.value })}
            />
          </label>
          <label>
            {t('captainActivation.quantity')}
            <input
              inputMode="numeric"
              value={line.quantity}
              onChange={(event) => change(index, { quantity: event.target.value })}
            />
          </label>
        </fieldset>
      ))}
      <button type="submit" disabled={command.isPending}>
        {t('captainActivation.issueKit')}
      </button>
      {problem && <p role="alert">{t('captainActivation.problem.kit')}</p>}
      <Status pending={command.isPending} failed={command.isError} result={command.data} />
    </form>
  );
}

function CashLimitPart(props: { application: Application; canSet: boolean; cityCode: string }) {
  const { t } = useTranslation();
  const { cashLimit } = props.application.activation;
  return (
    <>
      <h3>{t('captainActivation.cashLimit')}</h3>
      <p>{cashLimit ? formatMoney(cashLimit) : t('captainActivation.noCashLimit')}</p>
      {props.canSet && (
        <p>
          <Link to="/cash-desk/deposits" search={{ city: props.cityCode }}>
            {t('captainActivation.setCashLimitAtDesk')}
          </Link>
        </p>
      )}
    </>
  );
}

function ContractPart(props: {
  application: Application;
  canRecord: boolean;
  canConfirm: boolean;
  today: string;
}) {
  const { t } = useTranslation();
  const { contract } = props.application.activation;
  const command = useActivationCommand(props.application.id);
  const review = contract ? reviewKeys[contract.review] : null;
  return (
    <>
      <h3>{t('captainActivation.contract')}</h3>
      {contract ? (
        <dl>
          <dt>{t('captainActivation.signedOn')}</dt>
          <dd>{contract.signedOn}</dd>
          <dt>{t('captainActivation.startsOn')}</dt>
          <dd>{contract.startsOn}</dd>
          <dt>{t('captainActivation.probationEndsOn')}</dt>
          <dd>{contract.probationEndsOn}</dd>
          <dt>{t('captainActivation.commitment')}</dt>
          <dd>
            {t('captainActivation.commitmentDates', {
              from: contract.commitmentStartsOn,
              to: contract.commitmentEndsOn,
            })}
          </dd>
          {props.application.stage === 'active' && (
            <>
              <dt>{t('captainActivation.phaseNow')}</dt>
              <dd>{t(phaseKeys[contract.phase])}</dd>
            </>
          )}
          <dt>{t('captainActivation.probationConfirmed')}</dt>
          <dd>{contract.probationConfirmedOn ?? t('captainActivation.notYet')}</dd>
        </dl>
      ) : (
        <p>{t('captainActivation.noContract')}</p>
      )}
      {review && <p role="alert">{t(review)}</p>}
      {props.canConfirm && contract && contract.probationConfirmedOn === null && (
        <p>
          <button
            type="button"
            disabled={command.isPending}
            onClick={() => command.mutate({ action: 'confirm_probation' })}
          >
            {t('captainActivation.confirmProbation')}
          </button>
          <Status pending={command.isPending} failed={command.isError} result={command.data} />
        </p>
      )}
      {props.canRecord && <ContractFormPart application={props.application} today={props.today} />}
    </>
  );
}

const contractProblemKeys = {
  dates: 'captainActivation.problem.contractDates',
  files: 'captainActivation.problem.contractFiles',
} as const satisfies Record<ContractProblem, string>;

function ContractFormPart(props: { application: Application; today: string }) {
  const { t } = useTranslation();
  const [form, setForm] = useState<ContractForm>({
    signedOn: props.today,
    startsOn: props.today,
    files: [],
  });
  const [problem, setProblem] = useState<ContractProblem | null>(null);
  const record = useRecordContract(props.application.id);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const found = contractProblem(form, props.today);
    setProblem(found);
    if (found === null) record.mutate(form);
  };
  return (
    <form onSubmit={submit} aria-label={t('captainActivation.recordContract')}>
      <label>
        {t('captainActivation.signedOn')}
        <input
          type="date"
          value={form.signedOn}
          onChange={(event) => setForm({ ...form, signedOn: event.target.value })}
        />
      </label>
      <label>
        {t('captainActivation.startsOn')}
        <input
          type="date"
          value={form.startsOn}
          onChange={(event) => setForm({ ...form, startsOn: event.target.value })}
        />
      </label>
      <label>
        {t('captainActivation.scan')}
        <input
          type="file"
          multiple
          accept={IMAGE_TYPES.join(',')}
          onChange={(event) => setForm({ ...form, files: Array.from(event.target.files ?? []) })}
        />
      </label>
      <button type="submit" disabled={record.isPending}>
        {t('captainActivation.recordContract')}
      </button>
      {problem && <p role="alert">{t(contractProblemKeys[problem])}</p>}
      <Status pending={record.isPending} failed={record.isError} result={record.data} />
    </form>
  );
}

function DepositPart(props: { activation: Activation; canRecord: boolean; cityCode: string }) {
  const { t } = useTranslation();
  const { deposit } = props.activation;
  return (
    <>
      <h3>{t('captainActivation.deposit')}</h3>
      {deposit.amount ? (
        <p>
          {t('captainActivation.depositLine', {
            amount: formatMoney(deposit.amount),
            paid: formatMoney({ amount: deposit.paid, currency: deposit.amount.currency }),
            left: formatMoney({
              amount: depositLeft(deposit) ?? '0',
              currency: deposit.amount.currency,
            }),
          })}{' '}
          {deposit.instalment
            ? t('captainActivation.instalment', { amount: formatMoney(deposit.instalment) })
            : t('captainActivation.noInstalment')}
        </p>
      ) : (
        <p>{t('captainActivation.noDeposit')}</p>
      )}
      {props.canRecord && (
        <p>
          <Link to="/cash-desk/deposits" search={{ city: props.cityCode }}>
            {t('captainActivation.recordDeposit')}
          </Link>
        </p>
      )}
    </>
  );
}

function ActivatePart(props: { application: Application; canActivate: boolean }) {
  const { t } = useTranslation();
  const { missing } = props.application.activation;
  const command = useActivationCommand(props.application.id);
  return (
    <>
      <h3>{t('captainActivation.activate')}</h3>
      {missing.length === 0 ? (
        <p>{t('captainActivation.ready')}</p>
      ) : (
        <>
          <p>{t('captainActivation.waitingFor')}</p>
          <ul>
            {missing.map((each) => {
              const document = missingDocumentOf(each);
              return (
                <li key={each}>
                  {document
                    ? t('captainActivation.missing.document', {
                        kind: t(documentKindKeys[document as DocumentKind]),
                      })
                    : t(missingKeys[each as keyof typeof missingKeys])}
                </li>
              );
            })}
          </ul>
        </>
      )}
      {props.canActivate && (
        <button
          type="button"
          disabled={command.isPending || missing.length > 0}
          onClick={() => command.mutate({ action: 'activate' })}
        >
          {t('captainActivation.activate')}
        </button>
      )}
      <Status pending={command.isPending} failed={command.isError} result={command.data} />
    </>
  );
}

function Status(props: {
  pending: boolean;
  failed: boolean;
  result: CommandResult | undefined;
}): ReactNode {
  const { t } = useTranslation();
  if (props.pending) return <span role="status">{t('captainApplications.sending')}</span>;
  if (props.failed) return <span role="alert">{t('common.failed')}</span>;
  if (!props.result) return null;
  if (props.result.status === 'done') {
    return <span role="status">{t('captainApplications.done')}</span>;
  }
  const { refusal, stage } = props.result;
  return (
    <span role="alert">
      {refusal === 'wrong_stage' && stage
        ? t('captainApplications.refused.wrong_stage_now', { stage: t(stageKeys[stage]) })
        : t(`captainApplications.refused.${refusal}`)}
    </span>
  );
}
