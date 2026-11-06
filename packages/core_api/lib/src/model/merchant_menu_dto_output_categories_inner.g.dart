// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInner
    extends MerchantMenuDtoOutputCategoriesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool hidden;
  @override
  final bool available;
  @override
  final MerchantMenuDtoOutputCategoriesInnerSwitchedOff? switchedOff;
  @override
  final BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInner> items;

  factory _$MerchantMenuDtoOutputCategoriesInner([
    void Function(MerchantMenuDtoOutputCategoriesInnerBuilder)? updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerBuilder()..update(updates))._build();

  _$MerchantMenuDtoOutputCategoriesInner._({
    required this.id,
    required this.name,
    required this.hidden,
    required this.available,
    this.switchedOff,
    required this.items,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInner rebuild(
    void Function(MerchantMenuDtoOutputCategoriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerBuilder toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputCategoriesInner &&
        id == other.id &&
        name == other.name &&
        hidden == other.hidden &&
        available == other.available &&
        switchedOff == other.switchedOff &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantMenuDtoOutputCategoriesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('hidden', hidden)
          ..add('available', available)
          ..add('switchedOff', switchedOff)
          ..add('items', items))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInner,
          MerchantMenuDtoOutputCategoriesInnerBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

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

  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInner>? _items;
  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInner> get items =>
      _$this._items ??=
          ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInner>();
  set items(
    ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInner>? items,
  ) => _$this._items = items;

  MerchantMenuDtoOutputCategoriesInnerBuilder() {
    MerchantMenuDtoOutputCategoriesInner._defaults(this);
  }

  MerchantMenuDtoOutputCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _hidden = $v.hidden;
      _available = $v.available;
      _switchedOff = $v.switchedOff?.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputCategoriesInner other) {
    _$v = other as _$MerchantMenuDtoOutputCategoriesInner;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputCategoriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInner build() => _build();

  _$MerchantMenuDtoOutputCategoriesInner _build() {
    _$MerchantMenuDtoOutputCategoriesInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputCategoriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuDtoOutputCategoriesInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuDtoOutputCategoriesInner',
              'name',
            ),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'MerchantMenuDtoOutputCategoriesInner',
              'hidden',
            ),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'MerchantMenuDtoOutputCategoriesInner',
              'available',
            ),
            switchedOff: _switchedOff?.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'switchedOff';
        _switchedOff?.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputCategoriesInner',
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
