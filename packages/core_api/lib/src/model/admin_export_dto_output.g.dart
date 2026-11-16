// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_export_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminExportDtoOutputKindEnum
_$adminExportDtoOutputKindEnum_restaurantStatement =
    const AdminExportDtoOutputKindEnum._('restaurantStatement');

AdminExportDtoOutputKindEnum _$adminExportDtoOutputKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurantStatement':
      return _$adminExportDtoOutputKindEnum_restaurantStatement;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminExportDtoOutputKindEnum>
_$adminExportDtoOutputKindEnumValues = BuiltSet<AdminExportDtoOutputKindEnum>(
  const <AdminExportDtoOutputKindEnum>[
    _$adminExportDtoOutputKindEnum_restaurantStatement,
  ],
);

const AdminExportDtoOutputStatusEnum _$adminExportDtoOutputStatusEnum_pending =
    const AdminExportDtoOutputStatusEnum._('pending');
const AdminExportDtoOutputStatusEnum _$adminExportDtoOutputStatusEnum_ready =
    const AdminExportDtoOutputStatusEnum._('ready');
const AdminExportDtoOutputStatusEnum _$adminExportDtoOutputStatusEnum_expired =
    const AdminExportDtoOutputStatusEnum._('expired');

AdminExportDtoOutputStatusEnum _$adminExportDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'pending':
      return _$adminExportDtoOutputStatusEnum_pending;
    case 'ready':
      return _$adminExportDtoOutputStatusEnum_ready;
    case 'expired':
      return _$adminExportDtoOutputStatusEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminExportDtoOutputStatusEnum>
_$adminExportDtoOutputStatusEnumValues =
    BuiltSet<AdminExportDtoOutputStatusEnum>(
      const <AdminExportDtoOutputStatusEnum>[
        _$adminExportDtoOutputStatusEnum_pending,
        _$adminExportDtoOutputStatusEnum_ready,
        _$adminExportDtoOutputStatusEnum_expired,
      ],
    );

Serializer<AdminExportDtoOutputKindEnum>
_$adminExportDtoOutputKindEnumSerializer =
    _$AdminExportDtoOutputKindEnumSerializer();
Serializer<AdminExportDtoOutputStatusEnum>
_$adminExportDtoOutputStatusEnumSerializer =
    _$AdminExportDtoOutputStatusEnumSerializer();

class _$AdminExportDtoOutputKindEnumSerializer
    implements PrimitiveSerializer<AdminExportDtoOutputKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurantStatement': 'restaurant_statement',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant_statement': 'restaurantStatement',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminExportDtoOutputKindEnum];
  @override
  final String wireName = 'AdminExportDtoOutputKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminExportDtoOutputKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminExportDtoOutputKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminExportDtoOutputKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminExportDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminExportDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'ready': 'ready',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'ready': 'ready',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminExportDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminExportDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminExportDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminExportDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminExportDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminExportDtoOutput extends AdminExportDtoOutput {
  @override
  final String id;
  @override
  final AdminExportDtoOutputKindEnum kind;
  @override
  final AdminExportDtoOutputStatusEnum status;
  @override
  final String fileName;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? url;

  factory _$AdminExportDtoOutput([
    void Function(AdminExportDtoOutputBuilder)? updates,
  ]) => (AdminExportDtoOutputBuilder()..update(updates))._build();

  _$AdminExportDtoOutput._({
    required this.id,
    required this.kind,
    required this.status,
    required this.fileName,
    required this.createdAt,
    this.expiresAt,
    this.url,
  }) : super._();
  @override
  AdminExportDtoOutput rebuild(
    void Function(AdminExportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExportDtoOutputBuilder toBuilder() =>
      AdminExportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExportDtoOutput &&
        id == other.id &&
        kind == other.kind &&
        status == other.status &&
        fileName == other.fileName &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminExportDtoOutput')
          ..add('id', id)
          ..add('kind', kind)
          ..add('status', status)
          ..add('fileName', fileName)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt)
          ..add('url', url))
        .toString();
  }
}

class AdminExportDtoOutputBuilder
    implements Builder<AdminExportDtoOutput, AdminExportDtoOutputBuilder> {
  _$AdminExportDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminExportDtoOutputKindEnum? _kind;
  AdminExportDtoOutputKindEnum? get kind => _$this._kind;
  set kind(AdminExportDtoOutputKindEnum? kind) => _$this._kind = kind;

  AdminExportDtoOutputStatusEnum? _status;
  AdminExportDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminExportDtoOutputStatusEnum? status) => _$this._status = status;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  AdminExportDtoOutputBuilder() {
    AdminExportDtoOutput._defaults(this);
  }

  AdminExportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _status = $v.status;
      _fileName = $v.fileName;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExportDtoOutput other) {
    _$v = other as _$AdminExportDtoOutput;
  }

  @override
  void update(void Function(AdminExportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminExportDtoOutput build() => _build();

  _$AdminExportDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminExportDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminExportDtoOutput',
            'id',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminExportDtoOutput',
            'kind',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminExportDtoOutput',
            'status',
          ),
          fileName: BuiltValueNullFieldError.checkNotNull(
            fileName,
            r'AdminExportDtoOutput',
            'fileName',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AdminExportDtoOutput',
            'createdAt',
          ),
          expiresAt: expiresAt,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
