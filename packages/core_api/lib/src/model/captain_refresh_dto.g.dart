// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_refresh_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainRefreshDto extends CaptainRefreshDto {
  @override
  final String refreshToken;

  factory _$CaptainRefreshDto([
    void Function(CaptainRefreshDtoBuilder)? updates,
  ]) => (CaptainRefreshDtoBuilder()..update(updates))._build();

  _$CaptainRefreshDto._({required this.refreshToken}) : super._();
  @override
  CaptainRefreshDto rebuild(void Function(CaptainRefreshDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CaptainRefreshDtoBuilder toBuilder() =>
      CaptainRefreshDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainRefreshDto && refreshToken == other.refreshToken;
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
      r'CaptainRefreshDto',
    )..add('refreshToken', refreshToken)).toString();
  }
}

class CaptainRefreshDtoBuilder
    implements Builder<CaptainRefreshDto, CaptainRefreshDtoBuilder> {
  _$CaptainRefreshDto? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  CaptainRefreshDtoBuilder() {
    CaptainRefreshDto._defaults(this);
  }

  CaptainRefreshDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainRefreshDto other) {
    _$v = other as _$CaptainRefreshDto;
  }

  @override
  void update(void Function(CaptainRefreshDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainRefreshDto build() => _build();

  _$CaptainRefreshDto _build() {
    final _$result =
        _$v ??
        _$CaptainRefreshDto._(
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'CaptainRefreshDto',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
