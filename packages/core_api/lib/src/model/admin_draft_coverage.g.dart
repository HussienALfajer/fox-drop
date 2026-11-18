// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_coverage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDraftCoverageKindEnum _$adminDraftCoverageKindEnum_radius =
    const AdminDraftCoverageKindEnum._('radius');
const AdminDraftCoverageKindEnum _$adminDraftCoverageKindEnum_zones =
    const AdminDraftCoverageKindEnum._('zones');

AdminDraftCoverageKindEnum _$adminDraftCoverageKindEnumValueOf(String name) {
  switch (name) {
    case 'radius':
      return _$adminDraftCoverageKindEnum_radius;
    case 'zones':
      return _$adminDraftCoverageKindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDraftCoverageKindEnum> _$adminDraftCoverageKindEnumValues =
    BuiltSet<AdminDraftCoverageKindEnum>(const <AdminDraftCoverageKindEnum>[
      _$adminDraftCoverageKindEnum_radius,
      _$adminDraftCoverageKindEnum_zones,
    ]);

Serializer<AdminDraftCoverageKindEnum> _$adminDraftCoverageKindEnumSerializer =
    _$AdminDraftCoverageKindEnumSerializer();

class _$AdminDraftCoverageKindEnumSerializer
    implements PrimitiveSerializer<AdminDraftCoverageKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'radius': 'radius',
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'radius': 'radius',
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminDraftCoverageKindEnum];
  @override
  final String wireName = 'AdminDraftCoverageKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftCoverageKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDraftCoverageKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDraftCoverageKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDraftCoverage extends AdminDraftCoverage {
  @override
  final AdminDraftCoverageKindEnum kind;
  @override
  final int? radiusMetres;
  @override
  final BuiltList<String> zoneIds;

  factory _$AdminDraftCoverage([
    void Function(AdminDraftCoverageBuilder)? updates,
  ]) => (AdminDraftCoverageBuilder()..update(updates))._build();

  _$AdminDraftCoverage._({
    required this.kind,
    this.radiusMetres,
    required this.zoneIds,
  }) : super._();
  @override
  AdminDraftCoverage rebuild(
    void Function(AdminDraftCoverageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftCoverageBuilder toBuilder() =>
      AdminDraftCoverageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftCoverage &&
        kind == other.kind &&
        radiusMetres == other.radiusMetres &&
        zoneIds == other.zoneIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, radiusMetres.hashCode);
    _$hash = $jc(_$hash, zoneIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftCoverage')
          ..add('kind', kind)
          ..add('radiusMetres', radiusMetres)
          ..add('zoneIds', zoneIds))
        .toString();
  }
}

class AdminDraftCoverageBuilder
    implements Builder<AdminDraftCoverage, AdminDraftCoverageBuilder> {
  _$AdminDraftCoverage? _$v;

  AdminDraftCoverageKindEnum? _kind;
  AdminDraftCoverageKindEnum? get kind => _$this._kind;
  set kind(AdminDraftCoverageKindEnum? kind) => _$this._kind = kind;

  int? _radiusMetres;
  int? get radiusMetres => _$this._radiusMetres;
  set radiusMetres(int? radiusMetres) => _$this._radiusMetres = radiusMetres;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminDraftCoverageBuilder() {
    AdminDraftCoverage._defaults(this);
  }

  AdminDraftCoverageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _radiusMetres = $v.radiusMetres;
      _zoneIds = $v.zoneIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftCoverage other) {
    _$v = other as _$AdminDraftCoverage;
  }

  @override
  void update(void Function(AdminDraftCoverageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftCoverage build() => _build();

  _$AdminDraftCoverage _build() {
    _$AdminDraftCoverage _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftCoverage._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminDraftCoverage',
              'kind',
            ),
            radiusMetres: radiusMetres,
            zoneIds: zoneIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zoneIds';
        zoneIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDraftCoverage',
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
