// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_party_search_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketPartySearchDtoPartyEnum
_$adminTicketPartySearchDtoPartyEnum_customer =
    const AdminTicketPartySearchDtoPartyEnum._('customer');
const AdminTicketPartySearchDtoPartyEnum
_$adminTicketPartySearchDtoPartyEnum_restaurant =
    const AdminTicketPartySearchDtoPartyEnum._('restaurant');
const AdminTicketPartySearchDtoPartyEnum
_$adminTicketPartySearchDtoPartyEnum_captain =
    const AdminTicketPartySearchDtoPartyEnum._('captain');

AdminTicketPartySearchDtoPartyEnum _$adminTicketPartySearchDtoPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customer':
      return _$adminTicketPartySearchDtoPartyEnum_customer;
    case 'restaurant':
      return _$adminTicketPartySearchDtoPartyEnum_restaurant;
    case 'captain':
      return _$adminTicketPartySearchDtoPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketPartySearchDtoPartyEnum>
_$adminTicketPartySearchDtoPartyEnumValues =
    BuiltSet<AdminTicketPartySearchDtoPartyEnum>(
      const <AdminTicketPartySearchDtoPartyEnum>[
        _$adminTicketPartySearchDtoPartyEnum_customer,
        _$adminTicketPartySearchDtoPartyEnum_restaurant,
        _$adminTicketPartySearchDtoPartyEnum_captain,
      ],
    );

Serializer<AdminTicketPartySearchDtoPartyEnum>
_$adminTicketPartySearchDtoPartyEnumSerializer =
    _$AdminTicketPartySearchDtoPartyEnumSerializer();

class _$AdminTicketPartySearchDtoPartyEnumSerializer
    implements PrimitiveSerializer<AdminTicketPartySearchDtoPartyEnum> {
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
  final Iterable<Type> types = const <Type>[AdminTicketPartySearchDtoPartyEnum];
  @override
  final String wireName = 'AdminTicketPartySearchDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPartySearchDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketPartySearchDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketPartySearchDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketPartySearchDto extends AdminTicketPartySearchDto {
  @override
  final String cityId;
  @override
  final AdminTicketPartySearchDtoPartyEnum party;
  @override
  final String q;

  factory _$AdminTicketPartySearchDto([
    void Function(AdminTicketPartySearchDtoBuilder)? updates,
  ]) => (AdminTicketPartySearchDtoBuilder()..update(updates))._build();

  _$AdminTicketPartySearchDto._({
    required this.cityId,
    required this.party,
    required this.q,
  }) : super._();
  @override
  AdminTicketPartySearchDto rebuild(
    void Function(AdminTicketPartySearchDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPartySearchDtoBuilder toBuilder() =>
      AdminTicketPartySearchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPartySearchDto &&
        cityId == other.cityId &&
        party == other.party &&
        q == other.q;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, q.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketPartySearchDto')
          ..add('cityId', cityId)
          ..add('party', party)
          ..add('q', q))
        .toString();
  }
}

class AdminTicketPartySearchDtoBuilder
    implements
        Builder<AdminTicketPartySearchDto, AdminTicketPartySearchDtoBuilder> {
  _$AdminTicketPartySearchDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminTicketPartySearchDtoPartyEnum? _party;
  AdminTicketPartySearchDtoPartyEnum? get party => _$this._party;
  set party(AdminTicketPartySearchDtoPartyEnum? party) => _$this._party = party;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminTicketPartySearchDtoBuilder() {
    AdminTicketPartySearchDto._defaults(this);
  }

  AdminTicketPartySearchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _party = $v.party;
      _q = $v.q;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPartySearchDto other) {
    _$v = other as _$AdminTicketPartySearchDto;
  }

  @override
  void update(void Function(AdminTicketPartySearchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPartySearchDto build() => _build();

  _$AdminTicketPartySearchDto _build() {
    final _$result =
        _$v ??
        _$AdminTicketPartySearchDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminTicketPartySearchDto',
            'cityId',
          ),
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'AdminTicketPartySearchDto',
            'party',
          ),
          q: BuiltValueNullFieldError.checkNotNull(
            q,
            r'AdminTicketPartySearchDto',
            'q',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
