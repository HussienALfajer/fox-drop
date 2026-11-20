// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_export_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantExportDtoOutputKindEnum
_$merchantExportDtoOutputKindEnum_merchantReport =
    const MerchantExportDtoOutputKindEnum._('merchantReport');
const MerchantExportDtoOutputKindEnum
_$merchantExportDtoOutputKindEnum_merchantOrderHistory =
    const MerchantExportDtoOutputKindEnum._('merchantOrderHistory');
const MerchantExportDtoOutputKindEnum
_$merchantExportDtoOutputKindEnum_merchantStatement =
    const MerchantExportDtoOutputKindEnum._('merchantStatement');

MerchantExportDtoOutputKindEnum _$merchantExportDtoOutputKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'merchantReport':
      return _$merchantExportDtoOutputKindEnum_merchantReport;
    case 'merchantOrderHistory':
      return _$merchantExportDtoOutputKindEnum_merchantOrderHistory;
    case 'merchantStatement':
      return _$merchantExportDtoOutputKindEnum_merchantStatement;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantExportDtoOutputKindEnum>
_$merchantExportDtoOutputKindEnumValues =
    BuiltSet<MerchantExportDtoOutputKindEnum>(
      const <MerchantExportDtoOutputKindEnum>[
        _$merchantExportDtoOutputKindEnum_merchantReport,
        _$merchantExportDtoOutputKindEnum_merchantOrderHistory,
        _$merchantExportDtoOutputKindEnum_merchantStatement,
      ],
    );

const MerchantExportDtoOutputStatusEnum
_$merchantExportDtoOutputStatusEnum_pending =
    const MerchantExportDtoOutputStatusEnum._('pending');
const MerchantExportDtoOutputStatusEnum
_$merchantExportDtoOutputStatusEnum_ready =
    const MerchantExportDtoOutputStatusEnum._('ready');
const MerchantExportDtoOutputStatusEnum
_$merchantExportDtoOutputStatusEnum_expired =
    const MerchantExportDtoOutputStatusEnum._('expired');

MerchantExportDtoOutputStatusEnum _$merchantExportDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'pending':
      return _$merchantExportDtoOutputStatusEnum_pending;
    case 'ready':
      return _$merchantExportDtoOutputStatusEnum_ready;
    case 'expired':
      return _$merchantExportDtoOutputStatusEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantExportDtoOutputStatusEnum>
_$merchantExportDtoOutputStatusEnumValues =
    BuiltSet<MerchantExportDtoOutputStatusEnum>(
      const <MerchantExportDtoOutputStatusEnum>[
        _$merchantExportDtoOutputStatusEnum_pending,
        _$merchantExportDtoOutputStatusEnum_ready,
        _$merchantExportDtoOutputStatusEnum_expired,
      ],
    );

Serializer<MerchantExportDtoOutputKindEnum>
_$merchantExportDtoOutputKindEnumSerializer =
    _$MerchantExportDtoOutputKindEnumSerializer();
Serializer<MerchantExportDtoOutputStatusEnum>
_$merchantExportDtoOutputStatusEnumSerializer =
    _$MerchantExportDtoOutputStatusEnumSerializer();

class _$MerchantExportDtoOutputKindEnumSerializer
    implements PrimitiveSerializer<MerchantExportDtoOutputKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'merchantReport': 'merchant_report',
    'merchantOrderHistory': 'merchant_order_history',
    'merchantStatement': 'merchant_statement',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'merchant_report': 'merchantReport',
    'merchant_order_history': 'merchantOrderHistory',
    'merchant_statement': 'merchantStatement',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantExportDtoOutputKindEnum];
  @override
  final String wireName = 'MerchantExportDtoOutputKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantExportDtoOutputKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantExportDtoOutputKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantExportDtoOutputKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantExportDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MerchantExportDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[MerchantExportDtoOutputStatusEnum];
  @override
  final String wireName = 'MerchantExportDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantExportDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantExportDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantExportDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantExportDtoOutput extends MerchantExportDtoOutput {
  @override
  final String id;
  @override
  final MerchantExportDtoOutputKindEnum kind;
  @override
  final MerchantExportDtoOutputStatusEnum status;
  @override
  final String fileName;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? url;

  factory _$MerchantExportDtoOutput([
    void Function(MerchantExportDtoOutputBuilder)? updates,
  ]) => (MerchantExportDtoOutputBuilder()..update(updates))._build();

  _$MerchantExportDtoOutput._({
    required this.id,
    required this.kind,
    required this.status,
    required this.fileName,
    required this.createdAt,
    this.expiresAt,
    this.url,
  }) : super._();
  @override
  MerchantExportDtoOutput rebuild(
    void Function(MerchantExportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantExportDtoOutputBuilder toBuilder() =>
      MerchantExportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantExportDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantExportDtoOutput')
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

class MerchantExportDtoOutputBuilder
    implements
        Builder<MerchantExportDtoOutput, MerchantExportDtoOutputBuilder> {
  _$MerchantExportDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MerchantExportDtoOutputKindEnum? _kind;
  MerchantExportDtoOutputKindEnum? get kind => _$this._kind;
  set kind(MerchantExportDtoOutputKindEnum? kind) => _$this._kind = kind;

  MerchantExportDtoOutputStatusEnum? _status;
  MerchantExportDtoOutputStatusEnum? get status => _$this._status;
  set status(MerchantExportDtoOutputStatusEnum? status) =>
      _$this._status = status;

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

  MerchantExportDtoOutputBuilder() {
    MerchantExportDtoOutput._defaults(this);
  }

  MerchantExportDtoOutputBuilder get _$this {
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
  void replace(MerchantExportDtoOutput other) {
    _$v = other as _$MerchantExportDtoOutput;
  }

  @override
  void update(void Function(MerchantExportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantExportDtoOutput build() => _build();

  _$MerchantExportDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantExportDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'MerchantExportDtoOutput',
            'id',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'MerchantExportDtoOutput',
            'kind',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'MerchantExportDtoOutput',
            'status',
          ),
          fileName: BuiltValueNullFieldError.checkNotNull(
            fileName,
            r'MerchantExportDtoOutput',
            'fileName',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'MerchantExportDtoOutput',
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
