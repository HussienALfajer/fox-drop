import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef FiguresAnswer = MerchantFiguresDtoOutput;
typedef Figures = MerchantFiguresOutput;

/// RA §11's periods, in business days counted by the server; `query` is the
/// route's value.
enum ReportsPeriod {
  today('today'),
  yesterday('yesterday'),
  last7Days('last_7_days'),
  last30Days('last_30_days');

  const ReportsPeriod(this.query);

  final String query;
}

/// `GET /v1/merchant/figures?period=` (RA §11), the owners' (a cashier gets
/// `403 owner_only`): read while «التقارير» shows a period.
final reportsProvider = FutureProvider.autoDispose
    .family<FiguresAnswer, ReportsPeriod>((ref, period) async {
      final api = ref.read(coreApiProvider).getMerchantApi();
      return (await api.merchantFiguresRead(period: period.query)).data!;
    });

/// `GET /v1/merchant/figures?day=` (RA §11 «Daily summary image»): a
/// business day's figures against the day before.
final summaryProvider = FutureProvider.autoDispose
    .family<FiguresAnswer, String>((ref, day) async {
      final api = ref.read(coreApiProvider).getMerchantApi();
      return (await api.merchantFiguresRead(day: day)).data!;
    });

/// Why a read was refused (RA §5.4, §5.5): a cashier, or a terminated
/// restaurant; null for any other failure, which is worth a retry.
enum ReportsRefusal { ownersOnly, terminated }

ReportsRefusal? refusalOf(Object error) {
  if (error is! DioException || error.response?.statusCode != 403) return null;
  final body = error.response?.data;
  return body is Map && body['error'] == 'restaurant_terminated'
      ? ReportsRefusal.terminated
      : ReportsRefusal.ownersOnly;
}

/// How a figure reads.
enum MetricKind { count, share, minutes, money, rating }

/// A figure of RA §11's table: its value in a period as a number (money in
/// minor units), null where there is nothing to count or average.
enum Metric {
  received(MetricKind.count),
  acceptedByYou(MetricKind.count),
  acceptedByOperations(MetricKind.count),
  rejected(MetricKind.count),
  unanswered(MetricKind.count),
  acceptance(MetricKind.share),
  delivered(MetricKind.count),
  sales(MetricKind.money),
  averageOrder(MetricKind.money),
  commission(MetricKind.money),
  discounts(MetricKind.money),
  net(MetricKind.money),
  acceptTime(MetricKind.minutes),
  prepTime(MetricKind.minutes),
  chosenTime(MetricKind.minutes),
  late(MetricKind.share),
  readyNotPressed(MetricKind.count),
  captainWait(MetricKind.minutes),
  rating(MetricKind.rating);

  const Metric(this.kind);

  final MetricKind kind;

  num? of(Figures figures) => switch (this) {
    Metric.received => figures.received,
    Metric.acceptedByYou => figures.acceptedByYou,
    Metric.acceptedByOperations => figures.acceptedByOperations,
    Metric.rejected => figures.rejected,
    Metric.unanswered => figures.unanswered,
    Metric.acceptance => figures.acceptanceBp,
    Metric.delivered => figures.delivered,
    Metric.sales => int.parse(figures.sales),
    Metric.averageOrder =>
      figures.averageOrder == null ? null : int.parse(figures.averageOrder!),
    Metric.commission => int.parse(figures.commission),
    Metric.discounts => int.parse(figures.discounts),
    Metric.net => int.parse(figures.net),
    Metric.acceptTime => figures.acceptMinutes,
    Metric.prepTime => figures.prepActualMinutes,
    Metric.chosenTime => figures.prepChosenMinutes,
    Metric.late => figures.lateBp,
    Metric.readyNotPressed => figures.readyNotPressed,
    Metric.captainWait => figures.captainWaitMinutes,
    Metric.rating => figures.rating.average,
  };
}

/// The daily summary's key numbers, in the order the image shows them.
const summaryMetrics = [
  Metric.received,
  Metric.acceptedByYou,
  Metric.rejected,
  Metric.unanswered,
  Metric.delivered,
  Metric.sales,
  Metric.averageOrder,
  Metric.commission,
  Metric.net,
  Metric.acceptTime,
  Metric.prepTime,
  Metric.rating,
];

/// The comparison with the previous period of the same length (RA §11):
/// the arrow and the change in percent, or none when either has no value.
sealed class Change {
  const Change();
}

class NoChange extends Change {
  const NoChange();
}

class Same extends Change {
  const Same();
}

/// Above a previous period that was 0.
class Rose extends Change {
  const Rose();
}

class Moved extends Change {
  const Moved({required this.up, required this.percent});

  final bool up;

  /// The change against the previous value, whole percent.
  final int percent;
}

Change changeOf(num? current, num? previous) {
  if (current == null || previous == null) return const NoChange();
  if (current == previous) return const Same();
  if (previous == 0) return current > 0 ? const Rose() : const NoChange();
  final percent = ((current - previous).abs() * 100 / previous.abs()).round();
  return Moved(up: current > previous, percent: percent);
}

