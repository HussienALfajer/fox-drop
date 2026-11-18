// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_dto_output_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuDtoOutputCategoriesInner
    extends AdminMenuDtoOutputCategoriesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool hidden;
  @override
  final AdminMenuSwitchedOffOutput? switchedOff;
  @override
  final AdminMenuWindowOutput? window;
  @override
  final BuiltList<AdminMenuDtoOutputCategoriesInnerItemsInner> items;

  factory _$AdminMenuDtoOutputCategoriesInner([
    void Function(AdminMenuDtoOutputCategoriesInnerBuilder)? updates,
  ]) => (AdminMenuDtoOutputCategoriesInnerBuilder()..update(updates))._build();

  _$AdminMenuDtoOutputCategoriesInner._({
    required this.id,
    required this.name,
    required this.hidden,
    this.switchedOff,
    this.window,
    required this.items,
  }) : super._();
  @override
  AdminMenuDtoOutputCategoriesInner rebuild(
    void Function(AdminMenuDtoOutputCategoriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuDtoOutputCategoriesInnerBuilder toBuilder() =>
      AdminMenuDtoOutputCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuDtoOutputCategoriesInner &&
        id == other.id &&
        name == other.name &&
        hidden == other.hidden &&
        switchedOff == other.switchedOff &&
        window == other.window &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuDtoOutputCategoriesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('hidden', hidden)
          ..add('switchedOff', switchedOff)
          ..add('window', window)
          ..add('items', items))
        .toString();
  }
}

class AdminMenuDtoOutputCategoriesInnerBuilder
    implements
        Builder<
          AdminMenuDtoOutputCategoriesInner,
          AdminMenuDtoOutputCategoriesInnerBuilder
        > {
  _$AdminMenuDtoOutputCategoriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  AdminMenuSwitchedOffOutputBuilder? _switchedOff;
  AdminMenuSwitchedOffOutputBuilder get switchedOff =>
      _$this._switchedOff ??= AdminMenuSwitchedOffOutputBuilder();
  set switchedOff(AdminMenuSwitchedOffOutputBuilder? switchedOff) =>
      _$this._switchedOff = switchedOff;

  AdminMenuWindowOutputBuilder? _window;
  AdminMenuWindowOutputBuilder get window =>
      _$this._window ??= AdminMenuWindowOutputBuilder();
  set window(AdminMenuWindowOutputBuilder? window) => _$this._window = window;

  ListBuilder<AdminMenuDtoOutputCategoriesInnerItemsInner>? _items;
  ListBuilder<AdminMenuDtoOutputCategoriesInnerItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminMenuDtoOutputCategoriesInnerItemsInner>();
  set items(ListBuilder<AdminMenuDtoOutputCategoriesInnerItemsInner>? items) =>
      _$this._items = items;

  AdminMenuDtoOutputCategoriesInnerBuilder() {
    AdminMenuDtoOutputCategoriesInner._defaults(this);
  }

  AdminMenuDtoOutputCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _hidden = $v.hidden;
      _switchedOff = $v.switchedOff?.toBuilder();
      _window = $v.window?.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuDtoOutputCategoriesInner other) {
    _$v = other as _$AdminMenuDtoOutputCategoriesInner;
  }

  @override
  void update(
    void Function(AdminMenuDtoOutputCategoriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuDtoOutputCategoriesInner build() => _build();

  _$AdminMenuDtoOutputCategoriesInner _build() {
    _$AdminMenuDtoOutputCategoriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuDtoOutputCategoriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMenuDtoOutputCategoriesInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuDtoOutputCategoriesInner',
              'name',
            ),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'AdminMenuDtoOutputCategoriesInner',
              'hidden',
            ),
            switchedOff: _switchedOff?.build(),
            window: _window?.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'switchedOff';
        _switchedOff?.build();
        _$failedField = 'window';
        _window?.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuDtoOutputCategoriesInner',
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
