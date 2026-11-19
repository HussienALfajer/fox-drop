// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_preview_category_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuPreviewCategoryOutput
    extends MerchantMenuPreviewCategoryOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final CustomerRestaurantPageDtoOutputMenuInnerWindow? window;
  @override
  final BuiltList<AdminMenuPreviewDtoOutputMenuInnerItemsInner> items;

  factory _$MerchantMenuPreviewCategoryOutput([
    void Function(MerchantMenuPreviewCategoryOutputBuilder)? updates,
  ]) => (MerchantMenuPreviewCategoryOutputBuilder()..update(updates))._build();

  _$MerchantMenuPreviewCategoryOutput._({
    required this.id,
    required this.name,
    this.window,
    required this.items,
  }) : super._();
  @override
  MerchantMenuPreviewCategoryOutput rebuild(
    void Function(MerchantMenuPreviewCategoryOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuPreviewCategoryOutputBuilder toBuilder() =>
      MerchantMenuPreviewCategoryOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuPreviewCategoryOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantMenuPreviewCategoryOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('window', window)
          ..add('items', items))
        .toString();
  }
}

class MerchantMenuPreviewCategoryOutputBuilder
    implements
        Builder<
          MerchantMenuPreviewCategoryOutput,
          MerchantMenuPreviewCategoryOutputBuilder
        > {
  _$MerchantMenuPreviewCategoryOutput? _$v;

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

  MerchantMenuPreviewCategoryOutputBuilder() {
    MerchantMenuPreviewCategoryOutput._defaults(this);
  }

  MerchantMenuPreviewCategoryOutputBuilder get _$this {
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
  void replace(MerchantMenuPreviewCategoryOutput other) {
    _$v = other as _$MerchantMenuPreviewCategoryOutput;
  }

  @override
  void update(
    void Function(MerchantMenuPreviewCategoryOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuPreviewCategoryOutput build() => _build();

  _$MerchantMenuPreviewCategoryOutput _build() {
    _$MerchantMenuPreviewCategoryOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuPreviewCategoryOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuPreviewCategoryOutput',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuPreviewCategoryOutput',
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
          r'MerchantMenuPreviewCategoryOutput',
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
