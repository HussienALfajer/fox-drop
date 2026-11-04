// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusDtoOutputStatusEnum _$statusDtoOutputStatusEnum_ok =
    const StatusDtoOutputStatusEnum._('ok');

StatusDtoOutputStatusEnum _$statusDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$statusDtoOutputStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusDtoOutputStatusEnum> _$statusDtoOutputStatusEnumValues =
    BuiltSet<StatusDtoOutputStatusEnum>(const <StatusDtoOutputStatusEnum>[
      _$statusDtoOutputStatusEnum_ok,
    ]);

Serializer<StatusDtoOutputStatusEnum> _$statusDtoOutputStatusEnumSerializer =
    _$StatusDtoOutputStatusEnumSerializer();

class _$StatusDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<StatusDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{'ok': 'ok'};
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusDtoOutputStatusEnum];
  @override
  final String wireName = 'StatusDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    StatusDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  StatusDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => StatusDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$StatusDtoOutput extends StatusDtoOutput {
  @override
  final StatusDtoOutputStatusEnum status;
  @override
  final int serverTime;

  factory _$StatusDtoOutput([void Function(StatusDtoOutputBuilder)? updates]) =>
      (StatusDtoOutputBuilder()..update(updates))._build();

  _$StatusDtoOutput._({required this.status, required this.serverTime})
    : super._();
  @override
  StatusDtoOutput rebuild(void Function(StatusDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatusDtoOutputBuilder toBuilder() => StatusDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatusDtoOutput &&
        status == other.status &&
        serverTime == other.serverTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, serverTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatusDtoOutput')
          ..add('status', status)
          ..add('serverTime', serverTime))
        .toString();
  }
}

class StatusDtoOutputBuilder
    implements Builder<StatusDtoOutput, StatusDtoOutputBuilder> {
  _$StatusDtoOutput? _$v;

  StatusDtoOutputStatusEnum? _status;
  StatusDtoOutputStatusEnum? get status => _$this._status;
  set status(StatusDtoOutputStatusEnum? status) => _$this._status = status;

  int? _serverTime;
  int? get serverTime => _$this._serverTime;
  set serverTime(int? serverTime) => _$this._serverTime = serverTime;

  StatusDtoOutputBuilder() {
    StatusDtoOutput._defaults(this);
  }

  StatusDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _serverTime = $v.serverTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatusDtoOutput other) {
    _$v = other as _$StatusDtoOutput;
  }

  @override
  void update(void Function(StatusDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatusDtoOutput build() => _build();

  _$StatusDtoOutput _build() {
    final _$result =
        _$v ??
        _$StatusDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'StatusDtoOutput',
            'status',
          ),
          serverTime: BuiltValueNullFieldError.checkNotNull(
            serverTime,
            r'StatusDtoOutput',
            'serverTime',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
