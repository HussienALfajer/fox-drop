// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_preview_dto_output_menu_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuPreviewDtoOutputMenuInner
    extends AdminMenuPreviewDtoOutputMenuInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final CustomerRestaurantPageDtoOutputMenuInnerWindow? window;
  @override
  final BuiltList<AdminMenuPreviewDtoOutputMenuInnerItemsInner> items;

  factory _$AdminMenuPreviewDtoOutputMenuInner([
    void Function(AdminMenuPreviewDtoOutputMenuInnerBuilder)? updates,
  ]) => (AdminMenuPreviewDtoOutputMenuInnerBuilder()..update(updates))._build();

  _$AdminMenuPreviewDtoOutputMenuInner._({
    required this.id,
    required this.name,
    this.window,
    required this.items,
  }) : super._();
  @override
  AdminMenuPreviewDtoOutputMenuInner rebuild(
    void Function(AdminMenuPreviewDtoOutputMenuInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuPreviewDtoOutputMenuInnerBuilder toBuilder() =>
      AdminMenuPreviewDtoOutputMenuInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuPreviewDtoOutputMenuInner &&
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
    return (newBuiltValueToStringHelper(r'AdminMenuPreviewDtoOutputMenuInner')
          ..add('id', id)
          ..add('name', name)
          ..add('window', window)
          ..add('items', items))
        .toString();
  }
}

class AdminMenuPreviewDtoOutputMenuInnerBuilder
    implements
        Builder<
          AdminMenuPreviewDtoOutputMenuInner,
          AdminMenuPreviewDtoOutputMenuInnerBuilder
        > {
  _$AdminMenuPreviewDtoOutputMenuInner? _$v;

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

  ListBuilder<AdminMenuPreviewDtoOutputMenuInnerItemsInner>? _items;
  ListBuilder<AdminMenuPreviewDtoOutputMenuInnerItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminMenuPreviewDtoOutputMenuInnerItemsInner>();
  set items(ListBuilder<AdminMenuPreviewDtoOutputMenuInnerItemsInner>? items) =>
      _$this._items = items;

  AdminMenuPreviewDtoOutputMenuInnerBuilder() {
    AdminMenuPreviewDtoOutputMenuInner._defaults(this);
  }

  AdminMenuPreviewDtoOutputMenuInnerBuilder get _$this {
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
  void replace(AdminMenuPreviewDtoOutputMenuInner other) {
    _$v = other as _$AdminMenuPreviewDtoOutputMenuInner;
  }

  @override
  void update(
    void Function(AdminMenuPreviewDtoOutputMenuInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuPreviewDtoOutputMenuInner build() => _build();

  _$AdminMenuPreviewDtoOutputMenuInner _build() {
    _$AdminMenuPreviewDtoOutputMenuInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuPreviewDtoOutputMenuInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMenuPreviewDtoOutputMenuInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuPreviewDtoOutputMenuInner',
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
          r'AdminMenuPreviewDtoOutputMenuInner',
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
