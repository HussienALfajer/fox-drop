// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_new_address_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerNewAddressDtoLabelEnum _$customerNewAddressDtoLabelEnum_home =
    const CustomerNewAddressDtoLabelEnum._('home');
const CustomerNewAddressDtoLabelEnum _$customerNewAddressDtoLabelEnum_work =
    const CustomerNewAddressDtoLabelEnum._('work');
const CustomerNewAddressDtoLabelEnum _$customerNewAddressDtoLabelEnum_other =
    const CustomerNewAddressDtoLabelEnum._('other');

CustomerNewAddressDtoLabelEnum _$customerNewAddressDtoLabelEnumValueOf(
  String name,
) {
  switch (name) {
    case 'home':
      return _$customerNewAddressDtoLabelEnum_home;
    case 'work':
      return _$customerNewAddressDtoLabelEnum_work;
    case 'other':
      return _$customerNewAddressDtoLabelEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerNewAddressDtoLabelEnum>
_$customerNewAddressDtoLabelEnumValues =
    BuiltSet<CustomerNewAddressDtoLabelEnum>(
      const <CustomerNewAddressDtoLabelEnum>[
        _$customerNewAddressDtoLabelEnum_home,
        _$customerNewAddressDtoLabelEnum_work,
        _$customerNewAddressDtoLabelEnum_other,
      ],
    );

Serializer<CustomerNewAddressDtoLabelEnum>
_$customerNewAddressDtoLabelEnumSerializer =
    _$CustomerNewAddressDtoLabelEnumSerializer();

class _$CustomerNewAddressDtoLabelEnumSerializer
    implements PrimitiveSerializer<CustomerNewAddressDtoLabelEnum> {
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
  final Iterable<Type> types = const <Type>[CustomerNewAddressDtoLabelEnum];
  @override
  final String wireName = 'CustomerNewAddressDtoLabelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerNewAddressDtoLabelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerNewAddressDtoLabelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerNewAddressDtoLabelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerNewAddressDto extends CustomerNewAddressDto {
  @override
  final CustomerNewAddressDtoLocation location;
  @override
  final CustomerNewAddressDtoLabelEnum label;
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
  @override
  final bool isDefault;

  factory _$CustomerNewAddressDto([
    void Function(CustomerNewAddressDtoBuilder)? updates,
  ]) => (CustomerNewAddressDtoBuilder()..update(updates))._build();

  _$CustomerNewAddressDto._({
    required this.location,
    required this.label,
    this.customLabel,
    required this.street,
    this.floor,
    required this.landmark,
    this.contactPhone,
    this.recipientName,
    this.directions,
    required this.isDefault,
  }) : super._();
  @override
  CustomerNewAddressDto rebuild(
    void Function(CustomerNewAddressDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerNewAddressDtoBuilder toBuilder() =>
      CustomerNewAddressDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerNewAddressDto &&
        location == other.location &&
        label == other.label &&
        customLabel == other.customLabel &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        contactPhone == other.contactPhone &&
        recipientName == other.recipientName &&
        directions == other.directions &&
        isDefault == other.isDefault;
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
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerNewAddressDto')
          ..add('location', location)
          ..add('label', label)
          ..add('customLabel', customLabel)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('contactPhone', contactPhone)
          ..add('recipientName', recipientName)
          ..add('directions', directions)
          ..add('isDefault', isDefault))
        .toString();
  }
}

class CustomerNewAddressDtoBuilder
    implements Builder<CustomerNewAddressDto, CustomerNewAddressDtoBuilder> {
  _$CustomerNewAddressDto? _$v;

  CustomerNewAddressDtoLocationBuilder? _location;
  CustomerNewAddressDtoLocationBuilder get location =>
      _$this._location ??= CustomerNewAddressDtoLocationBuilder();
  set location(CustomerNewAddressDtoLocationBuilder? location) =>
      _$this._location = location;

  CustomerNewAddressDtoLabelEnum? _label;
  CustomerNewAddressDtoLabelEnum? get label => _$this._label;
  set label(CustomerNewAddressDtoLabelEnum? label) => _$this._label = label;

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

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  CustomerNewAddressDtoBuilder() {
    CustomerNewAddressDto._defaults(this);
  }

  CustomerNewAddressDtoBuilder get _$this {
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
      _isDefault = $v.isDefault;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerNewAddressDto other) {
    _$v = other as _$CustomerNewAddressDto;
  }

  @override
  void update(void Function(CustomerNewAddressDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerNewAddressDto build() => _build();

  _$CustomerNewAddressDto _build() {
    _$CustomerNewAddressDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerNewAddressDto._(
            location: location.build(),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'CustomerNewAddressDto',
              'label',
            ),
            customLabel: customLabel,
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'CustomerNewAddressDto',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'CustomerNewAddressDto',
              'landmark',
            ),
            contactPhone: contactPhone,
            recipientName: recipientName,
            directions: directions,
            isDefault: BuiltValueNullFieldError.checkNotNull(
              isDefault,
              r'CustomerNewAddressDto',
              'isDefault',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerNewAddressDto',
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
