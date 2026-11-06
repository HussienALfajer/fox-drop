// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_code_sent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantCodeSentDtoOutputChannelEnum
_$merchantCodeSentDtoOutputChannelEnum_whatsapp =
    const MerchantCodeSentDtoOutputChannelEnum._('whatsapp');

MerchantCodeSentDtoOutputChannelEnum
_$merchantCodeSentDtoOutputChannelEnumValueOf(String name) {
  switch (name) {
    case 'whatsapp':
      return _$merchantCodeSentDtoOutputChannelEnum_whatsapp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantCodeSentDtoOutputChannelEnum>
_$merchantCodeSentDtoOutputChannelEnumValues =
    BuiltSet<MerchantCodeSentDtoOutputChannelEnum>(
      const <MerchantCodeSentDtoOutputChannelEnum>[
        _$merchantCodeSentDtoOutputChannelEnum_whatsapp,
      ],
    );

Serializer<MerchantCodeSentDtoOutputChannelEnum>
_$merchantCodeSentDtoOutputChannelEnumSerializer =
    _$MerchantCodeSentDtoOutputChannelEnumSerializer();

class _$MerchantCodeSentDtoOutputChannelEnumSerializer
    implements PrimitiveSerializer<MerchantCodeSentDtoOutputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'whatsapp': 'whatsapp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'whatsapp': 'whatsapp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantCodeSentDtoOutputChannelEnum,
  ];
  @override
  final String wireName = 'MerchantCodeSentDtoOutputChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantCodeSentDtoOutputChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantCodeSentDtoOutputChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantCodeSentDtoOutputChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantCodeSentDtoOutput extends MerchantCodeSentDtoOutput {
  @override
  final MerchantCodeSentDtoOutputChannelEnum channel;
  @override
  final int resendAfterSec;
  @override
  final DateTime expiresAt;

  factory _$MerchantCodeSentDtoOutput([
    void Function(MerchantCodeSentDtoOutputBuilder)? updates,
  ]) => (MerchantCodeSentDtoOutputBuilder()..update(updates))._build();

  _$MerchantCodeSentDtoOutput._({
    required this.channel,
    required this.resendAfterSec,
    required this.expiresAt,
  }) : super._();
  @override
  MerchantCodeSentDtoOutput rebuild(
    void Function(MerchantCodeSentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantCodeSentDtoOutputBuilder toBuilder() =>
      MerchantCodeSentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantCodeSentDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantCodeSentDtoOutput')
          ..add('channel', channel)
          ..add('resendAfterSec', resendAfterSec)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MerchantCodeSentDtoOutputBuilder
    implements
        Builder<MerchantCodeSentDtoOutput, MerchantCodeSentDtoOutputBuilder> {
  _$MerchantCodeSentDtoOutput? _$v;

  MerchantCodeSentDtoOutputChannelEnum? _channel;
  MerchantCodeSentDtoOutputChannelEnum? get channel => _$this._channel;
  set channel(MerchantCodeSentDtoOutputChannelEnum? channel) =>
      _$this._channel = channel;

  int? _resendAfterSec;
  int? get resendAfterSec => _$this._resendAfterSec;
  set resendAfterSec(int? resendAfterSec) =>
      _$this._resendAfterSec = resendAfterSec;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MerchantCodeSentDtoOutputBuilder() {
    MerchantCodeSentDtoOutput._defaults(this);
  }

  MerchantCodeSentDtoOutputBuilder get _$this {
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
  void replace(MerchantCodeSentDtoOutput other) {
    _$v = other as _$MerchantCodeSentDtoOutput;
  }

  @override
  void update(void Function(MerchantCodeSentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantCodeSentDtoOutput build() => _build();

  _$MerchantCodeSentDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantCodeSentDtoOutput._(
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'MerchantCodeSentDtoOutput',
            'channel',
          ),
          resendAfterSec: BuiltValueNullFieldError.checkNotNull(
            resendAfterSec,
            r'MerchantCodeSentDtoOutput',
            'resendAfterSec',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MerchantCodeSentDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