/// A number to one decimal, without a needless «.0».
String oneDecimal(num value) {
  final rounded = (value * 10).round() / 10;
  return rounded == rounded.roundToDouble()
      ? rounded.toInt().toString()
      : rounded.toStringAsFixed(1);
}

extension ReportsTexts on AppLocalizations {
  String reportsPeriodLabel(ReportsPeriod period) => switch (period) {
    ReportsPeriod.today => merchantRatingsPeriodToday,
    ReportsPeriod.yesterday => merchantRatingsPeriodYesterday,
    ReportsPeriod.last7Days => merchantRatingsPeriodLast7Days,
    ReportsPeriod.last30Days => merchantRatingsPeriodLast30Days,
  };

  String metricLabel(Metric metric) => switch (metric) {
    Metric.received => merchantReportsMetricReceived,
    Metric.acceptedByYou => merchantReportsMetricAcceptedByYou,
    Metric.acceptedByOperations => merchantReportsMetricAcceptedByOperations,
    Metric.rejected => merchantReportsMetricRejected,
    Metric.unanswered => merchantReportsMetricUnanswered,
    Metric.acceptance => merchantReportsMetricAcceptance,
    Metric.delivered => merchantReportsMetricDelivered,
    Metric.sales => merchantReportsMetricSales,
    Metric.averageOrder => merchantReportsMetricAverageOrder,
    Metric.commission => merchantReportsMetricCommission,
    Metric.discounts => merchantReportsMetricDiscounts,
    Metric.net => merchantReportsMetricNet,
    Metric.acceptTime => merchantReportsMetricAcceptTime,
    Metric.prepTime => merchantReportsMetricPrepTime,
    Metric.chosenTime => merchantReportsMetricChosenTime,
    Metric.late => merchantReportsMetricLate,
    Metric.readyNotPressed => merchantReportsMetricReadyNotPressed,
    Metric.captainWait => merchantReportsMetricCaptainWait,
    Metric.rating => merchantReportsMetricRating,
  };

  String metricInfo(Metric metric) => switch (metric) {
    Metric.received => merchantReportsInfoReceived,
    Metric.acceptedByYou => merchantReportsInfoAcceptedByYou,
    Metric.acceptedByOperations => merchantReportsInfoAcceptedByOperations,
    Metric.rejected => merchantReportsInfoRejected,
    Metric.unanswered => merchantReportsInfoUnanswered,
    Metric.acceptance => merchantReportsInfoAcceptance,
    Metric.delivered => merchantReportsInfoDelivered,
    Metric.sales => merchantReportsInfoSales,
    Metric.averageOrder => merchantReportsInfoAverageOrder,
    Metric.commission => merchantReportsInfoCommission,
    Metric.discounts => merchantReportsInfoDiscounts,
    Metric.net => merchantReportsInfoNet,
    Metric.acceptTime => merchantReportsInfoAcceptTime,
    Metric.prepTime => merchantReportsInfoPrepTime,
    Metric.chosenTime => merchantReportsInfoChosenTime,
    Metric.late => merchantReportsInfoLate,
    Metric.readyNotPressed => merchantReportsInfoReadyNotPressed,
    Metric.captainWait => merchantReportsInfoCaptainWait,
    Metric.rating => merchantReportsInfoRating,
  };

  /// A figure's value as the screen shows it.
  String metricValue(Metric metric, Figures figures, String currency) {
    final value = metric.of(figures);
    if (value == null) return merchantReportsNoValue;
    return switch (metric.kind) {
      MetricKind.count => '$value',
      MetricKind.share => merchantReportsPercent(oneDecimal(value / 100)),
      MetricKind.minutes => merchantReportsMinutes(oneDecimal(value)),
      MetricKind.money => formatMoney('$value', currency),
      MetricKind.rating => merchantReportsRating(
        formatAverage(value),
        figures.rating.count,
      ),
    };
  }

  String changeText(Change change) => switch (change) {
    NoChange() => merchantReportsNoValue,
    Same() => merchantReportsChangeSame,
    Rose() => merchantReportsChangeNew,
    Moved(:final up, :final percent) =>
      up
          ? merchantReportsChangeUp('$percent')
          : merchantReportsChangeDown('$percent'),
  };
}

/// The business day a period starts on, `YYYY-MM-DD` on the city's clock:
/// the server's `from` is that day's cutoff.
String businessDayOf(DateTime from) {
  final city = from.toUtc().add(cityUtcOffset);
  String two(int value) => value.toString().padLeft(2, '0');
  return '${city.year}-${two(city.month)}-${two(city.day)}';
}

/// The day before a business day, `YYYY-MM-DD`.
String dayBefore(String day) {
  final date = DateTime.parse(
    '${day}T00:00:00Z',
  ).subtract(const Duration(days: 1));
  return date.toIso8601String().substring(0, 10);
}
