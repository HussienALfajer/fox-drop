// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_bulk_preview_dto_output_rows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuBulkPreviewDtoOutputRowsInner
    extends MerchantMenuBulkPreviewDtoOutputRowsInner {
  @override
  final String itemId;
  @override
  final String code;
  @override
  final String name;
  @override
  final String categoryId;
  @override
  final String before;
  @override
  final String? after;

  factory _$MerchantMenuBulkPreviewDtoOutputRowsInner([
    void Function(MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder)? updates,
  ]) => (MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder()..update(updates))
      ._build();

  _$MerchantMenuBulkPreviewDtoOutputRowsInner._({
    required this.itemId,
    required this.code,
    required this.name,
    required this.categoryId,
    required this.before,
    this.after,
  }) : super._();
  @override
  MerchantMenuBulkPreviewDtoOutputRowsInner rebuild(
    void Function(MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder toBuilder() =>
      MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuBulkPreviewDtoOutputRowsInner &&
        itemId == other.itemId &&
        code == other.code &&
        name == other.name &&
        categoryId == other.categoryId &&
        before == other.before &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuBulkPreviewDtoOutputRowsInner',
          )
          ..add('itemId', itemId)
          ..add('code', code)
          ..add('name', name)
          ..add('categoryId', categoryId)
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder
    implements
        Builder<
          MerchantMenuBulkPreviewDtoOutputRowsInner,
          MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder
        > {
  _$MerchantMenuBulkPreviewDtoOutputRowsInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _before;
  String? get before => _$this._before;
  set before(String? before) => _$this._before = before;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder() {
    MerchantMenuBulkPreviewDtoOutputRowsInner._defaults(this);
  }

  MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _code = $v.code;
      _name = $v.name;
      _categoryId = $v.categoryId;
      _before = $v.before;
      _after = $v.after;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuBulkPreviewDtoOutputRowsInner other) {
    _$v = other as _$MerchantMenuBulkPreviewDtoOutputRowsInner;
  }

  @override
  void update(
    void Function(MerchantMenuBulkPreviewDtoOutputRowsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuBulkPreviewDtoOutputRowsInner build() => _build();

  _$MerchantMenuBulkPreviewDtoOutputRowsInner _build() {
    final _$result =
        _$v ??
        _$MerchantMenuBulkPreviewDtoOutputRowsInner._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'MerchantMenuBulkPreviewDtoOutputRowsInner',
            'itemId',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantMenuBulkPreviewDtoOutputRowsInner',
            'code',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantMenuBulkPreviewDtoOutputRowsInner',
            'name',
          ),
          categoryId: BuiltValueNullFieldError.checkNotNull(
            categoryId,
            r'MerchantMenuBulkPreviewDtoOutputRowsInner',
            'categoryId',
          ),
          before: BuiltValueNullFieldError.checkNotNull(
            before,
            r'MerchantMenuBulkPreviewDtoOutputRowsInner',
            'before',
          ),
          after: after,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
