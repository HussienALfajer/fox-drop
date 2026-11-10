// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_dto_add_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditDtoAddInner extends AdminEditDtoAddInner {
  @override
  final String itemId;
  @override
  final BuiltList<String> optionIds;
  @override
  final int quantity;

  factory _$AdminEditDtoAddInner([
    void Function(AdminEditDtoAddInnerBuilder)? updates,
  ]) => (AdminEditDtoAddInnerBuilder()..update(updates))._build();

  _$AdminEditDtoAddInner._({
    required this.itemId,
    required this.optionIds,
    required this.quantity,
  }) : super._();
  @override
  AdminEditDtoAddInner rebuild(
    void Function(AdminEditDtoAddInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditDtoAddInnerBuilder toBuilder() =>
      AdminEditDtoAddInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditDtoAddInner &&
        itemId == other.itemId &&
        optionIds == other.optionIds &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, optionIds.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEditDtoAddInner')
          ..add('itemId', itemId)
          ..add('optionIds', optionIds)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminEditDtoAddInnerBuilder
    implements Builder<AdminEditDtoAddInner, AdminEditDtoAddInnerBuilder> {
  _$AdminEditDtoAddInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  ListBuilder<String>? _optionIds;
  ListBuilder<String> get optionIds =>
      _$this._optionIds ??= ListBuilder<String>();
  set optionIds(ListBuilder<String>? optionIds) =>
      _$this._optionIds = optionIds;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminEditDtoAddInnerBuilder() {
    AdminEditDtoAddInner._defaults(this);
  }

  AdminEditDtoAddInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _optionIds = $v.optionIds.toBuilder();
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditDtoAddInner other) {
    _$v = other as _$AdminEditDtoAddInner;
  }

  @override
  void update(void Function(AdminEditDtoAddInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditDtoAddInner build() => _build();

  _$AdminEditDtoAddInner _build() {
    _$AdminEditDtoAddInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditDtoAddInner._(
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'AdminEditDtoAddInner',
              'itemId',
            ),
            optionIds: optionIds.build(),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'AdminEditDtoAddInner',
              'quantity',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'optionIds';
        optionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEditDtoAddInner',
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
