// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_window_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuWindowDto extends MerchantMenuWindowDto {
  @override
  final MerchantMenuWindowDtoWindow? window;

  factory _$MerchantMenuWindowDto([
    void Function(MerchantMenuWindowDtoBuilder)? updates,
  ]) => (MerchantMenuWindowDtoBuilder()..update(updates))._build();

  _$MerchantMenuWindowDto._({this.window}) : super._();
  @override
  MerchantMenuWindowDto rebuild(
    void Function(MerchantMenuWindowDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuWindowDtoBuilder toBuilder() =>
      MerchantMenuWindowDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuWindowDto && window == other.window;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantMenuWindowDto',
    )..add('window', window)).toString();
  }
}

class MerchantMenuWindowDtoBuilder
    implements Builder<MerchantMenuWindowDto, MerchantMenuWindowDtoBuilder> {
  _$MerchantMenuWindowDto? _$v;

  MerchantMenuWindowDtoWindowBuilder? _window;
  MerchantMenuWindowDtoWindowBuilder get window =>
      _$this._window ??= MerchantMenuWindowDtoWindowBuilder();
  set window(MerchantMenuWindowDtoWindowBuilder? window) =>
      _$this._window = window;

  MerchantMenuWindowDtoBuilder() {
    MerchantMenuWindowDto._defaults(this);
  }

  MerchantMenuWindowDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _window = $v.window?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuWindowDto other) {
    _$v = other as _$MerchantMenuWindowDto;
  }

  @override
  void update(void Function(MerchantMenuWindowDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuWindowDto build() => _build();

  _$MerchantMenuWindowDto _build() {
    _$MerchantMenuWindowDto _$result;
    try {
      _$result = _$v ?? _$MerchantMenuWindowDto._(window: _window?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'window';
        _window?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuWindowDto',
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
