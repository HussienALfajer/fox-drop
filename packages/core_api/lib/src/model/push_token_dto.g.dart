// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PushTokenDtoPlatformEnum _$pushTokenDtoPlatformEnum_android =
    const PushTokenDtoPlatformEnum._('android');

PushTokenDtoPlatformEnum _$pushTokenDtoPlatformEnumValueOf(String name) {
  switch (name) {
    case 'android':
      return _$pushTokenDtoPlatformEnum_android;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PushTokenDtoPlatformEnum> _$pushTokenDtoPlatformEnumValues =
    BuiltSet<PushTokenDtoPlatformEnum>(const <PushTokenDtoPlatformEnum>[
      _$pushTokenDtoPlatformEnum_android,
    ]);

Serializer<PushTokenDtoPlatformEnum> _$pushTokenDtoPlatformEnumSerializer =
    _$PushTokenDtoPlatformEnumSerializer();

class _$PushTokenDtoPlatformEnumSerializer
    implements PrimitiveSerializer<PushTokenDtoPlatformEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'android': 'android',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'android': 'android',
  };

  @override
  final Iterable<Type> types = const <Type>[PushTokenDtoPlatformEnum];
  @override
  final String wireName = 'PushTokenDtoPlatformEnum';

  @override
  Object serialize(
    Serializers serializers,
    PushTokenDtoPlatformEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PushTokenDtoPlatformEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PushTokenDtoPlatformEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$PushTokenDto extends PushTokenDto {
  @override
  final String token;
  @override
  final PushTokenDtoPlatformEnum platform;

  factory _$PushTokenDto([void Function(PushTokenDtoBuilder)? updates]) =>
      (PushTokenDtoBuilder()..update(updates))._build();

  _$PushTokenDto._({required this.token, required this.platform}) : super._();
  @override
  PushTokenDto rebuild(void Function(PushTokenDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PushTokenDtoBuilder toBuilder() => PushTokenDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PushTokenDto &&
        token == other.token &&
        platform == other.platform;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PushTokenDto')
          ..add('token', token)
          ..add('platform', platform))
        .toString();
  }
}

class PushTokenDtoBuilder
    implements Builder<PushTokenDto, PushTokenDtoBuilder> {
  _$PushTokenDto? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  PushTokenDtoPlatformEnum? _platform;
  PushTokenDtoPlatformEnum? get platform => _$this._platform;
  set platform(PushTokenDtoPlatformEnum? platform) =>
      _$this._platform = platform;

  PushTokenDtoBuilder() {
    PushTokenDto._defaults(this);
  }

  PushTokenDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _platform = $v.platform;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PushTokenDto other) {
    _$v = other as _$PushTokenDto;
  }

  @override
  void update(void Function(PushTokenDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PushTokenDto build() => _build();

  _$PushTokenDto _build() {
    final _$result =
        _$v ??
        _$PushTokenDto._(
          token: BuiltValueNullFieldError.checkNotNull(
            token,
            r'PushTokenDto',
            'token',
          ),
          platform: BuiltValueNullFieldError.checkNotNull(
            platform,
            r'PushTokenDto',
            'platform',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
