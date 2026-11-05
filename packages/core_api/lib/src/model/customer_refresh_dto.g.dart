// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_refresh_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRefreshDto extends CustomerRefreshDto {
  @override
  final String refreshToken;

  factory _$CustomerRefreshDto([
    void Function(CustomerRefreshDtoBuilder)? updates,
  ]) => (CustomerRefreshDtoBuilder()..update(updates))._build();

  _$CustomerRefreshDto._({required this.refreshToken}) : super._();
  @override
  CustomerRefreshDto rebuild(
    void Function(CustomerRefreshDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRefreshDtoBuilder toBuilder() =>
      CustomerRefreshDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRefreshDto && refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerRefreshDto',
    )..add('refreshToken', refreshToken)).toString();
  }
}

class CustomerRefreshDtoBuilder
    implements Builder<CustomerRefreshDto, CustomerRefreshDtoBuilder> {
  _$CustomerRefreshDto? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  CustomerRefreshDtoBuilder() {
    CustomerRefreshDto._defaults(this);
  }

  CustomerRefreshDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRefreshDto other) {
    _$v = other as _$CustomerRefreshDto;
  }

  @override
  void update(void Function(CustomerRefreshDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRefreshDto build() => _build();

  _$CustomerRefreshDto _build() {
    final _$result =
        _$v ??
        _$CustomerRefreshDto._(
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'CustomerRefreshDto',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
