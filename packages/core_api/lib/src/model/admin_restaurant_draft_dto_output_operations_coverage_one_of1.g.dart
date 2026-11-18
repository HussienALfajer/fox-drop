// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_operations_coverage_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum_zones =
    const AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum._(
      'zones',
    );

AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'zones':
      return _$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum>
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumValues =
    BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum>(
      const <AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum>[
        _$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum_zones,
      ],
    );

Serializer<AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum>
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumSerializer =
    _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumSerializer();

class _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1
    extends AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 {
  @override
  final AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum kind;
  @override
  final BuiltList<String> zoneIds;

  factory _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1([
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1._({
    required this.kind,
    required this.zoneIds,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 rebuild(
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder toBuilder() =>
      AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 &&
        kind == other.kind &&
        zoneIds == other.zoneIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, zoneIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1',
          )
          ..add('kind', kind)
          ..add('zoneIds', zoneIds))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1,
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder
        > {
  _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1? _$v;

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum? _kind;
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum? get kind =>
      _$this._kind;
  set kind(
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum? kind,
  ) => _$this._kind = kind;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder() {
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1._defaults(this);
  }

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _zoneIds = $v.zoneIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 build() => _build();

  _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 _build() {
    _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1',
              'kind',
            ),
            zoneIds: zoneIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zoneIds';
        zoneIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1',
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
