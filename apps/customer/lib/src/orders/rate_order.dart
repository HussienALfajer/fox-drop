import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../content.dart';
import '../device.dart';
import 'order_live.dart';

/// CU §12.1: a comment of up to 300 characters (fixed).
const maxRatingComment = 300;

/// The two parts of a rating, sent apart (CU §12.1).
enum RatingParty { restaurant, captain }

/// Content's list of reason chips for the stars (AP Appendix B): 1–2, 3,
/// 4–5; the server checks the same.
String ratingReasonList(RatingParty party, int stars) {
  final band = stars <= 2 ? 'low' : (stars == 3 ? 'mid' : 'high');
  return '${party.name}_rating_$band';
}

/// One part as the customer fills it: the stars (required to send it), the
/// chosen chips' codes and the comment.
class RatingDraft {
  const RatingDraft({this.stars, this.reasons = const {}, this.comment = ''});

  final int? stars;
  final Set<String> reasons;
  final String comment;

  bool get ready => stars != null;

  /// Other stars change the list of chips, so the chips chosen go.
  RatingDraft withStars(int value) => RatingDraft(
    stars: value,
    reasons: value == stars ? reasons : const {},
    comment: comment,
  );

  RatingDraft toggle(String code) => RatingDraft(
    stars: stars,
    reasons: reasons.contains(code)
        ? ({...reasons}..remove(code))
        : {...reasons, code},
    comment: comment,
  );

  RatingDraft withComment(String value) =>
      RatingDraft(stars: stars, reasons: reasons, comment: value);
}

/// The parts the order screen still offers (CU §12.1): those not sent while
/// the window is ahead on the server's clock; the captain's only when a
/// captain delivered the order. Empty: nothing to rate.
Set<RatingParty> ratingPartsLeft(CustomerOrder order, DateTime now) {
  final rating = order.rating;
  final until = rating?.until;
  if (rating == null || until == null || !now.isBefore(until)) return {};
  return {
    if (rating.restaurant == null) RatingParty.restaurant,
    if (rating.captainRatable && rating.captain == null) RatingParty.captain,
  };
}

/// What «إرسال التقييم» came to.
enum RateOutcome {
  /// «شكراً لتقييمك».
  sent,

  /// The window closed meanwhile, or a part was already sent from another
  /// phone (Q16: never edited): the order screen shows what is left.
  refused,

  /// The panel changed the chips: they are read again and the customer
  /// chooses again.
  reasonsChanged,

  /// No answer or another refusal: the customer may try again.
  failed,
}

/// The customer's rating of one order: `POST /v1/customer/orders/{orderId}/
/// rating` with the parts filled, then the order's feed reads it again. A
/// sent part is never edited, so the command takes no key: a repeat after a
/// lost answer is `already_rated`, and the order then shows it.
class RateOrder {
  RateOrder(this._ref, this.orderId);

  final Ref _ref;
  final String orderId;

  Future<RateOutcome> send(Map<RatingParty, RatingDraft> parts) async {
    final alive = _ref.keepAlive();
    final api = _ref.read(coreApiProvider).getCustomerApi();
    String? comment(RatingDraft draft) {
      final text = draft.comment.trim();
      return text.isEmpty ? null : text;
    }

    final restaurant = parts[RatingParty.restaurant];
    final captain = parts[RatingParty.captain];
    try {
      await api.customerOrdersRate(
        orderId: orderId,
        customerRateOrderDto: CustomerRateOrderDto(
          (b) => b
            ..restaurant = restaurant == null || !restaurant.ready
                ? null
                : (CustomerRateOrderDtoRestaurantBuilder()
                    ..stars = restaurant.stars
                    ..reasons.addAll(restaurant.reasons)
                    ..comment = comment(restaurant))
            ..captain = captain == null || !captain.ready
                ? null
                : (CustomerRateOrderDtoCaptainBuilder()
                    ..stars = captain.stars
                    ..reasons.addAll(captain.reasons)
                    ..comment = comment(captain)),
        ),
      );
      _refresh();
      return RateOutcome.sent;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == null || status >= 500) return RateOutcome.failed;
      switch (AuthRefusal.of(error).error) {
        case 'already_rated' || 'rating_closed' || 'not_ratable':
          _refresh();
          return RateOutcome.refused;
        case 'unknown_reason':
          _ref.invalidate(contentProvider);
          return RateOutcome.reasonsChanged;
        default:
          return RateOutcome.failed;
      }
    } finally {
      alive.close();
    }
  }

  void _refresh() => _ref.read(orderFeedProvider(orderId)).refresh();
}

final rateOrderProvider = Provider.autoDispose.family<RateOrder, String>(
  RateOrder.new,
);

/// CU §12.1: the rating sheet opens by itself once after the delivery; this
/// phone remembers each order it opened for.
class RatingSheetOnce {
  RatingSheetOnce(this._ref);

  final Ref _ref;

  static String _key(String orderId) => 'rating_sheet_shown:$orderId';

  /// True the first time only, for an order with a part left to rate.
  Future<bool> take(String orderId) async {
    final device = _ref.read(deviceStoreProvider);
    if (await device.read(_key(orderId)) != null) return false;
    await device.write(_key(orderId), '1');
    return true;
  }
}

final ratingSheetOnceProvider = Provider<RatingSheetOnce>(RatingSheetOnce.new);
