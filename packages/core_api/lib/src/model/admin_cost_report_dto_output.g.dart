// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCostReportDtoOutput extends AdminCostReportDtoOutput {
  @override
  final String cityId;
  @override
  final String fromDay;
  @override
  final String toDay;
  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final String currency;
  @override
  final AdminCostReportDtoOutputTotals totals;
  @override
  final BuiltList<AdminCostReportDtoOutputCompensationReasonsInner>
  compensationReasons;
  @override
  final BuiltList<AdminCostReportDtoOutputOperatingReasonsInner>
  operatingReasons;
  @override
  final BuiltList<AdminCostReportDtoOutputCodesInner> codes;
  @override
  final BuiltList<AdminCostReportDtoOutputPartiesInner> parties;
  @override
  final BuiltList<AdminCostReportDtoOutputRestaurantsInner> restaurants;

  factory _$AdminCostReportDtoOutput([
    void Function(AdminCostReportDtoOutputBuilder)? updates,
  ]) => (AdminCostReportDtoOutputBuilder()..update(updates))._build();

  _$AdminCostReportDtoOutput._({
    required this.cityId,
    required this.fromDay,
    required this.toDay,
    required this.from,
    required this.to,
    required this.currency,
    required this.totals,
    required this.compensationReasons,
    required this.operatingReasons,
    required this.codes,
    required this.parties,
    required this.restaurants,
  }) : super._();
  @override
  AdminCostReportDtoOutput rebuild(
    void Function(AdminCostReportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputBuilder toBuilder() =>
      AdminCostReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutput &&
        cityId == other.cityId &&
        fromDay == other.fromDay &&
        toDay == other.toDay &&
        from == other.from &&
        to == other.to &&
        currency == other.currency &&
        totals == other.totals &&
        compensationReasons == other.compensationReasons &&
        operatingReasons == other.operatingReasons &&
        codes == other.codes &&
        parties == other.parties &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, fromDay.hashCode);
    _$hash = $jc(_$hash, toDay.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, compensationReasons.hashCode);
    _$hash = $jc(_$hash, operatingReasons.hashCode);
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jc(_$hash, parties.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCostReportDtoOutput')
          ..add('cityId', cityId)
          ..add('fromDay', fromDay)
          ..add('toDay', toDay)
          ..add('from', from)
          ..add('to', to)
          ..add('currency', currency)
          ..add('totals', totals)
          ..add('compensationReasons', compensationReasons)
          ..add('operatingReasons', operatingReasons)
          ..add('codes', codes)
          ..add('parties', parties)
          ..add('restaurants', restaurants))
        .toString();
  }
}

class AdminCostReportDtoOutputBuilder
    implements
        Builder<AdminCostReportDtoOutput, AdminCostReportDtoOutputBuilder> {
  _$AdminCostReportDtoOutput? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _fromDay;
  String? get fromDay => _$this._fromDay;
  set fromDay(String? fromDay) => _$this._fromDay = fromDay;

  String? _toDay;
  String? get toDay => _$this._toDay;
  set toDay(String? toDay) => _$this._toDay = toDay;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCostReportDtoOutputTotalsBuilder? _totals;
  AdminCostReportDtoOutputTotalsBuilder get totals =>
      _$this._totals ??= AdminCostReportDtoOutputTotalsBuilder();
  set totals(AdminCostReportDtoOutputTotalsBuilder? totals) =>
      _$this._totals = totals;

  ListBuilder<AdminCostReportDtoOutputCompensationReasonsInner>?
  _compensationReasons;
  ListBuilder<AdminCostReportDtoOutputCompensationReasonsInner>
  get compensationReasons => _$this._compensationReasons ??=
      ListBuilder<AdminCostReportDtoOutputCompensationReasonsInner>();
  set compensationReasons(
    ListBuilder<AdminCostReportDtoOutputCompensationReasonsInner>?
    compensationReasons,
  ) => _$this._compensationReasons = compensationReasons;

  ListBuilder<AdminCostReportDtoOutputOperatingReasonsInner>? _operatingReasons;
  ListBuilder<AdminCostReportDtoOutputOperatingReasonsInner>
  get operatingReasons => _$this._operatingReasons ??=
      ListBuilder<AdminCostReportDtoOutputOperatingReasonsInner>();
  set operatingReasons(
    ListBuilder<AdminCostReportDtoOutputOperatingReasonsInner>?
    operatingReasons,
  ) => _$this._operatingReasons = operatingReasons;

  ListBuilder<AdminCostReportDtoOutputCodesInner>? _codes;
  ListBuilder<AdminCostReportDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<AdminCostReportDtoOutputCodesInner>();
  set codes(ListBuilder<AdminCostReportDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  ListBuilder<AdminCostReportDtoOutputPartiesInner>? _parties;
  ListBuilder<AdminCostReportDtoOutputPartiesInner> get parties =>
      _$this._parties ??= ListBuilder<AdminCostReportDtoOutputPartiesInner>();
  set parties(ListBuilder<AdminCostReportDtoOutputPartiesInner>? parties) =>
      _$this._parties = parties;

  ListBuilder<AdminCostReportDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<AdminCostReportDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<AdminCostReportDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<AdminCostReportDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  AdminCostReportDtoOutputBuilder() {
    AdminCostReportDtoOutput._defaults(this);
  }

  AdminCostReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _fromDay = $v.fromDay;
      _toDay = $v.toDay;
      _from = $v.from;
      _to = $v.to;
      _currency = $v.currency;
      _totals = $v.totals.toBuilder();
      _compensationReasons = $v.compensationReasons.toBuilder();
      _operatingReasons = $v.operatingReasons.toBuilder();
      _codes = $v.codes.toBuilder();
      _parties = $v.parties.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutput other) {
    _$v = other as _$AdminCostReportDtoOutput;
  }

  @override
  void update(void Function(AdminCostReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutput build() => _build();

  _$AdminCostReportDtoOutput _build() {
    _$AdminCostReportDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCostReportDtoOutput._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCostReportDtoOutput',
              'cityId',
            ),
            fromDay: BuiltValueNullFieldError.checkNotNull(
              fromDay,
              r'AdminCostReportDtoOutput',
              'fromDay',
            ),
            toDay: BuiltValueNullFieldError.checkNotNull(
              toDay,
              r'AdminCostReportDtoOutput',
              'toDay',
            ),
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminCostReportDtoOutput',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminCostReportDtoOutput',
              'to',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminCostReportDtoOutput',
              'currency',
            ),
            totals: totals.build(),
            compensationReasons: compensationReasons.build(),
            operatingReasons: operatingReasons.build(),
            codes: codes.build(),
            parties: parties.build(),
            restaurants: restaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'compensationReasons';
        compensationReasons.build();
        _$failedField = 'operatingReasons';
        operatingReasons.build();
        _$failedField = 'codes';
        codes.build();
        _$failedField = 'parties';
        parties.build();
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCostReportDtoOutput',
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
