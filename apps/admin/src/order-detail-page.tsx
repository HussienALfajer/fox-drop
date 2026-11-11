import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, Outlet } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { canAssign, OPERATIONS_MANAGE } from './assign-captain.js';
import { ReleaseDevice } from './captain-device-page.js';
import { canReleaseDevice } from './captain-device.js';
import { ForceOffline } from './captain-offline-page.js';
import { chosenCity, citiesQuery } from './cities.js';
import { formatMoney, formatTime } from './format.js';
import { CancelOrder } from './order-cancel-page.js';
import { ChangeOutcome } from './order-outcome-change-page.js';
import { canChangeOutcome } from './order-outcome-change.js';
import { SetOutcome } from './order-outcome-page.js';
import { canSetOutcome } from './order-outcome.js';
import { RecordOutcomePayment } from './order-outcome-payment-page.js';
import { canRecordOutcomePayment } from './order-outcome-payment.js';
import { canCancel } from './order-cancel.js';
import { ReassignOrder } from './order-reassign-page.js';
import { canHandOver, handoverState } from './order-handover.js';
import { canReassign } from './order-reassign.js';
import {
  actorKey,
  cancelReasonKeys,
  cashKeys,
  handoverCloseKeys,
  eventKey,
  eventReason,
  orderQuery,
  outcomeKeys,
  requestStatusKeys,
  responsibleKeys,
  type OrderDetail,
} from './order-detail.js';
import { statusKeys, trackKeys, vehicleKey } from './order-labels.js';
import { DecideOnBehalf } from './order-on-behalf-page.js';
import { canDecide } from './order-on-behalf.js';
import { CloseItemReport, ItemReportSection, ReportedItems } from './order-item-report-page.js';
import { canCloseItemReport } from './order-item-report.js';
import { EditChangeText, EditOrder } from './order-edit-page.js';
import { canEdit } from './order-edit.js';
import { ChangeTime } from './order-time-change-page.js';
import { canChangeTime } from './order-time-change.js';
import { Badges } from './orders-board-page.js';
import {
  canResend,
  type ResendTarget,
  resendTargets,
  useResendNotification,
} from './resend-notification.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/orders/$orderId');

type Lines = { amount: string; currency: string }[];

function linesText(lines: Lines): string {
  return lines.map(formatMoney).join(' + ');
}

