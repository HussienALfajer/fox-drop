// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInnerItemsInner
    extends MerchantMenuDtoOutputCategoriesInnerItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  final MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice price;
  @override
  final bool available;
  @override
  final MerchantMenuDtoOutputCategoriesInnerSwitchedOff? switchedOff;
  @override
  final bool hidden;
  @override
  final BuiltList<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
  >
  optionGroups;

  factory _$MerchantMenuDtoOutputCategoriesInnerItemsInner([
    void Function(MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder)?
    updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder()..update(updates))
          ._build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInner._({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.price,
    required this.available,
    this.switchedOff,
    required this.hidden,
    required this.optionGroups,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInner rebuild(
    void Function(MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputCategoriesInnerItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        available == other.available &&
        switchedOff == other.switchedOff &&
        hidden == other.hidden &&
        optionGroups == other.optionGroups;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, optionGroups.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
          )
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('available', available)
          ..add('switchedOff', switchedOff)
          ..add('hidden', hidden)
          ..add('optionGroups', optionGroups))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerItemsInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? _price;
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder get price =>
      _$this._price ??=
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder();
  set price(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? price,
  ) => _$this._price = price;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder? _switchedOff;
  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder get switchedOff =>
      _$this._switchedOff ??=
          MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder();
  set switchedOff(
    MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder? switchedOff,
  ) => _$this._switchedOff = switchedOff;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner>?
  _optionGroups;
  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner>
  get optionGroups => _$this._optionGroups ??=
      ListBuilder<
        MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
      >();
  set optionGroups(
    ListBuilder<
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
    >?
    optionGroups,
  ) => _$this._optionGroups = optionGroups;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder() {
    MerchantMenuDtoOutputCategoriesInnerItemsInner._defaults(this);
  }

  MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _description = $v.description;
      _price = $v.price.toBuilder();
      _available = $v.available;
      _switchedOff = $v.switchedOff?.toBuilder();
      _hidden = $v.hidden;
      _optionGroups = $v.optionGroups.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputCategoriesInnerItemsInner other) {
    _$v = other as _$MerchantMenuDtoOutputCategoriesInnerItemsInner;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInner build() => _build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInner _build() {
    _$MerchantMenuDtoOutputCategoriesInnerItemsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputCategoriesInnerItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
              'id',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
              'code',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
              'name',
            ),
            description: description,
            price: price.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
              'available',
            ),
            switchedOff: _switchedOff?.build(),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
              'hidden',
            ),
            optionGroups: optionGroups.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();

        _$failedField = 'switchedOff';
        _switchedOff?.build();

        _$failedField = 'optionGroups';
        optionGroups.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputCategoriesInnerItemsInner',
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
