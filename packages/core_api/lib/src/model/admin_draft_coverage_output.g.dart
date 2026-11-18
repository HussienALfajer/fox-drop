// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_coverage_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDraftCoverageOutputKindEnum
_$adminDraftCoverageOutputKindEnum_radius =
    const AdminDraftCoverageOutputKindEnum._('radius');
const AdminDraftCoverageOutputKindEnum
_$adminDraftCoverageOutputKindEnum_zones =
    const AdminDraftCoverageOutputKindEnum._('zones');

AdminDraftCoverageOutputKindEnum _$adminDraftCoverageOutputKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'radius':
      return _$adminDraftCoverageOutputKindEnum_radius;
    case 'zones':
      return _$adminDraftCoverageOutputKindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDraftCoverageOutputKindEnum>
_$adminDraftCoverageOutputKindEnumValues =
    BuiltSet<AdminDraftCoverageOutputKindEnum>(
      const <AdminDraftCoverageOutputKindEnum>[
        _$adminDraftCoverageOutputKindEnum_radius,
        _$adminDraftCoverageOutputKindEnum_zones,
      ],
    );

Serializer<AdminDraftCoverageOutputKindEnum>
_$adminDraftCoverageOutputKindEnumSerializer =
    _$AdminDraftCoverageOutputKindEnumSerializer();

class _$AdminDraftCoverageOutputKindEnumSerializer
    implements PrimitiveSerializer<AdminDraftCoverageOutputKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'radius': 'radius',
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'radius': 'radius',
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminDraftCoverageOutputKindEnum];
  @override
  final String wireName = 'AdminDraftCoverageOutputKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftCoverageOutputKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDraftCoverageOutputKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDraftCoverageOutputKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDraftCoverageOutput extends AdminDraftCoverageOutput {
  @override
  final AdminDraftCoverageOutputKindEnum kind;
  @override
  final int? radiusMetres;
  @override
  final BuiltList<String> zoneIds;

  factory _$AdminDraftCoverageOutput([
    void Function(AdminDraftCoverageOutputBuilder)? updates,
  ]) => (AdminDraftCoverageOutputBuilder()..update(updates))._build();

  _$AdminDraftCoverageOutput._({
    required this.kind,
    this.radiusMetres,
    required this.zoneIds,
  }) : super._();
  @override
  AdminDraftCoverageOutput rebuild(
    void Function(AdminDraftCoverageOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftCoverageOutputBuilder toBuilder() =>
      AdminDraftCoverageOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftCoverageOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftCoverageOutput')
          ..add('kind', kind)
          ..add('radiusMetres', radiusMetres)
          ..add('zoneIds', zoneIds))
        .toString();
  }
}

class AdminDraftCoverageOutputBuilder
    implements
        Builder<AdminDraftCoverageOutput, AdminDraftCoverageOutputBuilder> {
  _$AdminDraftCoverageOutput? _$v;

  AdminDraftCoverageOutputKindEnum? _kind;
  AdminDraftCoverageOutputKindEnum? get kind => _$this._kind;
  set kind(AdminDraftCoverageOutputKindEnum? kind) => _$this._kind = kind;

  int? _radiusMetres;
  int? get radiusMetres => _$this._radiusMetres;
  set radiusMetres(int? radiusMetres) => _$this._radiusMetres = radiusMetres;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminDraftCoverageOutputBuilder() {
    AdminDraftCoverageOutput._defaults(this);
  }

  AdminDraftCoverageOutputBuilder get _$this {
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
  void replace(AdminDraftCoverageOutput other) {
    _$v = other as _$AdminDraftCoverageOutput;
  }

  @override
  void update(void Function(AdminDraftCoverageOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftCoverageOutput build() => _build();

  _$AdminDraftCoverageOutput _build() {
    _$AdminDraftCoverageOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftCoverageOutput._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminDraftCoverageOutput',
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
          r'AdminDraftCoverageOutput',
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
