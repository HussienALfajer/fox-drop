// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_item_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantItemReportDto extends MerchantItemReportDto {
  @override
  final BuiltList<MerchantRejectDtoItemsInner> items;
  @override
  final String? note;

  factory _$MerchantItemReportDto([
    void Function(MerchantItemReportDtoBuilder)? updates,
  ]) => (MerchantItemReportDtoBuilder()..update(updates))._build();

  _$MerchantItemReportDto._({required this.items, this.note}) : super._();
  @override
  MerchantItemReportDto rebuild(
    void Function(MerchantItemReportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantItemReportDtoBuilder toBuilder() =>
      MerchantItemReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantItemReportDto &&
        items == other.items &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantItemReportDto')
          ..add('items', items)
          ..add('note', note))
        .toString();
  }
}

class MerchantItemReportDtoBuilder
    implements Builder<MerchantItemReportDto, MerchantItemReportDtoBuilder> {
  _$MerchantItemReportDto? _$v;

  ListBuilder<MerchantRejectDtoItemsInner>? _items;
  ListBuilder<MerchantRejectDtoItemsInner> get items =>
      _$this._items ??= ListBuilder<MerchantRejectDtoItemsInner>();
  set items(ListBuilder<MerchantRejectDtoItemsInner>? items) =>
      _$this._items = items;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  MerchantItemReportDtoBuilder() {
    MerchantItemReportDto._defaults(this);
  }

  MerchantItemReportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantItemReportDto other) {
    _$v = other as _$MerchantItemReportDto;
  }

  @override
  void update(void Function(MerchantItemReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantItemReportDto build() => _build();

  _$MerchantItemReportDto _build() {
    _$MerchantItemReportDto _$result;
    try {
      _$result =
          _$v ?? _$MerchantItemReportDto._(items: items.build(), note: note);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantItemReportDto',
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
