// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_operations.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputOperations
    extends AdminRestaurantDraftDtoOutputOperations {
  @override
  final BuiltList<AdminDraftPeriodOutput> periods;
  @override
  final int? defaultPrepMin;
  @override
  final AdminDraftMoneyOutput? minimumOrder;
  @override
  final AdminDraftCoverageOutput? coverage;

  factory _$AdminRestaurantDraftDtoOutputOperations([
    void Function(AdminRestaurantDraftDtoOutputOperationsBuilder)? updates,
  ]) => (AdminRestaurantDraftDtoOutputOperationsBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDraftDtoOutputOperations._({
    required this.periods,
    this.defaultPrepMin,
    this.minimumOrder,
    this.coverage,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputOperations rebuild(
    void Function(AdminRestaurantDraftDtoOutputOperationsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputOperationsBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputOperationsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputOperations &&
        periods == other.periods &&
        defaultPrepMin == other.defaultPrepMin &&
        minimumOrder == other.minimumOrder &&
        coverage == other.coverage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, periods.hashCode);
    _$hash = $jc(_$hash, defaultPrepMin.hashCode);
    _$hash = $jc(_$hash, minimumOrder.hashCode);
    _$hash = $jc(_$hash, coverage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputOperations',
          )
          ..add('periods', periods)
          ..add('defaultPrepMin', defaultPrepMin)
          ..add('minimumOrder', minimumOrder)
          ..add('coverage', coverage))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputOperationsBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputOperations,
          AdminRestaurantDraftDtoOutputOperationsBuilder
        > {
  _$AdminRestaurantDraftDtoOutputOperations? _$v;

  ListBuilder<AdminDraftPeriodOutput>? _periods;
  ListBuilder<AdminDraftPeriodOutput> get periods =>
      _$this._periods ??= ListBuilder<AdminDraftPeriodOutput>();
  set periods(ListBuilder<AdminDraftPeriodOutput>? periods) =>
      _$this._periods = periods;

  int? _defaultPrepMin;
  int? get defaultPrepMin => _$this._defaultPrepMin;
  set defaultPrepMin(int? defaultPrepMin) =>
      _$this._defaultPrepMin = defaultPrepMin;

  AdminDraftMoneyOutputBuilder? _minimumOrder;
  AdminDraftMoneyOutputBuilder get minimumOrder =>
      _$this._minimumOrder ??= AdminDraftMoneyOutputBuilder();
  set minimumOrder(AdminDraftMoneyOutputBuilder? minimumOrder) =>
      _$this._minimumOrder = minimumOrder;

  AdminDraftCoverageOutputBuilder? _coverage;
  AdminDraftCoverageOutputBuilder get coverage =>
      _$this._coverage ??= AdminDraftCoverageOutputBuilder();
  set coverage(AdminDraftCoverageOutputBuilder? coverage) =>
      _$this._coverage = coverage;

  AdminRestaurantDraftDtoOutputOperationsBuilder() {
    AdminRestaurantDraftDtoOutputOperations._defaults(this);
  }

  AdminRestaurantDraftDtoOutputOperationsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _periods = $v.periods.toBuilder();
      _defaultPrepMin = $v.defaultPrepMin;
      _minimumOrder = $v.minimumOrder?.toBuilder();
      _coverage = $v.coverage?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputOperations other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputOperations;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputOperationsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputOperations build() => _build();

  _$AdminRestaurantDraftDtoOutputOperations _build() {
    _$AdminRestaurantDraftDtoOutputOperations _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftDtoOutputOperations._(
            periods: periods.build(),
            defaultPrepMin: defaultPrepMin,
            minimumOrder: _minimumOrder?.build(),
            coverage: _coverage?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'periods';
        periods.build();

        _$failedField = 'minimumOrder';
        _minimumOrder?.build();
        _$failedField = 'coverage';
        _coverage?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftDtoOutputOperations',
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
