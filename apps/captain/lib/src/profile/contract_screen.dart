import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../joining/application_screen.dart';
import 'profile.dart';

/// CA §12.3–12.4 «العقد والعدة» (slice 2.35a): the phase and the dates, the
/// early exit's explanation (C17), the kit issued and the deposit with its
/// instalments. The contract's scan waits for its signed link on the API's
/// host. Unstyled until the design.
class ContractScreen extends ConsumerWidget {
  const ContractScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final found = ref.watch(contractProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainProfileContract)),
      body: switch (found) {
        AsyncData(:final value) => ListView(
          children: [
            ...switch (value.contract) {
              final contract? => [
                ListTile(
                  key: const Key('contract-phase'),
                  title: Text(
                    l10n.captainContractPhase(phaseText(l10n, contract.phase)),
                  ),
                ),
                ListTile(
                  title: Text(
                    l10n.captainContractStart(
                      dayText(l10n, contract.startsOn.toString()),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    l10n.captainContractProbationEnd(
                      dayText(l10n, contract.probationEndsOn.toString()),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    l10n.captainContractCommitmentEnd(
                      dayText(l10n, contract.commitmentEndsOn.toString()),
                    ),
                  ),
                ),
              ],
              null => [ListTile(title: Text(l10n.captainContractNone))],
            },
            ListTile(title: Text(l10n.captainEarlyExitTitle)),
            ListTile(title: Text(l10n.captainEarlyExitNoPenalty)),
            ListTile(title: Text(l10n.captainEarlyExitKit)),
            ListTile(title: Text(l10n.captainEarlyExitFlag)),
            ListTile(title: Text(l10n.captainContractEndViaSupport)),
            ListTile(title: Text(l10n.captainKitTitle)),
            if (value.kit.isEmpty) ListTile(title: Text(l10n.captainKitNone)),
            for (final item in value.kit)
              ListTile(
                title: Text(
                  item.size == null
                      ? l10n.captainKitLine(item.label, '${item.quantity}')
                      : l10n.captainKitLineSized(
                          item.label,
                          item.size!,
                          '${item.quantity}',
                        ),
                ),
              ),
            if (value.deposit.amount case final amount?) ...[
              ListTile(
                key: const Key('contract-deposit'),
                title: Text(
                  l10n.captainDepositLine(
                    l10n.formatMoney(amount.amount, amount.currency),
                    l10n.formatMoney(value.deposit.paid, amount.currency),
                  ),
                ),
              ),
              ListTile(
                key: const Key('contract-deposit-left'),
                title: Text(
                  l10n.captainDepositLeft(
                    l10n.formatMoney(
                      (BigInt.parse(amount.amount) -
                              BigInt.parse(value.deposit.paid))
                          .toString(),
                      amount.currency,
                    ),
                  ),
                ),
              ),
              if (value.deposit.instalment case final instalment?)
                ListTile(
                  title: Text(
                    l10n.captainDepositInstalment(
                      l10n.formatMoney(instalment.amount, instalment.currency),
                    ),
                  ),
                ),
              ListTile(title: Text(l10n.captainDepositRefund)),
            ],
          ],
        ),
        AsyncError() => Column(
          children: [
            Text(l10n.signInError),
            TextButton(
              onPressed: () => ref.invalidate(contractProvider),
              child: Text(l10n.captainRetry),
            ),
          ],
        ),
        _ => const LinearProgressIndicator(),
      },
    );
  }
}
