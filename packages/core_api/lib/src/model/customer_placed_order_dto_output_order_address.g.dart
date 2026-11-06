// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_placed_order_dto_output_order_address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum
_$customerPlacedOrderDtoOutputOrderAddressLabelEnum_home =
    const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum._('home');
const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum
_$customerPlacedOrderDtoOutputOrderAddressLabelEnum_work =
    const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum._('work');
const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum
_$customerPlacedOrderDtoOutputOrderAddressLabelEnum_other =
    const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum._('other');

CustomerPlacedOrderDtoOutputOrderAddressLabelEnum
_$customerPlacedOrderDtoOutputOrderAddressLabelEnumValueOf(String name) {
  switch (name) {
    case 'home':
      return _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_home;
    case 'work':
      return _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_work;
    case 'other':
      return _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerPlacedOrderDtoOutputOrderAddressLabelEnum>
_$customerPlacedOrderDtoOutputOrderAddressLabelEnumValues =
    BuiltSet<CustomerPlacedOrderDtoOutputOrderAddressLabelEnum>(
      const <CustomerPlacedOrderDtoOutputOrderAddressLabelEnum>[
        _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_home,
        _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_work,
        _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_other,
      ],
    );

Serializer<CustomerPlacedOrderDtoOutputOrderAddressLabelEnum>
_$customerPlacedOrderDtoOutputOrderAddressLabelEnumSerializer =
    _$CustomerPlacedOrderDtoOutputOrderAddressLabelEnumSerializer();

class _$CustomerPlacedOrderDtoOutputOrderAddressLabelEnumSerializer
    implements
        PrimitiveSerializer<CustomerPlacedOrderDtoOutputOrderAddressLabelEnum> {
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
    CustomerPlacedOrderDtoOutputOrderAddressLabelEnum,
  ];
  @override
  final String wireName = 'CustomerPlacedOrderDtoOutputOrderAddressLabelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrderAddressLabelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerPlacedOrderDtoOutputOrderAddressLabelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerPlacedOrderDtoOutputOrderAddressLabelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerPlacedOrderDtoOutputOrderAddress
    extends CustomerPlacedOrderDtoOutputOrderAddress {
  @override
  final CustomerPlacedOrderDtoOutputOrderAddressLocation location;
  @override
  final String neighbourhood;
  @override
  final CustomerPlacedOrderDtoOutputOrderAddressLabelEnum? label;
  @override
  final String? customLabel;
  @override
  final String street;
  @override
  final String? floor;
  @override
  final String landmark;
  @override
  final String? recipientName;
  @override
  final String? directions;

  factory _$CustomerPlacedOrderDtoOutputOrderAddress([
    void Function(CustomerPlacedOrderDtoOutputOrderAddressBuilder)? updates,
  ]) => (CustomerPlacedOrderDtoOutputOrderAddressBuilder()..update(updates))
      ._build();

  _$CustomerPlacedOrderDtoOutputOrderAddress._({
    required this.location,
    required this.neighbourhood,
    this.label,
    this.customLabel,
    required this.street,
    this.floor,
    required this.landmark,
    this.recipientName,
    this.directions,
  }) : super._();
  @override
  CustomerPlacedOrderDtoOutputOrderAddress rebuild(
    void Function(CustomerPlacedOrderDtoOutputOrderAddressBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlacedOrderDtoOutputOrderAddressBuilder toBuilder() =>
      CustomerPlacedOrderDtoOutputOrderAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlacedOrderDtoOutputOrderAddress &&
        location == other.location &&
        neighbourhood == other.neighbourhood &&
        label == other.label &&
        customLabel == other.customLabel &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        recipientName == other.recipientName &&
        directions == other.directions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customLabel.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, landmark.hashCode);
    _$hash = $jc(_$hash, recipientName.hashCode);
    _$hash = $jc(_$hash, directions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerPlacedOrderDtoOutputOrderAddress',
          )
          ..add('location', location)
          ..add('neighbourhood', neighbourhood)
          ..add('label', label)
          ..add('customLabel', customLabel)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('recipientName', recipientName)
          ..add('directions', directions))
        .toString();
  }
}

class CustomerPlacedOrderDtoOutputOrderAddressBuilder
    implements
        Builder<
          CustomerPlacedOrderDtoOutputOrderAddress,
          CustomerPlacedOrderDtoOutputOrderAddressBuilder
        > {
  _$CustomerPlacedOrderDtoOutputOrderAddress? _$v;

  CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder? _location;
  CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder get location =>
      _$this._location ??=
          CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder();
  set location(
    CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder? location,
  ) => _$this._location = location;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  CustomerPlacedOrderDtoOutputOrderAddressLabelEnum? _label;
  CustomerPlacedOrderDtoOutputOrderAddressLabelEnum? get label => _$this._label;
  set label(CustomerPlacedOrderDtoOutputOrderAddressLabelEnum? label) =>
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

  String? _recipientName;
  String? get recipientName => _$this._recipientName;
  set recipientName(String? recipientName) =>
      _$this._recipientName = recipientName;

  String? _directions;
  String? get directions => _$this._directions;
  set directions(String? directions) => _$this._directions = directions;

  CustomerPlacedOrderDtoOutputOrderAddressBuilder() {
    CustomerPlacedOrderDtoOutputOrderAddress._defaults(this);
  }

  CustomerPlacedOrderDtoOutputOrderAddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _neighbourhood = $v.neighbourhood;
      _label = $v.label;
      _customLabel = $v.customLabel;
      _street = $v.street;
      _floor = $v.floor;
      _landmark = $v.landmark;
      _recipientName = $v.recipientName;
      _directions = $v.directions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlacedOrderDtoOutputOrderAddress other) {
    _$v = other as _$CustomerPlacedOrderDtoOutputOrderAddress;
  }

  @override
  void update(
    void Function(CustomerPlacedOrderDtoOutputOrderAddressBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlacedOrderDtoOutputOrderAddress build() => _build();

  _$CustomerPlacedOrderDtoOutputOrderAddress _build() {
    _$CustomerPlacedOrderDtoOutputOrderAddress _$result;
    try {
      _$result =
          _$v ??
          _$CustomerPlacedOrderDtoOutputOrderAddress._(
            location: location.build(),
            neighbourhood: BuiltValueNullFieldError.checkNotNull(
              neighbourhood,
              r'CustomerPlacedOrderDtoOutputOrderAddress',
              'neighbourhood',
            ),
            label: label,
            customLabel: customLabel,
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'CustomerPlacedOrderDtoOutputOrderAddress',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'CustomerPlacedOrderDtoOutputOrderAddress',
              'landmark',
            ),
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
          r'CustomerPlacedOrderDtoOutputOrderAddress',
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
