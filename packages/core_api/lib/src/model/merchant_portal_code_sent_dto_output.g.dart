// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_code_sent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantPortalCodeSentDtoOutputChannelEnum
_$merchantPortalCodeSentDtoOutputChannelEnum_whatsapp =
    const MerchantPortalCodeSentDtoOutputChannelEnum._('whatsapp');

MerchantPortalCodeSentDtoOutputChannelEnum
_$merchantPortalCodeSentDtoOutputChannelEnumValueOf(String name) {
  switch (name) {
    case 'whatsapp':
      return _$merchantPortalCodeSentDtoOutputChannelEnum_whatsapp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantPortalCodeSentDtoOutputChannelEnum>
_$merchantPortalCodeSentDtoOutputChannelEnumValues =
    BuiltSet<MerchantPortalCodeSentDtoOutputChannelEnum>(
      const <MerchantPortalCodeSentDtoOutputChannelEnum>[
        _$merchantPortalCodeSentDtoOutputChannelEnum_whatsapp,
      ],
    );

Serializer<MerchantPortalCodeSentDtoOutputChannelEnum>
_$merchantPortalCodeSentDtoOutputChannelEnumSerializer =
    _$MerchantPortalCodeSentDtoOutputChannelEnumSerializer();

class _$MerchantPortalCodeSentDtoOutputChannelEnumSerializer
    implements PrimitiveSerializer<MerchantPortalCodeSentDtoOutputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'whatsapp': 'whatsapp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'whatsapp': 'whatsapp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantPortalCodeSentDtoOutputChannelEnum,
  ];
  @override
  final String wireName = 'MerchantPortalCodeSentDtoOutputChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalCodeSentDtoOutputChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantPortalCodeSentDtoOutputChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantPortalCodeSentDtoOutputChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantPortalCodeSentDtoOutput
    extends MerchantPortalCodeSentDtoOutput {
  @override
  final MerchantPortalCodeSentDtoOutputChannelEnum channel;
  @override
  final int resendAfterSec;
  @override
  final DateTime expiresAt;

  factory _$MerchantPortalCodeSentDtoOutput([
    void Function(MerchantPortalCodeSentDtoOutputBuilder)? updates,
  ]) => (MerchantPortalCodeSentDtoOutputBuilder()..update(updates))._build();

  _$MerchantPortalCodeSentDtoOutput._({
    required this.channel,
    required this.resendAfterSec,
    required this.expiresAt,
  }) : super._();
  @override
  MerchantPortalCodeSentDtoOutput rebuild(
    void Function(MerchantPortalCodeSentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalCodeSentDtoOutputBuilder toBuilder() =>
      MerchantPortalCodeSentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalCodeSentDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantPortalCodeSentDtoOutput')
          ..add('channel', channel)
          ..add('resendAfterSec', resendAfterSec)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MerchantPortalCodeSentDtoOutputBuilder
    implements
        Builder<
          MerchantPortalCodeSentDtoOutput,
          MerchantPortalCodeSentDtoOutputBuilder
        > {
  _$MerchantPortalCodeSentDtoOutput? _$v;

  MerchantPortalCodeSentDtoOutputChannelEnum? _channel;
  MerchantPortalCodeSentDtoOutputChannelEnum? get channel => _$this._channel;
  set channel(MerchantPortalCodeSentDtoOutputChannelEnum? channel) =>
      _$this._channel = channel;

  int? _resendAfterSec;
  int? get resendAfterSec => _$this._resendAfterSec;
  set resendAfterSec(int? resendAfterSec) =>
      _$this._resendAfterSec = resendAfterSec;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MerchantPortalCodeSentDtoOutputBuilder() {
    MerchantPortalCodeSentDtoOutput._defaults(this);
  }

  MerchantPortalCodeSentDtoOutputBuilder get _$this {
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
  void replace(MerchantPortalCodeSentDtoOutput other) {
    _$v = other as _$MerchantPortalCodeSentDtoOutput;
  }

  @override
  void update(void Function(MerchantPortalCodeSentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalCodeSentDtoOutput build() => _build();

  _$MerchantPortalCodeSentDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantPortalCodeSentDtoOutput._(
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'MerchantPortalCodeSentDtoOutput',
            'channel',
          ),
          resendAfterSec: BuiltValueNullFieldError.checkNotNull(
            resendAfterSec,
            r'MerchantPortalCodeSentDtoOutput',
            'resendAfterSec',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MerchantPortalCodeSentDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
