import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../checkout/codes.dart';
import 'my_codes.dart';

/// «أكوادي» (CU §12.4): «متاحة» and «منتهية». Each code shows its value,
/// its conditions (minimum, restaurants, zones, hours), «ينتهي {التاريخ}»
/// and the uses left, with «استخدم»; an ended one says when it was used or
/// ended. Opened from a banner's code (CU §8.1, slice 2.27c), «متاحة»
/// shows that code first and selected, or says it is not available to the
/// customer now. Unstyled until the design.
class MyCodesScreen extends ConsumerWidget {
  const MyCodesScreen({super.key, this.shown});

  /// The banner's code, as the customer types it; null otherwise.
  final String? shown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final codes = ref.watch(myCodesProvider);
    Future<void> reload() => ref.refresh(myCodesProvider.future);
    Widget tab(List<Widget> rows) => RefreshIndicator(
      onRefresh: reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: rows.isEmpty
            ? [ListTile(title: Text(l10n.customerCodesEmpty))]
            : rows,
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.customerMyCodesTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.customerCodesTabAvailable),
              Tab(text: l10n.customerCodesTabEnded),
            ],
          ),
        ),
        body: switch (codes) {
          AsyncData(value: null) => Center(
            child: Text(l10n.customerCodesNoPoint),
          ),
          AsyncData(value: final MyCodes mine) => TabBarView(
            children: [
              tab([
                ..._shownFirst(l10n, mine),
                for (final code in mine.codes.where(
                  (c) => c.ended == null && c.code != shown,
                ))
                  _CodeTile(code: code, currency: mine.currency ?? ''),
              ]),
              tab([
                for (final code in mine.codes.where((c) => c.ended != null))
                  _CodeTile(code: code, currency: mine.currency ?? ''),
              ]),
            ],
          ),
          AsyncError() => Center(
            child: TextButton(
              onPressed: () => ref.invalidate(myCodesProvider),
              child: Text(l10n.customerTryAgain),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  // The banner's code first and selected when the customer may use it,
  // else the line that says it is not available now.
  List<Widget> _shownFirst(AppLocalizations l10n, MyCodes mine) {
    final code = shown;
    if (code == null) return const [];
    final found = mine.codes
        .where((c) => c.ended == null && c.code == code)
        .firstOrNull;
    return [
      if (found != null)
        _CodeTile(code: found, currency: mine.currency ?? '', selected: true)
      else
        ListTile(
          key: const Key('my-code-not-available'),
          title: Text(l10n.customerCodeNotAvailable(code)),
        ),
    ];
  }
}

class _CodeTile extends StatelessWidget {
  const _CodeTile({
    required this.code,
    required this.currency,
    this.selected = false,
  });

  final MyCode code;
  final String currency;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ended = code.ended;
    final hours = code.hours;
    final lines = [
      codeValueText(
        l10n,
        kind: CodeKind.values.byName(code.kind.name),
        percentBp: code.percentBp,
        amount: code.amount,
        maxDiscount: code.maxDiscount,
        currency: currency,
      ),
      if (code.minOrder case final minimum?)
        l10n.customerCodeMinimum(l10n.formatMoney(minimum, currency)),
      if (code.restaurants.isNotEmpty)
        l10n.customerCodeRestaurants(
          code.restaurants.map((r) => r!.name).join(l10n.listSeparator),
        ),
      if (code.zones.isNotEmpty)
        l10n.customerCodeZones(code.zones.join(l10n.listSeparator)),
      if (hours != null)
        l10n.customerCodeHours(
          l10n.formatMinuteOfDay(hours.startMinute),
          l10n.formatMinuteOfDay(hours.endMinute),
        ),
      if (ended == null) ...[
        l10n.customerCodeExpires(l10n.formatDate(code.validTo)),
        if (code.usesLeft case final left?) l10n.customerCodeUsesLeft(left),
      ] else if (ended.reason ==
          CustomerCodesDtoOutputCodesInnerEndedReasonEnum.used)
        l10n.customerCodeUsedOn(l10n.formatDate(ended.at))
      else
        l10n.customerCodeExpiredOn(l10n.formatDate(ended.at)),
    ];
    return ListTile(
      key: Key('my-code-${code.code}'),
      selected: selected,
      title: Text(code.code),
      subtitle: Text(lines.join('\n')),
      trailing: ended != null
          ? null
          : TextButton(
              key: Key('use-code-${code.code}'),
              onPressed: () => context.push(useCodePath(code)),
              child: Text(l10n.customerCodeUse),
            ),
    );
  }
}
