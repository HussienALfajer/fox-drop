// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_status_dto_output_pickup_currency_choices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner
    extends AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner {
  @override
  final String currency;
  @override
  final String name;

  factory _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner([
    void Function(
      AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner._({
    required this.currency,
    required this.name,
  }) : super._();
  @override
  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner rebuild(
    void Function(
      AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder toBuilder() =>
      AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner &&
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
            r'AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner',
          )
          ..add('currency', currency)
          ..add('name', name))
        .toString();
  }
}

class AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder
    implements
        Builder<
          AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner,
          AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder
        > {
  _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder() {
    AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner._defaults(this);
  }

  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner other) {
    _$v = other as _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner;
  }

  @override
  void update(
    void Function(
      AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner build() => _build();

  _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner',
            'currency',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
