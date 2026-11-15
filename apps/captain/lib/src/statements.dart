import 'dart:typed_data';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'api.dart';
import 'work/work.dart';

typedef StatementSummary = CaptainStatementListDtoOutputStatementsInner;
typedef Statement = CaptainStatementDtoOutput;

/// CA §10.7: `GET /v1/captain/statements`, newest first, read while the list
/// shows and again after every read of the captain's state (the settlement's
/// receipts send `captain.availability_changed`).
final statementsProvider = FutureProvider.autoDispose<List<StatementSummary>>((
  ref,
) async {
  ref.watch(workProvider.select((live) => live.value?.value));
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainStatementsList();
  return answer.data!.statements.toList();
});

/// One statement, `GET /v1/captain/statements/{statementId}`; a statement
/// never changes, so it is read once while its screen shows.
final statementProvider = FutureProvider.autoDispose.family<Statement, String>((
  ref,
  statementId,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainStatementsRead(statementId: statementId);
  return answer.data!;
});

/// Shares a PNG of the statement through the phone's share sheet
/// («مشاركة كصورة», CA §10.7); tests record it instead.
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

extension StatementTexts on AppLocalizations {
  /// A statement in the list: when, and what was paid or carried.
  String summaryText(StatementSummary statement) {
    final when = formatDate(statement.createdAt);
    final payout = statement.payout;
    final what = payout != null
        ? captainStatementPaid(formatMoney(payout.amount, payout.currency))
        : captainStatementCarried(
            formatMoney(statement.carriedOut, statement.currency),
          );
    return '$when: $what';
  }

  /// The period since the previous payout, as on the printed statement.
  String periodText(Statement statement) {
    String moment(DateTime at) => '${formatDate(at)} ${formatTime(at)}';
    final to = moment(statement.createdAt);
    return switch (statement.periodFrom) {
      final from? => captainStatementPeriod(moment(from), to),
      null => captainStatementPeriodFirst(to),
    };
  }

  /// CA §10.7: the statement's lines, as the desk prints them (AP §8.5.5).
  List<String> statementLines(Statement statement) {
    String money(String amount) => formatMoney(amount, statement.currency);
    final payout = statement.payout;
    return [
      for (final (label, amount) in [
        (captainStatementCarriedIn, money(statement.carriedIn)),
        (captainStatementBasePay, money(statement.basePay)),
        (captainStatementDistancePay, money(statement.distancePay)),
        (captainStatementWaitingPay, money(statement.waitingPay)),
        (captainStatementPeakBonus, money(statement.peakBonus)),
        (captainStatementBonuses, money(statement.bonuses)),
        (captainStatementCharges, money(statement.charges)),
        (captainStatementInstalments, money(statement.instalments)),
        (captainStatementAdjustments, money(statement.adjustments)),
        (captainStatementBalance, money(statement.balance)),
        (
          captainStatementPaidLine,
          payout == null
              ? money('0')
              : formatMoney(payout.amount, payout.currency),
        ),
        (captainStatementCollected, money(statement.collected)),
        (captainStatementCarriedOut, money(statement.carriedOut)),
      ])
        captainStatementLine(label, amount),
    ];
  }
}
