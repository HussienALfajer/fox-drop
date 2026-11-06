// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_menu_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutputMenuInner
    extends CustomerRestaurantPageDtoOutputMenuInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final CustomerRestaurantPageDtoOutputMenuInnerWindow? window;
  @override
  final BuiltList<CustomerRestaurantPageDtoOutputMenuInnerItemsInner> items;

  factory _$CustomerRestaurantPageDtoOutputMenuInner([
    void Function(CustomerRestaurantPageDtoOutputMenuInnerBuilder)? updates,
  ]) => (CustomerRestaurantPageDtoOutputMenuInnerBuilder()..update(updates))
      ._build();

  _$CustomerRestaurantPageDtoOutputMenuInner._({
    required this.id,
    required this.name,
    this.window,
    required this.items,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputMenuInner rebuild(
    void Function(CustomerRestaurantPageDtoOutputMenuInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputMenuInnerBuilder toBuilder() =>
      CustomerRestaurantPageDtoOutputMenuInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantPageDtoOutputMenuInner &&
        id == other.id &&
        name == other.name &&
        window == other.window &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantPageDtoOutputMenuInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('window', window)
          ..add('items', items))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputMenuInnerBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputMenuInner,
          CustomerRestaurantPageDtoOutputMenuInnerBuilder
        > {
  _$CustomerRestaurantPageDtoOutputMenuInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder? _window;
  CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder get window =>
      _$this._window ??=
          CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder();
  set window(CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder? window) =>
      _$this._window = window;

  ListBuilder<CustomerRestaurantPageDtoOutputMenuInnerItemsInner>? _items;
  ListBuilder<CustomerRestaurantPageDtoOutputMenuInnerItemsInner> get items =>
      _$this._items ??=
          ListBuilder<CustomerRestaurantPageDtoOutputMenuInnerItemsInner>();
  set items(
    ListBuilder<CustomerRestaurantPageDtoOutputMenuInnerItemsInner>? items,
  ) => _$this._items = items;

  CustomerRestaurantPageDtoOutputMenuInnerBuilder() {
    CustomerRestaurantPageDtoOutputMenuInner._defaults(this);
  }

  CustomerRestaurantPageDtoOutputMenuInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _window = $v.window?.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantPageDtoOutputMenuInner other) {
    _$v = other as _$CustomerRestaurantPageDtoOutputMenuInner;
  }

  @override
  void update(
    void Function(CustomerRestaurantPageDtoOutputMenuInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInner build() => _build();

  _$CustomerRestaurantPageDtoOutputMenuInner _build() {
    _$CustomerRestaurantPageDtoOutputMenuInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantPageDtoOutputMenuInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantPageDtoOutputMenuInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerRestaurantPageDtoOutputMenuInner',
              'name',
            ),
            window: _window?.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'window';
        _window?.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantPageDtoOutputMenuInner',
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
