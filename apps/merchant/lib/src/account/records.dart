import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show Size;

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../api.dart';
import 'account.dart';

typedef StatementSummary = MerchantStatementListDtoOutputStatementsInner;
typedef Statement = MerchantStatementDtoOutput;
typedef StatementLine = MerchantStatementDtoOutputLinesInner;
typedef StatementLineKind = MerchantStatementDtoOutputLinesInnerKindEnum;
typedef Decider = MerchantStatementDtoOutputLinesInnerDecidedByEnum;
typedef ReceiptSummary = MerchantReceiptListDtoOutputReceiptsInner;
typedef Receipt = MerchantReceiptDtoOutput;

/// RA §12.3 «الكشوف»: `GET /v1/merchant/statements`, the latest statements
/// newest first with their status; read while the list shows.
final statementsProvider = FutureProvider.autoDispose<List<StatementSummary>>((
  ref,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantRecordsStatements();
  return answer.data!.statements.toList();
});

/// One statement, `GET /v1/merchant/statements/{statementId}`: its lines
/// never change, its status does, so it is read while its screen shows.
final statementProvider = FutureProvider.autoDispose.family<Statement, String>((
  ref,
  statementId,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantRecordsStatement(statementId: statementId);
  return answer.data!;
});

/// RA §12.4 «الإيصالات»: `GET /v1/merchant/receipts`, newest first.
final receiptsProvider = FutureProvider.autoDispose<List<ReceiptSummary>>((
  ref,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantRecordsReceipts();
  return answer.data!.receipts.toList();
});

/// One receipt, `GET /v1/merchant/receipts/{receiptId}`.
final receiptProvider = FutureProvider.autoDispose.family<Receipt, String>((
  ref,
  receiptId,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantRecordsReceipt(receiptId: receiptId);
  return answer.data!;
});

/// Shares a PNG of the statement through the share sheet («مشاركة كصورة»,
/// RA §12.3: an image only, owner decision 2026-11-16); tests record it.
typedef ImageSharer = Future<void> Function(Uint8List png, String name);

final imageSharerProvider = Provider<ImageSharer>(
  (ref) => (png, name) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(png, mimeType: 'image/png', name: name)],
        fileNameOverrides: [name],
      ),
    );
  },
);

/// The longest side of a shared image, in pixels: a busy week's statement
/// is thousands of points tall, and many Android GPUs refuse a texture
/// above 8192 pixels (or run out of memory before).
const maxImageSide = 8192.0;

/// The pixel ratio to render a statement of [size] at: the screen's, lowered
/// so its longest side stays within [maxImageSide].
double imageRatio(double screenRatio, Size size) {
  final longest = size.longestSide;
  if (longest <= 0) return screenRatio;
  return math.min(screenRatio, maxImageSide / longest);
}

/// What a read failed with: a cashier (`403`, R10), a statement or receipt
/// this restaurant does not have (`404`, `400`: a push of another
/// restaurant on this device, or a bad id), or anything else, worth a retry.
enum RecordsFailure { ownersOnly, notFound, other }

RecordsFailure failureOf(Object error) => switch (error) {
  DioException(:final response?) when response.statusCode == 403 =>
    RecordsFailure.ownersOnly,
  DioException(:final response?)
      when response.statusCode == 404 || response.statusCode == 400 =>
    RecordsFailure.notFound,
  _ => RecordsFailure.other,
};

/// A statement's status by its name, whichever generated enum carries it.
enum StatementStatus { unpaid, partlyPaid, paid }

StatementStatus? statusOf(String? name) => switch (name) {
  'unpaid' => StatementStatus.unpaid,
  'partlyPaid' => StatementStatus.partlyPaid,
  'paid' => StatementStatus.paid,
  _ => null,
};

/// RA §12.3: each order, then the exceptions, then the payments, each in
/// the server's order.
({
  List<StatementLine> orders,
  List<StatementLine> exceptions,
  List<StatementLine> payments,
})
linesOf(Iterable<StatementLine> lines) => (
  orders: [
    for (final line in lines)
      if (line.kind == StatementLineKind.order) line,
  ],
  exceptions: [
    for (final line in lines)
      if (line.kind == StatementLineKind.exception) line,
  ],
  payments: [
    for (final line in lines)
      if (line.kind == StatementLineKind.payment) line,
  ],
);

