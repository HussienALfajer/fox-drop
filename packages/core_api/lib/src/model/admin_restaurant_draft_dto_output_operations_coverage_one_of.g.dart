// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_operations_coverage_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum_radius =
    const AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum._(
      'radius',
    );

AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'radius':
      return _$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum_radius;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum>
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumValues =
    BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum>(
      const <AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum>[
        _$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum_radius,
      ],
    );

Serializer<AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum>
_$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumSerializer =
    _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumSerializer();

class _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'radius': 'radius',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'radius': 'radius',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf
    extends AdminRestaurantDraftDtoOutputOperationsCoverageOneOf {
  @override
  final AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum kind;
  @override
  final int radiusMetres;

  factory _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf([
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf._({
    required this.kind,
    required this.radiusMetres,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf rebuild(
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputOperationsCoverageOneOf &&
        kind == other.kind &&
        radiusMetres == other.radiusMetres;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, radiusMetres.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf',
          )
          ..add('kind', kind)
          ..add('radiusMetres', radiusMetres))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf,
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder
        > {
  _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf? _$v;

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum? _kind;
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum? get kind =>
      _$this._kind;
  set kind(
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum? kind,
  ) => _$this._kind = kind;

  int? _radiusMetres;
  int? get radiusMetres => _$this._radiusMetres;
  set radiusMetres(int? radiusMetres) => _$this._radiusMetres = radiusMetres;

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder() {
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf._defaults(this);
  }

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _radiusMetres = $v.radiusMetres;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf build() => _build();

  _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf',
            'kind',
          ),
          radiusMetres: BuiltValueNullFieldError.checkNotNull(
            radiusMetres,
            r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf',
            'radiusMetres',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
