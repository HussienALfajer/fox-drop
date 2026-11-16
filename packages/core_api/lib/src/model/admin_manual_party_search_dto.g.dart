// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_party_search_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminManualPartySearchDtoPartyEnum
_$adminManualPartySearchDtoPartyEnum_captain =
    const AdminManualPartySearchDtoPartyEnum._('captain');
const AdminManualPartySearchDtoPartyEnum
_$adminManualPartySearchDtoPartyEnum_restaurant =
    const AdminManualPartySearchDtoPartyEnum._('restaurant');
const AdminManualPartySearchDtoPartyEnum
_$adminManualPartySearchDtoPartyEnum_customer =
    const AdminManualPartySearchDtoPartyEnum._('customer');

AdminManualPartySearchDtoPartyEnum _$adminManualPartySearchDtoPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'captain':
      return _$adminManualPartySearchDtoPartyEnum_captain;
    case 'restaurant':
      return _$adminManualPartySearchDtoPartyEnum_restaurant;
    case 'customer':
      return _$adminManualPartySearchDtoPartyEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualPartySearchDtoPartyEnum>
_$adminManualPartySearchDtoPartyEnumValues =
    BuiltSet<AdminManualPartySearchDtoPartyEnum>(
      const <AdminManualPartySearchDtoPartyEnum>[
        _$adminManualPartySearchDtoPartyEnum_captain,
        _$adminManualPartySearchDtoPartyEnum_restaurant,
        _$adminManualPartySearchDtoPartyEnum_customer,
      ],
    );

Serializer<AdminManualPartySearchDtoPartyEnum>
_$adminManualPartySearchDtoPartyEnumSerializer =
    _$AdminManualPartySearchDtoPartyEnumSerializer();

class _$AdminManualPartySearchDtoPartyEnumSerializer
    implements PrimitiveSerializer<AdminManualPartySearchDtoPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'restaurant': 'restaurant',
    'customer': 'customer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'restaurant': 'restaurant',
    'customer': 'customer',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminManualPartySearchDtoPartyEnum];
  @override
  final String wireName = 'AdminManualPartySearchDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualPartySearchDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualPartySearchDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualPartySearchDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualPartySearchDto extends AdminManualPartySearchDto {
  @override
  final String cityId;
  @override
  final AdminManualPartySearchDtoPartyEnum party;
  @override
  final String q;

  factory _$AdminManualPartySearchDto([
    void Function(AdminManualPartySearchDtoBuilder)? updates,
  ]) => (AdminManualPartySearchDtoBuilder()..update(updates))._build();

  _$AdminManualPartySearchDto._({
    required this.cityId,
    required this.party,
    required this.q,
  }) : super._();
  @override
  AdminManualPartySearchDto rebuild(
    void Function(AdminManualPartySearchDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualPartySearchDtoBuilder toBuilder() =>
      AdminManualPartySearchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualPartySearchDto &&
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
    return (newBuiltValueToStringHelper(r'AdminManualPartySearchDto')
          ..add('cityId', cityId)
          ..add('party', party)
          ..add('q', q))
        .toString();
  }
}

class AdminManualPartySearchDtoBuilder
    implements
        Builder<AdminManualPartySearchDto, AdminManualPartySearchDtoBuilder> {
  _$AdminManualPartySearchDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminManualPartySearchDtoPartyEnum? _party;
  AdminManualPartySearchDtoPartyEnum? get party => _$this._party;
  set party(AdminManualPartySearchDtoPartyEnum? party) => _$this._party = party;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminManualPartySearchDtoBuilder() {
    AdminManualPartySearchDto._defaults(this);
  }

  AdminManualPartySearchDtoBuilder get _$this {
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
  void replace(AdminManualPartySearchDto other) {
    _$v = other as _$AdminManualPartySearchDto;
  }

  @override
  void update(void Function(AdminManualPartySearchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualPartySearchDto build() => _build();

  _$AdminManualPartySearchDto _build() {
    final _$result =
        _$v ??
        _$AdminManualPartySearchDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminManualPartySearchDto',
            'cityId',
          ),
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'AdminManualPartySearchDto',
            'party',
          ),
          q: BuiltValueNullFieldError.checkNotNull(
            q,
            r'AdminManualPartySearchDto',
            'q',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
