// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_overview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantOverviewDtoOutput
    extends AdminRestaurantOverviewDtoOutput {
  @override
  final DateTime from;
  @override
  final int orders;
  @override
  final BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?>
  sales;
  @override
  final int? acceptanceBp;
  @override
  final int? rejectionBp;
  @override
  final BuiltList<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>
  rejectionReasons;
  @override
  final int unanswered;
  @override
  final num? prepActualMin;
  @override
  final num? prepChosenMin;
  @override
  final int? lateBp;
  @override
  final int ratingCount;
  @override
  final num? ratingAverage;

  factory _$AdminRestaurantOverviewDtoOutput([
    void Function(AdminRestaurantOverviewDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantOverviewDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantOverviewDtoOutput._({
    required this.from,
    required this.orders,
    required this.sales,
    this.acceptanceBp,
    this.rejectionBp,
    required this.rejectionReasons,
    required this.unanswered,
    this.prepActualMin,
    this.prepChosenMin,
    this.lateBp,
    required this.ratingCount,
    this.ratingAverage,
  }) : super._();
  @override
  AdminRestaurantOverviewDtoOutput rebuild(
    void Function(AdminRestaurantOverviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantOverviewDtoOutputBuilder toBuilder() =>
      AdminRestaurantOverviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantOverviewDtoOutput &&
        from == other.from &&
        orders == other.orders &&
        sales == other.sales &&
        acceptanceBp == other.acceptanceBp &&
        rejectionBp == other.rejectionBp &&
        rejectionReasons == other.rejectionReasons &&
        unanswered == other.unanswered &&
        prepActualMin == other.prepActualMin &&
        prepChosenMin == other.prepChosenMin &&
        lateBp == other.lateBp &&
        ratingCount == other.ratingCount &&
        ratingAverage == other.ratingAverage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jc(_$hash, acceptanceBp.hashCode);
    _$hash = $jc(_$hash, rejectionBp.hashCode);
    _$hash = $jc(_$hash, rejectionReasons.hashCode);
    _$hash = $jc(_$hash, unanswered.hashCode);
    _$hash = $jc(_$hash, prepActualMin.hashCode);
    _$hash = $jc(_$hash, prepChosenMin.hashCode);
    _$hash = $jc(_$hash, lateBp.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, ratingAverage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantOverviewDtoOutput')
          ..add('from', from)
          ..add('orders', orders)
          ..add('sales', sales)
          ..add('acceptanceBp', acceptanceBp)
          ..add('rejectionBp', rejectionBp)
          ..add('rejectionReasons', rejectionReasons)
          ..add('unanswered', unanswered)
          ..add('prepActualMin', prepActualMin)
          ..add('prepChosenMin', prepChosenMin)
          ..add('lateBp', lateBp)
          ..add('ratingCount', ratingCount)
          ..add('ratingAverage', ratingAverage))
        .toString();
  }
}

class AdminRestaurantOverviewDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantOverviewDtoOutput,
          AdminRestaurantOverviewDtoOutputBuilder
        > {
  _$AdminRestaurantOverviewDtoOutput? _$v;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?>?
  _sales;
  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?>
  get sales => _$this._sales ??=
      ListBuilder<
        CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?
      >();
  set sales(
    ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?>?
    sales,
  ) => _$this._sales = sales;

  int? _acceptanceBp;
  int? get acceptanceBp => _$this._acceptanceBp;
  set acceptanceBp(int? acceptanceBp) => _$this._acceptanceBp = acceptanceBp;

  int? _rejectionBp;
  int? get rejectionBp => _$this._rejectionBp;
  set rejectionBp(int? rejectionBp) => _$this._rejectionBp = rejectionBp;

  ListBuilder<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>?
  _rejectionReasons;
  ListBuilder<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>
  get rejectionReasons => _$this._rejectionReasons ??=
      ListBuilder<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>();
  set rejectionReasons(
    ListBuilder<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>?
    rejectionReasons,
  ) => _$this._rejectionReasons = rejectionReasons;

  int? _unanswered;
  int? get unanswered => _$this._unanswered;
  set unanswered(int? unanswered) => _$this._unanswered = unanswered;

  num? _prepActualMin;
  num? get prepActualMin => _$this._prepActualMin;
  set prepActualMin(num? prepActualMin) =>
      _$this._prepActualMin = prepActualMin;

  num? _prepChosenMin;
  num? get prepChosenMin => _$this._prepChosenMin;
  set prepChosenMin(num? prepChosenMin) =>
      _$this._prepChosenMin = prepChosenMin;

  int? _lateBp;
  int? get lateBp => _$this._lateBp;
  set lateBp(int? lateBp) => _$this._lateBp = lateBp;

  int? _ratingCount;
  int? get ratingCount => _$this._ratingCount;
  set ratingCount(int? ratingCount) => _$this._ratingCount = ratingCount;

  num? _ratingAverage;
  num? get ratingAverage => _$this._ratingAverage;
  set ratingAverage(num? ratingAverage) =>
      _$this._ratingAverage = ratingAverage;

  AdminRestaurantOverviewDtoOutputBuilder() {
    AdminRestaurantOverviewDtoOutput._defaults(this);
  }

  AdminRestaurantOverviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _orders = $v.orders;
      _sales = $v.sales.toBuilder();
      _acceptanceBp = $v.acceptanceBp;
      _rejectionBp = $v.rejectionBp;
      _rejectionReasons = $v.rejectionReasons.toBuilder();
      _unanswered = $v.unanswered;
      _prepActualMin = $v.prepActualMin;
      _prepChosenMin = $v.prepChosenMin;
      _lateBp = $v.lateBp;
      _ratingCount = $v.ratingCount;
      _ratingAverage = $v.ratingAverage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantOverviewDtoOutput other) {
    _$v = other as _$AdminRestaurantOverviewDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantOverviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantOverviewDtoOutput build() => _build();

  _$AdminRestaurantOverviewDtoOutput _build() {
    _$AdminRestaurantOverviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantOverviewDtoOutput._(
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminRestaurantOverviewDtoOutput',
              'from',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'AdminRestaurantOverviewDtoOutput',
              'orders',
            ),
            sales: sales.build(),
            acceptanceBp: acceptanceBp,
            rejectionBp: rejectionBp,
            rejectionReasons: rejectionReasons.build(),
            unanswered: BuiltValueNullFieldError.checkNotNull(
              unanswered,
              r'AdminRestaurantOverviewDtoOutput',
              'unanswered',
            ),
            prepActualMin: prepActualMin,
            prepChosenMin: prepChosenMin,
            lateBp: lateBp,
            ratingCount: BuiltValueNullFieldError.checkNotNull(
              ratingCount,
              r'AdminRestaurantOverviewDtoOutput',
              'ratingCount',
            ),
            ratingAverage: ratingAverage,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sales';
        sales.build();

        _$failedField = 'rejectionReasons';
        rejectionReasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantOverviewDtoOutput',
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
