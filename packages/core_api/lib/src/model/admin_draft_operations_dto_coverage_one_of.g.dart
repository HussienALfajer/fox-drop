// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_operations_dto_coverage_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDraftOperationsDtoCoverageOneOfKindEnum
_$adminDraftOperationsDtoCoverageOneOfKindEnum_radius =
    const AdminDraftOperationsDtoCoverageOneOfKindEnum._('radius');

AdminDraftOperationsDtoCoverageOneOfKindEnum
_$adminDraftOperationsDtoCoverageOneOfKindEnumValueOf(String name) {
  switch (name) {
    case 'radius':
      return _$adminDraftOperationsDtoCoverageOneOfKindEnum_radius;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDraftOperationsDtoCoverageOneOfKindEnum>
_$adminDraftOperationsDtoCoverageOneOfKindEnumValues =
    BuiltSet<AdminDraftOperationsDtoCoverageOneOfKindEnum>(
      const <AdminDraftOperationsDtoCoverageOneOfKindEnum>[
        _$adminDraftOperationsDtoCoverageOneOfKindEnum_radius,
      ],
    );

Serializer<AdminDraftOperationsDtoCoverageOneOfKindEnum>
_$adminDraftOperationsDtoCoverageOneOfKindEnumSerializer =
    _$AdminDraftOperationsDtoCoverageOneOfKindEnumSerializer();

class _$AdminDraftOperationsDtoCoverageOneOfKindEnumSerializer
    implements
        PrimitiveSerializer<AdminDraftOperationsDtoCoverageOneOfKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'radius': 'radius',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'radius': 'radius',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDraftOperationsDtoCoverageOneOfKindEnum,
  ];
  @override
  final String wireName = 'AdminDraftOperationsDtoCoverageOneOfKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageOneOfKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDraftOperationsDtoCoverageOneOfKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDraftOperationsDtoCoverageOneOfKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDraftOperationsDtoCoverageOneOf
    extends AdminDraftOperationsDtoCoverageOneOf {
  @override
  final AdminDraftOperationsDtoCoverageOneOfKindEnum kind;
  @override
  final int radiusMetres;

  factory _$AdminDraftOperationsDtoCoverageOneOf([
    void Function(AdminDraftOperationsDtoCoverageOneOfBuilder)? updates,
  ]) =>
      (AdminDraftOperationsDtoCoverageOneOfBuilder()..update(updates))._build();

  _$AdminDraftOperationsDtoCoverageOneOf._({
    required this.kind,
    required this.radiusMetres,
  }) : super._();
  @override
  AdminDraftOperationsDtoCoverageOneOf rebuild(
    void Function(AdminDraftOperationsDtoCoverageOneOfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftOperationsDtoCoverageOneOfBuilder toBuilder() =>
      AdminDraftOperationsDtoCoverageOneOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftOperationsDtoCoverageOneOf &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftOperationsDtoCoverageOneOf')
          ..add('kind', kind)
          ..add('radiusMetres', radiusMetres))
        .toString();
  }
}

class AdminDraftOperationsDtoCoverageOneOfBuilder
    implements
        Builder<
          AdminDraftOperationsDtoCoverageOneOf,
          AdminDraftOperationsDtoCoverageOneOfBuilder
        > {
  _$AdminDraftOperationsDtoCoverageOneOf? _$v;

  AdminDraftOperationsDtoCoverageOneOfKindEnum? _kind;
  AdminDraftOperationsDtoCoverageOneOfKindEnum? get kind => _$this._kind;
  set kind(AdminDraftOperationsDtoCoverageOneOfKindEnum? kind) =>
      _$this._kind = kind;

  int? _radiusMetres;
  int? get radiusMetres => _$this._radiusMetres;
  set radiusMetres(int? radiusMetres) => _$this._radiusMetres = radiusMetres;

  AdminDraftOperationsDtoCoverageOneOfBuilder() {
    AdminDraftOperationsDtoCoverageOneOf._defaults(this);
  }

  AdminDraftOperationsDtoCoverageOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _radiusMetres = $v.radiusMetres;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftOperationsDtoCoverageOneOf other) {
    _$v = other as _$AdminDraftOperationsDtoCoverageOneOf;
  }

  @override
  void update(
    void Function(AdminDraftOperationsDtoCoverageOneOfBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftOperationsDtoCoverageOneOf build() => _build();

  _$AdminDraftOperationsDtoCoverageOneOf _build() {
    final _$result =
        _$v ??
        _$AdminDraftOperationsDtoCoverageOneOf._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminDraftOperationsDtoCoverageOneOf',
            'kind',
          ),
          radiusMetres: BuiltValueNullFieldError.checkNotNull(
            radiusMetres,
            r'AdminDraftOperationsDtoCoverageOneOf',
            'radiusMetres',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
