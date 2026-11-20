// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_tables_inner_columns_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_count =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('count');
const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_bp =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('bp');
const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_minutes =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('minutes');
const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_money =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('money');
const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_stars =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('stars');
const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_code =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('code');
const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_text =
    const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._('text');

AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'count':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_count;
    case 'bp':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_bp;
    case 'minutes':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_minutes;
    case 'money':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_money;
    case 'stars':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_stars;
    case 'code':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_code;
    case 'text':
      return _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_text;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReportDtoOutputTablesInnerColumnsInnerKindEnum>
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnumValues =
    BuiltSet<AdminReportDtoOutputTablesInnerColumnsInnerKindEnum>(
      const <AdminReportDtoOutputTablesInnerColumnsInnerKindEnum>[
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_count,
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_bp,
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_minutes,
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_money,
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_stars,
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_code,
        _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_text,
      ],
    );

Serializer<AdminReportDtoOutputTablesInnerColumnsInnerKindEnum>
_$adminReportDtoOutputTablesInnerColumnsInnerKindEnumSerializer =
    _$AdminReportDtoOutputTablesInnerColumnsInnerKindEnumSerializer();

class _$AdminReportDtoOutputTablesInnerColumnsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminReportDtoOutputTablesInnerColumnsInnerKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'count': 'count',
    'bp': 'bp',
    'minutes': 'minutes',
    'money': 'money',
    'stars': 'stars',
    'code': 'code',
    'text': 'text',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'count': 'count',
    'bp': 'bp',
    'minutes': 'minutes',
    'money': 'money',
    'stars': 'stars',
    'code': 'code',
    'text': 'text',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminReportDtoOutputTablesInnerColumnsInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminReportDtoOutputTablesInnerColumnsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputTablesInnerColumnsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReportDtoOutputTablesInnerColumnsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReportDtoOutputTablesInnerColumnsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReportDtoOutputTablesInnerColumnsInner
    extends AdminReportDtoOutputTablesInnerColumnsInner {
  @override
  final String key;
  @override
  final AdminReportDtoOutputTablesInnerColumnsInnerKindEnum kind;

  factory _$AdminReportDtoOutputTablesInnerColumnsInner([
    void Function(AdminReportDtoOutputTablesInnerColumnsInnerBuilder)? updates,
  ]) => (AdminReportDtoOutputTablesInnerColumnsInnerBuilder()..update(updates))
      ._build();

  _$AdminReportDtoOutputTablesInnerColumnsInner._({
    required this.key,
    required this.kind,
  }) : super._();
  @override
  AdminReportDtoOutputTablesInnerColumnsInner rebuild(
    void Function(AdminReportDtoOutputTablesInnerColumnsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputTablesInnerColumnsInnerBuilder toBuilder() =>
      AdminReportDtoOutputTablesInnerColumnsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputTablesInnerColumnsInner &&
        key == other.key &&
        kind == other.kind;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminReportDtoOutputTablesInnerColumnsInner',
          )
          ..add('key', key)
          ..add('kind', kind))
        .toString();
  }
}

class AdminReportDtoOutputTablesInnerColumnsInnerBuilder
    implements
        Builder<
          AdminReportDtoOutputTablesInnerColumnsInner,
          AdminReportDtoOutputTablesInnerColumnsInnerBuilder
        > {
  _$AdminReportDtoOutputTablesInnerColumnsInner? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  AdminReportDtoOutputTablesInnerColumnsInnerKindEnum? _kind;
  AdminReportDtoOutputTablesInnerColumnsInnerKindEnum? get kind => _$this._kind;
  set kind(AdminReportDtoOutputTablesInnerColumnsInnerKindEnum? kind) =>
      _$this._kind = kind;

  AdminReportDtoOutputTablesInnerColumnsInnerBuilder() {
    AdminReportDtoOutputTablesInnerColumnsInner._defaults(this);
  }

  AdminReportDtoOutputTablesInnerColumnsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _kind = $v.kind;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputTablesInnerColumnsInner other) {
    _$v = other as _$AdminReportDtoOutputTablesInnerColumnsInner;
  }

  @override
  void update(
    void Function(AdminReportDtoOutputTablesInnerColumnsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputTablesInnerColumnsInner build() => _build();

  _$AdminReportDtoOutputTablesInnerColumnsInner _build() {
    final _$result =
        _$v ??
        _$AdminReportDtoOutputTablesInnerColumnsInner._(
          key: BuiltValueNullFieldError.checkNotNull(
            key,
            r'AdminReportDtoOutputTablesInnerColumnsInner',
            'key',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminReportDtoOutputTablesInnerColumnsInner',
            'kind',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
