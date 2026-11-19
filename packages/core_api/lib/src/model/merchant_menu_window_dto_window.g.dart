// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_window_dto_window.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuWindowDtoWindow extends MerchantMenuWindowDtoWindow {
  @override
  final int startsAt;
  @override
  final int endsAt;

  factory _$MerchantMenuWindowDtoWindow([
    void Function(MerchantMenuWindowDtoWindowBuilder)? updates,
  ]) => (MerchantMenuWindowDtoWindowBuilder()..update(updates))._build();

  _$MerchantMenuWindowDtoWindow._({
    required this.startsAt,
    required this.endsAt,
  }) : super._();
  @override
  MerchantMenuWindowDtoWindow rebuild(
    void Function(MerchantMenuWindowDtoWindowBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuWindowDtoWindowBuilder toBuilder() =>
      MerchantMenuWindowDtoWindowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuWindowDtoWindow &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantMenuWindowDtoWindow')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class MerchantMenuWindowDtoWindowBuilder
    implements
        Builder<
          MerchantMenuWindowDtoWindow,
          MerchantMenuWindowDtoWindowBuilder
        > {
  _$MerchantMenuWindowDtoWindow? _$v;

  int? _startsAt;
  int? get startsAt => _$this._startsAt;
  set startsAt(int? startsAt) => _$this._startsAt = startsAt;

  int? _endsAt;
  int? get endsAt => _$this._endsAt;
  set endsAt(int? endsAt) => _$this._endsAt = endsAt;

  MerchantMenuWindowDtoWindowBuilder() {
    MerchantMenuWindowDtoWindow._defaults(this);
  }

  MerchantMenuWindowDtoWindowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuWindowDtoWindow other) {
    _$v = other as _$MerchantMenuWindowDtoWindow;
  }

  @override
  void update(void Function(MerchantMenuWindowDtoWindowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuWindowDtoWindow build() => _build();

  _$MerchantMenuWindowDtoWindow _build() {
    final _$result =
        _$v ??
        _$MerchantMenuWindowDtoWindow._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
            startsAt,
            r'MerchantMenuWindowDtoWindow',
            'startsAt',
          ),
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'MerchantMenuWindowDtoWindow',
            'endsAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
