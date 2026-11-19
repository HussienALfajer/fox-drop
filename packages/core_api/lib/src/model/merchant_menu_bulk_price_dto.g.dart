// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_bulk_price_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantMenuBulkPriceDtoKindEnum
_$merchantMenuBulkPriceDtoKindEnum_percent =
    const MerchantMenuBulkPriceDtoKindEnum._('percent');
const MerchantMenuBulkPriceDtoKindEnum
_$merchantMenuBulkPriceDtoKindEnum_amount =
    const MerchantMenuBulkPriceDtoKindEnum._('amount');

MerchantMenuBulkPriceDtoKindEnum _$merchantMenuBulkPriceDtoKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'percent':
      return _$merchantMenuBulkPriceDtoKindEnum_percent;
    case 'amount':
      return _$merchantMenuBulkPriceDtoKindEnum_amount;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantMenuBulkPriceDtoKindEnum>
_$merchantMenuBulkPriceDtoKindEnumValues =
    BuiltSet<MerchantMenuBulkPriceDtoKindEnum>(
      const <MerchantMenuBulkPriceDtoKindEnum>[
        _$merchantMenuBulkPriceDtoKindEnum_percent,
        _$merchantMenuBulkPriceDtoKindEnum_amount,
      ],
    );

const MerchantMenuBulkPriceDtoDirectionEnum
_$merchantMenuBulkPriceDtoDirectionEnum_up =
    const MerchantMenuBulkPriceDtoDirectionEnum._('up');
const MerchantMenuBulkPriceDtoDirectionEnum
_$merchantMenuBulkPriceDtoDirectionEnum_down =
    const MerchantMenuBulkPriceDtoDirectionEnum._('down');

MerchantMenuBulkPriceDtoDirectionEnum
_$merchantMenuBulkPriceDtoDirectionEnumValueOf(String name) {
  switch (name) {
    case 'up':
      return _$merchantMenuBulkPriceDtoDirectionEnum_up;
    case 'down':
      return _$merchantMenuBulkPriceDtoDirectionEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantMenuBulkPriceDtoDirectionEnum>
_$merchantMenuBulkPriceDtoDirectionEnumValues =
    BuiltSet<MerchantMenuBulkPriceDtoDirectionEnum>(
      const <MerchantMenuBulkPriceDtoDirectionEnum>[
        _$merchantMenuBulkPriceDtoDirectionEnum_up,
        _$merchantMenuBulkPriceDtoDirectionEnum_down,
      ],
    );

Serializer<MerchantMenuBulkPriceDtoKindEnum>
_$merchantMenuBulkPriceDtoKindEnumSerializer =
    _$MerchantMenuBulkPriceDtoKindEnumSerializer();
Serializer<MerchantMenuBulkPriceDtoDirectionEnum>
_$merchantMenuBulkPriceDtoDirectionEnumSerializer =
    _$MerchantMenuBulkPriceDtoDirectionEnumSerializer();

class _$MerchantMenuBulkPriceDtoKindEnumSerializer
    implements PrimitiveSerializer<MerchantMenuBulkPriceDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'percent': 'percent',
    'amount': 'amount',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'percent': 'percent',
    'amount': 'amount',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantMenuBulkPriceDtoKindEnum];
  @override
  final String wireName = 'MerchantMenuBulkPriceDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuBulkPriceDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantMenuBulkPriceDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantMenuBulkPriceDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantMenuBulkPriceDtoDirectionEnumSerializer
    implements PrimitiveSerializer<MerchantMenuBulkPriceDtoDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantMenuBulkPriceDtoDirectionEnum,
  ];
  @override
  final String wireName = 'MerchantMenuBulkPriceDtoDirectionEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuBulkPriceDtoDirectionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantMenuBulkPriceDtoDirectionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantMenuBulkPriceDtoDirectionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantMenuBulkPriceDto extends MerchantMenuBulkPriceDto {
  @override
  final String? categoryId;
  @override
  final MerchantMenuBulkPriceDtoKindEnum kind;
  @override
  final MerchantMenuBulkPriceDtoDirectionEnum direction;
  @override
  final String value;

  factory _$MerchantMenuBulkPriceDto([
    void Function(MerchantMenuBulkPriceDtoBuilder)? updates,
  ]) => (MerchantMenuBulkPriceDtoBuilder()..update(updates))._build();

  _$MerchantMenuBulkPriceDto._({
    this.categoryId,
    required this.kind,
    required this.direction,
    required this.value,
  }) : super._();
  @override
  MerchantMenuBulkPriceDto rebuild(
    void Function(MerchantMenuBulkPriceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuBulkPriceDtoBuilder toBuilder() =>
      MerchantMenuBulkPriceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuBulkPriceDto &&
        categoryId == other.categoryId &&
        kind == other.kind &&
        direction == other.direction &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantMenuBulkPriceDto')
          ..add('categoryId', categoryId)
          ..add('kind', kind)
          ..add('direction', direction)
          ..add('value', value))
        .toString();
  }
}

class MerchantMenuBulkPriceDtoBuilder
    implements
        Builder<MerchantMenuBulkPriceDto, MerchantMenuBulkPriceDtoBuilder> {
  _$MerchantMenuBulkPriceDto? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  MerchantMenuBulkPriceDtoKindEnum? _kind;
  MerchantMenuBulkPriceDtoKindEnum? get kind => _$this._kind;
  set kind(MerchantMenuBulkPriceDtoKindEnum? kind) => _$this._kind = kind;

  MerchantMenuBulkPriceDtoDirectionEnum? _direction;
  MerchantMenuBulkPriceDtoDirectionEnum? get direction => _$this._direction;
  set direction(MerchantMenuBulkPriceDtoDirectionEnum? direction) =>
      _$this._direction = direction;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  MerchantMenuBulkPriceDtoBuilder() {
    MerchantMenuBulkPriceDto._defaults(this);
  }

  MerchantMenuBulkPriceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _kind = $v.kind;
      _direction = $v.direction;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuBulkPriceDto other) {
    _$v = other as _$MerchantMenuBulkPriceDto;
  }

  @override
  void update(void Function(MerchantMenuBulkPriceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuBulkPriceDto build() => _build();

  _$MerchantMenuBulkPriceDto _build() {
    final _$result =
        _$v ??
        _$MerchantMenuBulkPriceDto._(
          categoryId: categoryId,
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'MerchantMenuBulkPriceDto',
            'kind',
          ),
          direction: BuiltValueNullFieldError.checkNotNull(
            direction,
            r'MerchantMenuBulkPriceDto',
            'direction',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'MerchantMenuBulkPriceDto',
            'value',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
