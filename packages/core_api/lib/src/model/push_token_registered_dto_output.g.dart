// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_registered_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PushTokenRegisteredDtoOutputStatusEnum
_$pushTokenRegisteredDtoOutputStatusEnum_registered =
    const PushTokenRegisteredDtoOutputStatusEnum._('registered');

PushTokenRegisteredDtoOutputStatusEnum
_$pushTokenRegisteredDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'registered':
      return _$pushTokenRegisteredDtoOutputStatusEnum_registered;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PushTokenRegisteredDtoOutputStatusEnum>
_$pushTokenRegisteredDtoOutputStatusEnumValues =
    BuiltSet<PushTokenRegisteredDtoOutputStatusEnum>(
      const <PushTokenRegisteredDtoOutputStatusEnum>[
        _$pushTokenRegisteredDtoOutputStatusEnum_registered,
      ],
    );

Serializer<PushTokenRegisteredDtoOutputStatusEnum>
_$pushTokenRegisteredDtoOutputStatusEnumSerializer =
    _$PushTokenRegisteredDtoOutputStatusEnumSerializer();

class _$PushTokenRegisteredDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PushTokenRegisteredDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'registered': 'registered',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'registered': 'registered',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PushTokenRegisteredDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'PushTokenRegisteredDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    PushTokenRegisteredDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PushTokenRegisteredDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PushTokenRegisteredDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$PushTokenRegisteredDtoOutput extends PushTokenRegisteredDtoOutput {
  @override
  final PushTokenRegisteredDtoOutputStatusEnum status;

  factory _$PushTokenRegisteredDtoOutput([
    void Function(PushTokenRegisteredDtoOutputBuilder)? updates,
  ]) => (PushTokenRegisteredDtoOutputBuilder()..update(updates))._build();

  _$PushTokenRegisteredDtoOutput._({required this.status}) : super._();
  @override
  PushTokenRegisteredDtoOutput rebuild(
    void Function(PushTokenRegisteredDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PushTokenRegisteredDtoOutputBuilder toBuilder() =>
      PushTokenRegisteredDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PushTokenRegisteredDtoOutput && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'PushTokenRegisteredDtoOutput',
    )..add('status', status)).toString();
  }
}

class PushTokenRegisteredDtoOutputBuilder
    implements
        Builder<
          PushTokenRegisteredDtoOutput,
          PushTokenRegisteredDtoOutputBuilder
        > {
  _$PushTokenRegisteredDtoOutput? _$v;

  PushTokenRegisteredDtoOutputStatusEnum? _status;
  PushTokenRegisteredDtoOutputStatusEnum? get status => _$this._status;
  set status(PushTokenRegisteredDtoOutputStatusEnum? status) =>
      _$this._status = status;

  PushTokenRegisteredDtoOutputBuilder() {
    PushTokenRegisteredDtoOutput._defaults(this);
  }

  PushTokenRegisteredDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PushTokenRegisteredDtoOutput other) {
    _$v = other as _$PushTokenRegisteredDtoOutput;
  }

  @override
  void update(void Function(PushTokenRegisteredDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PushTokenRegisteredDtoOutput build() => _build();

  _$PushTokenRegisteredDtoOutput _build() {
    final _$result =
        _$v ??
        _$PushTokenRegisteredDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'PushTokenRegisteredDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
