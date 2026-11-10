// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_item_report_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
_$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_tomorrow =
    const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum._(
      'tomorrow',
    );
const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
_$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_turnedBackOn =
    const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum._(
      'turnedBackOn',
    );

MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
_$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumValueOf(
  String name,
) {
  switch (name) {
    case 'tomorrow':
      return _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum>
_$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumValues =
    BuiltSet<
      MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
    >(const <MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum>[
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_tomorrow,
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_turnedBackOn,
    ]);

Serializer<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum>
_$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumSerializer =
    _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumSerializer();

class _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
        > {
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
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum,
  ];
  @override
  final String wireName =
      'MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
    extends MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner {
  @override
  final String itemId;
  @override
  final String name;
  @override
  final MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum until;

  factory _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner([
    void Function(
      MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder,
    )?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner._({
    required this.itemId,
    required this.name,
    required this.until,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner &&
        itemId == other.itemId &&
        name == other.name &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner',
          )
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('until', until))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
          MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum? _until;
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum? get until =>
      _$this._until;
  set until(
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum? until,
  ) => _$this._until = until;

  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _name = $v.name;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner;
  }

  @override
  void update(
    void Function(
      MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner',
            'itemId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner',
            'name',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
