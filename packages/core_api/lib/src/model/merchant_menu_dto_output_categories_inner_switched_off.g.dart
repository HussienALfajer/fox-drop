// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_switched_off.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff
    extends MerchantMenuDtoOutputCategoriesInnerSwitchedOff {
  @override
  final DateTime? until;

  factory _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff([
    void Function(MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder)?
    updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder()
            ..update(updates))
          ._build();

  _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff._({this.until}) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff rebuild(
    void Function(MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputCategoriesInnerSwitchedOff &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantMenuDtoOutputCategoriesInnerSwitchedOff',
    )..add('until', until)).toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerSwitchedOff,
          MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff? _$v;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder() {
    MerchantMenuDtoOutputCategoriesInnerSwitchedOff._defaults(this);
  }

  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputCategoriesInnerSwitchedOff other) {
    _$v = other as _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff build() => _build();

  _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff _build() {
    final _$result =
        _$v ??
        _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff._(until: until);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
