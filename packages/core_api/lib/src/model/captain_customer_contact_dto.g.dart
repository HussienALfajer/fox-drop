// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_customer_contact_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainCustomerContactDtoChannelEnum
_$captainCustomerContactDtoChannelEnum_call =
    const CaptainCustomerContactDtoChannelEnum._('call');
const CaptainCustomerContactDtoChannelEnum
_$captainCustomerContactDtoChannelEnum_whatsapp =
    const CaptainCustomerContactDtoChannelEnum._('whatsapp');

CaptainCustomerContactDtoChannelEnum
_$captainCustomerContactDtoChannelEnumValueOf(String name) {
  switch (name) {
    case 'call':
      return _$captainCustomerContactDtoChannelEnum_call;
    case 'whatsapp':
      return _$captainCustomerContactDtoChannelEnum_whatsapp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainCustomerContactDtoChannelEnum>
_$captainCustomerContactDtoChannelEnumValues =
    BuiltSet<CaptainCustomerContactDtoChannelEnum>(
      const <CaptainCustomerContactDtoChannelEnum>[
        _$captainCustomerContactDtoChannelEnum_call,
        _$captainCustomerContactDtoChannelEnum_whatsapp,
      ],
    );

Serializer<CaptainCustomerContactDtoChannelEnum>
_$captainCustomerContactDtoChannelEnumSerializer =
    _$CaptainCustomerContactDtoChannelEnumSerializer();

class _$CaptainCustomerContactDtoChannelEnumSerializer
    implements PrimitiveSerializer<CaptainCustomerContactDtoChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'call': 'call',
    'whatsapp': 'whatsapp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'call': 'call',
    'whatsapp': 'whatsapp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainCustomerContactDtoChannelEnum,
  ];
  @override
  final String wireName = 'CaptainCustomerContactDtoChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustomerContactDtoChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainCustomerContactDtoChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainCustomerContactDtoChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainCustomerContactDto extends CaptainCustomerContactDto {
  @override
  final CaptainCustomerContactDtoChannelEnum channel;

  factory _$CaptainCustomerContactDto([
    void Function(CaptainCustomerContactDtoBuilder)? updates,
  ]) => (CaptainCustomerContactDtoBuilder()..update(updates))._build();

  _$CaptainCustomerContactDto._({required this.channel}) : super._();
  @override
  CaptainCustomerContactDto rebuild(
    void Function(CaptainCustomerContactDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustomerContactDtoBuilder toBuilder() =>
      CaptainCustomerContactDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustomerContactDto && channel == other.channel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainCustomerContactDto',
    )..add('channel', channel)).toString();
  }
}

class CaptainCustomerContactDtoBuilder
    implements
        Builder<CaptainCustomerContactDto, CaptainCustomerContactDtoBuilder> {
  _$CaptainCustomerContactDto? _$v;

  CaptainCustomerContactDtoChannelEnum? _channel;
  CaptainCustomerContactDtoChannelEnum? get channel => _$this._channel;
  set channel(CaptainCustomerContactDtoChannelEnum? channel) =>
      _$this._channel = channel;

  CaptainCustomerContactDtoBuilder() {
    CaptainCustomerContactDto._defaults(this);
  }

  CaptainCustomerContactDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channel = $v.channel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustomerContactDto other) {
    _$v = other as _$CaptainCustomerContactDto;
  }

  @override
  void update(void Function(CaptainCustomerContactDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustomerContactDto build() => _build();

  _$CaptainCustomerContactDto _build() {
    final _$result =
        _$v ??
        _$CaptainCustomerContactDto._(
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'CaptainCustomerContactDto',
            'channel',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
