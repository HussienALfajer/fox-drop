// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposit_cash_limit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositCashLimitDto extends AdminDepositCashLimitDto {
  @override
  final String cityId;
  @override
  final AdminDepositCashLimitDtoCashLimit cashLimit;

  factory _$AdminDepositCashLimitDto([
    void Function(AdminDepositCashLimitDtoBuilder)? updates,
  ]) => (AdminDepositCashLimitDtoBuilder()..update(updates))._build();

  _$AdminDepositCashLimitDto._({required this.cityId, required this.cashLimit})
    : super._();
  @override
  AdminDepositCashLimitDto rebuild(
    void Function(AdminDepositCashLimitDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositCashLimitDtoBuilder toBuilder() =>
      AdminDepositCashLimitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositCashLimitDto &&
        cityId == other.cityId &&
        cashLimit == other.cashLimit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, cashLimit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDepositCashLimitDto')
          ..add('cityId', cityId)
          ..add('cashLimit', cashLimit))
        .toString();
  }
}

class AdminDepositCashLimitDtoBuilder
    implements
        Builder<AdminDepositCashLimitDto, AdminDepositCashLimitDtoBuilder> {
  _$AdminDepositCashLimitDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminDepositCashLimitDtoCashLimitBuilder? _cashLimit;
  AdminDepositCashLimitDtoCashLimitBuilder get cashLimit =>
      _$this._cashLimit ??= AdminDepositCashLimitDtoCashLimitBuilder();
  set cashLimit(AdminDepositCashLimitDtoCashLimitBuilder? cashLimit) =>
      _$this._cashLimit = cashLimit;

  AdminDepositCashLimitDtoBuilder() {
    AdminDepositCashLimitDto._defaults(this);
  }

  AdminDepositCashLimitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _cashLimit = $v.cashLimit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositCashLimitDto other) {
    _$v = other as _$AdminDepositCashLimitDto;
  }

  @override
  void update(void Function(AdminDepositCashLimitDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositCashLimitDto build() => _build();

  _$AdminDepositCashLimitDto _build() {
    _$AdminDepositCashLimitDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminDepositCashLimitDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminDepositCashLimitDto',
              'cityId',
            ),
            cashLimit: cashLimit.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cashLimit';
        cashLimit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDepositCashLimitDto',
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
