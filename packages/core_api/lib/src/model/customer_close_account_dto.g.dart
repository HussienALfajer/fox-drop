// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_close_account_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCloseAccountDto extends CustomerCloseAccountDto {
  @override
  final String code;

  factory _$CustomerCloseAccountDto([
    void Function(CustomerCloseAccountDtoBuilder)? updates,
  ]) => (CustomerCloseAccountDtoBuilder()..update(updates))._build();

  _$CustomerCloseAccountDto._({required this.code}) : super._();
  @override
  CustomerCloseAccountDto rebuild(
    void Function(CustomerCloseAccountDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCloseAccountDtoBuilder toBuilder() =>
      CustomerCloseAccountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCloseAccountDto && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerCloseAccountDto',
    )..add('code', code)).toString();
  }
}

class CustomerCloseAccountDtoBuilder
    implements
        Builder<CustomerCloseAccountDto, CustomerCloseAccountDtoBuilder> {
  _$CustomerCloseAccountDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerCloseAccountDtoBuilder() {
    CustomerCloseAccountDto._defaults(this);
  }

  CustomerCloseAccountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCloseAccountDto other) {
    _$v = other as _$CustomerCloseAccountDto;
  }

  @override
  void update(void Function(CustomerCloseAccountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCloseAccountDto build() => _build();

  _$CustomerCloseAccountDto _build() {
    final _$result =
        _$v ??
        _$CustomerCloseAccountDto._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CustomerCloseAccountDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
