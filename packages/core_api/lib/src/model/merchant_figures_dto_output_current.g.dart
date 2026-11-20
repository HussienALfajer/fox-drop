// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output_current.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutputCurrent
    extends MerchantFiguresDtoOutputCurrent {
  @override
  final int received;
  @override
  final int acceptedByYou;
  @override
  final int acceptedByOperations;
  @override
  final int rejected;
  @override
  final BuiltList<MerchantFiguresDtoOutputCurrentRejectionsInner> rejections;
  @override
  final int unanswered;
  @override
  final int? acceptanceBp;
  @override
  final int delivered;
  @override
  final String sales;
  @override
  final String? averageOrder;
  @override
  final String commission;
  @override
  final String discounts;
  @override
  final String net;
  @override
  final num? acceptMinutes;
  @override
  final num? prepActualMinutes;
  @override
  final num? prepChosenMinutes;
  @override
  final int? lateBp;
  @override
  final int readyNotPressed;
  @override
  final num? captainWaitMinutes;
  @override
  final MerchantFiguresDtoOutputCurrentRating rating;
  @override
  final BuiltList<MerchantFiguresDtoOutputCurrentTopByQuantityInner>
  topByQuantity;
  @override
  final BuiltList<MerchantFiguresDtoOutputCurrentTopByQuantityInner> topBySales;
  @override
  final BuiltList<MerchantFiguresDtoOutputCurrentHoursInner> hours;
  @override
  final MerchantFiguresDtoOutputCurrentPauseMinutes pauseMinutes;

  factory _$MerchantFiguresDtoOutputCurrent([
    void Function(MerchantFiguresDtoOutputCurrentBuilder)? updates,
  ]) => (MerchantFiguresDtoOutputCurrentBuilder()..update(updates))._build();

  _$MerchantFiguresDtoOutputCurrent._({
    required this.received,
    required this.acceptedByYou,
    required this.acceptedByOperations,
    required this.rejected,
    required this.rejections,
    required this.unanswered,
    this.acceptanceBp,
    required this.delivered,
    required this.sales,
    this.averageOrder,
    required this.commission,
    required this.discounts,
    required this.net,
    this.acceptMinutes,
    this.prepActualMinutes,
    this.prepChosenMinutes,
    this.lateBp,
    required this.readyNotPressed,
    this.captainWaitMinutes,
    required this.rating,
    required this.topByQuantity,
    required this.topBySales,
    required this.hours,
    required this.pauseMinutes,
  }) : super._();
  @override
  MerchantFiguresDtoOutputCurrent rebuild(
    void Function(MerchantFiguresDtoOutputCurrentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputCurrentBuilder toBuilder() =>
      MerchantFiguresDtoOutputCurrentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutputCurrent &&
        received == other.received &&
        acceptedByYou == other.acceptedByYou &&
        acceptedByOperations == other.acceptedByOperations &&
        rejected == other.rejected &&
        rejections == other.rejections &&
        unanswered == other.unanswered &&
        acceptanceBp == other.acceptanceBp &&
        delivered == other.delivered &&
        sales == other.sales &&
        averageOrder == other.averageOrder &&
        commission == other.commission &&
        discounts == other.discounts &&
        net == other.net &&
        acceptMinutes == other.acceptMinutes &&
        prepActualMinutes == other.prepActualMinutes &&
        prepChosenMinutes == other.prepChosenMinutes &&
        lateBp == other.lateBp &&
        readyNotPressed == other.readyNotPressed &&
        captainWaitMinutes == other.captainWaitMinutes &&
        rating == other.rating &&
        topByQuantity == other.topByQuantity &&
        topBySales == other.topBySales &&
        hours == other.hours &&
        pauseMinutes == other.pauseMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, acceptedByYou.hashCode);
    _$hash = $jc(_$hash, acceptedByOperations.hashCode);
    _$hash = $jc(_$hash, rejected.hashCode);
    _$hash = $jc(_$hash, rejections.hashCode);
    _$hash = $jc(_$hash, unanswered.hashCode);
    _$hash = $jc(_$hash, acceptanceBp.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jc(_$hash, averageOrder.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discounts.hashCode);
    _$hash = $jc(_$hash, net.hashCode);
    _$hash = $jc(_$hash, acceptMinutes.hashCode);
    _$hash = $jc(_$hash, prepActualMinutes.hashCode);
    _$hash = $jc(_$hash, prepChosenMinutes.hashCode);
    _$hash = $jc(_$hash, lateBp.hashCode);
    _$hash = $jc(_$hash, readyNotPressed.hashCode);
    _$hash = $jc(_$hash, captainWaitMinutes.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, topByQuantity.hashCode);
    _$hash = $jc(_$hash, topBySales.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, pauseMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantFiguresDtoOutputCurrent')
          ..add('received', received)
          ..add('acceptedByYou', acceptedByYou)
          ..add('acceptedByOperations', acceptedByOperations)
          ..add('rejected', rejected)
          ..add('rejections', rejections)
          ..add('unanswered', unanswered)
          ..add('acceptanceBp', acceptanceBp)
          ..add('delivered', delivered)
          ..add('sales', sales)
          ..add('averageOrder', averageOrder)
          ..add('commission', commission)
          ..add('discounts', discounts)
          ..add('net', net)
          ..add('acceptMinutes', acceptMinutes)
          ..add('prepActualMinutes', prepActualMinutes)
          ..add('prepChosenMinutes', prepChosenMinutes)
          ..add('lateBp', lateBp)
          ..add('readyNotPressed', readyNotPressed)
          ..add('captainWaitMinutes', captainWaitMinutes)
          ..add('rating', rating)
          ..add('topByQuantity', topByQuantity)
          ..add('topBySales', topBySales)
          ..add('hours', hours)
          ..add('pauseMinutes', pauseMinutes))
        .toString();
  }
}

class MerchantFiguresDtoOutputCurrentBuilder
    implements
        Builder<
          MerchantFiguresDtoOutputCurrent,
          MerchantFiguresDtoOutputCurrentBuilder
        > {
  _$MerchantFiguresDtoOutputCurrent? _$v;

  int? _received;
  int? get received => _$this._received;
  set received(int? received) => _$this._received = received;

  int? _acceptedByYou;
  int? get acceptedByYou => _$this._acceptedByYou;
  set acceptedByYou(int? acceptedByYou) =>
      _$this._acceptedByYou = acceptedByYou;

  int? _acceptedByOperations;
  int? get acceptedByOperations => _$this._acceptedByOperations;
  set acceptedByOperations(int? acceptedByOperations) =>
      _$this._acceptedByOperations = acceptedByOperations;

  int? _rejected;
  int? get rejected => _$this._rejected;
  set rejected(int? rejected) => _$this._rejected = rejected;

  ListBuilder<MerchantFiguresDtoOutputCurrentRejectionsInner>? _rejections;
  ListBuilder<MerchantFiguresDtoOutputCurrentRejectionsInner> get rejections =>
      _$this._rejections ??=
          ListBuilder<MerchantFiguresDtoOutputCurrentRejectionsInner>();
  set rejections(
    ListBuilder<MerchantFiguresDtoOutputCurrentRejectionsInner>? rejections,
  ) => _$this._rejections = rejections;

  int? _unanswered;
  int? get unanswered => _$this._unanswered;
  set unanswered(int? unanswered) => _$this._unanswered = unanswered;

  int? _acceptanceBp;
  int? get acceptanceBp => _$this._acceptanceBp;
  set acceptanceBp(int? acceptanceBp) => _$this._acceptanceBp = acceptanceBp;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  String? _sales;
  String? get sales => _$this._sales;
  set sales(String? sales) => _$this._sales = sales;

  String? _averageOrder;
  String? get averageOrder => _$this._averageOrder;
  set averageOrder(String? averageOrder) => _$this._averageOrder = averageOrder;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _discounts;
  String? get discounts => _$this._discounts;
  set discounts(String? discounts) => _$this._discounts = discounts;

  String? _net;
  String? get net => _$this._net;
  set net(String? net) => _$this._net = net;

  num? _acceptMinutes;
  num? get acceptMinutes => _$this._acceptMinutes;
  set acceptMinutes(num? acceptMinutes) =>
      _$this._acceptMinutes = acceptMinutes;

  num? _prepActualMinutes;
  num? get prepActualMinutes => _$this._prepActualMinutes;
  set prepActualMinutes(num? prepActualMinutes) =>
      _$this._prepActualMinutes = prepActualMinutes;

  num? _prepChosenMinutes;
  num? get prepChosenMinutes => _$this._prepChosenMinutes;
  set prepChosenMinutes(num? prepChosenMinutes) =>
      _$this._prepChosenMinutes = prepChosenMinutes;

  int? _lateBp;
  int? get lateBp => _$this._lateBp;
  set lateBp(int? lateBp) => _$this._lateBp = lateBp;

  int? _readyNotPressed;
  int? get readyNotPressed => _$this._readyNotPressed;
  set readyNotPressed(int? readyNotPressed) =>
      _$this._readyNotPressed = readyNotPressed;

  num? _captainWaitMinutes;
  num? get captainWaitMinutes => _$this._captainWaitMinutes;
  set captainWaitMinutes(num? captainWaitMinutes) =>
      _$this._captainWaitMinutes = captainWaitMinutes;

  MerchantFiguresDtoOutputCurrentRatingBuilder? _rating;
  MerchantFiguresDtoOutputCurrentRatingBuilder get rating =>
      _$this._rating ??= MerchantFiguresDtoOutputCurrentRatingBuilder();
  set rating(MerchantFiguresDtoOutputCurrentRatingBuilder? rating) =>
      _$this._rating = rating;

  ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>?
  _topByQuantity;
  ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>
  get topByQuantity => _$this._topByQuantity ??=
      ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>();
  set topByQuantity(
    ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>?
    topByQuantity,
  ) => _$this._topByQuantity = topByQuantity;

  ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>? _topBySales;
  ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>
  get topBySales => _$this._topBySales ??=
      ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>();
  set topBySales(
    ListBuilder<MerchantFiguresDtoOutputCurrentTopByQuantityInner>? topBySales,
  ) => _$this._topBySales = topBySales;

  ListBuilder<MerchantFiguresDtoOutputCurrentHoursInner>? _hours;
  ListBuilder<MerchantFiguresDtoOutputCurrentHoursInner> get hours =>
      _$this._hours ??=
          ListBuilder<MerchantFiguresDtoOutputCurrentHoursInner>();
  set hours(ListBuilder<MerchantFiguresDtoOutputCurrentHoursInner>? hours) =>
      _$this._hours = hours;

  MerchantFiguresDtoOutputCurrentPauseMinutesBuilder? _pauseMinutes;
  MerchantFiguresDtoOutputCurrentPauseMinutesBuilder get pauseMinutes =>
      _$this._pauseMinutes ??=
          MerchantFiguresDtoOutputCurrentPauseMinutesBuilder();
  set pauseMinutes(
    MerchantFiguresDtoOutputCurrentPauseMinutesBuilder? pauseMinutes,
  ) => _$this._pauseMinutes = pauseMinutes;

  MerchantFiguresDtoOutputCurrentBuilder() {
    MerchantFiguresDtoOutputCurrent._defaults(this);
  }

  MerchantFiguresDtoOutputCurrentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received;
      _acceptedByYou = $v.acceptedByYou;
      _acceptedByOperations = $v.acceptedByOperations;
      _rejected = $v.rejected;
      _rejections = $v.rejections.toBuilder();
      _unanswered = $v.unanswered;
      _acceptanceBp = $v.acceptanceBp;
      _delivered = $v.delivered;
      _sales = $v.sales;
      _averageOrder = $v.averageOrder;
      _commission = $v.commission;
      _discounts = $v.discounts;
      _net = $v.net;
      _acceptMinutes = $v.acceptMinutes;
      _prepActualMinutes = $v.prepActualMinutes;
      _prepChosenMinutes = $v.prepChosenMinutes;
      _lateBp = $v.lateBp;
      _readyNotPressed = $v.readyNotPressed;
      _captainWaitMinutes = $v.captainWaitMinutes;
      _rating = $v.rating.toBuilder();
      _topByQuantity = $v.topByQuantity.toBuilder();
      _topBySales = $v.topBySales.toBuilder();
      _hours = $v.hours.toBuilder();
      _pauseMinutes = $v.pauseMinutes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresDtoOutputCurrent other) {
    _$v = other as _$MerchantFiguresDtoOutputCurrent;
  }

  @override
  void update(void Function(MerchantFiguresDtoOutputCurrentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutputCurrent build() => _build();

  _$MerchantFiguresDtoOutputCurrent _build() {
    _$MerchantFiguresDtoOutputCurrent _$result;
    try {
      _$result =
          _$v ??
          _$MerchantFiguresDtoOutputCurrent._(
            received: BuiltValueNullFieldError.checkNotNull(
              received,
              r'MerchantFiguresDtoOutputCurrent',
              'received',
            ),
            acceptedByYou: BuiltValueNullFieldError.checkNotNull(
              acceptedByYou,
              r'MerchantFiguresDtoOutputCurrent',
              'acceptedByYou',
            ),
            acceptedByOperations: BuiltValueNullFieldError.checkNotNull(
              acceptedByOperations,
              r'MerchantFiguresDtoOutputCurrent',
              'acceptedByOperations',
            ),
            rejected: BuiltValueNullFieldError.checkNotNull(
              rejected,
              r'MerchantFiguresDtoOutputCurrent',
              'rejected',
            ),
            rejections: rejections.build(),
            unanswered: BuiltValueNullFieldError.checkNotNull(
              unanswered,
              r'MerchantFiguresDtoOutputCurrent',
              'unanswered',
            ),
            acceptanceBp: acceptanceBp,
            delivered: BuiltValueNullFieldError.checkNotNull(
              delivered,
              r'MerchantFiguresDtoOutputCurrent',
              'delivered',
            ),
            sales: BuiltValueNullFieldError.checkNotNull(
              sales,
              r'MerchantFiguresDtoOutputCurrent',
              'sales',
            ),
            averageOrder: averageOrder,
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'MerchantFiguresDtoOutputCurrent',
              'commission',
            ),
            discounts: BuiltValueNullFieldError.checkNotNull(
              discounts,
              r'MerchantFiguresDtoOutputCurrent',
              'discounts',
            ),
            net: BuiltValueNullFieldError.checkNotNull(
              net,
              r'MerchantFiguresDtoOutputCurrent',
              'net',
            ),
            acceptMinutes: acceptMinutes,
            prepActualMinutes: prepActualMinutes,
            prepChosenMinutes: prepChosenMinutes,
            lateBp: lateBp,
            readyNotPressed: BuiltValueNullFieldError.checkNotNull(
              readyNotPressed,
              r'MerchantFiguresDtoOutputCurrent',
              'readyNotPressed',
            ),
            captainWaitMinutes: captainWaitMinutes,
            rating: rating.build(),
            topByQuantity: topByQuantity.build(),
            topBySales: topBySales.build(),
            hours: hours.build(),
            pauseMinutes: pauseMinutes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rejections';
        rejections.build();

        _$failedField = 'rating';
        rating.build();
        _$failedField = 'topByQuantity';
        topByQuantity.build();
        _$failedField = 'topBySales';
        topBySales.build();
        _$failedField = 'hours';
        hours.build();
        _$failedField = 'pauseMinutes';
        pauseMinutes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantFiguresDtoOutputCurrent',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
