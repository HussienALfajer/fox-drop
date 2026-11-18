// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_operations_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftOperationsDto extends AdminDraftOperationsDto {
  @override
  final BuiltList<AdminDraftPeriod> periods;
  @override
  final int defaultPrepMin;
  @override
  final AdminDraftMoney minimumOrder;
  @override
  final AdminDraftCoverage coverage;

  factory _$AdminDraftOperationsDto([
    void Function(AdminDraftOperationsDtoBuilder)? updates,
  ]) => (AdminDraftOperationsDtoBuilder()..update(updates))._build();

  _$AdminDraftOperationsDto._({
    required this.periods,
    required this.defaultPrepMin,
    required this.minimumOrder,
    required this.coverage,
  }) : super._();
  @override
  AdminDraftOperationsDto rebuild(
    void Function(AdminDraftOperationsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftOperationsDtoBuilder toBuilder() =>
      AdminDraftOperationsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftOperationsDto &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftOperationsDto')
          ..add('periods', periods)
          ..add('defaultPrepMin', defaultPrepMin)
          ..add('minimumOrder', minimumOrder)
          ..add('coverage', coverage))
        .toString();
  }
}

class AdminDraftOperationsDtoBuilder
    implements
        Builder<AdminDraftOperationsDto, AdminDraftOperationsDtoBuilder> {
  _$AdminDraftOperationsDto? _$v;

  ListBuilder<AdminDraftPeriod>? _periods;
  ListBuilder<AdminDraftPeriod> get periods =>
      _$this._periods ??= ListBuilder<AdminDraftPeriod>();
  set periods(ListBuilder<AdminDraftPeriod>? periods) =>
      _$this._periods = periods;

  int? _defaultPrepMin;
  int? get defaultPrepMin => _$this._defaultPrepMin;
  set defaultPrepMin(int? defaultPrepMin) =>
      _$this._defaultPrepMin = defaultPrepMin;

  AdminDraftMoneyBuilder? _minimumOrder;
  AdminDraftMoneyBuilder get minimumOrder =>
      _$this._minimumOrder ??= AdminDraftMoneyBuilder();
  set minimumOrder(AdminDraftMoneyBuilder? minimumOrder) =>
      _$this._minimumOrder = minimumOrder;

  AdminDraftCoverageBuilder? _coverage;
  AdminDraftCoverageBuilder get coverage =>
      _$this._coverage ??= AdminDraftCoverageBuilder();
  set coverage(AdminDraftCoverageBuilder? coverage) =>
      _$this._coverage = coverage;

  AdminDraftOperationsDtoBuilder() {
    AdminDraftOperationsDto._defaults(this);
  }

  AdminDraftOperationsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _periods = $v.periods.toBuilder();
      _defaultPrepMin = $v.defaultPrepMin;
      _minimumOrder = $v.minimumOrder.toBuilder();
      _coverage = $v.coverage.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftOperationsDto other) {
    _$v = other as _$AdminDraftOperationsDto;
  }

  @override
  void update(void Function(AdminDraftOperationsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftOperationsDto build() => _build();

  _$AdminDraftOperationsDto _build() {
    _$AdminDraftOperationsDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftOperationsDto._(
            periods: periods.build(),
            defaultPrepMin: BuiltValueNullFieldError.checkNotNull(
              defaultPrepMin,
              r'AdminDraftOperationsDto',
              'defaultPrepMin',
            ),
            minimumOrder: minimumOrder.build(),
            coverage: coverage.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'periods';
        periods.build();

        _$failedField = 'minimumOrder';
        minimumOrder.build();
        _$failedField = 'coverage';
        coverage.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDraftOperationsDto',
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
