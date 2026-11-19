// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_window.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInnerWindow
    extends MerchantMenuDtoOutputCategoriesInnerWindow {
  @override
  final int startsAt;
  @override
  final int endsAt;

  factory _$MerchantMenuDtoOutputCategoriesInnerWindow([
    void Function(MerchantMenuDtoOutputCategoriesInnerWindowBuilder)? updates,
  ]) => (MerchantMenuDtoOutputCategoriesInnerWindowBuilder()..update(updates))
      ._build();

  _$MerchantMenuDtoOutputCategoriesInnerWindow._({
    required this.startsAt,
    required this.endsAt,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerWindow rebuild(
    void Function(MerchantMenuDtoOutputCategoriesInnerWindowBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerWindowBuilder toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerWindowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputCategoriesInnerWindow &&
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
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputCategoriesInnerWindow',
          )
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerWindowBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerWindow,
          MerchantMenuDtoOutputCategoriesInnerWindowBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerWindow? _$v;

  int? _startsAt;
  int? get startsAt => _$this._startsAt;
  set startsAt(int? startsAt) => _$this._startsAt = startsAt;

  int? _endsAt;
  int? get endsAt => _$this._endsAt;
  set endsAt(int? endsAt) => _$this._endsAt = endsAt;

  MerchantMenuDtoOutputCategoriesInnerWindowBuilder() {
    MerchantMenuDtoOutputCategoriesInnerWindow._defaults(this);
  }

  MerchantMenuDtoOutputCategoriesInnerWindowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputCategoriesInnerWindow other) {
    _$v = other as _$MerchantMenuDtoOutputCategoriesInnerWindow;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputCategoriesInnerWindowBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerWindow build() => _build();

  _$MerchantMenuDtoOutputCategoriesInnerWindow _build() {
    final _$result =
        _$v ??
        _$MerchantMenuDtoOutputCategoriesInnerWindow._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
            startsAt,
            r'MerchantMenuDtoOutputCategoriesInnerWindow',
            'startsAt',
          ),
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'MerchantMenuDtoOutputCategoriesInnerWindow',
            'endsAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
