// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_operations_dto_coverage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDraftOperationsDtoCoverageKindEnum
_$adminDraftOperationsDtoCoverageKindEnum_zones =
    const AdminDraftOperationsDtoCoverageKindEnum._('zones');

AdminDraftOperationsDtoCoverageKindEnum
_$adminDraftOperationsDtoCoverageKindEnumValueOf(String name) {
  switch (name) {
    case 'zones':
      return _$adminDraftOperationsDtoCoverageKindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDraftOperationsDtoCoverageKindEnum>
_$adminDraftOperationsDtoCoverageKindEnumValues =
    BuiltSet<AdminDraftOperationsDtoCoverageKindEnum>(
      const <AdminDraftOperationsDtoCoverageKindEnum>[
        _$adminDraftOperationsDtoCoverageKindEnum_zones,
      ],
    );

Serializer<AdminDraftOperationsDtoCoverageKindEnum>
_$adminDraftOperationsDtoCoverageKindEnumSerializer =
    _$AdminDraftOperationsDtoCoverageKindEnumSerializer();

class _$AdminDraftOperationsDtoCoverageKindEnumSerializer
    implements PrimitiveSerializer<AdminDraftOperationsDtoCoverageKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDraftOperationsDtoCoverageKindEnum,
  ];
  @override
  final String wireName = 'AdminDraftOperationsDtoCoverageKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDraftOperationsDtoCoverageKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDraftOperationsDtoCoverageKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDraftOperationsDtoCoverage
    extends AdminDraftOperationsDtoCoverage {
  @override
  final OneOf oneOf;

  factory _$AdminDraftOperationsDtoCoverage([
    void Function(AdminDraftOperationsDtoCoverageBuilder)? updates,
  ]) => (AdminDraftOperationsDtoCoverageBuilder()..update(updates))._build();

  _$AdminDraftOperationsDtoCoverage._({required this.oneOf}) : super._();
  @override
  AdminDraftOperationsDtoCoverage rebuild(
    void Function(AdminDraftOperationsDtoCoverageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftOperationsDtoCoverageBuilder toBuilder() =>
      AdminDraftOperationsDtoCoverageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftOperationsDtoCoverage && oneOf == other.oneOf;
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
      r'AdminDraftOperationsDtoCoverage',
    )..add('oneOf', oneOf)).toString();
  }
}

class AdminDraftOperationsDtoCoverageBuilder
    implements
        Builder<
          AdminDraftOperationsDtoCoverage,
          AdminDraftOperationsDtoCoverageBuilder
        > {
  _$AdminDraftOperationsDtoCoverage? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  AdminDraftOperationsDtoCoverageBuilder() {
    AdminDraftOperationsDtoCoverage._defaults(this);
  }

  AdminDraftOperationsDtoCoverageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftOperationsDtoCoverage other) {
    _$v = other as _$AdminDraftOperationsDtoCoverage;
  }

  @override
  void update(void Function(AdminDraftOperationsDtoCoverageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftOperationsDtoCoverage build() => _build();

  _$AdminDraftOperationsDtoCoverage _build() {
    final _$result =
        _$v ??
        _$AdminDraftOperationsDtoCoverage._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'AdminDraftOperationsDtoCoverage',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
