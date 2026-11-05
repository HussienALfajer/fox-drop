// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_code_sent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerCodeSentDtoOutputChannelEnum
_$customerCodeSentDtoOutputChannelEnum_whatsapp =
    const CustomerCodeSentDtoOutputChannelEnum._('whatsapp');

CustomerCodeSentDtoOutputChannelEnum
_$customerCodeSentDtoOutputChannelEnumValueOf(String name) {
  switch (name) {
    case 'whatsapp':
      return _$customerCodeSentDtoOutputChannelEnum_whatsapp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerCodeSentDtoOutputChannelEnum>
_$customerCodeSentDtoOutputChannelEnumValues =
    BuiltSet<CustomerCodeSentDtoOutputChannelEnum>(
      const <CustomerCodeSentDtoOutputChannelEnum>[
        _$customerCodeSentDtoOutputChannelEnum_whatsapp,
      ],
    );

Serializer<CustomerCodeSentDtoOutputChannelEnum>
_$customerCodeSentDtoOutputChannelEnumSerializer =
    _$CustomerCodeSentDtoOutputChannelEnumSerializer();

class _$CustomerCodeSentDtoOutputChannelEnumSerializer
    implements PrimitiveSerializer<CustomerCodeSentDtoOutputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'whatsapp': 'whatsapp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'whatsapp': 'whatsapp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerCodeSentDtoOutputChannelEnum,
  ];
  @override
  final String wireName = 'CustomerCodeSentDtoOutputChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodeSentDtoOutputChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerCodeSentDtoOutputChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerCodeSentDtoOutputChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerCodeSentDtoOutput extends CustomerCodeSentDtoOutput {
  @override
  final CustomerCodeSentDtoOutputChannelEnum channel;
  @override
  final int resendAfterSec;
  @override
  final DateTime expiresAt;

  factory _$CustomerCodeSentDtoOutput([
    void Function(CustomerCodeSentDtoOutputBuilder)? updates,
  ]) => (CustomerCodeSentDtoOutputBuilder()..update(updates))._build();

  _$CustomerCodeSentDtoOutput._({
    required this.channel,
    required this.resendAfterSec,
    required this.expiresAt,
  }) : super._();
  @override
  CustomerCodeSentDtoOutput rebuild(
    void Function(CustomerCodeSentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCodeSentDtoOutputBuilder toBuilder() =>
      CustomerCodeSentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCodeSentDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CustomerCodeSentDtoOutput')
          ..add('channel', channel)
          ..add('resendAfterSec', resendAfterSec)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class CustomerCodeSentDtoOutputBuilder
    implements
        Builder<CustomerCodeSentDtoOutput, CustomerCodeSentDtoOutputBuilder> {
  _$CustomerCodeSentDtoOutput? _$v;

  CustomerCodeSentDtoOutputChannelEnum? _channel;
  CustomerCodeSentDtoOutputChannelEnum? get channel => _$this._channel;
  set channel(CustomerCodeSentDtoOutputChannelEnum? channel) =>
      _$this._channel = channel;

  int? _resendAfterSec;
  int? get resendAfterSec => _$this._resendAfterSec;
  set resendAfterSec(int? resendAfterSec) =>
      _$this._resendAfterSec = resendAfterSec;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CustomerCodeSentDtoOutputBuilder() {
    CustomerCodeSentDtoOutput._defaults(this);
  }

  CustomerCodeSentDtoOutputBuilder get _$this {
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
  void replace(CustomerCodeSentDtoOutput other) {
    _$v = other as _$CustomerCodeSentDtoOutput;
  }

  @override
  void update(void Function(CustomerCodeSentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCodeSentDtoOutput build() => _build();

  _$CustomerCodeSentDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerCodeSentDtoOutput._(
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'CustomerCodeSentDtoOutput',
            'channel',
          ),
          resendAfterSec: BuiltValueNullFieldError.checkNotNull(
            resendAfterSec,
            r'CustomerCodeSentDtoOutput',
            'resendAfterSec',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'CustomerCodeSentDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
