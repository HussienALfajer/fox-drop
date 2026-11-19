import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, lazy, type ReactNode, Suspense, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ActivationSection } from './captain-activation-page.js';
import { offboardingActions } from './captain-offboarding.js';
import {
  actionsOf,
  type Application,
  type ApplicationDocument,
  applicationQuery,
  BOARD_STAGES,
  boardQuery,
  type CommandResult,
  countOf,
  type DocumentKind,
  documentKindKeys,
  documentKindsOf,
  documentsOf,
  documentStatusKeys,
  duplicateFieldKeys,
  eventKindKeys,
  interviewBody,
  interviewFormOf,
  type InterviewProblem,
  reasonOf,
  scanProblem,
  type ScanProblem,
  stageKeys,
  useAddApplicationNote,
  useApplicationCommand,
  useUploadScan,
} from './captain-applications.js';
import { chosenCity, citiesQuery } from './cities.js';
import { serverNow } from './clock.js';
import { formatDateTime } from './format.js';
import { useCityOffice } from './office.js';
import { vehicleKey } from './order-labels.js';
import { ZONES_READ } from './peak-bonus.js';
import { degreesOf } from './restaurant-drafts.js';
import { IMAGE_TYPES } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

// MapLibre is most of the bundle: loaded only when the interview form shows.
const PinMap = lazy(() => import('./pin-map.js').then((module) => ({ default: module.PinMap })));

const boardRoute = getRouteApi('/signed-in/captain-applications');
const reviewRoute = getRouteApi('/signed-in/captain-applications/$applicationId');
const signedIn = getRouteApi('/signed-in');

