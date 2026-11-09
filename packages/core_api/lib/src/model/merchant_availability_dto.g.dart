// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_availability_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantAvailabilityDtoTypeEnum
_$merchantAvailabilityDtoTypeEnum_category =
    const MerchantAvailabilityDtoTypeEnum._('category');
const MerchantAvailabilityDtoTypeEnum _$merchantAvailabilityDtoTypeEnum_item =
    const MerchantAvailabilityDtoTypeEnum._('item');
const MerchantAvailabilityDtoTypeEnum _$merchantAvailabilityDtoTypeEnum_option =
    const MerchantAvailabilityDtoTypeEnum._('option');

MerchantAvailabilityDtoTypeEnum _$merchantAvailabilityDtoTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'category':
      return _$merchantAvailabilityDtoTypeEnum_category;
    case 'item':
      return _$merchantAvailabilityDtoTypeEnum_item;
    case 'option':
      return _$merchantAvailabilityDtoTypeEnum_option;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantAvailabilityDtoTypeEnum>
_$merchantAvailabilityDtoTypeEnumValues =
    BuiltSet<MerchantAvailabilityDtoTypeEnum>(
      const <MerchantAvailabilityDtoTypeEnum>[
        _$merchantAvailabilityDtoTypeEnum_category,
        _$merchantAvailabilityDtoTypeEnum_item,
        _$merchantAvailabilityDtoTypeEnum_option,
      ],
    );

const MerchantAvailabilityDtoUntilEnum
_$merchantAvailabilityDtoUntilEnum_tomorrow =
    const MerchantAvailabilityDtoUntilEnum._('tomorrow');
const MerchantAvailabilityDtoUntilEnum
_$merchantAvailabilityDtoUntilEnum_turnedBackOn =
    const MerchantAvailabilityDtoUntilEnum._('turnedBackOn');

MerchantAvailabilityDtoUntilEnum _$merchantAvailabilityDtoUntilEnumValueOf(
  String name,
) {
  switch (name) {
    case 'tomorrow':
      return _$merchantAvailabilityDtoUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$merchantAvailabilityDtoUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantAvailabilityDtoUntilEnum>
_$merchantAvailabilityDtoUntilEnumValues =
    BuiltSet<MerchantAvailabilityDtoUntilEnum>(
      const <MerchantAvailabilityDtoUntilEnum>[
        _$merchantAvailabilityDtoUntilEnum_tomorrow,
        _$merchantAvailabilityDtoUntilEnum_turnedBackOn,
      ],
    );

Serializer<MerchantAvailabilityDtoTypeEnum>
_$merchantAvailabilityDtoTypeEnumSerializer =
    _$MerchantAvailabilityDtoTypeEnumSerializer();
Serializer<MerchantAvailabilityDtoUntilEnum>
_$merchantAvailabilityDtoUntilEnumSerializer =
    _$MerchantAvailabilityDtoUntilEnumSerializer();

class _$MerchantAvailabilityDtoTypeEnumSerializer
    implements PrimitiveSerializer<MerchantAvailabilityDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'category': 'category',
    'item': 'item',
    'option': 'option',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'category': 'category',
    'item': 'item',
    'option': 'option',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantAvailabilityDtoTypeEnum];
  @override
  final String wireName = 'MerchantAvailabilityDtoTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantAvailabilityDtoTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantAvailabilityDtoTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantAvailabilityDtoTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantAvailabilityDtoUntilEnumSerializer
    implements PrimitiveSerializer<MerchantAvailabilityDtoUntilEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'turnedBackOn': 'turned_back_on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'turned_back_on': 'turnedBackOn',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantAvailabilityDtoUntilEnum];
  @override
  final String wireName = 'MerchantAvailabilityDtoUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantAvailabilityDtoUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantAvailabilityDtoUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantAvailabilityDtoUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantAvailabilityDto extends MerchantAvailabilityDto {
  @override
  final MerchantAvailabilityDtoTypeEnum type;
  @override
  final String id;
  @override
  final bool available;
  @override
  final MerchantAvailabilityDtoUntilEnum? until;

  factory _$MerchantAvailabilityDto([
    void Function(MerchantAvailabilityDtoBuilder)? updates,
  ]) => (MerchantAvailabilityDtoBuilder()..update(updates))._build();

  _$MerchantAvailabilityDto._({
    required this.type,
    required this.id,
    required this.available,
    this.until,
  }) : super._();
  @override
  MerchantAvailabilityDto rebuild(
    void Function(MerchantAvailabilityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAvailabilityDtoBuilder toBuilder() =>
      MerchantAvailabilityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAvailabilityDto &&
        type == other.type &&
        id == other.id &&
        available == other.available &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantAvailabilityDto')
          ..add('type', type)
          ..add('id', id)
          ..add('available', available)
          ..add('until', until))
        .toString();
  }
}

class MerchantAvailabilityDtoBuilder
    implements
        Builder<MerchantAvailabilityDto, MerchantAvailabilityDtoBuilder> {
  _$MerchantAvailabilityDto? _$v;

  MerchantAvailabilityDtoTypeEnum? _type;
  MerchantAvailabilityDtoTypeEnum? get type => _$this._type;
  set type(MerchantAvailabilityDtoTypeEnum? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  MerchantAvailabilityDtoUntilEnum? _until;
  MerchantAvailabilityDtoUntilEnum? get until => _$this._until;
  set until(MerchantAvailabilityDtoUntilEnum? until) => _$this._until = until;

  MerchantAvailabilityDtoBuilder() {
    MerchantAvailabilityDto._defaults(this);
  }

  MerchantAvailabilityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _available = $v.available;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAvailabilityDto other) {
    _$v = other as _$MerchantAvailabilityDto;
  }

  @override
  void update(void Function(MerchantAvailabilityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAvailabilityDto build() => _build();

  _$MerchantAvailabilityDto _build() {
    final _$result =
        _$v ??
        _$MerchantAvailabilityDto._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'MerchantAvailabilityDto',
            'type',
          ),
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'MerchantAvailabilityDto',
            'id',
          ),
          available: BuiltValueNullFieldError.checkNotNull(
            available,
            r'MerchantAvailabilityDto',
            'available',
          ),
          until: until,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
