// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_customer_address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum
_$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_home =
    const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum._('home');
const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum
_$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_work =
    const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum._('work');
const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum
_$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_other =
    const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum._('other');

CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum
_$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnumValueOf(String name) {
  switch (name) {
    case 'home':
      return _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_home;
    case 'work':
      return _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_work;
    case 'other':
      return _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum>
_$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum>(
      const <CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum>[
        _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_home,
        _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_work,
        _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_other,
      ],
    );

Serializer<CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum>
_$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnumSerializer();

class _$CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum
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
    CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum,
  ];
  @override
  final String wireName =
      'CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderCustomerAddress
    extends CaptainActiveOrderDtoOutputOrderCustomerAddress {
  @override
  final String neighbourhood;
  @override
  final CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum? label;
  @override
  final String? customLabel;
  @override
  final String street;
  @override
  final String? floor;
  @override
  final String landmark;
  @override
  final String? directions;

  factory _$CaptainActiveOrderDtoOutputOrderCustomerAddress([
    void Function(CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderCustomerAddress._({
    required this.neighbourhood,
    this.label,
    this.customLabel,
    required this.street,
    this.floor,
    required this.landmark,
    this.directions,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCustomerAddress rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCustomerAddress &&
        neighbourhood == other.neighbourhood &&
        label == other.label &&
        customLabel == other.customLabel &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        directions == other.directions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customLabel.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, landmark.hashCode);
    _$hash = $jc(_$hash, directions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderCustomerAddress',
          )
          ..add('neighbourhood', neighbourhood)
          ..add('label', label)
          ..add('customLabel', customLabel)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('directions', directions))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCustomerAddress,
          CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCustomerAddress? _$v;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum? _label;
  CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum? get label =>
      _$this._label;
  set label(CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum? label) =>
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

  String? _directions;
  String? get directions => _$this._directions;
  set directions(String? directions) => _$this._directions = directions;

  CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder() {
    CaptainActiveOrderDtoOutputOrderCustomerAddress._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _neighbourhood = $v.neighbourhood;
      _label = $v.label;
      _customLabel = $v.customLabel;
      _street = $v.street;
      _floor = $v.floor;
      _landmark = $v.landmark;
      _directions = $v.directions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCustomerAddress other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCustomerAddress;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomerAddress build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCustomerAddress _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderCustomerAddress._(
          neighbourhood: BuiltValueNullFieldError.checkNotNull(
            neighbourhood,
            r'CaptainActiveOrderDtoOutputOrderCustomerAddress',
            'neighbourhood',
          ),
          label: label,
          customLabel: customLabel,
          street: BuiltValueNullFieldError.checkNotNull(
            street,
            r'CaptainActiveOrderDtoOutputOrderCustomerAddress',
            'street',
          ),
          floor: floor,
          landmark: BuiltValueNullFieldError.checkNotNull(
            landmark,
            r'CaptainActiveOrderDtoOutputOrderCustomerAddress',
            'landmark',
          ),
          directions: directions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
