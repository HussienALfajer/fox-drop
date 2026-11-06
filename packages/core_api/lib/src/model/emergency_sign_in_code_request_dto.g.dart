// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_sign_in_code_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmergencySignInCodeRequestDtoPartyEnum
_$emergencySignInCodeRequestDtoPartyEnum_captain =
    const EmergencySignInCodeRequestDtoPartyEnum._('captain');
const EmergencySignInCodeRequestDtoPartyEnum
_$emergencySignInCodeRequestDtoPartyEnum_merchant =
    const EmergencySignInCodeRequestDtoPartyEnum._('merchant');

EmergencySignInCodeRequestDtoPartyEnum
_$emergencySignInCodeRequestDtoPartyEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$emergencySignInCodeRequestDtoPartyEnum_captain;
    case 'merchant':
      return _$emergencySignInCodeRequestDtoPartyEnum_merchant;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmergencySignInCodeRequestDtoPartyEnum>
_$emergencySignInCodeRequestDtoPartyEnumValues =
    BuiltSet<EmergencySignInCodeRequestDtoPartyEnum>(
      const <EmergencySignInCodeRequestDtoPartyEnum>[
        _$emergencySignInCodeRequestDtoPartyEnum_captain,
        _$emergencySignInCodeRequestDtoPartyEnum_merchant,
      ],
    );

Serializer<EmergencySignInCodeRequestDtoPartyEnum>
_$emergencySignInCodeRequestDtoPartyEnumSerializer =
    _$EmergencySignInCodeRequestDtoPartyEnumSerializer();

class _$EmergencySignInCodeRequestDtoPartyEnumSerializer
    implements PrimitiveSerializer<EmergencySignInCodeRequestDtoPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'merchant': 'merchant',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'merchant': 'merchant',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EmergencySignInCodeRequestDtoPartyEnum,
  ];
  @override
  final String wireName = 'EmergencySignInCodeRequestDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    EmergencySignInCodeRequestDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmergencySignInCodeRequestDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmergencySignInCodeRequestDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$EmergencySignInCodeRequestDto extends EmergencySignInCodeRequestDto {
  @override
  final EmergencySignInCodeRequestDtoPartyEnum party;
  @override
  final String phone;
  @override
  final String reason;

  factory _$EmergencySignInCodeRequestDto([
    void Function(EmergencySignInCodeRequestDtoBuilder)? updates,
  ]) => (EmergencySignInCodeRequestDtoBuilder()..update(updates))._build();

  _$EmergencySignInCodeRequestDto._({
    required this.party,
    required this.phone,
    required this.reason,
  }) : super._();
  @override
  EmergencySignInCodeRequestDto rebuild(
    void Function(EmergencySignInCodeRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmergencySignInCodeRequestDtoBuilder toBuilder() =>
      EmergencySignInCodeRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmergencySignInCodeRequestDto &&
        party == other.party &&
        phone == other.phone &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmergencySignInCodeRequestDto')
          ..add('party', party)
          ..add('phone', phone)
          ..add('reason', reason))
        .toString();
  }
}

class EmergencySignInCodeRequestDtoBuilder
    implements
        Builder<
          EmergencySignInCodeRequestDto,
          EmergencySignInCodeRequestDtoBuilder
        > {
  _$EmergencySignInCodeRequestDto? _$v;

  EmergencySignInCodeRequestDtoPartyEnum? _party;
  EmergencySignInCodeRequestDtoPartyEnum? get party => _$this._party;
  set party(EmergencySignInCodeRequestDtoPartyEnum? party) =>
      _$this._party = party;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  EmergencySignInCodeRequestDtoBuilder() {
    EmergencySignInCodeRequestDto._defaults(this);
  }

  EmergencySignInCodeRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _party = $v.party;
      _phone = $v.phone;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmergencySignInCodeRequestDto other) {
    _$v = other as _$EmergencySignInCodeRequestDto;
  }

  @override
  void update(void Function(EmergencySignInCodeRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmergencySignInCodeRequestDto build() => _build();

  _$EmergencySignInCodeRequestDto _build() {
    final _$result =
        _$v ??
        _$EmergencySignInCodeRequestDto._(
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'EmergencySignInCodeRequestDto',
            'party',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'EmergencySignInCodeRequestDto',
            'phone',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'EmergencySignInCodeRequestDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
