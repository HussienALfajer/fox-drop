// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_number_status_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SenderNumberStatusDtoStatusEnum _$senderNumberStatusDtoStatusEnum_active =
    const SenderNumberStatusDtoStatusEnum._('active');
const SenderNumberStatusDtoStatusEnum
_$senderNumberStatusDtoStatusEnum_standby =
    const SenderNumberStatusDtoStatusEnum._('standby');

SenderNumberStatusDtoStatusEnum _$senderNumberStatusDtoStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'active':
      return _$senderNumberStatusDtoStatusEnum_active;
    case 'standby':
      return _$senderNumberStatusDtoStatusEnum_standby;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderNumberStatusDtoStatusEnum>
_$senderNumberStatusDtoStatusEnumValues =
    BuiltSet<SenderNumberStatusDtoStatusEnum>(
      const <SenderNumberStatusDtoStatusEnum>[
        _$senderNumberStatusDtoStatusEnum_active,
        _$senderNumberStatusDtoStatusEnum_standby,
      ],
    );

Serializer<SenderNumberStatusDtoStatusEnum>
_$senderNumberStatusDtoStatusEnumSerializer =
    _$SenderNumberStatusDtoStatusEnumSerializer();

class _$SenderNumberStatusDtoStatusEnumSerializer
    implements PrimitiveSerializer<SenderNumberStatusDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'standby': 'standby',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'standby': 'standby',
  };

  @override
  final Iterable<Type> types = const <Type>[SenderNumberStatusDtoStatusEnum];
  @override
  final String wireName = 'SenderNumberStatusDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderNumberStatusDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderNumberStatusDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderNumberStatusDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderNumberStatusDto extends SenderNumberStatusDto {
  @override
  final SenderNumberStatusDtoStatusEnum status;

  factory _$SenderNumberStatusDto([
    void Function(SenderNumberStatusDtoBuilder)? updates,
  ]) => (SenderNumberStatusDtoBuilder()..update(updates))._build();

  _$SenderNumberStatusDto._({required this.status}) : super._();
  @override
  SenderNumberStatusDto rebuild(
    void Function(SenderNumberStatusDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderNumberStatusDtoBuilder toBuilder() =>
      SenderNumberStatusDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderNumberStatusDto && status == other.status;
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
      r'SenderNumberStatusDto',
    )..add('status', status)).toString();
  }
}

class SenderNumberStatusDtoBuilder
    implements Builder<SenderNumberStatusDto, SenderNumberStatusDtoBuilder> {
  _$SenderNumberStatusDto? _$v;

  SenderNumberStatusDtoStatusEnum? _status;
  SenderNumberStatusDtoStatusEnum? get status => _$this._status;
  set status(SenderNumberStatusDtoStatusEnum? status) =>
      _$this._status = status;

  SenderNumberStatusDtoBuilder() {
    SenderNumberStatusDto._defaults(this);
  }

  SenderNumberStatusDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderNumberStatusDto other) {
    _$v = other as _$SenderNumberStatusDto;
  }

  @override
  void update(void Function(SenderNumberStatusDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SenderNumberStatusDto build() => _build();

  _$SenderNumberStatusDto _build() {
    final _$result =
        _$v ??
        _$SenderNumberStatusDto._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'SenderNumberStatusDto',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