// AP §9.7.1 «طلبات الانضمام» (slice 2.34b): the applications by stage, with
// the count of each. Unstyled until the design.
export function CaptainApplicationsPage() {
  const { t } = useTranslation();
  const search = boardRoute.useSearch();
  const stage = search.stage ?? 'new';
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const board = useQuery({ ...boardQuery(city?.id ?? '', stage), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('captainApplications.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {cities.isError || board.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !board.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <nav aria-label={t('captainApplications.stages')}>
            <ul>
              {BOARD_STAGES.map((each) => (
                <li key={each}>
                  <Link
                    to="/captain-applications"
                    search={{ city: city.code, stage: each }}
                    aria-current={each === stage ? 'page' : undefined}
                  >
                    {t('captainApplications.stageCount', {
                      stage: t(stageKeys[each]),
                      number: countOf(board.data.counts, each),
                    })}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
          <h2>{t(stageKeys[stage])}</h2>
          {board.data.applications.length === 0 ? (
            <p>{t('captainApplications.none')}</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>{t('captainApplications.name')}</th>
                  <th>{t('captainApplications.vehicle')}</th>
                  <th>{t('captainApplications.submittedAt')}</th>
                  <th>{t('captainApplications.updatedAt')}</th>
                </tr>
              </thead>
              <tbody>
                {board.data.applications.map((entry) => (
                  <tr key={entry.id}>
                    <td>
                      <Link
                        to="/captain-applications/$applicationId"
                        params={{ applicationId: entry.id }}
                        search={{ city: city.code }}
                      >
                        {entry.fullName}
                      </Link>
                    </td>
                    <td>{t(vehicleKey(entry.vehicle))}</td>
                    <td>{formatDateTime(entry.submittedAt, city.timeZone)}</td>
                    <td>{formatDateTime(entry.updatedAt, city.timeZone)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </main>
  );
}

// AP §9.7.1 «Application review page»: the applicant's data, the duplicate
// warning, the documents, the stage's actions, the notes and the history.
export function CaptainApplicationPage() {
  const { t } = useTranslation();
  const { applicationId } = reviewRoute.useParams();
  const search = reviewRoute.useSearch();
  const { session } = signedIn.useRouteContext();
  const cities = useQuery(citiesQuery);
  const application = useQuery(applicationQuery(applicationId));
  const city =
    cities.data && application.data
      ? (cities.data.find((each) => each.id === application.data?.cityId) ??
        chosenCity(cities.data, search.city))
      : undefined;
  return (
    <main>
      <h1>{t('captainApplications.reviewTitle')}</h1>
      <p>
        <Link to="/captain-applications" search={search.city ? { city: search.city } : {}}>
          {t('captainApplications.back')}
        </Link>
      </p>
      {cities.isError || application.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : application.data === null ? (
        <p role="alert">{t('captainApplications.refused.unknown_application')}</p>
      ) : !application.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <Review
          application={application.data}
          timeZone={city.timeZone}
          cityId={city.id}
          cityCode={city.code}
          session={session}
        />
      )}
    </main>
  );
}

function Review(props: {
  application: Application;
  timeZone: string;
  cityId: string;
  cityCode: string;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const { application, timeZone } = props;
  const time = (at: string) => formatDateTime(at, timeZone);
  const actions = offboardingActions(
    actionsOf(props.session, application.stage),
    application.offboarding,
  );
  return (
    <>
      <section aria-label={t('captainApplications.data')}>
        <h2>{application.fullName}</h2>
        <p>{t('captainApplications.stageNow', { stage: t(stageKeys[application.stage]) })}</p>
        <dl>
          <dt>{t('captainApplications.phone')}</dt>
          <dd dir="ltr">{application.phone ?? t('captainApplications.dash')}</dd>
          <dt>{t('captainApplications.birthDate')}</dt>
          <dd>{application.birthDate}</dd>
          <dt>{t('captainApplications.zone')}</dt>
          <dd>{application.zoneName ?? t('captainApplications.dash')}</dd>
          <dt>{t('captainApplications.vehicle')}</dt>
          <dd>
            {application.vehicle
              ? t(vehicleKey(application.vehicle))
              : t('captainApplications.dash')}
          </dd>
          <dt>{t('captainApplications.plate')}</dt>
          <dd>{application.plate ?? t('captainApplications.dash')}</dd>
          <dt>{t('captainApplications.submittedAt')}</dt>
          <dd>
            {application.submittedAt
              ? time(application.submittedAt)
              : t('captainApplications.dash')}
          </dd>
        </dl>
      </section>
      {application.formerCaptain && (
        <p role="alert">
          {application.formerCaptain.earlyExit
            ? t('captainOffboarding.formerCaptainEarlyExit')
            : t('captainOffboarding.formerCaptain')}
        </p>
      )}
      {application.duplicates.length > 0 && (
        <section aria-label={t('captainApplications.duplicates')}>
          <p role="alert">{t('captainApplications.duplicates')}</p>
          <ul>
            {application.duplicates.map((duplicate, index) => (
              <li key={index}>
                {t('captainApplications.duplicateLine', {
                  field: t(duplicateFieldKeys[duplicate.field]),
                  name: duplicate.fullName,
                })}{' '}
                {duplicate.captainId !== null
                  ? t('captainApplications.duplicateCaptain')
                  : duplicate.stage !== null
                    ? t('captainApplications.duplicateApplication', {
                        stage: t(stageKeys[duplicate.stage]),
                      })
                    : null}{' '}
                {duplicate.earlyExit && t('captainOffboarding.earlyExitFlag')}{' '}
                {duplicate.applicationId !== null && (
                  <Link
                    to="/captain-applications/$applicationId"
                    params={{ applicationId: duplicate.applicationId }}
                  >
                    {t('captainApplications.openApplication')}
                  </Link>
                )}
              </li>
            ))}
          </ul>
        </section>
      )}
      {application.rejection && (
        <section aria-label={t('captainApplications.rejection')}>
          <h2>{t('captainApplications.rejection')}</h2>
          <p>{application.rejection.reason}</p>
          <p>
            {t('captainApplications.rejectedAt', {
              time: time(application.rejection.at),
              from: time(application.rejection.reapplyFrom),
            })}
          </p>
        </section>
      )}
      <section aria-label={t('captainApplications.documents')}>
        <h2>{t('captainApplications.documents')}</h2>
        {documentKindsOf(application).map((kind) => (
          <DocumentKindSection
            key={kind}
            application={application}
            kind={kind}
            timeZone={timeZone}
            canReview={actions.has('review_document')}
          />
        ))}
        {application.requests.length > 0 && (
          <>
            <h3>{t('captainApplications.requests')}</h3>
            <ul>
              {application.requests.map((request) => (
                <li key={request.kind}>
                  {t('captainApplications.requestLine', {
                    kind: t(documentKindKeys[request.kind]),
                    reason: request.reason,
                    time: time(request.requestedAt),
                  })}
                  {request.requestedBy && (
                    <> {t('captainApplications.requestedBy', { name: request.requestedBy })}</>
                  )}
                </li>
              ))}
            </ul>
          </>
        )}
        {actions.has('upload_document') && <ScanSection application={application} />}
        {actions.has('request_document') && <RequestSection application={application} />}
      </section>
      <section aria-label={t('captainApplications.interview')}>
        <h2>{t('captainApplications.interview')}</h2>
        {application.interview ? (
          <p>
            {t('captainApplications.interviewLine', {
              time: time(application.interview.at),
              place: application.interview.place,
            })}
          </p>
        ) : (
          <p>{t('captainApplications.noInterview')}</p>
        )}
        {actions.has('schedule_interview') && (
          <InterviewSection application={application} timeZone={timeZone} cityId={props.cityId} />
        )}
      </section>
      <ActivationSection
        application={application}
        session={props.session}
        actions={actions}
        today={new Intl.DateTimeFormat('en-CA', { timeZone }).format(serverNow())}
        cityCode={props.cityCode}
      />
      {application.stage === 'active' && application.activation.captainId !== null && (
        // «إنهاء التعاقد» and its checklist live in the captain's profile
        // (AP §9.7.5, slice 2.36a).
        <p>
          <Link
            to="/captains/$captainId"
            params={{ captainId: application.activation.captainId }}
            search={{ city: props.cityCode, tab: 'contract' }}
          >
            {t('captainApplications.openProfile')}
          </Link>
        </p>
      )}
      <StageActions application={application} actions={actions} />
      {actions.has('note') && <NoteSection applicationId={application.id} />}
      <section aria-label={t('captainApplications.history')}>
        <h2>{t('captainApplications.history')}</h2>
        <ul>
          {application.events.map((event) => (
            <li key={event.id}>
              {t('captainApplications.eventLine', {
                time: time(event.at),
                actor: event.actor ?? t('captainApplications.applicant'),
                what: t(eventKindKeys[event.kind], {
                  stage: t(stageKeys[event.stage]),
                  kind: event.documentKind ? t(documentKindKeys[event.documentKind]) : '',
                  status: event.documentStatus ? t(documentStatusKeys[event.documentStatus]) : '',
                }),
              })}
              {event.note && <q>{event.note}</q>}
            </li>
          ))}
        </ul>
      </section>
    </>
  );
}

function DocumentKindSection(props: {
  application: Application;
  kind: DocumentKind;
  timeZone: string;
  canReview: boolean;
}) {
  const { t } = useTranslation();
  const documents = documentsOf(props.application, props.kind);
  const required = props.application.requiredDocuments.includes(props.kind);
  return (
    <section aria-label={t(documentKindKeys[props.kind])}>
      <h3>
        {t(documentKindKeys[props.kind])}{' '}
        {required ? t('captainApplications.required') : t('captainApplications.optional')}
      </h3>
      {documents.length === 0 ? (
        <p>{t('captainApplications.noDocument')}</p>
      ) : (
        <ul>
          {documents.map((document) => (
            <DocumentLine
              key={document.id}
              applicationId={props.application.id}
              document={document}
              timeZone={props.timeZone}
              canReview={props.canReview && document.inForce}
            />
          ))}
        </ul>
      )}
    </section>
  );
}

function DocumentLine(props: {
  applicationId: string;
  document: ApplicationDocument;
  timeZone: string;
  canReview: boolean;
}) {
  const { t } = useTranslation();
  const { document } = props;
  const time = (at: string) => formatDateTime(at, props.timeZone);
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState(false);
  const review = useApplicationCommand(props.applicationId);
  const kind = t(documentKindKeys[document.kind]);
  const reject = (event: FormEvent) => {
    event.preventDefault();
    const text = reasonOf(reason);
    setProblem(text === null);
    if (text !== null) {
      review.mutate({
        action: 'review_document',
        documentId: document.id,
        status: 'rejected',
        reason: text,
      });
    }
  };
  return (
    <li>
      <p>
        <strong>{t(documentStatusKeys[document.status])}</strong>
        {document.inForce ? null : <> {t('captainApplications.replaced')}</>}
        {document.reason && (
          <> {t('captainApplications.documentReason', { reason: document.reason })}</>
        )}
      </p>
      <p>
        {document.uploadedByOffice
          ? t('captainApplications.uploadedByOffice', {
              name: document.uploadedBy ?? '',
              time: time(document.uploadedAt),
            })
          : t('captainApplications.uploadedByApplicant', { time: time(document.uploadedAt) })}
      </p>
      {document.number && <p>{t('captainApplications.number', { number: document.number })}</p>}
      {document.issueDate && (
        <p>{t('captainApplications.issueDate', { date: document.issueDate })}</p>
      )}
      {document.expiresOn && (
        <p>{t('captainApplications.expiresOn', { date: document.expiresOn })}</p>
      )}
      {document.reviewedAt && (
        <p>
          {t('captainApplications.reviewedBy', {
            name: document.reviewedBy ?? '',
            time: time(document.reviewedAt),
          })}
        </p>
      )}
      {document.fileUrls.map((url, index) => (
        <img
          key={url}
          src={url}
          width={320}
          alt={t('captainApplications.fileAlt', { kind, number: index + 1 })}
        />
      ))}
      {props.canReview && (
        <>
          {document.status !== 'accepted' && (
            <button
              type="button"
              disabled={review.isPending}
              onClick={() =>
                review.mutate({
                  action: 'review_document',
                  documentId: document.id,
                  status: 'accepted',
                })
              }
            >
              {t('captainApplications.accept')}
            </button>
          )}
          <form onSubmit={reject}>
            <label>
              {t('captainApplications.rejectReason')}
              <input value={reason} onChange={(event) => setReason(event.target.value)} />
            </label>
            <button type="submit" disabled={review.isPending}>
              {t('captainApplications.rejectDocument')}
            </button>
          </form>
          {problem && <p role="alert">{t('captainApplications.problem.reason')}</p>}
          <CommandStatus pending={review.isPending} failed={review.isError} result={review.data} />
        </>
      )}
    </li>
  );
}

const scanProblemKeys = {
  files: 'captainApplications.problem.files',
  number: 'captainApplications.problem.number',
  issue_date: 'captainApplications.problem.issueDate',
} as const satisfies Record<ScanProblem, string>;

function KindSelect(props: {
  application: Application;
  value: DocumentKind;
  onChange: (kind: DocumentKind) => void;
}) {
  const { t } = useTranslation();
  return (
    <label>
      {t('captainApplications.kind')}
      <select
        value={props.value}
        onChange={(event) => props.onChange(event.target.value as DocumentKind)}
      >
        {documentKindsOf(props.application).map((kind) => (
          <option key={kind} value={kind}>
            {t(documentKindKeys[kind])}
          </option>
        ))}
      </select>
    </label>
  );
}

// «رفع نسخة المكتب»: the office's scan of a paper document (AP §9.7.1).
function ScanSection({ application }: { application: Application }) {
  const { t } = useTranslation();
  const [kind, setKind] = useState<DocumentKind>('national_id');
  const [files, setFiles] = useState<File[]>([]);
  const [number, setNumber] = useState('');
  const [issueDate, setIssueDate] = useState('');
  const [problem, setProblem] = useState<ScanProblem | null>(null);
  const upload = useUploadScan(application.id);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const form = { kind, files, number, issueDate };
    const found = scanProblem(form);
    setProblem(found);
    if (found === null) upload.mutate(form);
  };
  return (
    <form onSubmit={submit} aria-label={t('captainApplications.scan')}>
      <h3>{t('captainApplications.scan')}</h3>
      <KindSelect application={application} value={kind} onChange={setKind} />
      <label>
        {t('captainApplications.files')}
        <input
          type="file"
          multiple
          accept={IMAGE_TYPES.join(',')}
          onChange={(event) => setFiles(Array.from(event.target.files ?? []))}
        />
      </label>
      {kind === 'national_id' && (
        <label>
          {t('captainApplications.idNumber')}
          <input dir="ltr" value={number} onChange={(event) => setNumber(event.target.value)} />
        </label>
      )}
      {kind === 'criminal_record' && (
        <label>
          {t('captainApplications.issueDateLabel')}
          <input
            type="date"
            value={issueDate}
            onChange={(event) => setIssueDate(event.target.value)}
          />
        </label>
      )}
      <button type="submit" disabled={upload.isPending}>
        {t('captainApplications.scan')}
      </button>
      {problem && <p role="alert">{t(scanProblemKeys[problem])}</p>}
      <CommandStatus pending={upload.isPending} failed={upload.isError} result={upload.data} />
    </form>
  );
}

// «طلب مستند»: the applicant is told what is missing.
function RequestSection({ application }: { application: Application }) {
  const { t } = useTranslation();
  const [kind, setKind] = useState<DocumentKind>('national_id');
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState(false);
  const request = useApplicationCommand(application.id);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const text = reasonOf(reason);
    setProblem(text === null);
    if (text !== null) request.mutate({ action: 'request_document', kind, reason: text });
  };
  return (
    <form onSubmit={submit} aria-label={t('captainApplications.requestDocument')}>
      <h3>{t('captainApplications.requestDocument')}</h3>
      <KindSelect application={application} value={kind} onChange={setKind} />
      <label>
        {t('captainApplications.requestReason')}
        <input value={reason} onChange={(event) => setReason(event.target.value)} />
      </label>
      <button type="submit" disabled={request.isPending}>
        {t('captainApplications.requestDocument')}
      </button>
      {problem && <p role="alert">{t('captainApplications.problem.reason')}</p>}
      <CommandStatus pending={request.isPending} failed={request.isError} result={request.data} />
    </form>
  );
}

const interviewProblemKeys = {
  at: 'captainApplications.problem.interviewAt',
  in_past: 'captainApplications.refused.interview_in_past',
  place: 'captainApplications.problem.place',
  point: 'captainApplications.problem.point',
} as const satisfies Record<InterviewProblem, string>;

// «تحديد مقابلة»: the time on the city's clock, the place and its point,
// picked on the map (from the office's point) or typed.
function InterviewSection(props: { application: Application; timeZone: string; cityId: string }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const office = useCityOffice(can(session, ZONES_READ) ? props.cityId : undefined);
  const [form, setForm] = useState(() =>
    interviewFormOf(props.application.interview, props.timeZone),
  );
  const [problem, setProblem] = useState<InterviewProblem | null>(null);
  const schedule = useApplicationCommand(props.application.id);
  const latitude = degreesOf(form.latitude, 90);
  const longitude = degreesOf(form.longitude, 180);
  const pin = latitude !== null && longitude !== null ? { latitude, longitude } : null;
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const request = interviewBody(form, props.timeZone, serverNow());
    setProblem('problem' in request ? request.problem : null);
    if ('body' in request) schedule.mutate({ action: 'schedule_interview', body: request.body });
  };
  return (
    <form onSubmit={submit} aria-label={t('captainApplications.scheduleInterview')}>
      <h3>{t('captainApplications.scheduleInterview')}</h3>
      <label>
        {t('captainApplications.interviewAt')}
        <input
          type="datetime-local"
          value={form.at}
          onChange={(event) => setForm({ ...form, at: event.target.value })}
        />
      </label>
      <label>
        {t('captainApplications.place')}
        <input
          value={form.place}
          maxLength={200}
          onChange={(event) => setForm({ ...form, place: event.target.value })}
        />
      </label>
      <Suspense fallback={<p role="status">{t('status.loading')}</p>}>
        <PinMap
          pin={pin}
          centre={office.data?.office?.location ?? null}
          onChange={(point) =>
            setForm({
              ...form,
              latitude: point.latitude.toFixed(6),
              longitude: point.longitude.toFixed(6),
            })
          }
        />
      </Suspense>
      <label>
        {t('captainApplications.latitude')}
        <input
          dir="ltr"
          inputMode="decimal"
          value={form.latitude}
          onChange={(event) => setForm({ ...form, latitude: event.target.value })}
        />
      </label>
      <label>
        {t('captainApplications.longitude')}
        <input
          dir="ltr"
          inputMode="decimal"
          value={form.longitude}
          onChange={(event) => setForm({ ...form, longitude: event.target.value })}
        />
      </label>
      <button type="submit" disabled={schedule.isPending}>
        {t('captainApplications.scheduleInterview')}
      </button>
      {problem && <p role="alert">{t(interviewProblemKeys[problem])}</p>}
      <CommandStatus
        pending={schedule.isPending}
        failed={schedule.isError}
        result={schedule.data}
      />
    </form>
  );
}

// The stage's moves: «اجتاز التدريب والاختبار», «قائمة انتظار», «إعادة إلى
// المراجعة» and «رفض» with the reason sent to the applicant (CA §5.4).
function StageActions(props: { application: Application; actions: ReadonlySet<string> }) {
  const { t } = useTranslation();
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState(false);
  const command = useApplicationCommand(props.application.id);
  const { actions } = props;
  if (
    !actions.has('training_passed') &&
    !actions.has('waitlist') &&
    !actions.has('back_from_waitlist') &&
    !actions.has('reject')
  ) {
    return null;
  }
  const reject = (event: FormEvent) => {
    event.preventDefault();
    const text = reasonOf(reason);
    setProblem(text === null);
    if (text !== null) command.mutate({ action: 'reject', reason: text });
  };
  const button = (action: 'training_passed' | 'waitlist' | 'back_from_waitlist', label: string) =>
    actions.has(action) && (
      <button type="button" disabled={command.isPending} onClick={() => command.mutate({ action })}>
        {label}
      </button>
    );
  return (
    <section aria-label={t('captainApplications.actions')}>
      <h2>{t('captainApplications.actions')}</h2>
      {button('training_passed', t('captainApplications.trainingPassed'))}{' '}
      {button('waitlist', t('captainApplications.waitlist'))}{' '}
      {button('back_from_waitlist', t('captainApplications.backFromWaitlist'))}
      {actions.has('reject') && (
        <form onSubmit={reject}>
          <label>
            {t('captainApplications.rejectApplicationReason')}
            <input value={reason} onChange={(event) => setReason(event.target.value)} />
          </label>
          <button type="submit" disabled={command.isPending}>
            {t('captainApplications.reject')}
          </button>
        </form>
      )}
      {problem && <p role="alert">{t('captainApplications.problem.reason')}</p>}
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
    </section>
  );
}

function NoteSection({ applicationId }: { applicationId: string }) {
  const { t } = useTranslation();
  const [note, setNote] = useState('');
  const add = useAddApplicationNote(applicationId);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const text = note.trim();
    if (text === '') return;
    add.mutate(text, {
      onSuccess: (result) => {
        if (result.status === 'done') setNote('');
      },
    });
  };
  return (
    <form onSubmit={submit} aria-label={t('captainApplications.addNote')}>
      <label>
        {t('captainApplications.note')}
        <textarea value={note} maxLength={2000} onChange={(event) => setNote(event.target.value)} />
      </label>
      <button type="submit" disabled={add.isPending || note.trim() === ''}>
        {t('captainApplications.addNote')}
      </button>
      <CommandStatus pending={add.isPending} failed={add.isError} result={add.data} />
    </form>
  );
}

// A command's state: sending, failed, its refusal in words, or done.
function CommandStatus(props: {
  pending: boolean;
  failed: boolean;
  result: CommandResult | undefined;
}): ReactNode {
  const { t } = useTranslation();
  if (props.pending) return <p role="status">{t('captainApplications.sending')}</p>;
  if (props.failed) return <p role="alert">{t('common.failed')}</p>;
  if (!props.result) return null;
  if (props.result.status === 'done') {
    return <p role="status">{t('captainApplications.done')}</p>;
  }
  const { refusal, stage } = props.result;
  return (
    <p role="alert">
      {refusal === 'wrong_stage' && stage
        ? t('captainApplications.refused.wrong_stage_now', { stage: t(stageKeys[stage]) })
        : t(`captainApplications.refused.${refusal}`)}
    </p>
  );
}
