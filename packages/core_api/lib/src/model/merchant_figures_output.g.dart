// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresOutput extends MerchantFiguresOutput {
  @override
  final int received;
  @override
  final int acceptedByYou;
  @override
  final int acceptedByOperations;
  @override
  final int rejected;
  @override
  final BuiltList<MerchantFiguresOutputRejectionsInner> rejections;
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
  final MerchantFiguresOutputRating rating;
  @override
  final BuiltList<MerchantFiguresItemOutput> topByQuantity;
  @override
  final BuiltList<MerchantFiguresItemOutput> topBySales;
  @override
  final BuiltList<MerchantFiguresOutputHoursInner> hours;
  @override
  final MerchantFiguresOutputPauseMinutes pauseMinutes;

  factory _$MerchantFiguresOutput([
    void Function(MerchantFiguresOutputBuilder)? updates,
  ]) => (MerchantFiguresOutputBuilder()..update(updates))._build();

  _$MerchantFiguresOutput._({
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
  MerchantFiguresOutput rebuild(
    void Function(MerchantFiguresOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresOutputBuilder toBuilder() =>
      MerchantFiguresOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantFiguresOutput')
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

class MerchantFiguresOutputBuilder
    implements Builder<MerchantFiguresOutput, MerchantFiguresOutputBuilder> {
  _$MerchantFiguresOutput? _$v;

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

  ListBuilder<MerchantFiguresOutputRejectionsInner>? _rejections;
  ListBuilder<MerchantFiguresOutputRejectionsInner> get rejections =>
      _$this._rejections ??=
          ListBuilder<MerchantFiguresOutputRejectionsInner>();
  set rejections(
    ListBuilder<MerchantFiguresOutputRejectionsInner>? rejections,
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

  MerchantFiguresOutputRatingBuilder? _rating;
  MerchantFiguresOutputRatingBuilder get rating =>
      _$this._rating ??= MerchantFiguresOutputRatingBuilder();
  set rating(MerchantFiguresOutputRatingBuilder? rating) =>
      _$this._rating = rating;

  ListBuilder<MerchantFiguresItemOutput>? _topByQuantity;
  ListBuilder<MerchantFiguresItemOutput> get topByQuantity =>
      _$this._topByQuantity ??= ListBuilder<MerchantFiguresItemOutput>();
  set topByQuantity(ListBuilder<MerchantFiguresItemOutput>? topByQuantity) =>
      _$this._topByQuantity = topByQuantity;

  ListBuilder<MerchantFiguresItemOutput>? _topBySales;
  ListBuilder<MerchantFiguresItemOutput> get topBySales =>
      _$this._topBySales ??= ListBuilder<MerchantFiguresItemOutput>();
  set topBySales(ListBuilder<MerchantFiguresItemOutput>? topBySales) =>
      _$this._topBySales = topBySales;

  ListBuilder<MerchantFiguresOutputHoursInner>? _hours;
  ListBuilder<MerchantFiguresOutputHoursInner> get hours =>
      _$this._hours ??= ListBuilder<MerchantFiguresOutputHoursInner>();
  set hours(ListBuilder<MerchantFiguresOutputHoursInner>? hours) =>
      _$this._hours = hours;

  MerchantFiguresOutputPauseMinutesBuilder? _pauseMinutes;
  MerchantFiguresOutputPauseMinutesBuilder get pauseMinutes =>
      _$this._pauseMinutes ??= MerchantFiguresOutputPauseMinutesBuilder();
  set pauseMinutes(MerchantFiguresOutputPauseMinutesBuilder? pauseMinutes) =>
      _$this._pauseMinutes = pauseMinutes;

  MerchantFiguresOutputBuilder() {
    MerchantFiguresOutput._defaults(this);
  }

  MerchantFiguresOutputBuilder get _$this {
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
  void replace(MerchantFiguresOutput other) {
    _$v = other as _$MerchantFiguresOutput;
  }

  @override
  void update(void Function(MerchantFiguresOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresOutput build() => _build();

  _$MerchantFiguresOutput _build() {
    _$MerchantFiguresOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantFiguresOutput._(
            received: BuiltValueNullFieldError.checkNotNull(
              received,
              r'MerchantFiguresOutput',
              'received',
            ),
            acceptedByYou: BuiltValueNullFieldError.checkNotNull(
              acceptedByYou,
              r'MerchantFiguresOutput',
              'acceptedByYou',
            ),
            acceptedByOperations: BuiltValueNullFieldError.checkNotNull(
              acceptedByOperations,
              r'MerchantFiguresOutput',
              'acceptedByOperations',
            ),
            rejected: BuiltValueNullFieldError.checkNotNull(
              rejected,
              r'MerchantFiguresOutput',
              'rejected',
            ),
            rejections: rejections.build(),
            unanswered: BuiltValueNullFieldError.checkNotNull(
              unanswered,
              r'MerchantFiguresOutput',
              'unanswered',
            ),
            acceptanceBp: acceptanceBp,
            delivered: BuiltValueNullFieldError.checkNotNull(
              delivered,
              r'MerchantFiguresOutput',
              'delivered',
            ),
            sales: BuiltValueNullFieldError.checkNotNull(
              sales,
              r'MerchantFiguresOutput',
              'sales',
            ),
            averageOrder: averageOrder,
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'MerchantFiguresOutput',
              'commission',
            ),
            discounts: BuiltValueNullFieldError.checkNotNull(
              discounts,
              r'MerchantFiguresOutput',
              'discounts',
            ),
            net: BuiltValueNullFieldError.checkNotNull(
              net,
              r'MerchantFiguresOutput',
              'net',
            ),
            acceptMinutes: acceptMinutes,
            prepActualMinutes: prepActualMinutes,
            prepChosenMinutes: prepChosenMinutes,
            lateBp: lateBp,
            readyNotPressed: BuiltValueNullFieldError.checkNotNull(
              readyNotPressed,
              r'MerchantFiguresOutput',
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
          r'MerchantFiguresOutput',
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