// AP §9.3.1: the order detail beside the board, live over the board's
// channel. Its actions come with their slices: «تعيين كابتن» (AP §9.3.2),
// whose picker opens below it, while placed «قبول نيابة عن المطعم» and
// «رفض نيابة عن المطعم», until pickup «إلغاء الطلب», from acceptance until
// the captain reaches the customer «تعديل الوقت», and while a report is
// open «إغلاق بلاغ صنف نفد».
export function OrderDetailPage() {
  const { t } = useTranslation();
  const { orderId } = route.useParams();
  const { city: cityCode } = route.useSearch();
  const { session } = route.useRouteContext();
  const cities = useQuery(citiesQuery);
  // The board's city; the order's own comes with a second city.
  const city = cities.data && chosenCity(cities.data, cityCode);
  const order = useQuery(orderQuery(orderId, city?.id));
  const close = (
    <p>
      <Link to="/orders" search>
        {t('order.close')}
      </Link>
    </p>
  );

  if (order.isError) return <p role="alert">{t('status.error')}</p>;
  if (order.isPending || !city) return <p>{t('status.loading')}</p>;
  if (order.data === null) {
    return (
      <section>
        <p role="alert">{t('order.notFound')}</p>
        {close}
      </section>
    );
  }
  const detail = order.data;
  const time = (at: string) => formatTime(at, city.timeZone);
  const money = (amount: string) => formatMoney({ amount, currency: detail.money.currency });
  const { customer, pickup, delivery, cancellation, rejection } = detail;
  // The reason as chosen, or the timer's (AP §8.3); an unknown code is hidden.
  const cancelLabel =
    cancellation &&
    (cancellation.label ??
      (cancellation.reason in cancelReasonKeys ? t(cancelReasonKeys[cancellation.reason]!) : null));

  return (
    <section aria-labelledby="order-title">
      <h2 id="order-title">{t('order.number', { number: detail.number })}</h2>
      {close}
      <p>
        {t(statusKeys[detail.status])}
        {detail.captainTrack && <span> {t(trackKeys[detail.captainTrack])}</span>}
        {delivery && <span> {t(outcomeKeys[delivery.outcome])}</span>}
      </p>
      {detail.promisedAt && <p>{t('order.promisedAt', { time: time(detail.promisedAt) })}</p>}
      {detail.acceptance && (
        <p>
          {t('order.acceptance', {
            time: time(detail.acceptance.at),
            prepMin: detail.acceptance.prepMin,
            due: time(detail.acceptance.prepDueAt),
          })}
        </p>
      )}
      {detail.readyAt && <p>{t('order.readyAt', { time: time(detail.readyAt) })}</p>}
      {cancellation && (
        <>
          <p>
            {t('order.cancelledAt', { time: time(cancellation.at) })}{' '}
            {cancelLabel && t('order.cancellation.title', { label: cancelLabel })}
          </p>
          <p>{t('order.cancellation.by', { actor: t(actorKey(cancellation.by.type)) })}</p>
          {cancellation.note && (
            <p>
              {t(
                cancellation.by.type === 'admin'
                  ? 'order.cancellation.opsNote'
                  : 'order.cancellation.customerNote',
                { note: cancellation.note },
              )}
            </p>
          )}
          {cancellation.customerText && (
            <p>{t('order.cancellation.customerText', { text: cancellation.customerText })}</p>
          )}
          {cancellation.responsible && (
            <p>
              {t('order.cancellation.responsible', {
                party: t(responsibleKeys[cancellation.responsible]),
              })}
            </p>
          )}
          {cancellation.foodPrepared && <p>{t('order.cancellation.foodPrepared')}</p>}
          {cancellation.cash && (
            <p>{t('order.cancellation.cash', { answer: t(cashKeys[cancellation.cash]) })}</p>
          )}
          {cancellation.merchantCredit && (
            <p>
              {t('order.cancellation.merchantCredit', {
                amount: formatMoney(cancellation.merchantCredit),
              })}
            </p>
          )}
          {cancellation.captainCompensation && (
            <p>
              {t('order.cancellation.captainCompensation', {
                amount: formatMoney(cancellation.captainCompensation),
              })}
            </p>
          )}
          {cancellation.acknowledgedAt && (
            <p>
              {t('order.cancellation.acknowledged', { time: time(cancellation.acknowledgedAt) })}
            </p>
          )}
          {cancellation.captainSeenAt && (
            <p>{t('order.cancellation.captainSeen', { time: time(cancellation.captainSeenAt) })}</p>
          )}
        </>
      )}
      {rejection && (
        <>
          <p>
            {t('order.rejectedAt', { time: time(rejection.at) })}{' '}
            {t('order.rejection.title', { label: rejection.label })}
          </p>
          {rejection.byOperations && <p>{t('order.rejection.byOperations')}</p>}
          {rejection.itemIds.length > 0 && (
            <p>
              {t('order.rejection.items', {
                names: [
                  ...new Set(
                    detail.lines
                      .filter((line) => rejection.itemIds.includes(line.itemId))
                      .map((line) => line.name),
                  ),
                ].join('، '),
              })}
            </p>
          )}
          <p>{t('order.rejection.customerText', { text: rejection.customerText })}</p>
        </>
      )}
      <Badges card={detail} />
      {detail.itemReport && <ItemReportSection report={detail.itemReport} time={time} />}
      {canCloseItemReport(session, detail) && <CloseItemReport key={orderId} orderId={orderId} />}
      {canChangeTime(session, detail) && (
        <ChangeTime
          key={orderId}
          orderId={orderId}
          status={detail.status}
          promisedAt={detail.promisedAt}
          choices={detail.timeChange}
          time={time}
        />
      )}
      {canEdit(session, detail) && (
        <EditOrder
          key={editKey(orderId, detail)}
          orderId={orderId}
          detail={detail}
          choices={detail.editChoices}
          time={time}
        />
      )}
      {canDecide(session, detail) && (
        <DecideOnBehalf
          key={orderId}
          orderId={orderId}
          choices={detail.onBehalf}
          lines={detail.lines}
        />
      )}
      {detail.outcome && <OutcomeSection outcome={detail.outcome} time={time} />}
      {canSetOutcome(session, detail) && (
        <SetOutcome
          key={orderId}
          orderId={orderId}
          version={detail.version}
          choices={detail.outcomeChoices}
          pickup={{
            captainName: detail.captain?.name ?? null,
            payment: { amount: detail.money.pickupPayment, currency: detail.money.currency },
          }}
          total={{ amount: detail.money.total, currency: detail.money.currency }}
        />
      )}
      {canChangeOutcome(session, detail) && (
        <ChangeOutcome
          key={[orderId, detail.version].join(':')}
          orderId={orderId}
          version={detail.version}
          current={detail.outcome}
          choices={detail.outcomeChange}
          time={time}
        />
      )}
      {detail.outcome && canRecordOutcomePayment(session, detail) && (
        <RecordOutcomePayment
          key={orderId}
          orderId={orderId}
          due={detail.outcome.amountToCollect}
        />
      )}
      {canCancel(session, detail) && (
        <CancelOrder
          key={orderId}
          orderId={orderId}
          status={detail.status}
          version={detail.version}
          choices={detail.cancelChoices}
        />
      )}
      {canReassign(session, detail) && (
        <ReassignOrder
          key={[orderId, detail.version].join(':')}
          orderId={orderId}
          version={detail.version}
          choices={detail.reassignChoices}
        />
      )}
      {canResend(session) && (
        <ResendNotification orderId={orderId} targets={resendTargets(detail)} />
      )}

      <h3>{t('order.captain')}</h3>
      {detail.captain ? (
        <p>
          {detail.captain.name} {t(vehicleKey(detail.captain.vehicle))}
        </p>
      ) : (
        <p>
          <strong>{t('board.noCaptain')}</strong>
        </p>
      )}
      {canReleaseDevice(session, detail) && (
        <ReleaseDevice key={detail.captain.id} captainId={detail.captain.id} time={time} />
      )}
      {canReleaseDevice(session, detail) && (
        <ForceOffline key={detail.captain.id} captainId={detail.captain.id} />
      )}
      {detail.captainTrack === 'offered' && <p>{t('order.offerOpen')}</p>}
      {can(session, OPERATIONS_MANAGE) && canAssign(detail) && (
        <p>
          <Link to="/orders/$orderId/assign" params={{ orderId }} search>
            {t('assign.title')}
          </Link>
        </p>
      )}
      {canHandOver(session, detail) && (
        <p>
          <Link to="/orders/$orderId/handover" params={{ orderId }} search>
            {t('handover.title')}
          </Link>
          {detail.handover.handovers.some(
            (each) => each.receivedAt === null && each.closedAt === null,
          ) && <span> {t('handover.replaces')}</span>}
        </p>
      )}
      <Outlet />
      {detail.handover.handovers.length > 0 && (
        <section>
          <h4>{t('order.handovers.title')}</h4>
          <ul>
            {detail.handover.handovers.map((each) => {
              const state = handoverState(each);
              return (
                <li key={each.openedAt}>
                  {[
                    t('order.handovers.line', {
                      time: time(each.openedAt),
                      from: each.fromCaptainName ?? '',
                      to: each.toCaptainName ?? '',
                    }),
                    state.kind === 'received'
                      ? t('order.handovers.received', { time: time(state.at) })
                      : state.kind === 'closed'
                        ? t(handoverCloseKeys[state.reason])
                        : t(
                            state.kind === 'offered'
                              ? 'order.handovers.offered'
                              : 'order.handovers.waiting',
                          ),
                    each.note,
                  ].join(' ')}
                </li>
              );
            })}
          </ul>
        </section>
      )}
      {detail.reassignments.length > 0 && (
        <section>
          <h4>{t('order.reassignments.title')}</h4>
          <ul>
            {detail.reassignments.map((each) => (
              <li key={each.at}>
                {[
                  t('order.reassignments.line', {
                    time: time(each.at),
                    label: each.label,
                    fault: t(
                      each.captainFault ? 'order.reassign.captainFault' : 'order.reassign.noFault',
                    ),
                  }),
                  each.cash && t('order.cancellation.cash', { answer: t(cashKeys[each.cash]) }),
                  each.note,
                ]
                  .filter(Boolean)
                  .join(' ')}
              </li>
            ))}
          </ul>
        </section>
      )}

      <h3>{t('order.restaurant')}</h3>
      <p>{detail.restaurant.name}</p>

      <h3>{t('order.customer')}</h3>
      <p>{customer.name ?? t('order.noName')}</p>
      {customer.recipientName && <p>{t('order.recipient', { name: customer.recipientName })}</p>}
      <p>{customer.address.neighbourhood}</p>
      <p>{customer.address.street}</p>
      {customer.address.floor && <p>{customer.address.floor}</p>}
      <p>{t('order.landmark', { landmark: customer.address.landmark })}</p>
      {customer.address.directions && <p>{customer.address.directions}</p>}
      {customer.payIn && <p>{t('order.payIn', { currency: customer.payIn })}</p>}
      {detail.note && <p>{t('order.note', { note: detail.note })}</p>}
      {customer.arrival && (
        <p>
          {t('order.atCustomer', { time: time(customer.arrival.at) })}
          {customer.arrival.away && (
            <strong>
              {' '}
              {t('order.alert.awayFromAddress')} {customer.arrival.away.label}{' '}
              {customer.arrival.away.note}
            </strong>
          )}
        </p>
      )}

      <h3>{t('order.items')}</h3>
      <ul>
        {detail.lines.map((line, index) => (
          <li key={index}>
            {t('order.line', { quantity: line.quantity, name: line.name })} {money(line.lineTotal)}
            {line.added && <strong> {t('order.lineAdded')}</strong>}
            {line.quantityBefore !== null && (
              <span> {t('order.lineQuantityBefore', { quantity: line.quantityBefore })}</span>
            )}
            {line.options.length > 0 && (
              <ul>
                {line.options.map((option, each) => (
                  <li key={each}>{option.name}</li>
                ))}
              </ul>
            )}
            {line.note && <p>{line.note}</p>}
          </li>
        ))}
      </ul>

      {detail.removedLines.length > 0 && (
        <ul>
          {detail.removedLines.map((line, index) => (
            <li key={index}>
              <del>{t('order.removedLine', { quantity: line.quantity, name: line.name })}</del>
            </li>
          ))}
        </ul>
      )}
      {detail.edits.length > 0 && (
        <>
          <h3>{t('order.edits')}</h3>
          <ul>
            {detail.edits.map((edit, index) => (
              <li key={index}>
                {t('order.editEntry', {
                  time: time(edit.at),
                  itemsBefore: money(edit.itemsValue.before),
                  itemsAfter: money(edit.itemsValue.after),
                  totalBefore: money(edit.total.before),
                  totalAfter: money(edit.total.after),
                })}
                {edit.deliveryFee.before !== edit.deliveryFee.after && (
                  <p>
                    {t('order.editFee', {
                      before: money(edit.deliveryFee.before),
                      after: money(edit.deliveryFee.after),
                    })}
                  </p>
                )}
                {edit.extraPrepMin !== null && (
                  <p>{t('order.editExtraPrep', { minutes: edit.extraPrepMin })}</p>
                )}
                <ul>
                  {edit.changes.map((change, each) => (
                    <li key={each}>
                      <EditChangeText change={change} />
                    </li>
                  ))}
                </ul>
                {edit.responsible !== null ? (
                  // AP §9.3.3: after the pickup, who bore it; no acknowledgement.
                  <p>
                    {t('order.editAfterPickup', {
                      party: t(responsibleKeys[edit.responsible]),
                      amount: money(edit.charge ?? '0'),
                    })}
                  </p>
                ) : (
                  <p>
                    {edit.acknowledgedAt
                      ? t('order.editAcknowledgedAt', { time: time(edit.acknowledgedAt) })
                      : t('order.editNotAcknowledged')}
                  </p>
                )}
              </li>
            ))}
          </ul>
        </>
      )}

      <h3>{t('order.money')}</h3>
      <dl>
        <dt>{t('order.itemsValue')}</dt>
        <dd>{money(detail.money.itemsValue)}</dd>
        <dt>{t('order.deliveryFee')}</dt>
        <dd>{money(detail.money.deliveryFee)}</dd>
        <dt>{t('order.discount')}</dt>
        <dd>{money(detail.money.discount)}</dd>
        <dt>{t('order.rounding')}</dt>
        <dd>{money(detail.money.rounding)}</dd>
        <dt>{t('order.total')}</dt>
        <dd>{money(detail.money.total)}</dd>
        <dt>{t('order.pickupPayment')}</dt>
        <dd>{money(detail.money.pickupPayment)}</dd>
      </dl>

      <h3>{t('order.pickup')}</h3>
      {pickup.at ? (
        <p>{t('order.pickedUpAt', { time: time(pickup.at) })}</p>
      ) : (
        <p>{t('order.notPickedUp')}</p>
      )}
      {pickup.readyNotPressed && <p>{t('order.readyNotPressed')}</p>}
      {pickup.requests.length > 0 && (
        <ul>
          {pickup.requests.map((request) => (
            <li key={request.id}>
              {t('order.request.line', {
                time: time(request.openedAt),
                status: t(requestStatusKeys[request.status]),
                lines: linesText(request.bookedLines ?? request.lines),
              })}
              {request.receivedLines && (
                <span>
                  {' '}
                  {t('order.request.received', { lines: linesText(request.receivedLines) })}
                </span>
              )}
            </li>
          ))}
        </ul>
      )}
      {pickup.dispute && (
        <p>
          <strong>
            {t('order.pickupDisputed')}{' '}
            {t('order.request.received', { lines: linesText(pickup.dispute.receivedLines) })}
          </strong>
        </p>
      )}

      {delivery && (
        <>
          <h3>{t('order.delivery')}</h3>
          <p>{t('order.deliveredAt', { time: time(delivery.at) })}</p>
          <p>{t('order.received', { lines: linesText(delivery.received) })}</p>
          {delivery.change.length > 0 && (
            <p>{t('order.change', { lines: linesText(delivery.change) })}</p>
          )}
          <p>{t('order.netReceived', { amount: formatMoney(delivery.netReceived) })}</p>
          {delivery.shortfall && (
            <p>
              <strong>
                {t('order.shortfall', { amount: formatMoney(delivery.shortfall.amount) })}{' '}
                {delivery.shortfall.label} {delivery.shortfall.note}
              </strong>
            </p>
          )}
        </>
      )}

      <h3>{t('order.timeline')}</h3>
      <ol>
        {detail.timeline.map((event) => {
          const key = eventKey(event.type);
          const reason = eventReason(event);
          // AP §9.3.1 «cancellation (reason and party)»: the reason as chosen
          // and the responsible party, beside operations' note.
          const cancelled = event.type === 'order.cancelled' && cancellation;
          return (
            <li key={event.version}>
              <time dateTime={event.at}>{time(event.at)}</time>{' '}
              {key ? t(key) : t(statusKeys[event.to])}{' '}
              {t('order.by', { actor: t(actorKey(event.actor.type)) })}
              {cancelled && cancelLabel && <span> {cancelLabel}</span>}
              {cancelled && cancellation.responsible && (
                <span>
                  {' '}
                  {t('order.cancellation.responsible', {
                    party: t(responsibleKeys[cancellation.responsible]),
                  })}
                </span>
              )}
              {cancelled && cancellation.by.type === 'customer' && cancellation.note && (
                <span> {cancellation.note}</span>
              )}
              {event.timeChange && (
                <span>
                  {' '}
                  {t('order.changeTime.event', {
                    minutes: event.timeChange.addMin,
                    time: time(event.timeChange.promisedAt),
                  })}
                </span>
              )}
              {event.itemReport && <ReportedItems report={event.itemReport} />}
              {reason && !(cancelled && 'key' in reason) && (
                <span> {'key' in reason ? t(reason.key) : reason.text}</span>
              )}
            </li>
          );
        })}
      </ol>
    </section>
  );
}

