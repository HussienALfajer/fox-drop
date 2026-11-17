// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_report_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerReportOrderDto extends CustomerReportOrderDto {
  @override
  final String typeCode;
  @override
  final String? note;
  @override
  final BuiltList<CustomerReportOrderDtoItemsInner> items;
  @override
  final BuiltList<String> photoUploadIds;

  factory _$CustomerReportOrderDto([
    void Function(CustomerReportOrderDtoBuilder)? updates,
  ]) => (CustomerReportOrderDtoBuilder()..update(updates))._build();

  _$CustomerReportOrderDto._({
    required this.typeCode,
    this.note,
    required this.items,
    required this.photoUploadIds,
  }) : super._();
  @override
  CustomerReportOrderDto rebuild(
    void Function(CustomerReportOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerReportOrderDtoBuilder toBuilder() =>
      CustomerReportOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerReportOrderDto &&
        typeCode == other.typeCode &&
        note == other.note &&
        items == other.items &&
        photoUploadIds == other.photoUploadIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, photoUploadIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerReportOrderDto')
          ..add('typeCode', typeCode)
          ..add('note', note)
          ..add('items', items)
          ..add('photoUploadIds', photoUploadIds))
        .toString();
  }
}

class CustomerReportOrderDtoBuilder
    implements Builder<CustomerReportOrderDto, CustomerReportOrderDtoBuilder> {
  _$CustomerReportOrderDto? _$v;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<CustomerReportOrderDtoItemsInner>? _items;
  ListBuilder<CustomerReportOrderDtoItemsInner> get items =>
      _$this._items ??= ListBuilder<CustomerReportOrderDtoItemsInner>();
  set items(ListBuilder<CustomerReportOrderDtoItemsInner>? items) =>
      _$this._items = items;

  ListBuilder<String>? _photoUploadIds;
  ListBuilder<String> get photoUploadIds =>
      _$this._photoUploadIds ??= ListBuilder<String>();
  set photoUploadIds(ListBuilder<String>? photoUploadIds) =>
      _$this._photoUploadIds = photoUploadIds;

  CustomerReportOrderDtoBuilder() {
    CustomerReportOrderDto._defaults(this);
  }

  CustomerReportOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _typeCode = $v.typeCode;
      _note = $v.note;
      _items = $v.items.toBuilder();
      _photoUploadIds = $v.photoUploadIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerReportOrderDto other) {
    _$v = other as _$CustomerReportOrderDto;
  }

  @override
  void update(void Function(CustomerReportOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerReportOrderDto build() => _build();

  _$CustomerReportOrderDto _build() {
    _$CustomerReportOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerReportOrderDto._(
            typeCode: BuiltValueNullFieldError.checkNotNull(
              typeCode,
              r'CustomerReportOrderDto',
              'typeCode',
            ),
            note: note,
            items: items.build(),
            photoUploadIds: photoUploadIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
        _$failedField = 'photoUploadIds';
        photoUploadIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerReportOrderDto',
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
