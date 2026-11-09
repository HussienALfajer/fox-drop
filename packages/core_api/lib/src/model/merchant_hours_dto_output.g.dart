// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_hours_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantHoursDtoOutput extends MerchantHoursDtoOutput {
  @override
  final BuiltList<MerchantHoursDtoOutputPeriodsInner> periods;
  @override
  final MerchantStatusDtoOutputHoliday? holiday;
  @override
  final int defaultPrepMin;
  @override
  final int prepFloorMin;
  @override
  final int prepCeilingMin;
  @override
  final int? maxActiveOrders;
  @override
  final MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice minimumOrder;
  @override
  final MerchantHoursDtoOutputCoverage coverage;
  @override
  final int? commissionBp;
  @override
  final String settlementWeekday;

  factory _$MerchantHoursDtoOutput([
    void Function(MerchantHoursDtoOutputBuilder)? updates,
  ]) => (MerchantHoursDtoOutputBuilder()..update(updates))._build();

  _$MerchantHoursDtoOutput._({
    required this.periods,
    this.holiday,
    required this.defaultPrepMin,
    required this.prepFloorMin,
    required this.prepCeilingMin,
    this.maxActiveOrders,
    required this.minimumOrder,
    required this.coverage,
    this.commissionBp,
    required this.settlementWeekday,
  }) : super._();
  @override
  MerchantHoursDtoOutput rebuild(
    void Function(MerchantHoursDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantHoursDtoOutputBuilder toBuilder() =>
      MerchantHoursDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantHoursDtoOutput &&
        periods == other.periods &&
        holiday == other.holiday &&
        defaultPrepMin == other.defaultPrepMin &&
        prepFloorMin == other.prepFloorMin &&
        prepCeilingMin == other.prepCeilingMin &&
        maxActiveOrders == other.maxActiveOrders &&
        minimumOrder == other.minimumOrder &&
        coverage == other.coverage &&
        commissionBp == other.commissionBp &&
        settlementWeekday == other.settlementWeekday;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, periods.hashCode);
    _$hash = $jc(_$hash, holiday.hashCode);
    _$hash = $jc(_$hash, defaultPrepMin.hashCode);
    _$hash = $jc(_$hash, prepFloorMin.hashCode);
    _$hash = $jc(_$hash, prepCeilingMin.hashCode);
    _$hash = $jc(_$hash, maxActiveOrders.hashCode);
    _$hash = $jc(_$hash, minimumOrder.hashCode);
    _$hash = $jc(_$hash, coverage.hashCode);
    _$hash = $jc(_$hash, commissionBp.hashCode);
    _$hash = $jc(_$hash, settlementWeekday.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantHoursDtoOutput')
          ..add('periods', periods)
          ..add('holiday', holiday)
          ..add('defaultPrepMin', defaultPrepMin)
          ..add('prepFloorMin', prepFloorMin)
          ..add('prepCeilingMin', prepCeilingMin)
          ..add('maxActiveOrders', maxActiveOrders)
          ..add('minimumOrder', minimumOrder)
          ..add('coverage', coverage)
          ..add('commissionBp', commissionBp)
          ..add('settlementWeekday', settlementWeekday))
        .toString();
  }
}