extension RecordsTexts on AppLocalizations {
  /// RA §12.3: «غير مسدّد», «مسدّد جزئياً» or «مسدّد».
  String statusText(StatementStatus status) => switch (status) {
    StatementStatus.unpaid => merchantStatementUnpaid,
    StatementStatus.partlyPaid => merchantStatementPartlyPaid,
    StatementStatus.paid => merchantStatementPaid,
  };

  /// A statement in the list: its settlement day and total due.
  String statementSummary(StatementSummary statement) =>
      merchantStatementSummary(
        formatDate(statement.cutoff),
        formatMoney(statement.totalDue, statement.currency),
      );

  /// The period since the previous statement, as on the printed one.
  String statementPeriod(Statement statement) {
    String moment(DateTime at) => '${formatDate(at)} ${formatTime(at)}';
    final to = moment(statement.cutoff);
    return switch (statement.periodFrom) {
      final from? => merchantStatementPeriod(moment(from), to),
      null => merchantStatementPeriodFirst(to),
    };
  }

  /// RA §12.5 «من قرّر»: the FOX DROP staff member by name, else who
  /// posted it.
  String? deciderText(StatementLine line) =>
      deciderNameText(line.decidedBy?.name, line.decidedByName);

  /// The same by the actor type's name, whichever generated enum carries it
  /// (the statement's or «الحساب»'s week).
  String? deciderNameText(String? type, String? name) => switch (type) {
    'admin' => merchantStatementDecidedBy(name ?? merchantDeciderPlatform),
    'system' => merchantStatementDecidedBy(merchantDeciderSystem),
    'merchant' => merchantStatementDecidedBy(merchantDeciderRestaurant),
    'captain' => merchantStatementDecidedBy(merchantDeciderCaptain),
    'customer' => merchantStatementDecidedBy(merchantDeciderCustomer),
    _ => null,
  };

  /// RA §12.3: the totals, as the desk prints them (AP §8.7).
  List<String> statementTotals(Statement statement) {
    String money(String amount) => formatMoney(amount, statement.currency);
    return [
      for (final (label, amount) in [
        (merchantStatementItemsValue, statement.itemsValue),
        (merchantStatementCommission, statement.commission),
        (merchantStatementDiscountShare, statement.discountShare),
        (merchantStatementExceptions, statement.exceptions),
        (merchantStatementWeekTotal, statement.weekTotal),
        (merchantStatementPreviousDue, statement.previousDue),
        (merchantStatementPaidSince, statement.paid),
        (merchantStatementEarlierUnpaid, statement.earlierUnpaid),
        (merchantStatementTotalDue, statement.totalDue),
      ])
        merchantStatementLine(label, money(amount)),
    ];
  }

  /// RA §12.4: «في المكتب» or «زيارة ميدانية».
  String methodText(String method) => method == 'field'
      ? merchantReceiptMethodField
      : merchantReceiptMethodOffice;

  /// A receipt in the list: its number and what it moved.
  String receiptSummary(ReceiptSummary receipt) {
    final total = formatMoney(receipt.total, receipt.currency);
    return receipt.type.name == 'merchantPayout'
        ? merchantReceiptPayout(receipt.number, total)
        : merchantReceiptPayment(receipt.number, total);
  }

  /// A currency line: its amount, and its base value when another currency.
  String receiptLine(String currency, String amount, String base, String to) =>
      currency == to
      ? formatMoney(amount, currency)
      : merchantReceiptLineBase(
          formatMoney(amount, currency),
          formatMoney(base, to),
        );

  /// What the restaurant owed (+) or was owed (−), before or after.
  String dueText(String due, String currency) {
    final amount = BigInt.parse(due);
    if (amount == BigInt.zero) return merchantReceiptDueNone;
    return amount.isNegative
        ? merchantAccountCredit(formatMoney((-amount).toString(), currency))
        : merchantReceiptDueOwed(formatMoney(amount.toString(), currency));
  }
}

/// Reused from «الحساب»: an exception's label (RA §12.5).
String exceptionLabel(AppLocalizations l10n, StatementLine line) =>
    l10n.causeNameLabel(line.cause?.name, line.reason);
