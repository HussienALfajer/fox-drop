// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_operations_dto_coverage_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDraftOperationsDtoCoverageOneOf1KindEnum
_$adminDraftOperationsDtoCoverageOneOf1KindEnum_zones =
    const AdminDraftOperationsDtoCoverageOneOf1KindEnum._('zones');

AdminDraftOperationsDtoCoverageOneOf1KindEnum
_$adminDraftOperationsDtoCoverageOneOf1KindEnumValueOf(String name) {
  switch (name) {
    case 'zones':
      return _$adminDraftOperationsDtoCoverageOneOf1KindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDraftOperationsDtoCoverageOneOf1KindEnum>
_$adminDraftOperationsDtoCoverageOneOf1KindEnumValues =
    BuiltSet<AdminDraftOperationsDtoCoverageOneOf1KindEnum>(
      const <AdminDraftOperationsDtoCoverageOneOf1KindEnum>[
        _$adminDraftOperationsDtoCoverageOneOf1KindEnum_zones,
      ],
    );

Serializer<AdminDraftOperationsDtoCoverageOneOf1KindEnum>
_$adminDraftOperationsDtoCoverageOneOf1KindEnumSerializer =
    _$AdminDraftOperationsDtoCoverageOneOf1KindEnumSerializer();

class _$AdminDraftOperationsDtoCoverageOneOf1KindEnumSerializer
    implements
        PrimitiveSerializer<AdminDraftOperationsDtoCoverageOneOf1KindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDraftOperationsDtoCoverageOneOf1KindEnum,
  ];
  @override
  final String wireName = 'AdminDraftOperationsDtoCoverageOneOf1KindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageOneOf1KindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDraftOperationsDtoCoverageOneOf1KindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDraftOperationsDtoCoverageOneOf1KindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDraftOperationsDtoCoverageOneOf1
    extends AdminDraftOperationsDtoCoverageOneOf1 {
  @override
  final AdminDraftOperationsDtoCoverageOneOf1KindEnum kind;
  @override
  final BuiltList<String> zoneIds;

  factory _$AdminDraftOperationsDtoCoverageOneOf1([
    void Function(AdminDraftOperationsDtoCoverageOneOf1Builder)? updates,
  ]) => (AdminDraftOperationsDtoCoverageOneOf1Builder()..update(updates))
      ._build();

  _$AdminDraftOperationsDtoCoverageOneOf1._({
    required this.kind,
    required this.zoneIds,
  }) : super._();
  @override
  AdminDraftOperationsDtoCoverageOneOf1 rebuild(
    void Function(AdminDraftOperationsDtoCoverageOneOf1Builder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftOperationsDtoCoverageOneOf1Builder toBuilder() =>
      AdminDraftOperationsDtoCoverageOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftOperationsDtoCoverageOneOf1 &&
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
            r'AdminDraftOperationsDtoCoverageOneOf1',
          )
          ..add('kind', kind)
          ..add('zoneIds', zoneIds))
        .toString();
  }
}

class AdminDraftOperationsDtoCoverageOneOf1Builder
    implements
        Builder<
          AdminDraftOperationsDtoCoverageOneOf1,
          AdminDraftOperationsDtoCoverageOneOf1Builder
        > {
  _$AdminDraftOperationsDtoCoverageOneOf1? _$v;

  AdminDraftOperationsDtoCoverageOneOf1KindEnum? _kind;
  AdminDraftOperationsDtoCoverageOneOf1KindEnum? get kind => _$this._kind;
  set kind(AdminDraftOperationsDtoCoverageOneOf1KindEnum? kind) =>
      _$this._kind = kind;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminDraftOperationsDtoCoverageOneOf1Builder() {
    AdminDraftOperationsDtoCoverageOneOf1._defaults(this);
  }

  AdminDraftOperationsDtoCoverageOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _zoneIds = $v.zoneIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftOperationsDtoCoverageOneOf1 other) {
    _$v = other as _$AdminDraftOperationsDtoCoverageOneOf1;
  }

  @override
  void update(
    void Function(AdminDraftOperationsDtoCoverageOneOf1Builder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftOperationsDtoCoverageOneOf1 build() => _build();

  _$AdminDraftOperationsDtoCoverageOneOf1 _build() {
    _$AdminDraftOperationsDtoCoverageOneOf1 _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftOperationsDtoCoverageOneOf1._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminDraftOperationsDtoCoverageOneOf1',
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
          r'AdminDraftOperationsDtoCoverageOneOf1',
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