const targetKeys = {
  customer: 'order.resend.customer',
  merchant: 'order.resend.merchant',
  captain: 'order.resend.captain',
} as const satisfies Record<ResendTarget, string>;

// AP §9.3.2 «إعادة إرسال الإشعار»: the order's latest push to that party,
// sent again.
function ResendNotification({ orderId, targets }: { orderId: string; targets: ResendTarget[] }) {
  const { t } = useTranslation();
  const resend = useResendNotification(orderId);
  if (targets.length === 0) return null;
  const result = resend.data;
  return (
    <section>
      <h3>{t('order.resend.title')}</h3>
      {targets.map((to) => (
        <button
          key={to}
          type="button"
          disabled={resend.isPending}
          onClick={() => resend.mutate(to)}
        >
          {t(targetKeys[to])}
        </button>
      ))}
      {resend.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'sent' && (
        <p role="status">{t('order.resend.sent', { text: result.body })}</p>
      )}
      {result?.status === 'refused' && (
        <p role="alert">
          {t(
            result.refusal === 'nothing_to_resend'
              ? 'order.resend.nothingToResend'
              : 'order.resend.notActive',
          )}
        </p>
      )}
    </section>
  );
}

// The edit form starts again from the order's lines whenever they change (an
// edit made, here or elsewhere), and keeps what is typed otherwise.
function editKey(orderId: string, detail: OrderDetail): string {
  return [orderId, ...detail.lines.map((line) => [line.position, line.quantity].join(':'))].join(
    '|',
  );
}

