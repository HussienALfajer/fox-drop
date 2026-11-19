// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_item_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuItemOrderDto extends MerchantMenuItemOrderDto {
  @override
  final BuiltList<String> itemIds;

  factory _$MerchantMenuItemOrderDto([
    void Function(MerchantMenuItemOrderDtoBuilder)? updates,
  ]) => (MerchantMenuItemOrderDtoBuilder()..update(updates))._build();

  _$MerchantMenuItemOrderDto._({required this.itemIds}) : super._();
  @override
  MerchantMenuItemOrderDto rebuild(
    void Function(MerchantMenuItemOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuItemOrderDtoBuilder toBuilder() =>
      MerchantMenuItemOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuItemOrderDto && itemIds == other.itemIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantMenuItemOrderDto',
    )..add('itemIds', itemIds)).toString();
  }
}

class MerchantMenuItemOrderDtoBuilder
    implements
        Builder<MerchantMenuItemOrderDto, MerchantMenuItemOrderDtoBuilder> {
  _$MerchantMenuItemOrderDto? _$v;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  MerchantMenuItemOrderDtoBuilder() {
    MerchantMenuItemOrderDto._defaults(this);
  }

  MerchantMenuItemOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemIds = $v.itemIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuItemOrderDto other) {
    _$v = other as _$MerchantMenuItemOrderDto;
  }

  @override
  void update(void Function(MerchantMenuItemOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuItemOrderDto build() => _build();

  _$MerchantMenuItemOrderDto _build() {
    _$MerchantMenuItemOrderDto _$result;
    try {
      _$result = _$v ?? _$MerchantMenuItemOrderDto._(itemIds: itemIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuItemOrderDto',
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
