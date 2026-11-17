import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../reports/photo_fields.dart';
import '../reports/report_photos.dart';
import 'browsing.dart';
import 'price_report.dart';

/// «أبلغ عن سعر مختلف» (CU §9.5): the item from the menu, the shop's price in
/// the menu's currency, a note and one photo, all optional. Sending answers
/// «شكراً، سنتحقق من السعر» and goes back to the restaurant. Unstyled until
/// the design.
class PriceReportScreen extends ConsumerStatefulWidget {
  const PriceReportScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  ConsumerState<PriceReportScreen> createState() => _PriceReportScreenState();
}

class _PriceReportScreenState extends ConsumerState<PriceReportScreen> {
  String? _itemId;
  final _price = TextEditingController();
  final _note = TextEditingController();
  final _photos = <ReportPhoto>[];
  bool _sending = false;

  @override
  void dispose() {
    _price.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(restaurantPageProvider(widget.restaurantId)).value;
    final items = [...?page?.menu.expand((category) => category.items)];
    // The menu's prices are in the city's base currency, as the shop price.
    final currency = items
        .map((item) => item.price?.currency)
        .nonNulls
        .firstOrNull;
    final typed = _price.text.trim();
    final shopPrice = typed.isEmpty || currency == null
        ? null
        : minorOfTyped(typed, currency);
    final priceProblem = typed.isNotEmpty && shopPrice == null;
    final note = _note.text.trim();

    Future<void> send() async {
      setState(() => _sending = true);
      final outcome = await ref
          .read(priceReportProvider(widget.restaurantId))
          .send(
            itemId: _itemId,
            shopPrice: shopPrice,
            note: note.isEmpty ? null : note,
            photo: _photos.firstOrNull,
          );
      if (!mounted) return;
      setState(() => _sending = false);
      final messenger = ScaffoldMessenger.of(this.context);
      void say(String text) =>
          messenger.showSnackBar(SnackBar(content: Text(text)));
      switch (outcome) {
        case PriceReportOutcome.sent:
          say(l10n.customerPriceThanks);
          this.context.pop();
        case PriceReportOutcome.today:
          say(l10n.customerPriceToday);
          this.context.pop();
        case PriceReportOutcome.photoFailed:
          say(l10n.customerReportPhotoFailed);
        case PriceReportOutcome.failed:
          say(l10n.customerTryAgain);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerReportPrice)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: DropdownButtonFormField<String?>(
              key: const Key('price-item'),
              initialValue: _itemId,
              decoration: InputDecoration(labelText: l10n.customerPriceItem),
              items: [
                DropdownMenuItem(child: Text(l10n.customerPriceNoItem)),
                for (final item in items)
                  DropdownMenuItem(value: item.id, child: Text(item.name)),
              ],
              onChanged: (value) => setState(() => _itemId = value),
            ),
          ),
          if (currency != null)
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: TextField(
                key: const Key('price-shop'),
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.customerShopPrice,
                  suffixText: l10n.currencySymbol(currency),
                  errorText: priceProblem
                      ? l10n.customerShopPriceInvalid
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: TextField(
              key: const Key('price-note'),
              controller: _note,
              maxLength: 300,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.customerReportNote),
              onChanged: (_) => setState(() {}),
            ),
          ),
          ListTile(title: Text(l10n.customerReportPhoto)),
          PhotoFields(
            photos: _photos,
            max: 1,
            onChanged: () => setState(() {}),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: FilledButton(
              key: const Key('price-send'),
              onPressed: !priceProblem && !_sending ? send : null,
              child: Text(l10n.customerReportSend),
            ),
          ),
        ],
      ),
    );
  }
}
