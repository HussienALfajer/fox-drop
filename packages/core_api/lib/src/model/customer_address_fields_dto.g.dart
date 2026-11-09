// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_fields_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerAddressFieldsDtoLabelEnum
_$customerAddressFieldsDtoLabelEnum_home =
    const CustomerAddressFieldsDtoLabelEnum._('home');
const CustomerAddressFieldsDtoLabelEnum
_$customerAddressFieldsDtoLabelEnum_work =
    const CustomerAddressFieldsDtoLabelEnum._('work');
const CustomerAddressFieldsDtoLabelEnum
_$customerAddressFieldsDtoLabelEnum_other =
    const CustomerAddressFieldsDtoLabelEnum._('other');

CustomerAddressFieldsDtoLabelEnum _$customerAddressFieldsDtoLabelEnumValueOf(
  String name,
) {
  switch (name) {
    case 'home':
      return _$customerAddressFieldsDtoLabelEnum_home;
    case 'work':
      return _$customerAddressFieldsDtoLabelEnum_work;
    case 'other':
      return _$customerAddressFieldsDtoLabelEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerAddressFieldsDtoLabelEnum>
_$customerAddressFieldsDtoLabelEnumValues =
    BuiltSet<CustomerAddressFieldsDtoLabelEnum>(
      const <CustomerAddressFieldsDtoLabelEnum>[
        _$customerAddressFieldsDtoLabelEnum_home,
        _$customerAddressFieldsDtoLabelEnum_work,
        _$customerAddressFieldsDtoLabelEnum_other,
      ],
    );

Serializer<CustomerAddressFieldsDtoLabelEnum>
_$customerAddressFieldsDtoLabelEnumSerializer =
    _$CustomerAddressFieldsDtoLabelEnumSerializer();

class _$CustomerAddressFieldsDtoLabelEnumSerializer
    implements PrimitiveSerializer<CustomerAddressFieldsDtoLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'home': 'home',
    'work': 'work',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'home': 'home',
    'work': 'work',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[CustomerAddressFieldsDtoLabelEnum];
  @override
  final String wireName = 'CustomerAddressFieldsDtoLabelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerAddressFieldsDtoLabelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerAddressFieldsDtoLabelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerAddressFieldsDtoLabelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerAddressFieldsDto extends CustomerAddressFieldsDto {
  @override
  final CustomerNewAddressDtoLocation location;
  @override
  final CustomerAddressFieldsDtoLabelEnum label;
  @override
  final String? customLabel;
  @override
  final String street;
  @override
  final String? floor;
  @override
  final String landmark;
  @override
  final String? contactPhone;
  @override
  final String? recipientName;
  @override
  final String? directions;

  factory _$CustomerAddressFieldsDto([
    void Function(CustomerAddressFieldsDtoBuilder)? updates,
  ]) => (CustomerAddressFieldsDtoBuilder()..update(updates))._build();

  _$CustomerAddressFieldsDto._({
    required this.location,
    required this.label,
    this.customLabel,
    required this.street,
    this.floor,
    required this.landmark,
    this.contactPhone,
    this.recipientName,
    this.directions,
  }) : super._();
  @override
  CustomerAddressFieldsDto rebuild(
    void Function(CustomerAddressFieldsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAddressFieldsDtoBuilder toBuilder() =>
      CustomerAddressFieldsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAddressFieldsDto &&
        location == other.location &&
        label == other.label &&
        customLabel == other.customLabel &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        contactPhone == other.contactPhone &&
        recipientName == other.recipientName &&
        directions == other.directions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customLabel.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, landmark.hashCode);
    _$hash = $jc(_$hash, contactPhone.hashCode);
    _$hash = $jc(_$hash, recipientName.hashCode);
    _$hash = $jc(_$hash, directions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerAddressFieldsDto')
          ..add('location', location)
          ..add('label', label)
          ..add('customLabel', customLabel)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('contactPhone', contactPhone)
          ..add('recipientName', recipientName)
          ..add('directions', directions))
        .toString();
  }
}

class CustomerAddressFieldsDtoBuilder
    implements
        Builder<CustomerAddressFieldsDto, CustomerAddressFieldsDtoBuilder> {
  _$CustomerAddressFieldsDto? _$v;

  CustomerNewAddressDtoLocationBuilder? _location;
  CustomerNewAddressDtoLocationBuilder get location =>
      _$this._location ??= CustomerNewAddressDtoLocationBuilder();
  set location(CustomerNewAddressDtoLocationBuilder? location) =>
      _$this._location = location;

  CustomerAddressFieldsDtoLabelEnum? _label;
  CustomerAddressFieldsDtoLabelEnum? get label => _$this._label;
  set label(CustomerAddressFieldsDtoLabelEnum? label) => _$this._label = label;

  String? _customLabel;
  String? get customLabel => _$this._customLabel;
  set customLabel(String? customLabel) => _$this._customLabel = customLabel;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _floor;
  String? get floor => _$this._floor;
  set floor(String? floor) => _$this._floor = floor;

  String? _landmark;
  String? get landmark => _$this._landmark;
  set landmark(String? landmark) => _$this._landmark = landmark;

  String? _contactPhone;
  String? get contactPhone => _$this._contactPhone;
  set contactPhone(String? contactPhone) => _$this._contactPhone = contactPhone;

  String? _recipientName;
  String? get recipientName => _$this._recipientName;
  set recipientName(String? recipientName) =>
      _$this._recipientName = recipientName;

  String? _directions;
  String? get directions => _$this._directions;
  set directions(String? directions) => _$this._directions = directions;

  CustomerAddressFieldsDtoBuilder() {
    CustomerAddressFieldsDto._defaults(this);
  }

  CustomerAddressFieldsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _label = $v.label;
      _customLabel = $v.customLabel;
      _street = $v.street;
      _floor = $v.floor;
      _landmark = $v.landmark;
      _contactPhone = $v.contactPhone;
      _recipientName = $v.recipientName;
      _directions = $v.directions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAddressFieldsDto other) {
    _$v = other as _$CustomerAddressFieldsDto;
  }

  @override
  void update(void Function(CustomerAddressFieldsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAddressFieldsDto build() => _build();

  _$CustomerAddressFieldsDto _build() {
    _$CustomerAddressFieldsDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerAddressFieldsDto._(
            location: location.build(),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'CustomerAddressFieldsDto',
              'label',
            ),
            customLabel: customLabel,
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'CustomerAddressFieldsDto',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'CustomerAddressFieldsDto',
              'landmark',
            ),
            contactPhone: contactPhone,
            recipientName: recipientName,
            directions: directions,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerAddressFieldsDto',
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
