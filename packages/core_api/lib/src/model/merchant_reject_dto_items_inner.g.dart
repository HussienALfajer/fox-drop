// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_reject_dto_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantRejectDtoItemsInnerUntilEnum
_$merchantRejectDtoItemsInnerUntilEnum_tomorrow =
    const MerchantRejectDtoItemsInnerUntilEnum._('tomorrow');
const MerchantRejectDtoItemsInnerUntilEnum
_$merchantRejectDtoItemsInnerUntilEnum_turnedBackOn =
    const MerchantRejectDtoItemsInnerUntilEnum._('turnedBackOn');

MerchantRejectDtoItemsInnerUntilEnum
_$merchantRejectDtoItemsInnerUntilEnumValueOf(String name) {
  switch (name) {
    case 'tomorrow':
      return _$merchantRejectDtoItemsInnerUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$merchantRejectDtoItemsInnerUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantRejectDtoItemsInnerUntilEnum>
_$merchantRejectDtoItemsInnerUntilEnumValues =
    BuiltSet<MerchantRejectDtoItemsInnerUntilEnum>(
      const <MerchantRejectDtoItemsInnerUntilEnum>[
        _$merchantRejectDtoItemsInnerUntilEnum_tomorrow,
        _$merchantRejectDtoItemsInnerUntilEnum_turnedBackOn,
      ],
    );

Serializer<MerchantRejectDtoItemsInnerUntilEnum>
_$merchantRejectDtoItemsInnerUntilEnumSerializer =
    _$MerchantRejectDtoItemsInnerUntilEnumSerializer();

class _$MerchantRejectDtoItemsInnerUntilEnumSerializer
    implements PrimitiveSerializer<MerchantRejectDtoItemsInnerUntilEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'turnedBackOn': 'turned_back_on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'turned_back_on': 'turnedBackOn',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantRejectDtoItemsInnerUntilEnum,
  ];
  @override
  final String wireName = 'MerchantRejectDtoItemsInnerUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantRejectDtoItemsInnerUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantRejectDtoItemsInnerUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantRejectDtoItemsInnerUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantRejectDtoItemsInner extends MerchantRejectDtoItemsInner {
  @override
  final String itemId;
  @override
  final MerchantRejectDtoItemsInnerUntilEnum until;

  factory _$MerchantRejectDtoItemsInner([
    void Function(MerchantRejectDtoItemsInnerBuilder)? updates,
  ]) => (MerchantRejectDtoItemsInnerBuilder()..update(updates))._build();

  _$MerchantRejectDtoItemsInner._({required this.itemId, required this.until})
    : super._();
  @override
  MerchantRejectDtoItemsInner rebuild(
    void Function(MerchantRejectDtoItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRejectDtoItemsInnerBuilder toBuilder() =>
      MerchantRejectDtoItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRejectDtoItemsInner &&
        itemId == other.itemId &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantRejectDtoItemsInner')
          ..add('itemId', itemId)
          ..add('until', until))
        .toString();
  }
}

class MerchantRejectDtoItemsInnerBuilder
    implements
        Builder<
          MerchantRejectDtoItemsInner,
          MerchantRejectDtoItemsInnerBuilder
        > {
  _$MerchantRejectDtoItemsInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  MerchantRejectDtoItemsInnerUntilEnum? _until;
  MerchantRejectDtoItemsInnerUntilEnum? get until => _$this._until;
  set until(MerchantRejectDtoItemsInnerUntilEnum? until) =>
      _$this._until = until;

  MerchantRejectDtoItemsInnerBuilder() {
    MerchantRejectDtoItemsInner._defaults(this);
  }

  MerchantRejectDtoItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRejectDtoItemsInner other) {
    _$v = other as _$MerchantRejectDtoItemsInner;
  }

  @override
  void update(void Function(MerchantRejectDtoItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRejectDtoItemsInner build() => _build();

  _$MerchantRejectDtoItemsInner _build() {
    final _$result =
        _$v ??
        _$MerchantRejectDtoItemsInner._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'MerchantRejectDtoItemsInner',
            'itemId',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'MerchantRejectDtoItemsInner',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
