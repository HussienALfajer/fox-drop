// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum
_$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_home =
    const CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum._('home');
const CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum
_$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_work =
    const CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum._('work');
const CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum
_$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_other =
    const CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum._('other');

CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum
_$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnumValueOf(String name) {
  switch (name) {
    case 'home':
      return _$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_home;
    case 'work':
      return _$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_work;
    case 'other':
      return _$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum>
_$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum>(
      const <CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum>[
        _$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_home,
        _$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_work,
        _$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum_other,
      ],
    );

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum>
_$customerActiveOrdersDtoOutputOrdersInnerAddressLabelEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum
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
    CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerAddress
    extends CustomerActiveOrdersDtoOutputOrdersInnerAddress {
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation location;
  @override
  final String neighbourhood;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum? label;
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

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerAddress([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerAddress._({
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
  CustomerActiveOrdersDtoOutputOrdersInnerAddress rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerAddress &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerAddress',
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

class CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerAddress,
          CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerAddress? _$v;

  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder? _location;
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder get location =>
      _$this._location ??=
          CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder();
  set location(
    CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder? location,
  ) => _$this._location = location;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum? _label;
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum? get label =>
      _$this._label;
  set label(CustomerActiveOrdersDtoOutputOrdersInnerAddressLabelEnum? label) =>
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

  CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerAddress._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder get _$this {
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
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerAddress other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerAddress;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerAddress build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerAddress _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerAddress _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerAddress._(
            location: location.build(),
            neighbourhood: BuiltValueNullFieldError.checkNotNull(
              neighbourhood,
              r'CustomerActiveOrdersDtoOutputOrdersInnerAddress',
              'neighbourhood',
            ),
            label: label,
            customLabel: customLabel,
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'CustomerActiveOrdersDtoOutputOrdersInnerAddress',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'CustomerActiveOrdersDtoOutputOrdersInnerAddress',
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
          r'CustomerActiveOrdersDtoOutputOrdersInnerAddress',
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
