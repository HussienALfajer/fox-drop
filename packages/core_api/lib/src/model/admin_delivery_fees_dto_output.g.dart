// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeesDtoOutputDistanceMethodEnum
_$adminDeliveryFeesDtoOutputDistanceMethodEnum_road =
    const AdminDeliveryFeesDtoOutputDistanceMethodEnum._('road');
const AdminDeliveryFeesDtoOutputDistanceMethodEnum
_$adminDeliveryFeesDtoOutputDistanceMethodEnum_straightLine =
    const AdminDeliveryFeesDtoOutputDistanceMethodEnum._('straightLine');

AdminDeliveryFeesDtoOutputDistanceMethodEnum
_$adminDeliveryFeesDtoOutputDistanceMethodEnumValueOf(String name) {
  switch (name) {
    case 'road':
      return _$adminDeliveryFeesDtoOutputDistanceMethodEnum_road;
    case 'straightLine':
      return _$adminDeliveryFeesDtoOutputDistanceMethodEnum_straightLine;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeesDtoOutputDistanceMethodEnum>
_$adminDeliveryFeesDtoOutputDistanceMethodEnumValues =
    BuiltSet<AdminDeliveryFeesDtoOutputDistanceMethodEnum>(
      const <AdminDeliveryFeesDtoOutputDistanceMethodEnum>[
        _$adminDeliveryFeesDtoOutputDistanceMethodEnum_road,
        _$adminDeliveryFeesDtoOutputDistanceMethodEnum_straightLine,
      ],
    );

Serializer<AdminDeliveryFeesDtoOutputDistanceMethodEnum>
_$adminDeliveryFeesDtoOutputDistanceMethodEnumSerializer =
    _$AdminDeliveryFeesDtoOutputDistanceMethodEnumSerializer();

class _$AdminDeliveryFeesDtoOutputDistanceMethodEnumSerializer
    implements
        PrimitiveSerializer<AdminDeliveryFeesDtoOutputDistanceMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'road': 'road',
    'straightLine': 'straight_line',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'road': 'road',
    'straight_line': 'straightLine',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeliveryFeesDtoOutputDistanceMethodEnum,
  ];
  @override
  final String wireName = 'AdminDeliveryFeesDtoOutputDistanceMethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputDistanceMethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeesDtoOutputDistanceMethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeesDtoOutputDistanceMethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeesDtoOutput extends AdminDeliveryFeesDtoOutput {
  @override
  final String? baseCurrency;
  @override
  final AdminDeliveryFeesDtoOutputDistanceMethodEnum distanceMethod;
  @override
  final BuiltList<AdminDeliveryFeesDtoOutputVersionsInner> versions;
  @override
  final BuiltList<AdminDeliveryFeesDtoOutputRestaurantsInner> restaurants;

  factory _$AdminDeliveryFeesDtoOutput([
    void Function(AdminDeliveryFeesDtoOutputBuilder)? updates,
  ]) => (AdminDeliveryFeesDtoOutputBuilder()..update(updates))._build();

  _$AdminDeliveryFeesDtoOutput._({
    this.baseCurrency,
    required this.distanceMethod,
    required this.versions,
    required this.restaurants,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutput rebuild(
    void Function(AdminDeliveryFeesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutput &&
        baseCurrency == other.baseCurrency &&
        distanceMethod == other.distanceMethod &&
        versions == other.versions &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, distanceMethod.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDeliveryFeesDtoOutput')
          ..add('baseCurrency', baseCurrency)
          ..add('distanceMethod', distanceMethod)
          ..add('versions', versions)
          ..add('restaurants', restaurants))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputBuilder
    implements
        Builder<AdminDeliveryFeesDtoOutput, AdminDeliveryFeesDtoOutputBuilder> {
  _$AdminDeliveryFeesDtoOutput? _$v;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  AdminDeliveryFeesDtoOutputDistanceMethodEnum? _distanceMethod;
  AdminDeliveryFeesDtoOutputDistanceMethodEnum? get distanceMethod =>
      _$this._distanceMethod;
  set distanceMethod(
    AdminDeliveryFeesDtoOutputDistanceMethodEnum? distanceMethod,
  ) => _$this._distanceMethod = distanceMethod;

  ListBuilder<AdminDeliveryFeesDtoOutputVersionsInner>? _versions;
  ListBuilder<AdminDeliveryFeesDtoOutputVersionsInner> get versions =>
      _$this._versions ??=
          ListBuilder<AdminDeliveryFeesDtoOutputVersionsInner>();
  set versions(
    ListBuilder<AdminDeliveryFeesDtoOutputVersionsInner>? versions,
  ) => _$this._versions = versions;

  ListBuilder<AdminDeliveryFeesDtoOutputRestaurantsInner>? _restaurants;
  ListBuilder<AdminDeliveryFeesDtoOutputRestaurantsInner> get restaurants =>
      _$this._restaurants ??=
          ListBuilder<AdminDeliveryFeesDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<AdminDeliveryFeesDtoOutputRestaurantsInner>? restaurants,
  ) => _$this._restaurants = restaurants;

  AdminDeliveryFeesDtoOutputBuilder() {
    AdminDeliveryFeesDtoOutput._defaults(this);
  }

  AdminDeliveryFeesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseCurrency = $v.baseCurrency;
      _distanceMethod = $v.distanceMethod;
      _versions = $v.versions.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeesDtoOutput other) {
    _$v = other as _$AdminDeliveryFeesDtoOutput;
  }

  @override
  void update(void Function(AdminDeliveryFeesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutput build() => _build();

  _$AdminDeliveryFeesDtoOutput _build() {
    _$AdminDeliveryFeesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeliveryFeesDtoOutput._(
            baseCurrency: baseCurrency,
            distanceMethod: BuiltValueNullFieldError.checkNotNull(
              distanceMethod,
              r'AdminDeliveryFeesDtoOutput',
              'distanceMethod',
            ),
            versions: versions.build(),
            restaurants: restaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'versions';
        versions.build();
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDeliveryFeesDtoOutput',
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
