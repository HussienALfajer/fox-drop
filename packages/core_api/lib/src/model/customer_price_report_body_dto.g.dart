// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_price_report_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPriceReportBodyDto extends CustomerPriceReportBodyDto {
  @override
  final String? itemId;
  @override
  final String? shopPrice;
  @override
  final String? note;
  @override
  final String? photoUploadId;

  factory _$CustomerPriceReportBodyDto([
    void Function(CustomerPriceReportBodyDtoBuilder)? updates,
  ]) => (CustomerPriceReportBodyDtoBuilder()..update(updates))._build();

  _$CustomerPriceReportBodyDto._({
    this.itemId,
    this.shopPrice,
    this.note,
    this.photoUploadId,
  }) : super._();
  @override
  CustomerPriceReportBodyDto rebuild(
    void Function(CustomerPriceReportBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPriceReportBodyDtoBuilder toBuilder() =>
      CustomerPriceReportBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPriceReportBodyDto &&
        itemId == other.itemId &&
        shopPrice == other.shopPrice &&
        note == other.note &&
        photoUploadId == other.photoUploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, shopPrice.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, photoUploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerPriceReportBodyDto')
          ..add('itemId', itemId)
          ..add('shopPrice', shopPrice)
          ..add('note', note)
          ..add('photoUploadId', photoUploadId))
        .toString();
  }
}

class CustomerPriceReportBodyDtoBuilder
    implements
        Builder<CustomerPriceReportBodyDto, CustomerPriceReportBodyDtoBuilder> {
  _$CustomerPriceReportBodyDto? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _shopPrice;
  String? get shopPrice => _$this._shopPrice;
  set shopPrice(String? shopPrice) => _$this._shopPrice = shopPrice;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _photoUploadId;
  String? get photoUploadId => _$this._photoUploadId;
  set photoUploadId(String? photoUploadId) =>
      _$this._photoUploadId = photoUploadId;

  CustomerPriceReportBodyDtoBuilder() {
    CustomerPriceReportBodyDto._defaults(this);
  }

  CustomerPriceReportBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _shopPrice = $v.shopPrice;
      _note = $v.note;
      _photoUploadId = $v.photoUploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPriceReportBodyDto other) {
    _$v = other as _$CustomerPriceReportBodyDto;
  }

  @override
  void update(void Function(CustomerPriceReportBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPriceReportBodyDto build() => _build();

  _$CustomerPriceReportBodyDto _build() {
    final _$result =
        _$v ??
        _$CustomerPriceReportBodyDto._(
          itemId: itemId,
          shopPrice: shopPrice,
          note: note,
          photoUploadId: photoUploadId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
