// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_bulk_price_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuBulkPriceDtoKindEnum _$adminMenuBulkPriceDtoKindEnum_percent =
    const AdminMenuBulkPriceDtoKindEnum._('percent');
const AdminMenuBulkPriceDtoKindEnum _$adminMenuBulkPriceDtoKindEnum_amount =
    const AdminMenuBulkPriceDtoKindEnum._('amount');

AdminMenuBulkPriceDtoKindEnum _$adminMenuBulkPriceDtoKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'percent':
      return _$adminMenuBulkPriceDtoKindEnum_percent;
    case 'amount':
      return _$adminMenuBulkPriceDtoKindEnum_amount;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuBulkPriceDtoKindEnum>
_$adminMenuBulkPriceDtoKindEnumValues = BuiltSet<AdminMenuBulkPriceDtoKindEnum>(
  const <AdminMenuBulkPriceDtoKindEnum>[
    _$adminMenuBulkPriceDtoKindEnum_percent,
    _$adminMenuBulkPriceDtoKindEnum_amount,
  ],
);

const AdminMenuBulkPriceDtoDirectionEnum
_$adminMenuBulkPriceDtoDirectionEnum_up =
    const AdminMenuBulkPriceDtoDirectionEnum._('up');
const AdminMenuBulkPriceDtoDirectionEnum
_$adminMenuBulkPriceDtoDirectionEnum_down =
    const AdminMenuBulkPriceDtoDirectionEnum._('down');

AdminMenuBulkPriceDtoDirectionEnum _$adminMenuBulkPriceDtoDirectionEnumValueOf(
  String name,
) {
  switch (name) {
    case 'up':
      return _$adminMenuBulkPriceDtoDirectionEnum_up;
    case 'down':
      return _$adminMenuBulkPriceDtoDirectionEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuBulkPriceDtoDirectionEnum>
_$adminMenuBulkPriceDtoDirectionEnumValues =
    BuiltSet<AdminMenuBulkPriceDtoDirectionEnum>(
      const <AdminMenuBulkPriceDtoDirectionEnum>[
        _$adminMenuBulkPriceDtoDirectionEnum_up,
        _$adminMenuBulkPriceDtoDirectionEnum_down,
      ],
    );

Serializer<AdminMenuBulkPriceDtoKindEnum>
_$adminMenuBulkPriceDtoKindEnumSerializer =
    _$AdminMenuBulkPriceDtoKindEnumSerializer();
Serializer<AdminMenuBulkPriceDtoDirectionEnum>
_$adminMenuBulkPriceDtoDirectionEnumSerializer =
    _$AdminMenuBulkPriceDtoDirectionEnumSerializer();

class _$AdminMenuBulkPriceDtoKindEnumSerializer
    implements PrimitiveSerializer<AdminMenuBulkPriceDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'percent': 'percent',
    'amount': 'amount',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'percent': 'percent',
    'amount': 'amount',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminMenuBulkPriceDtoKindEnum];
  @override
  final String wireName = 'AdminMenuBulkPriceDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkPriceDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuBulkPriceDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuBulkPriceDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuBulkPriceDtoDirectionEnumSerializer
    implements PrimitiveSerializer<AdminMenuBulkPriceDtoDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminMenuBulkPriceDtoDirectionEnum];
  @override
  final String wireName = 'AdminMenuBulkPriceDtoDirectionEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkPriceDtoDirectionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuBulkPriceDtoDirectionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuBulkPriceDtoDirectionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuBulkPriceDto extends AdminMenuBulkPriceDto {
  @override
  final String? categoryId;
  @override
  final AdminMenuBulkPriceDtoKindEnum kind;
  @override
  final AdminMenuBulkPriceDtoDirectionEnum direction;
  @override
  final String value;

  factory _$AdminMenuBulkPriceDto([
    void Function(AdminMenuBulkPriceDtoBuilder)? updates,
  ]) => (AdminMenuBulkPriceDtoBuilder()..update(updates))._build();

  _$AdminMenuBulkPriceDto._({
    this.categoryId,
    required this.kind,
    required this.direction,
    required this.value,
  }) : super._();
  @override
  AdminMenuBulkPriceDto rebuild(
    void Function(AdminMenuBulkPriceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuBulkPriceDtoBuilder toBuilder() =>
      AdminMenuBulkPriceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuBulkPriceDto &&
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
    return (newBuiltValueToStringHelper(r'AdminMenuBulkPriceDto')
          ..add('categoryId', categoryId)
          ..add('kind', kind)
          ..add('direction', direction)
          ..add('value', value))
        .toString();
  }
}

class AdminMenuBulkPriceDtoBuilder
    implements Builder<AdminMenuBulkPriceDto, AdminMenuBulkPriceDtoBuilder> {
  _$AdminMenuBulkPriceDto? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  AdminMenuBulkPriceDtoKindEnum? _kind;
  AdminMenuBulkPriceDtoKindEnum? get kind => _$this._kind;
  set kind(AdminMenuBulkPriceDtoKindEnum? kind) => _$this._kind = kind;

  AdminMenuBulkPriceDtoDirectionEnum? _direction;
  AdminMenuBulkPriceDtoDirectionEnum? get direction => _$this._direction;
  set direction(AdminMenuBulkPriceDtoDirectionEnum? direction) =>
      _$this._direction = direction;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  AdminMenuBulkPriceDtoBuilder() {
    AdminMenuBulkPriceDto._defaults(this);
  }

  AdminMenuBulkPriceDtoBuilder get _$this {
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
  void replace(AdminMenuBulkPriceDto other) {
    _$v = other as _$AdminMenuBulkPriceDto;
  }

  @override
  void update(void Function(AdminMenuBulkPriceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuBulkPriceDto build() => _build();

  _$AdminMenuBulkPriceDto _build() {
    final _$result =
        _$v ??
        _$AdminMenuBulkPriceDto._(
          categoryId: categoryId,
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminMenuBulkPriceDto',
            'kind',
          ),
          direction: BuiltValueNullFieldError.checkNotNull(
            direction,
            r'AdminMenuBulkPriceDto',
            'direction',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'AdminMenuBulkPriceDto',
            'value',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
