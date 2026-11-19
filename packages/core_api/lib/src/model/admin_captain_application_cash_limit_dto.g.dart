// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_cash_limit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationCashLimitDto
    extends AdminCaptainApplicationCashLimitDto {
  @override
  final AdminCaptainApplicationCashLimitDtoCashLimit cashLimit;

  factory _$AdminCaptainApplicationCashLimitDto([
    void Function(AdminCaptainApplicationCashLimitDtoBuilder)? updates,
  ]) =>
      (AdminCaptainApplicationCashLimitDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationCashLimitDto._({required this.cashLimit})
    : super._();
  @override
  AdminCaptainApplicationCashLimitDto rebuild(
    void Function(AdminCaptainApplicationCashLimitDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationCashLimitDtoBuilder toBuilder() =>
      AdminCaptainApplicationCashLimitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationCashLimitDto &&
        cashLimit == other.cashLimit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cashLimit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainApplicationCashLimitDto',
    )..add('cashLimit', cashLimit)).toString();
  }
}

class AdminCaptainApplicationCashLimitDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationCashLimitDto,
          AdminCaptainApplicationCashLimitDtoBuilder
        > {
  _$AdminCaptainApplicationCashLimitDto? _$v;

  AdminCaptainApplicationCashLimitDtoCashLimitBuilder? _cashLimit;
  AdminCaptainApplicationCashLimitDtoCashLimitBuilder get cashLimit =>
      _$this._cashLimit ??=
          AdminCaptainApplicationCashLimitDtoCashLimitBuilder();
  set cashLimit(
    AdminCaptainApplicationCashLimitDtoCashLimitBuilder? cashLimit,
  ) => _$this._cashLimit = cashLimit;

  AdminCaptainApplicationCashLimitDtoBuilder() {
    AdminCaptainApplicationCashLimitDto._defaults(this);
  }

  AdminCaptainApplicationCashLimitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cashLimit = $v.cashLimit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationCashLimitDto other) {
    _$v = other as _$AdminCaptainApplicationCashLimitDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationCashLimitDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationCashLimitDto build() => _build();

  _$AdminCaptainApplicationCashLimitDto _build() {
    _$AdminCaptainApplicationCashLimitDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationCashLimitDto._(cashLimit: cashLimit.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cashLimit';
        cashLimit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationCashLimitDto',
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
