// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_new_item_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantNewItemRequestDto extends MerchantNewItemRequestDto {
  @override
  final String categoryId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final MerchantMenuItemPriceDtoPrice price;
  @override
  final String? uploadId;

  factory _$MerchantNewItemRequestDto([
    void Function(MerchantNewItemRequestDtoBuilder)? updates,
  ]) => (MerchantNewItemRequestDtoBuilder()..update(updates))._build();

  _$MerchantNewItemRequestDto._({
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.uploadId,
  }) : super._();
  @override
  MerchantNewItemRequestDto rebuild(
    void Function(MerchantNewItemRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantNewItemRequestDtoBuilder toBuilder() =>
      MerchantNewItemRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantNewItemRequestDto &&
        categoryId == other.categoryId &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        uploadId == other.uploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, uploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantNewItemRequestDto')
          ..add('categoryId', categoryId)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('uploadId', uploadId))
        .toString();
  }
}

class MerchantNewItemRequestDtoBuilder
    implements
        Builder<MerchantNewItemRequestDto, MerchantNewItemRequestDtoBuilder> {
  _$MerchantNewItemRequestDto? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  MerchantMenuItemPriceDtoPriceBuilder? _price;
  MerchantMenuItemPriceDtoPriceBuilder get price =>
      _$this._price ??= MerchantMenuItemPriceDtoPriceBuilder();
  set price(MerchantMenuItemPriceDtoPriceBuilder? price) =>
      _$this._price = price;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  MerchantNewItemRequestDtoBuilder() {
    MerchantNewItemRequestDto._defaults(this);
  }

  MerchantNewItemRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _name = $v.name;
      _description = $v.description;
      _price = $v.price.toBuilder();
      _uploadId = $v.uploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantNewItemRequestDto other) {
    _$v = other as _$MerchantNewItemRequestDto;
  }

  @override
  void update(void Function(MerchantNewItemRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantNewItemRequestDto build() => _build();

  _$MerchantNewItemRequestDto _build() {
    _$MerchantNewItemRequestDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantNewItemRequestDto._(
            categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId,
              r'MerchantNewItemRequestDto',
              'categoryId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantNewItemRequestDto',
              'name',
            ),
            description: description,
            price: price.build(),
            uploadId: uploadId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantNewItemRequestDto',
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
