// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_close_code_sent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerCloseCodeSentDtoOutputChannelEnum
_$customerCloseCodeSentDtoOutputChannelEnum_whatsapp =
    const CustomerCloseCodeSentDtoOutputChannelEnum._('whatsapp');

CustomerCloseCodeSentDtoOutputChannelEnum
_$customerCloseCodeSentDtoOutputChannelEnumValueOf(String name) {
  switch (name) {
    case 'whatsapp':
      return _$customerCloseCodeSentDtoOutputChannelEnum_whatsapp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerCloseCodeSentDtoOutputChannelEnum>
_$customerCloseCodeSentDtoOutputChannelEnumValues =
    BuiltSet<CustomerCloseCodeSentDtoOutputChannelEnum>(
      const <CustomerCloseCodeSentDtoOutputChannelEnum>[
        _$customerCloseCodeSentDtoOutputChannelEnum_whatsapp,
      ],
    );

Serializer<CustomerCloseCodeSentDtoOutputChannelEnum>
_$customerCloseCodeSentDtoOutputChannelEnumSerializer =
    _$CustomerCloseCodeSentDtoOutputChannelEnumSerializer();

class _$CustomerCloseCodeSentDtoOutputChannelEnumSerializer
    implements PrimitiveSerializer<CustomerCloseCodeSentDtoOutputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'whatsapp': 'whatsapp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'whatsapp': 'whatsapp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerCloseCodeSentDtoOutputChannelEnum,
  ];
  @override
  final String wireName = 'CustomerCloseCodeSentDtoOutputChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerCloseCodeSentDtoOutputChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerCloseCodeSentDtoOutputChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerCloseCodeSentDtoOutputChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerCloseCodeSentDtoOutput extends CustomerCloseCodeSentDtoOutput {
  @override
  final CustomerCloseCodeSentDtoOutputChannelEnum channel;
  @override
  final int resendAfterSec;
  @override
  final DateTime expiresAt;

  factory _$CustomerCloseCodeSentDtoOutput([
    void Function(CustomerCloseCodeSentDtoOutputBuilder)? updates,
  ]) => (CustomerCloseCodeSentDtoOutputBuilder()..update(updates))._build();

  _$CustomerCloseCodeSentDtoOutput._({
    required this.channel,
    required this.resendAfterSec,
    required this.expiresAt,
  }) : super._();
  @override
  CustomerCloseCodeSentDtoOutput rebuild(
    void Function(CustomerCloseCodeSentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCloseCodeSentDtoOutputBuilder toBuilder() =>
      CustomerCloseCodeSentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCloseCodeSentDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CustomerCloseCodeSentDtoOutput')
          ..add('channel', channel)
          ..add('resendAfterSec', resendAfterSec)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class CustomerCloseCodeSentDtoOutputBuilder
    implements
        Builder<
          CustomerCloseCodeSentDtoOutput,
          CustomerCloseCodeSentDtoOutputBuilder
        > {
  _$CustomerCloseCodeSentDtoOutput? _$v;

  CustomerCloseCodeSentDtoOutputChannelEnum? _channel;
  CustomerCloseCodeSentDtoOutputChannelEnum? get channel => _$this._channel;
  set channel(CustomerCloseCodeSentDtoOutputChannelEnum? channel) =>
      _$this._channel = channel;

  int? _resendAfterSec;
  int? get resendAfterSec => _$this._resendAfterSec;
  set resendAfterSec(int? resendAfterSec) =>
      _$this._resendAfterSec = resendAfterSec;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CustomerCloseCodeSentDtoOutputBuilder() {
    CustomerCloseCodeSentDtoOutput._defaults(this);
  }

  CustomerCloseCodeSentDtoOutputBuilder get _$this {
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
  void replace(CustomerCloseCodeSentDtoOutput other) {
    _$v = other as _$CustomerCloseCodeSentDtoOutput;
  }

  @override
  void update(void Function(CustomerCloseCodeSentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCloseCodeSentDtoOutput build() => _build();

  _$CustomerCloseCodeSentDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerCloseCodeSentDtoOutput._(
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'CustomerCloseCodeSentDtoOutput',
            'channel',
          ),
          resendAfterSec: BuiltValueNullFieldError.checkNotNull(
            resendAfterSec,
            r'CustomerCloseCodeSentDtoOutput',
            'resendAfterSec',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'CustomerCloseCodeSentDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
