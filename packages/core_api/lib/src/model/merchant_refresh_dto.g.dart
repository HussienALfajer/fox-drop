// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_refresh_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRefreshDto extends MerchantRefreshDto {
  @override
  final String refreshToken;

  factory _$MerchantRefreshDto([
    void Function(MerchantRefreshDtoBuilder)? updates,
  ]) => (MerchantRefreshDtoBuilder()..update(updates))._build();

  _$MerchantRefreshDto._({required this.refreshToken}) : super._();
  @override
  MerchantRefreshDto rebuild(
    void Function(MerchantRefreshDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRefreshDtoBuilder toBuilder() =>
      MerchantRefreshDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRefreshDto && refreshToken == other.refreshToken;
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
      r'MerchantRefreshDto',
    )..add('refreshToken', refreshToken)).toString();
  }
}

class MerchantRefreshDtoBuilder
    implements Builder<MerchantRefreshDto, MerchantRefreshDtoBuilder> {
  _$MerchantRefreshDto? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  MerchantRefreshDtoBuilder() {
    MerchantRefreshDto._defaults(this);
  }

  MerchantRefreshDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRefreshDto other) {
    _$v = other as _$MerchantRefreshDto;
  }

  @override
  void update(void Function(MerchantRefreshDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRefreshDto build() => _build();

  _$MerchantRefreshDto _build() {
    final _$result =
        _$v ??
        _$MerchantRefreshDto._(
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'MerchantRefreshDto',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
