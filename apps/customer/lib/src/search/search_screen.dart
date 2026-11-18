import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../browsing/browsing.dart';
import '../browsing/restaurant_list.dart';
import '../device.dart';
import 'search.dart';

/// «البحث» (CU §8.3): one box that searches once typing stops, the recent
/// searches while it is empty, and the restaurants and items in two tabs.
/// Unstyled until the design (the design stop in the root CLAUDE.md).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _box = TextEditingController();
  Timer? _wait;
  String? _query;

  @override
  void dispose() {
    _wait?.cancel();
    _box.dispose();
    super.dispose();
  }

  void _typed(String text) {
    _wait?.cancel();
    final query = searchQuery(text);
    if (query == null) {
      setState(() => _query = null);
      return;
    }
    _wait = Timer(searchDelay, () => _search(query));
  }

  void _search(String query) {
    if (!mounted) return;
    setState(() => _query = query);
    unawaited(ref.read(recentSearchesProvider.notifier).add(query));
  }

  void _pick(String query) {
    _wait?.cancel();
    _box.text = query;
    _search(query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _query;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('search-box'),
          controller: _box,
          autofocus: true,
          maxLength: searchMaxLength,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.customerSearchHint,
            counterText: '',
          ),
          onChanged: _typed,
          onSubmitted: (text) {
            _wait?.cancel();
            if (searchQuery(text) case final query?) _search(query);
          },
        ),
      ),
      body: query == null ? _Recent(onPick: _pick) : _Results(query: query),
    );
  }
}

/// The last searches with «مسح»; a tap searches again.
class _Recent extends ConsumerWidget {
  const _Recent({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recent = ref.watch(recentSearchesProvider).value ?? const [];
    if (recent.isEmpty) return const SizedBox.shrink();
    return ListView(
      children: [
        ListTile(
          title: Text(l10n.customerSearchRecent),
          trailing: TextButton(
            key: const Key('clear-recent'),
            onPressed: () => ref.read(recentSearchesProvider.notifier).clear(),
            child: Text(l10n.customerSearchClear),
          ),
        ),
        for (final each in recent)
          ListTile(
            key: Key('recent-$each'),
            title: Text(each),
            onTap: () => onPick(each),
          ),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = searchProvider(query);
    return switch (ref.watch(provider)) {
      AsyncData(value: null) => Center(
        child: Text(l10n.customerWhereToDeliver),
      ),
      AsyncData(:final value?) when value.isEmpty => Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.customerSearchNoResults(query),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('suggest-restaurant'),
                onPressed: () => context.push(
                  Uri(
                    path: '/search/suggest',
                    queryParameters: {'q': query},
                  ).toString(),
                ),
                child: Text(l10n.customerSuggestOpen),
              ),
            ],
          ),
        ),
      ),
      AsyncData(:final value?) => DefaultTabController(
        length: 2,
        // The tab with results first opens when only items were found.
        initialIndex: value.restaurants.isEmpty ? 1 : 0,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: l10n.customerSearchRestaurants),
                Tab(text: l10n.customerSearchItems),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _Tab(
                    children: [
                      for (final card in value.restaurants)
                        RestaurantTile(card: card),
                    ],
                  ),
                  _Tab(
                    children: [
                      for (final item in value.items) _ItemTile(item: item),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      AsyncError() => ListView(
        children: [
          ListTile(title: Text(l10n.statusError)),
          TextButton(
            onPressed: () => ref.invalidate(provider),
            child: Text(l10n.customerTryAgain),
          ),
        ],
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => children.isEmpty
      ? Center(
          child: Text(AppLocalizations.of(context).customerSearchNothingHere),
        )
      : ListView(children: children);
}

/// An item found (CU §8.3): its name, its restaurant and price, the
/// restaurant's state when it is not open; a tap opens the restaurant's
/// page.
class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item});

  final SearchItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(clockProvider)();
    final amount = switch (item.fromPrice) {
      final from? => l10n.formatMoney(from.amount, from.currency),
      null => l10n.formatMoney(item.price!.amount, item.price!.currency),
    };
    return ListTile(
      key: Key('item-${item.id}'),
      title: Text(item.name),
      subtitle: Text(
        [
          l10n.customerSearchItemLine(
            item.restaurantName,
            item.fromPrice == null ? amount : l10n.customerFromPrice(amount),
          ),
          ?restaurantBadge(
            l10n,
            RestaurantState.ofCard(item.restaurantState),
            now,
          ),
        ].join(' · '),
      ),
      onTap: () => context.push('/restaurants/${item.restaurantId}'),
    );
  }
}
