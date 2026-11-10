import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'alerts.dart';
import 'commands.dart';
import 'texts.dart';
import 'work.dart';

/// The full-screen offer (CA §8.2) with its countdown on the server's clock;
/// «قبول» and «رفض» (CA §8.3). Never the customer's name, phone or exact
/// address (C2). Unstyled until the design; the map waits for Phase 2.
class OfferSheet extends ConsumerWidget {
  const OfferSheet({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(tickProvider);
    final clock = ref.watch(serverClockProvider);
    final sending = ref.watch(commandsProvider).contains(offer.id);
    final pay = offer.pay;
    final preparation = offer.preparation;
    // CA §9.10.1: «استلام من كابتن», from the first captain; nothing to pay.
    final handover = offer.handover;
    final readyAt = preparation.readyAt;
    Future<void> answer(bool accept) async {
      // The sheet closes once answered, so the message goes to the home's.
      final messenger = ScaffoldMessenger.of(context);
      final answered = ref.read(answeredProvider);
      answered.offers.add(offer.id);
      if (accept) answered.orders.add(offer.orderId);
      final commands = ref.read(commandsProvider.notifier);
      final notice = accept
          ? await commands.accept(offer.id)
          : await commands.decline(offer.id);
      // Refused for another reason, the offer is still open: it shows and
      // rings again.
      if (notice != null && notice is! OfferUnavailable) {
        answered.offers.remove(offer.id);
        answered.orders.remove(offer.orderId);
      }
      if (notice != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.noticeText(notice))),
        );
      }
    }

    return Material(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            Text(l10n.captainNewOffer),
            if (handover != null) Text(l10n.captainHandoverOffer),
            if (offer.fromOperations) Text(l10n.captainOfferFromOperations),
            Text(l10n.formatCountdown(clock.until(offer.expiresAt))),
            Text(
              pay == null
                  ? l10n.captainOfferNoPay
                  : l10n.formatMoney(pay.amount, pay.currency),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(l10n.captainWaitingPayMayApply),
            Text(
              handover == null
                  ? l10n.captainOfferRestaurant(
                      offer.restaurant.name,
                      l10n.formatDistance(offer.restaurant.distanceMetres),
                    )
                  : l10n.captainHandoverFrom(
                      handover.fromCaptainName,
                      l10n.formatDistance(offer.restaurant.distanceMetres),
                    ),
            ),
            Text(
              l10n.captainOfferCustomer(
                offer.customer.neighbourhood,
                l10n.formatDistance(offer.customer.tripMetres),
              ),
            ),
            Text(
              handover != null
                  ? l10n.captainPayNothing
                  : l10n.captainPayToRestaurant(
                      l10n.formatMoney(
                        offer.pickupPayment.amount,
                        offer.pickupPayment.currency,
                      ),
                    ),
            ),
            Text(
              l10n.captainCollectFromCustomer(
                l10n.formatMoney(offer.collect.amount, offer.collect.currency),
              ),
            ),
            if (handover == null)
              Text(
                preparation.ready || readyAt == null
                    ? l10n.captainReady
                    : l10n.captainOfferPreparing(
                        (clock.until(readyAt).inSeconds / 60).ceil(),
                      ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: sending ? null : () => answer(true),
              child: Text(sending ? l10n.captainSending : l10n.captainAccept),
            ),
            TextButton(
              onPressed: sending ? null : () => answer(false),
              child: Text(l10n.captainDecline),
            ),
          ],
        ),
      ),
    );
  }
}