class MerchantHoursDtoOutputBuilder
    implements Builder<MerchantHoursDtoOutput, MerchantHoursDtoOutputBuilder> {
  _$MerchantHoursDtoOutput? _$v;

  ListBuilder<MerchantHoursDtoOutputPeriodsInner>? _periods;
  ListBuilder<MerchantHoursDtoOutputPeriodsInner> get periods =>
      _$this._periods ??= ListBuilder<MerchantHoursDtoOutputPeriodsInner>();
  set periods(ListBuilder<MerchantHoursDtoOutputPeriodsInner>? periods) =>
      _$this._periods = periods;

  MerchantStatusDtoOutputHolidayBuilder? _holiday;
  MerchantStatusDtoOutputHolidayBuilder get holiday =>
      _$this._holiday ??= MerchantStatusDtoOutputHolidayBuilder();
  set holiday(MerchantStatusDtoOutputHolidayBuilder? holiday) =>
      _$this._holiday = holiday;

  int? _defaultPrepMin;
  int? get defaultPrepMin => _$this._defaultPrepMin;
  set defaultPrepMin(int? defaultPrepMin) =>
      _$this._defaultPrepMin = defaultPrepMin;

  int? _prepFloorMin;
  int? get prepFloorMin => _$this._prepFloorMin;
  set prepFloorMin(int? prepFloorMin) => _$this._prepFloorMin = prepFloorMin;

  int? _prepCeilingMin;
  int? get prepCeilingMin => _$this._prepCeilingMin;
  set prepCeilingMin(int? prepCeilingMin) =>
      _$this._prepCeilingMin = prepCeilingMin;

  int? _maxActiveOrders;
  int? get maxActiveOrders => _$this._maxActiveOrders;
  set maxActiveOrders(int? maxActiveOrders) =>
      _$this._maxActiveOrders = maxActiveOrders;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? _minimumOrder;
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder get minimumOrder =>
      _$this._minimumOrder ??=
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder();
  set minimumOrder(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? minimumOrder,
  ) => _$this._minimumOrder = minimumOrder;

  MerchantHoursDtoOutputCoverageBuilder? _coverage;
  MerchantHoursDtoOutputCoverageBuilder get coverage =>
      _$this._coverage ??= MerchantHoursDtoOutputCoverageBuilder();
  set coverage(MerchantHoursDtoOutputCoverageBuilder? coverage) =>
      _$this._coverage = coverage;

  int? _commissionBp;
  int? get commissionBp => _$this._commissionBp;
  set commissionBp(int? commissionBp) => _$this._commissionBp = commissionBp;

  String? _settlementWeekday;
  String? get settlementWeekday => _$this._settlementWeekday;
  set settlementWeekday(String? settlementWeekday) =>
      _$this._settlementWeekday = settlementWeekday;

  MerchantHoursDtoOutputBuilder() {
    MerchantHoursDtoOutput._defaults(this);
  }

  MerchantHoursDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _periods = $v.periods.toBuilder();
      _holiday = $v.holiday?.toBuilder();
      _defaultPrepMin = $v.defaultPrepMin;
      _prepFloorMin = $v.prepFloorMin;
      _prepCeilingMin = $v.prepCeilingMin;
      _maxActiveOrders = $v.maxActiveOrders;
      _minimumOrder = $v.minimumOrder.toBuilder();
      _coverage = $v.coverage.toBuilder();
      _commissionBp = $v.commissionBp;
      _settlementWeekday = $v.settlementWeekday;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantHoursDtoOutput other) {
    _$v = other as _$MerchantHoursDtoOutput;
  }

  @override
  void update(void Function(MerchantHoursDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantHoursDtoOutput build() => _build();

  _$MerchantHoursDtoOutput _build() {
    _$MerchantHoursDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantHoursDtoOutput._(
            periods: periods.build(),
            holiday: _holiday?.build(),
            defaultPrepMin: BuiltValueNullFieldError.checkNotNull(
              defaultPrepMin,
              r'MerchantHoursDtoOutput',
              'defaultPrepMin',
            ),
            prepFloorMin: BuiltValueNullFieldError.checkNotNull(
              prepFloorMin,
              r'MerchantHoursDtoOutput',
              'prepFloorMin',
            ),
            prepCeilingMin: BuiltValueNullFieldError.checkNotNull(
              prepCeilingMin,
              r'MerchantHoursDtoOutput',
              'prepCeilingMin',
            ),
            maxActiveOrders: maxActiveOrders,
            minimumOrder: minimumOrder.build(),
            coverage: coverage.build(),
            commissionBp: commissionBp,
            settlementWeekday: BuiltValueNullFieldError.checkNotNull(
              settlementWeekday,
              r'MerchantHoursDtoOutput',
              'settlementWeekday',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'periods';
        periods.build();
        _$failedField = 'holiday';
        _holiday?.build();

        _$failedField = 'minimumOrder';
        minimumOrder.build();
        _$failedField = 'coverage';
        coverage.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantHoursDtoOutput',
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
