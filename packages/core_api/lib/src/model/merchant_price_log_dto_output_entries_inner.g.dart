// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_price_log_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item =
    const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum._('item');
const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option =
    const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum._('option');

MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnumValueOf(String name) {
  switch (name) {
    case 'item':
      return _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item;
    case 'option':
      return _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
_$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnumValues =
    BuiltSet<MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum>(
      const <MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum>[
        _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item,
        _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option,
      ],
    );

const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_admin =
    const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum._('admin');
const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant =
    const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum._('merchant');
const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_system =
    const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum._('system');

MerchantPriceLogDtoOutputEntriesInnerByTypeEnum
_$merchantPriceLogDtoOutputEntriesInnerByTypeEnumValueOf(String name) {
  switch (name) {
    case 'admin':
      return _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_admin;
    case 'merchant':
      return _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant;
    case 'system':
      return _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_system;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantPriceLogDtoOutputEntriesInnerByTypeEnum>
_$merchantPriceLogDtoOutputEntriesInnerByTypeEnumValues =
    BuiltSet<MerchantPriceLogDtoOutputEntriesInnerByTypeEnum>(
      const <MerchantPriceLogDtoOutputEntriesInnerByTypeEnum>[
        _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_admin,
        _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant,
        _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_system,
      ],
    );

Serializer<MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
_$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer =
    _$MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer();
Serializer<MerchantPriceLogDtoOutputEntriesInnerByTypeEnum>
_$merchantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer =
    _$MerchantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer();

class _$MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'item': 'item',
    'option': 'option',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'item': 'item',
    'option': 'option',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum,
  ];
  @override
  final String wireName = 'MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer
    implements
        PrimitiveSerializer<MerchantPriceLogDtoOutputEntriesInnerByTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'admin': 'admin',
    'merchant': 'merchant',
    'system': 'system',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'admin': 'admin',
    'merchant': 'merchant',
    'system': 'system',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantPriceLogDtoOutputEntriesInnerByTypeEnum,
  ];
  @override
  final String wireName = 'MerchantPriceLogDtoOutputEntriesInnerByTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantPriceLogDtoOutputEntriesInnerByTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantPriceLogDtoOutputEntriesInnerByTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantPriceLogDtoOutputEntriesInnerByTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantPriceLogDtoOutputEntriesInner
    extends MerchantPriceLogDtoOutputEntriesInner {
  @override
  final String id;
  @override
  final MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum targetType;
  @override
  final String targetId;
  @override
  final String name;
  @override
  final String? groupName;
  @override
  final MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice oldPrice;
  @override
  final MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice newPrice;
  @override
  final MerchantPriceLogDtoOutputEntriesInnerByTypeEnum byType;
  @override
  final String? byName;
  @override
  final DateTime at;

  factory _$MerchantPriceLogDtoOutputEntriesInner([
    void Function(MerchantPriceLogDtoOutputEntriesInnerBuilder)? updates,
  ]) => (MerchantPriceLogDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$MerchantPriceLogDtoOutputEntriesInner._({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.name,
    this.groupName,
    required this.oldPrice,
    required this.newPrice,
    required this.byType,
    this.byName,
    required this.at,
  }) : super._();
  @override
  MerchantPriceLogDtoOutputEntriesInner rebuild(
    void Function(MerchantPriceLogDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPriceLogDtoOutputEntriesInnerBuilder toBuilder() =>
      MerchantPriceLogDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPriceLogDtoOutputEntriesInner &&
        id == other.id &&
        targetType == other.targetType &&
        targetId == other.targetId &&
        name == other.name &&
        groupName == other.groupName &&
        oldPrice == other.oldPrice &&
        newPrice == other.newPrice &&
        byType == other.byType &&
        byName == other.byName &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, groupName.hashCode);
    _$hash = $jc(_$hash, oldPrice.hashCode);
    _$hash = $jc(_$hash, newPrice.hashCode);
    _$hash = $jc(_$hash, byType.hashCode);
    _$hash = $jc(_$hash, byName.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantPriceLogDtoOutputEntriesInner',
          )
          ..add('id', id)
          ..add('targetType', targetType)
          ..add('targetId', targetId)
          ..add('name', name)
          ..add('groupName', groupName)
          ..add('oldPrice', oldPrice)
          ..add('newPrice', newPrice)
          ..add('byType', byType)
          ..add('byName', byName)
          ..add('at', at))
        .toString();
  }
}

class MerchantPriceLogDtoOutputEntriesInnerBuilder
    implements
        Builder<
          MerchantPriceLogDtoOutputEntriesInner,
          MerchantPriceLogDtoOutputEntriesInnerBuilder
        > {
  _$MerchantPriceLogDtoOutputEntriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum? _targetType;
  MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum? get targetType =>
      _$this._targetType;
  set targetType(
    MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum? targetType,
  ) => _$this._targetType = targetType;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _groupName;
  String? get groupName => _$this._groupName;
  set groupName(String? groupName) => _$this._groupName = groupName;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? _oldPrice;
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder get oldPrice =>
      _$this._oldPrice ??=
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder();
  set oldPrice(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? oldPrice,
  ) => _$this._oldPrice = oldPrice;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? _newPrice;
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder get newPrice =>
      _$this._newPrice ??=
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder();
  set newPrice(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? newPrice,
  ) => _$this._newPrice = newPrice;

  MerchantPriceLogDtoOutputEntriesInnerByTypeEnum? _byType;
  MerchantPriceLogDtoOutputEntriesInnerByTypeEnum? get byType => _$this._byType;
  set byType(MerchantPriceLogDtoOutputEntriesInnerByTypeEnum? byType) =>
      _$this._byType = byType;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  MerchantPriceLogDtoOutputEntriesInnerBuilder() {
    MerchantPriceLogDtoOutputEntriesInner._defaults(this);
  }

  MerchantPriceLogDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _targetType = $v.targetType;
      _targetId = $v.targetId;
      _name = $v.name;
      _groupName = $v.groupName;
      _oldPrice = $v.oldPrice.toBuilder();
      _newPrice = $v.newPrice.toBuilder();
      _byType = $v.byType;
      _byName = $v.byName;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPriceLogDtoOutputEntriesInner other) {
    _$v = other as _$MerchantPriceLogDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(MerchantPriceLogDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPriceLogDtoOutputEntriesInner build() => _build();

  _$MerchantPriceLogDtoOutputEntriesInner _build() {
    _$MerchantPriceLogDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPriceLogDtoOutputEntriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantPriceLogDtoOutputEntriesInner',
              'id',
            ),
            targetType: BuiltValueNullFieldError.checkNotNull(
              targetType,
              r'MerchantPriceLogDtoOutputEntriesInner',
              'targetType',
            ),
            targetId: BuiltValueNullFieldError.checkNotNull(
              targetId,
              r'MerchantPriceLogDtoOutputEntriesInner',
              'targetId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantPriceLogDtoOutputEntriesInner',
              'name',
            ),
            groupName: groupName,
            oldPrice: oldPrice.build(),
            newPrice: newPrice.build(),
            byType: BuiltValueNullFieldError.checkNotNull(
              byType,
              r'MerchantPriceLogDtoOutputEntriesInner',
              'byType',
            ),
            byName: byName,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'MerchantPriceLogDtoOutputEntriesInner',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'oldPrice';
        oldPrice.build();
        _$failedField = 'newPrice';
        newPrice.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPriceLogDtoOutputEntriesInner',
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
