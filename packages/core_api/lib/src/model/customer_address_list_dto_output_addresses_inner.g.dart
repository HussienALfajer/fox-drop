// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_list_dto_output_addresses_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerAddressListDtoOutputAddressesInnerLabelEnum
_$customerAddressListDtoOutputAddressesInnerLabelEnum_home =
    const CustomerAddressListDtoOutputAddressesInnerLabelEnum._('home');
const CustomerAddressListDtoOutputAddressesInnerLabelEnum
_$customerAddressListDtoOutputAddressesInnerLabelEnum_work =
    const CustomerAddressListDtoOutputAddressesInnerLabelEnum._('work');
const CustomerAddressListDtoOutputAddressesInnerLabelEnum
_$customerAddressListDtoOutputAddressesInnerLabelEnum_other =
    const CustomerAddressListDtoOutputAddressesInnerLabelEnum._('other');

CustomerAddressListDtoOutputAddressesInnerLabelEnum
_$customerAddressListDtoOutputAddressesInnerLabelEnumValueOf(String name) {
  switch (name) {
    case 'home':
      return _$customerAddressListDtoOutputAddressesInnerLabelEnum_home;
    case 'work':
      return _$customerAddressListDtoOutputAddressesInnerLabelEnum_work;
    case 'other':
      return _$customerAddressListDtoOutputAddressesInnerLabelEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerAddressListDtoOutputAddressesInnerLabelEnum>
_$customerAddressListDtoOutputAddressesInnerLabelEnumValues =
    BuiltSet<CustomerAddressListDtoOutputAddressesInnerLabelEnum>(
      const <CustomerAddressListDtoOutputAddressesInnerLabelEnum>[
        _$customerAddressListDtoOutputAddressesInnerLabelEnum_home,
        _$customerAddressListDtoOutputAddressesInnerLabelEnum_work,
        _$customerAddressListDtoOutputAddressesInnerLabelEnum_other,
      ],
    );

Serializer<CustomerAddressListDtoOutputAddressesInnerLabelEnum>
_$customerAddressListDtoOutputAddressesInnerLabelEnumSerializer =
    _$CustomerAddressListDtoOutputAddressesInnerLabelEnumSerializer();

class _$CustomerAddressListDtoOutputAddressesInnerLabelEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerAddressListDtoOutputAddressesInnerLabelEnum
        > {
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
  final Iterable<Type> types = const <Type>[
    CustomerAddressListDtoOutputAddressesInnerLabelEnum,
  ];
  @override
  final String wireName = 'CustomerAddressListDtoOutputAddressesInnerLabelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerAddressListDtoOutputAddressesInnerLabelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerAddressListDtoOutputAddressesInnerLabelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerAddressListDtoOutputAddressesInnerLabelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerAddressListDtoOutputAddressesInner
    extends CustomerAddressListDtoOutputAddressesInner {
  @override
  final CustomerAddressListDtoOutputAddressesInnerLocation location;
  @override
  final CustomerAddressListDtoOutputAddressesInnerLabelEnum label;
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
  final String id;
  @override
  final bool isDefault;
  @override
  final String? neighbourhood;

  factory _$CustomerAddressListDtoOutputAddressesInner([
    void Function(CustomerAddressListDtoOutputAddressesInnerBuilder)? updates,
  ]) => (CustomerAddressListDtoOutputAddressesInnerBuilder()..update(updates))
      ._build();

  _$CustomerAddressListDtoOutputAddressesInner._({
    required this.location,
    required this.label,
    this.customLabel,
    required this.street,
    this.floor,
    required this.landmark,
    this.contactPhone,
    this.recipientName,
    this.directions,
    required this.id,
    required this.isDefault,
    this.neighbourhood,
  }) : super._();
  @override
  CustomerAddressListDtoOutputAddressesInner rebuild(
    void Function(CustomerAddressListDtoOutputAddressesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAddressListDtoOutputAddressesInnerBuilder toBuilder() =>
      CustomerAddressListDtoOutputAddressesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAddressListDtoOutputAddressesInner &&
        location == other.location &&
        label == other.label &&
        customLabel == other.customLabel &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        contactPhone == other.contactPhone &&
        recipientName == other.recipientName &&
        directions == other.directions &&
        id == other.id &&
        isDefault == other.isDefault &&
        neighbourhood == other.neighbourhood;
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
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerAddressListDtoOutputAddressesInner',
          )
          ..add('location', location)
          ..add('label', label)
          ..add('customLabel', customLabel)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('contactPhone', contactPhone)
          ..add('recipientName', recipientName)
          ..add('directions', directions)
          ..add('id', id)
          ..add('isDefault', isDefault)
          ..add('neighbourhood', neighbourhood))
        .toString();
  }
}

class CustomerAddressListDtoOutputAddressesInnerBuilder
    implements
        Builder<
          CustomerAddressListDtoOutputAddressesInner,
          CustomerAddressListDtoOutputAddressesInnerBuilder
        > {
  _$CustomerAddressListDtoOutputAddressesInner? _$v;

  CustomerAddressListDtoOutputAddressesInnerLocationBuilder? _location;
  CustomerAddressListDtoOutputAddressesInnerLocationBuilder get location =>
      _$this._location ??=
          CustomerAddressListDtoOutputAddressesInnerLocationBuilder();
  set location(
    CustomerAddressListDtoOutputAddressesInnerLocationBuilder? location,
  ) => _$this._location = location;

  CustomerAddressListDtoOutputAddressesInnerLabelEnum? _label;
  CustomerAddressListDtoOutputAddressesInnerLabelEnum? get label =>
      _$this._label;
  set label(CustomerAddressListDtoOutputAddressesInnerLabelEnum? label) =>
      _$this._label = label;

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

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  CustomerAddressListDtoOutputAddressesInnerBuilder() {
    CustomerAddressListDtoOutputAddressesInner._defaults(this);
  }

  CustomerAddressListDtoOutputAddressesInnerBuilder get _$this {
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
      _id = $v.id;
      _isDefault = $v.isDefault;
      _neighbourhood = $v.neighbourhood;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAddressListDtoOutputAddressesInner other) {
    _$v = other as _$CustomerAddressListDtoOutputAddressesInner;
  }

  @override
  void update(
    void Function(CustomerAddressListDtoOutputAddressesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAddressListDtoOutputAddressesInner build() => _build();

  _$CustomerAddressListDtoOutputAddressesInner _build() {
    _$CustomerAddressListDtoOutputAddressesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerAddressListDtoOutputAddressesInner._(
            location: location.build(),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'CustomerAddressListDtoOutputAddressesInner',
              'label',
            ),
            customLabel: customLabel,
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'CustomerAddressListDtoOutputAddressesInner',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'CustomerAddressListDtoOutputAddressesInner',
              'landmark',
            ),
            contactPhone: contactPhone,
            recipientName: recipientName,
            directions: directions,
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerAddressListDtoOutputAddressesInner',
              'id',
            ),
            isDefault: BuiltValueNullFieldError.checkNotNull(
              isDefault,
              r'CustomerAddressListDtoOutputAddressesInner',
              'isDefault',
            ),
            neighbourhood: neighbourhood,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerAddressListDtoOutputAddressesInner',
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
