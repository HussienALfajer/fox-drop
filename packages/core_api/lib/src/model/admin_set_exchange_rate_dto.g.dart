// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_exchange_rate_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetExchangeRateDtoDirectionEnum
_$adminSetExchangeRateDtoDirectionEnum_basePerUnit =
    const AdminSetExchangeRateDtoDirectionEnum._('basePerUnit');
const AdminSetExchangeRateDtoDirectionEnum
_$adminSetExchangeRateDtoDirectionEnum_unitsPerBase =
    const AdminSetExchangeRateDtoDirectionEnum._('unitsPerBase');

AdminSetExchangeRateDtoDirectionEnum
_$adminSetExchangeRateDtoDirectionEnumValueOf(String name) {
  switch (name) {
    case 'basePerUnit':
      return _$adminSetExchangeRateDtoDirectionEnum_basePerUnit;
    case 'unitsPerBase':
      return _$adminSetExchangeRateDtoDirectionEnum_unitsPerBase;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetExchangeRateDtoDirectionEnum>
_$adminSetExchangeRateDtoDirectionEnumValues =
    BuiltSet<AdminSetExchangeRateDtoDirectionEnum>(
      const <AdminSetExchangeRateDtoDirectionEnum>[
        _$adminSetExchangeRateDtoDirectionEnum_basePerUnit,
        _$adminSetExchangeRateDtoDirectionEnum_unitsPerBase,
      ],
    );

Serializer<AdminSetExchangeRateDtoDirectionEnum>
_$adminSetExchangeRateDtoDirectionEnumSerializer =
    _$AdminSetExchangeRateDtoDirectionEnumSerializer();

class _$AdminSetExchangeRateDtoDirectionEnumSerializer
    implements PrimitiveSerializer<AdminSetExchangeRateDtoDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'basePerUnit': 'base_per_unit',
    'unitsPerBase': 'units_per_base',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'base_per_unit': 'basePerUnit',
    'units_per_base': 'unitsPerBase',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSetExchangeRateDtoDirectionEnum,
  ];
  @override
  final String wireName = 'AdminSetExchangeRateDtoDirectionEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetExchangeRateDtoDirectionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetExchangeRateDtoDirectionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetExchangeRateDtoDirectionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetExchangeRateDto extends AdminSetExchangeRateDto {
  @override
  final String cityId;
  @override
  final String currency;
  @override
  final String value;
  @override
  final AdminSetExchangeRateDtoDirectionEnum direction;
  @override
  final String? reason;
  @override
  final bool? confirmLargeChange;

  factory _$AdminSetExchangeRateDto([
    void Function(AdminSetExchangeRateDtoBuilder)? updates,
  ]) => (AdminSetExchangeRateDtoBuilder()..update(updates))._build();

  _$AdminSetExchangeRateDto._({
    required this.cityId,
    required this.currency,
    required this.value,
    required this.direction,
    this.reason,
    this.confirmLargeChange,
  }) : super._();
  @override
  AdminSetExchangeRateDto rebuild(
    void Function(AdminSetExchangeRateDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetExchangeRateDtoBuilder toBuilder() =>
      AdminSetExchangeRateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetExchangeRateDto &&
        cityId == other.cityId &&
        currency == other.currency &&
        value == other.value &&
        direction == other.direction &&
        reason == other.reason &&
        confirmLargeChange == other.confirmLargeChange;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, confirmLargeChange.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetExchangeRateDto')
          ..add('cityId', cityId)
          ..add('currency', currency)
          ..add('value', value)
          ..add('direction', direction)
          ..add('reason', reason)
          ..add('confirmLargeChange', confirmLargeChange))
        .toString();
  }
}

class AdminSetExchangeRateDtoBuilder
    implements
        Builder<AdminSetExchangeRateDto, AdminSetExchangeRateDtoBuilder> {
  _$AdminSetExchangeRateDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  AdminSetExchangeRateDtoDirectionEnum? _direction;
  AdminSetExchangeRateDtoDirectionEnum? get direction => _$this._direction;
  set direction(AdminSetExchangeRateDtoDirectionEnum? direction) =>
      _$this._direction = direction;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _confirmLargeChange;
  bool? get confirmLargeChange => _$this._confirmLargeChange;
  set confirmLargeChange(bool? confirmLargeChange) =>
      _$this._confirmLargeChange = confirmLargeChange;

  AdminSetExchangeRateDtoBuilder() {
    AdminSetExchangeRateDto._defaults(this);
  }

  AdminSetExchangeRateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _currency = $v.currency;
      _value = $v.value;
      _direction = $v.direction;
      _reason = $v.reason;
      _confirmLargeChange = $v.confirmLargeChange;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetExchangeRateDto other) {
    _$v = other as _$AdminSetExchangeRateDto;
  }

  @override
  void update(void Function(AdminSetExchangeRateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetExchangeRateDto build() => _build();

  _$AdminSetExchangeRateDto _build() {
    final _$result =
        _$v ??
        _$AdminSetExchangeRateDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminSetExchangeRateDto',
            'cityId',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSetExchangeRateDto',
            'currency',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'AdminSetExchangeRateDto',
            'value',
          ),
          direction: BuiltValueNullFieldError.checkNotNull(
            direction,
            r'AdminSetExchangeRateDto',
            'direction',
          ),
          reason: reason,
          confirmLargeChange: confirmLargeChange,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
