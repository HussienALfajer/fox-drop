// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_open_ticket_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOpenTicketDtoPartyEnum _$adminOpenTicketDtoPartyEnum_customer =
    const AdminOpenTicketDtoPartyEnum._('customer');
const AdminOpenTicketDtoPartyEnum _$adminOpenTicketDtoPartyEnum_restaurant =
    const AdminOpenTicketDtoPartyEnum._('restaurant');
const AdminOpenTicketDtoPartyEnum _$adminOpenTicketDtoPartyEnum_captain =
    const AdminOpenTicketDtoPartyEnum._('captain');

AdminOpenTicketDtoPartyEnum _$adminOpenTicketDtoPartyEnumValueOf(String name) {
  switch (name) {
    case 'customer':
      return _$adminOpenTicketDtoPartyEnum_customer;
    case 'restaurant':
      return _$adminOpenTicketDtoPartyEnum_restaurant;
    case 'captain':
      return _$adminOpenTicketDtoPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOpenTicketDtoPartyEnum>
_$adminOpenTicketDtoPartyEnumValues =
    BuiltSet<AdminOpenTicketDtoPartyEnum>(const <AdminOpenTicketDtoPartyEnum>[
      _$adminOpenTicketDtoPartyEnum_customer,
      _$adminOpenTicketDtoPartyEnum_restaurant,
      _$adminOpenTicketDtoPartyEnum_captain,
    ]);

Serializer<AdminOpenTicketDtoPartyEnum>
_$adminOpenTicketDtoPartyEnumSerializer =
    _$AdminOpenTicketDtoPartyEnumSerializer();

class _$AdminOpenTicketDtoPartyEnumSerializer
    implements PrimitiveSerializer<AdminOpenTicketDtoPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customer': 'customer',
    'restaurant': 'restaurant',
    'captain': 'captain',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer': 'customer',
    'restaurant': 'restaurant',
    'captain': 'captain',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminOpenTicketDtoPartyEnum];
  @override
  final String wireName = 'AdminOpenTicketDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenTicketDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOpenTicketDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOpenTicketDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOpenTicketDto extends AdminOpenTicketDto {
  @override
  final String cityId;
  @override
  final AdminOpenTicketDtoPartyEnum party;
  @override
  final String typeCode;
  @override
  final String description;
  @override
  final String partyId;
  @override
  final String? restaurantId;

  factory _$AdminOpenTicketDto([
    void Function(AdminOpenTicketDtoBuilder)? updates,
  ]) => (AdminOpenTicketDtoBuilder()..update(updates))._build();

  _$AdminOpenTicketDto._({
    required this.cityId,
    required this.party,
    required this.typeCode,
    required this.description,
    required this.partyId,
    this.restaurantId,
  }) : super._();
  @override
  AdminOpenTicketDto rebuild(
    void Function(AdminOpenTicketDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOpenTicketDtoBuilder toBuilder() =>
      AdminOpenTicketDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOpenTicketDto &&
        cityId == other.cityId &&
        party == other.party &&
        typeCode == other.typeCode &&
        description == other.description &&
        partyId == other.partyId &&
        restaurantId == other.restaurantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, partyId.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOpenTicketDto')
          ..add('cityId', cityId)
          ..add('party', party)
          ..add('typeCode', typeCode)
          ..add('description', description)
          ..add('partyId', partyId)
          ..add('restaurantId', restaurantId))
        .toString();
  }
}

class AdminOpenTicketDtoBuilder
    implements Builder<AdminOpenTicketDto, AdminOpenTicketDtoBuilder> {
  _$AdminOpenTicketDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminOpenTicketDtoPartyEnum? _party;
  AdminOpenTicketDtoPartyEnum? get party => _$this._party;
  set party(AdminOpenTicketDtoPartyEnum? party) => _$this._party = party;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  AdminOpenTicketDtoBuilder() {
    AdminOpenTicketDto._defaults(this);
  }

  AdminOpenTicketDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _party = $v.party;
      _typeCode = $v.typeCode;
      _description = $v.description;
      _partyId = $v.partyId;
      _restaurantId = $v.restaurantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOpenTicketDto other) {
    _$v = other as _$AdminOpenTicketDto;
  }

  @override
  void update(void Function(AdminOpenTicketDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOpenTicketDto build() => _build();

  _$AdminOpenTicketDto _build() {
    final _$result =
        _$v ??
        _$AdminOpenTicketDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminOpenTicketDto',
            'cityId',
          ),
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'AdminOpenTicketDto',
            'party',
          ),
          typeCode: BuiltValueNullFieldError.checkNotNull(
            typeCode,
            r'AdminOpenTicketDto',
            'typeCode',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'AdminOpenTicketDto',
            'description',
          ),
          partyId: BuiltValueNullFieldError.checkNotNull(
            partyId,
            r'AdminOpenTicketDto',
            'partyId',
          ),
          restaurantId: restaurantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
