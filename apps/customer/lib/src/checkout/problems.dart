import 'package:core_l10n/core_l10n.dart';

import '../browsing/browsing.dart';
import '../cart/cart.dart';
import 'quote.dart';

/// What the customer can do about a problem (CU Appendix C).
enum ProblemAction { none, remove, acceptPrice, addItems, changeAddress, retry }

/// A blocking problem as checkout shows it, at the top (CU §10.6).
class ProblemView {
  const ProblemView(this.text, this.action, {this.lineKey, this.newPrice});

  final String text;
  final ProblemAction action;

  /// The key of the cart line it is about ([CartLine.key]): the action acts
  /// on that line, even when the cart changed since the quote.
  final String? lineKey;

  /// The quote's unit price for «موافق» on a new price.
  final String? newPrice;
}

/// The problems of [quote] with the texts of CU Appendix C and §5.5. The
/// server lists every problem; each blocks ordering.
List<ProblemView> problemViews(
  AppLocalizations l10n,
  Quote quote,
  Cart cart,
  DateTime now,
) {
  final views = <ProblemView>[];
  var unpriced = false;
  for (final problem in quote.problems) {
    final index = problem.line;
    final cartLine = index != null && index < cart.lines.length
        ? cart.lines[index]
        : null;
    final quoteLine = index != null && index < quote.lines.length
        ? quote.lines[index]
        : null;
    final name = quoteLine?.name ?? cartLine?.name ?? '';
    switch (problem.code) {
      case ProblemCode.updateRequired:
        views.add(ProblemView(l10n.customerUpdateRequired, ProblemAction.none));
      case ProblemCode.maintenance:
        views.add(ProblemView(l10n.customerMaintenance, ProblemAction.none));
      case ProblemCode.platformClosed:
        final opensAt = problem.opensAt;
        views.add(
          ProblemView(
            opensAt == null
                ? l10n.customerPlatformClosedNow
                : l10n.customerPlatformClosed(l10n.formatTime(opensAt)),
            ProblemAction.none,
          ),
        );
      case ProblemCode.outsideZones || ProblemCode.notCovered:
        views.add(
          ProblemView(l10n.customerNotCovered, ProblemAction.changeAddress),
        );
      case ProblemCode.restaurantClosed:
        views.add(
          ProblemView(
            restaurantStateText(
                  l10n,
                  RestaurantState.ofQuote(quote.restaurant),
                  now,
                ) ??
                l10n.customerRestaurantClosed,
            ProblemAction.none,
          ),
        );
      case ProblemCode.belowMinimumOrder:
        views.add(
          ProblemView(
            l10n.customerBelowMinimum(
              l10n.formatMoney(quote.minimumOrder.missing, quote.currency),
            ),
            ProblemAction.addItems,
          ),
        );
      case ProblemCode.oneOrderAtATime:
        views.add(
          ProblemView(l10n.customerOneOrderAtATime, ProblemAction.none),
        );
      case ProblemCode.activeOrderLimit:
        views.add(
          ProblemView(l10n.customerActiveOrderLimit, ProblemAction.none),
        );
      case ProblemCode.noCaptainNearby:
        views.add(ProblemView(l10n.customerNoCaptain, ProblemAction.retry));
      case ProblemCode.priceChanged:
        final newPrice = quoteLine?.unitPrice;
        views.add(
          ProblemView(
            l10n.customerPriceChanged(
              name,
              l10n.formatMoney(cartLine?.unitPrice ?? '0', quote.currency),
              l10n.formatMoney(newPrice ?? '0', quote.currency),
            ),
            newPrice == null ? ProblemAction.remove : ProblemAction.acceptPrice,
            lineKey: cartLine?.key,
            newPrice: newPrice,
          ),
        );
      case ProblemCode.itemNotFound ||
          ProblemCode.itemUnavailable ||
          ProblemCode.optionNotFound ||
          ProblemCode.optionUnavailable ||
          ProblemCode.optionsInvalid:
        views.add(
          ProblemView(
            l10n.customerItemGone(name),
            ProblemAction.remove,
            lineKey: cartLine?.key,
          ),
        );
      default:
        // The restaurant's prices or the city's money settings cannot be
        // priced now (minimum_not_in_base_currency, delivery_unpriced,
        // rates_unavailable, captain_pay_unset, price_not_in_base_currency):
        // nothing the customer can fix. One line for all of them.
        if (!unpriced) {
          unpriced = true;
          views.add(ProblemView(l10n.customerCannotPrice, ProblemAction.none));
        }
    }
  }
  return views;
}
