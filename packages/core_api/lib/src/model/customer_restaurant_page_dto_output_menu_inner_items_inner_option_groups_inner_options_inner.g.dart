// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_menu_inner_items_inner_option_groups_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    extends
        CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final CaptainWentOfflineDtoOutputHandIn? priceDelta;
  @override
  final bool available;

  factory _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner([
    void Function(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder,
    )?
    updates,
  ]) =>
      (CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner._({
    required this.id,
    required this.name,
    this.priceDelta,
    required this.available,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  rebuild(
    void Function(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
  toBuilder() =>
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta)
          ..add('available', available))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
        > {
  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner?
  _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CaptainWentOfflineDtoOutputHandInBuilder? _priceDelta;
  CaptainWentOfflineDtoOutputHandInBuilder get priceDelta =>
      _$this._priceDelta ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set priceDelta(CaptainWentOfflineDtoOutputHandInBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder() {
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner._defaults(
      this,
    );
  }

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta?.toBuilder();
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    other,
  ) {
    _$v =
        other
            as _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner;
  }

  @override
  void update(
    void Function(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  build() => _build();

  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  _build() {
    _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner',
              'name',
            ),
            priceDelta: _priceDelta?.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner',
              'available',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        _priceDelta?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner',
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
