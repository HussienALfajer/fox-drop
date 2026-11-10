// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_item_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantItemReportDtoNoteEnum
_$merchantItemReportDtoNoteEnum_similarSubstitute =
    const MerchantItemReportDtoNoteEnum._('similarSubstitute');
const MerchantItemReportDtoNoteEnum _$merchantItemReportDtoNoteEnum_notEnough =
    const MerchantItemReportDtoNoteEnum._('notEnough');

MerchantItemReportDtoNoteEnum _$merchantItemReportDtoNoteEnumValueOf(
  String name,
) {
  switch (name) {
    case 'similarSubstitute':
      return _$merchantItemReportDtoNoteEnum_similarSubstitute;
    case 'notEnough':
      return _$merchantItemReportDtoNoteEnum_notEnough;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantItemReportDtoNoteEnum>
_$merchantItemReportDtoNoteEnumValues = BuiltSet<MerchantItemReportDtoNoteEnum>(
  const <MerchantItemReportDtoNoteEnum>[
    _$merchantItemReportDtoNoteEnum_similarSubstitute,
    _$merchantItemReportDtoNoteEnum_notEnough,
  ],
);

Serializer<MerchantItemReportDtoNoteEnum>
_$merchantItemReportDtoNoteEnumSerializer =
    _$MerchantItemReportDtoNoteEnumSerializer();

class _$MerchantItemReportDtoNoteEnumSerializer
    implements PrimitiveSerializer<MerchantItemReportDtoNoteEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'similarSubstitute': 'similar_substitute',
    'notEnough': 'not_enough',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'similar_substitute': 'similarSubstitute',
    'not_enough': 'notEnough',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantItemReportDtoNoteEnum];
  @override
  final String wireName = 'MerchantItemReportDtoNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantItemReportDtoNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantItemReportDtoNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantItemReportDtoNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantItemReportDto extends MerchantItemReportDto {
  @override
  final BuiltList<MerchantRejectDtoItemsInner> items;
  @override
  final MerchantItemReportDtoNoteEnum? note;

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

  MerchantItemReportDtoNoteEnum? _note;
  MerchantItemReportDtoNoteEnum? get note => _$this._note;
  set note(MerchantItemReportDtoNoteEnum? note) => _$this._note = note;

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
