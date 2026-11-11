// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pickup_currencies_dto_output_choices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPickupCurrenciesDtoOutputChoicesInner
    extends MerchantPickupCurrenciesDtoOutputChoicesInner {
  @override
  final String currency;
  @override
  final String name;

  factory _$MerchantPickupCurrenciesDtoOutputChoicesInner([
    void Function(MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder)?
    updates,
  ]) =>
      (MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder()..update(updates))
          ._build();

  _$MerchantPickupCurrenciesDtoOutputChoicesInner._({
    required this.currency,
    required this.name,
  }) : super._();
  @override
  MerchantPickupCurrenciesDtoOutputChoicesInner rebuild(
    void Function(MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder toBuilder() =>
      MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPickupCurrenciesDtoOutputChoicesInner &&
        currency == other.currency &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantPickupCurrenciesDtoOutputChoicesInner',
          )
          ..add('currency', currency)
          ..add('name', name))
        .toString();
  }
}

class MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder
    implements
        Builder<
          MerchantPickupCurrenciesDtoOutputChoicesInner,
          MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder
        > {
  _$MerchantPickupCurrenciesDtoOutputChoicesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder() {
    MerchantPickupCurrenciesDtoOutputChoicesInner._defaults(this);
  }

  MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPickupCurrenciesDtoOutputChoicesInner other) {
    _$v = other as _$MerchantPickupCurrenciesDtoOutputChoicesInner;
  }

  @override
  void update(
    void Function(MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPickupCurrenciesDtoOutputChoicesInner build() => _build();

  _$MerchantPickupCurrenciesDtoOutputChoicesInner _build() {
    final _$result =
        _$v ??
        _$MerchantPickupCurrenciesDtoOutputChoicesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantPickupCurrenciesDtoOutputChoicesInner',
            'currency',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantPickupCurrenciesDtoOutputChoicesInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
