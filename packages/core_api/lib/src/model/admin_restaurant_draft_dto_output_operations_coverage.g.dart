// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_operations_coverage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum
_$adminRestaurantDraftDtoOutputOperationsCoverageKindEnum_zones =
    const AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum._('zones');

AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum
_$adminRestaurantDraftDtoOutputOperationsCoverageKindEnumValueOf(String name) {
  switch (name) {
    case 'zones':
      return _$adminRestaurantDraftDtoOutputOperationsCoverageKindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum>
_$adminRestaurantDraftDtoOutputOperationsCoverageKindEnumValues =
    BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum>(
      const <AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum>[
        _$adminRestaurantDraftDtoOutputOperationsCoverageKindEnum_zones,
      ],
    );

Serializer<AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum>
_$adminRestaurantDraftDtoOutputOperationsCoverageKindEnumSerializer =
    _$AdminRestaurantDraftDtoOutputOperationsCoverageKindEnumSerializer();

class _$AdminRestaurantDraftDtoOutputOperationsCoverageKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantDraftDtoOutputOperationsCoverage
    extends AdminRestaurantDraftDtoOutputOperationsCoverage {
  @override
  final OneOf oneOf;

  factory _$AdminRestaurantDraftDtoOutputOperationsCoverage([
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputOperationsCoverageBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputOperationsCoverage._({required this.oneOf})
    : super._();
  @override
  AdminRestaurantDraftDtoOutputOperationsCoverage rebuild(
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputOperationsCoverageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputOperationsCoverage &&
        oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantDraftDtoOutputOperationsCoverage',
    )..add('oneOf', oneOf)).toString();
  }
}

class AdminRestaurantDraftDtoOutputOperationsCoverageBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputOperationsCoverage,
          AdminRestaurantDraftDtoOutputOperationsCoverageBuilder
        > {
  _$AdminRestaurantDraftDtoOutputOperationsCoverage? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  AdminRestaurantDraftDtoOutputOperationsCoverageBuilder() {
    AdminRestaurantDraftDtoOutputOperationsCoverage._defaults(this);
  }

  AdminRestaurantDraftDtoOutputOperationsCoverageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputOperationsCoverage other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputOperationsCoverage;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverage build() => _build();

  _$AdminRestaurantDraftDtoOutputOperationsCoverage _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputOperationsCoverage._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'AdminRestaurantDraftDtoOutputOperationsCoverage',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
