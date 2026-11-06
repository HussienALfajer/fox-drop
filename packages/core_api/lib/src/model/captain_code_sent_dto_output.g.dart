// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_code_sent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainCodeSentDtoOutputChannelEnum
_$captainCodeSentDtoOutputChannelEnum_whatsapp =
    const CaptainCodeSentDtoOutputChannelEnum._('whatsapp');

CaptainCodeSentDtoOutputChannelEnum
_$captainCodeSentDtoOutputChannelEnumValueOf(String name) {
  switch (name) {
    case 'whatsapp':
      return _$captainCodeSentDtoOutputChannelEnum_whatsapp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainCodeSentDtoOutputChannelEnum>
_$captainCodeSentDtoOutputChannelEnumValues =
    BuiltSet<CaptainCodeSentDtoOutputChannelEnum>(
      const <CaptainCodeSentDtoOutputChannelEnum>[
        _$captainCodeSentDtoOutputChannelEnum_whatsapp,
      ],
    );

Serializer<CaptainCodeSentDtoOutputChannelEnum>
_$captainCodeSentDtoOutputChannelEnumSerializer =
    _$CaptainCodeSentDtoOutputChannelEnumSerializer();

class _$CaptainCodeSentDtoOutputChannelEnumSerializer
    implements PrimitiveSerializer<CaptainCodeSentDtoOutputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'whatsapp': 'whatsapp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'whatsapp': 'whatsapp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainCodeSentDtoOutputChannelEnum,
  ];
  @override
  final String wireName = 'CaptainCodeSentDtoOutputChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainCodeSentDtoOutputChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainCodeSentDtoOutputChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainCodeSentDtoOutputChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainCodeSentDtoOutput extends CaptainCodeSentDtoOutput {
  @override
  final CaptainCodeSentDtoOutputChannelEnum channel;
  @override
  final int resendAfterSec;
  @override
  final DateTime expiresAt;

  factory _$CaptainCodeSentDtoOutput([
    void Function(CaptainCodeSentDtoOutputBuilder)? updates,
  ]) => (CaptainCodeSentDtoOutputBuilder()..update(updates))._build();

  _$CaptainCodeSentDtoOutput._({
    required this.channel,
    required this.resendAfterSec,
    required this.expiresAt,
  }) : super._();
  @override
  CaptainCodeSentDtoOutput rebuild(
    void Function(CaptainCodeSentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCodeSentDtoOutputBuilder toBuilder() =>
      CaptainCodeSentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCodeSentDtoOutput &&
        channel == other.channel &&
        resendAfterSec == other.resendAfterSec &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, resendAfterSec.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCodeSentDtoOutput')
          ..add('channel', channel)
          ..add('resendAfterSec', resendAfterSec)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class CaptainCodeSentDtoOutputBuilder
    implements
        Builder<CaptainCodeSentDtoOutput, CaptainCodeSentDtoOutputBuilder> {
  _$CaptainCodeSentDtoOutput? _$v;

  CaptainCodeSentDtoOutputChannelEnum? _channel;
  CaptainCodeSentDtoOutputChannelEnum? get channel => _$this._channel;
  set channel(CaptainCodeSentDtoOutputChannelEnum? channel) =>
      _$this._channel = channel;

  int? _resendAfterSec;
  int? get resendAfterSec => _$this._resendAfterSec;
  set resendAfterSec(int? resendAfterSec) =>
      _$this._resendAfterSec = resendAfterSec;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CaptainCodeSentDtoOutputBuilder() {
    CaptainCodeSentDtoOutput._defaults(this);
  }

  CaptainCodeSentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channel = $v.channel;
      _resendAfterSec = $v.resendAfterSec;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCodeSentDtoOutput other) {
    _$v = other as _$CaptainCodeSentDtoOutput;
  }

  @override
  void update(void Function(CaptainCodeSentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCodeSentDtoOutput build() => _build();

  _$CaptainCodeSentDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainCodeSentDtoOutput._(
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'CaptainCodeSentDtoOutput',
            'channel',
          ),
          resendAfterSec: BuiltValueNullFieldError.checkNotNull(
            resendAfterSec,
            r'CaptainCodeSentDtoOutput',
            'resendAfterSec',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'CaptainCodeSentDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
