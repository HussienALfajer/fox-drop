import 'package:core_ui/core_ui.dart';
import 'package:flutter/widgets.dart';

import 'parity.dart';

/// The order parts' twins of every web story they can show (`pnpm parity
/// CountdownRing OrderRow Logo TrackingSteps Timer OrderCard`), with the
/// stories' own arguments. The timer's `compact` density is web only (the
/// Flutter timer has one), so it has no case.
void main() {
  _countdownRing();
  _logo();
  _orderRow();
  _trackingSteps();
  _timer();
  _orderCard();
}

void _countdownRing() {
  parityCase(
    'countdownring--full',
    () => const FoxCountdownRing(seconds: 45, total: 45),
  );
  parityCase(
    'countdownring--default',
    () => const FoxCountdownRing(seconds: 38, total: 45),
  );
  parityCase(
    'countdownring--half',
    () => const FoxCountdownRing(seconds: 23, total: 45),
  );
  parityCase(
    'countdownring--last',
    () => const FoxCountdownRing(seconds: 8, total: 45),
  );
}

void _logo() {
  parityCase('logo--letter', () => const FoxLogo(name: 'فطائر الريف'));
  parityCase('logo--latin-letter', () => const FoxLogo(name: 'pizza roma'));
}

Widget _row({
  String date = 'اليوم · 9:45 م',
  FoxOrderStatus status = FoxOrderStatus.pickedUp,
  String label = 'في الطريق إليك',
  Widget? trailing,
}) => FoxOrderRow(
  restaurant: 'برجر كبصو',
  date: date,
  status: FoxStatusChip(status: status, label: label),
  total: const FoxMoney(amount: '47000', symbol: '₺', bold: true),
  trailing: trailing,
  onPressed: () {},
);

void _orderRow() {
  parityCase('orderrow--active', _row);
  parityCase(
    'orderrow--past',
    () => _row(
      date: '21/11/2026',
      status: FoxOrderStatus.delivered,
      label: 'تم التسليم',
      trailing: FoxButton(
        label: 'اطلب مرة أخرى',
        variant: FoxButtonVariant.ghost,
        onPressed: () {},
      ),
    ),
  );
  parityCase(
    'orderrow--cancelled',
    () => _row(
      date: '21/11/2026',
      status: FoxOrderStatus.cancelled,
      label: 'أُلغي الطلب',
    ),
  );
}

const _steps = [
  FoxTrackingStep(icon: FoxIcons.receipt, label: 'استلام'),
  FoxTrackingStep(icon: FoxIcons.restaurant, label: 'تحضير'),
  FoxTrackingStep(icon: FoxIcons.motorcycle, label: 'في الطريق'),
  FoxTrackingStep(icon: FoxIcons.house, label: 'وصل'),
];

Widget _strip(int current) => SizedBox(
  // The web list fills its frame; the parity frame aligns a widget to its
  // start at its own width, so the strip takes the frame's width here.
  width: parityWidth - 2 * parityInset,
  child: FoxTrackingSteps(
    steps: _steps,
    current: current,
    doneLabel: 'تم',
    nowLabel: 'الآن',
  ),
);

void _trackingSteps() {
  parityCase('trackingsteps--first', () => _strip(0));
  parityCase('trackingsteps--middle', () => _strip(2));
  parityCase('trackingsteps--last', () => _strip(3));
  parityCase('trackingsteps--done', () => _strip(4));
}

void _timer() {
  parityCase(
    'timer--default',
    () => const FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د'),
  );
  parityCase(
    'timer--soon',
    () => const FoxTimer(seconds: 48, countsDown: true, minuteUnit: 'د'),
  );
  parityCase(
    'timer--minutes',
    () => const FoxTimer(seconds: 1080, countsDown: true, minuteUnit: 'د'),
  );
  parityCase(
    'timer--late',
    () => const FoxTimer(
      seconds: 180,
      countsDown: false,
      late: true,
      prefix: 'متأخر',
      minuteUnit: 'د',
    ),
  );
  parityCase(
    'timer--waiting',
    () => const FoxTimer(
      seconds: 240,
      countsDown: false,
      tone: FoxTimerTone.soon,
      prefix: 'ينتظر منذ',
      icon: FoxIcons.motorcycle,
      minuteUnit: 'د',
    ),
  );
}

const _newTimer = FoxTimer(seconds: 272, countsDown: true, minuteUnit: 'د');

Widget _card({FoxOrderAction? action, VoidCallback? onPressed}) => FoxOrderCard(
  number: '10423',
  since: 'منذ 1 د',
  items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
  captain: 'بانتظار كابتن',
  timer: _newTimer,
  action: action,
  onPressed: onPressed,
);

void _orderCard() {
  parityCase(
    'ordercard--default',
    () => _card(action: FoxOrderAction('قبول', () {})),
  );
  parityCase(
    'ordercard--preparing',
    () => FoxOrderCard(
      number: '10419',
      since: 'منذ 9 د',
      items: '2 أصناف · برجر كبصو، كوب عيران',
      captain: 'الكابتن أحمد في الطريق — يصل خلال 4 د',
      timer: const FoxTimer(seconds: 360, countsDown: true, minuteUnit: 'د'),
      badges: const [
        FoxStatusChip(
          tone: FoxTone.warning,
          icon: FoxIcons.warning,
          label: 'صنف نفد — بانتظار العمليات',
        ),
      ],
      action: FoxOrderAction('الطلب جاهز', () {}),
    ),
  );
  parityCase(
    'ordercard--late',
    () => FoxOrderCard(
      number: '10412',
      since: 'منذ 24 د',
      items: '5 أصناف · وجبة عائلية…',
      captain: 'وصل الكابتن — ينتظر منذ 3 د',
      timer: const FoxTimer(
        seconds: 240,
        countsDown: false,
        late: true,
        prefix: 'متأخر',
        minuteUnit: 'د',
      ),
      late: true,
      lateLabel: 'متأخر',
      action: FoxOrderAction('الطلب جاهز', () {}),
    ),
  );
  // The owner's portal shows live orders read-only (RA R15).
  parityCase('ordercard--read-only', _card);
  // The number opens the order on the web; the Flutter card is one button.
  parityCase('ordercard--open', () => _card(onPressed: () {}));
}