// AP §9.3.2 «تحديد النتيجة» (slice 2.11a): the outcome operations set, with
// what it booked, what the customer sees and the note.
function OutcomeSection({
  outcome,
  time,
}: {
  outcome: NonNullable<OrderDetail['outcome']>;
  time: (iso: string) => string;
}) {
  const { t } = useTranslation();
  const food = outcome.food && foodKeys[outcome.food];
  return (
    <>
      <p>
        {t('order.outcomeSet.title', {
          outcome: t(outcomeKeys[outcome.outcome]),
          responsible: t(responsibleKeys[outcome.responsible]),
        })}
      </p>
      <p>{t('order.outcomeSet.at', { time: time(outcome.at) })}</p>
      {outcome.amountToCollect.amount !== '0' && (
        <p>
          {t('order.outcomeSet.amountToCollect', {
            amount: formatMoney(outcome.amountToCollect),
          })}
        </p>
      )}
      {outcome.awaitingCollection && <p>{t('order.outcomeSet.awaitingCollection')}</p>}
      {food && <p>{t('order.outcomeSet.food', { food: t(food) })}</p>}
      {outcome.loss.amount !== '0' && (
        <p>{t('order.outcomeSet.loss', { amount: formatMoney(outcome.loss) })}</p>
      )}
      {outcome.dues && <p>{t('order.outcomeSet.dues', { amount: formatMoney(outcome.dues) })}</p>}
      {outcome.merchantDebit && (
        <p>{t('order.outcomeSet.merchantDebit', { amount: formatMoney(outcome.merchantDebit) })}</p>
      )}
      <p>{t('order.outcomeSet.captainPay', { amount: formatMoney(outcome.captainPay) })}</p>
      {outcome.customerText && (
        <p>{t('order.outcomeSet.customerText', { text: outcome.customerText })}</p>
      )}
      <p>{t('order.outcomeSet.note', { note: outcome.note })}</p>
      {outcome.history.length > 0 && (
        <>
          <h4>{t('order.outcomeSet.history')}</h4>
          <ul>
            {outcome.history.map((each) => (
              <li key={each.at}>
                {t('order.outcomeSet.replaced', {
                  outcome: t(outcomeKeys[each.outcome]),
                  responsible: t(responsibleKeys[each.responsible]),
                  from: time(each.at),
                  to: time(each.replacedAt),
                  note: each.note,
                })}
              </li>
            ))}
          </ul>
        </>
      )}
    </>
  );
}

// AP Appendix B «Food after a failed order»: the labels as the panel shows
// them (the dialog shows Content's own).
const foodKeys = {
  kept_by_captain: 'order.food.keptByCaptain',
  returned_to_restaurant: 'order.food.returnedToRestaurant',
  destroyed: 'order.food.destroyed',
} as const satisfies Record<NonNullable<NonNullable<OrderDetail['outcome']>['food']>, string>;
