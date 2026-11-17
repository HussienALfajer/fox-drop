// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_open_order_ticket_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOpenOrderTicketDtoPartyEnum
_$adminOpenOrderTicketDtoPartyEnum_customer =
    const AdminOpenOrderTicketDtoPartyEnum._('customer');
const AdminOpenOrderTicketDtoPartyEnum
_$adminOpenOrderTicketDtoPartyEnum_restaurant =
    const AdminOpenOrderTicketDtoPartyEnum._('restaurant');
const AdminOpenOrderTicketDtoPartyEnum
_$adminOpenOrderTicketDtoPartyEnum_captain =
    const AdminOpenOrderTicketDtoPartyEnum._('captain');

AdminOpenOrderTicketDtoPartyEnum _$adminOpenOrderTicketDtoPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customer':
      return _$adminOpenOrderTicketDtoPartyEnum_customer;
    case 'restaurant':
      return _$adminOpenOrderTicketDtoPartyEnum_restaurant;
    case 'captain':
      return _$adminOpenOrderTicketDtoPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOpenOrderTicketDtoPartyEnum>
_$adminOpenOrderTicketDtoPartyEnumValues =
    BuiltSet<AdminOpenOrderTicketDtoPartyEnum>(
      const <AdminOpenOrderTicketDtoPartyEnum>[
        _$adminOpenOrderTicketDtoPartyEnum_customer,
        _$adminOpenOrderTicketDtoPartyEnum_restaurant,
        _$adminOpenOrderTicketDtoPartyEnum_captain,
      ],
    );

Serializer<AdminOpenOrderTicketDtoPartyEnum>
_$adminOpenOrderTicketDtoPartyEnumSerializer =
    _$AdminOpenOrderTicketDtoPartyEnumSerializer();

class _$AdminOpenOrderTicketDtoPartyEnumSerializer
    implements PrimitiveSerializer<AdminOpenOrderTicketDtoPartyEnum> {
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
  final Iterable<Type> types = const <Type>[AdminOpenOrderTicketDtoPartyEnum];
  @override
  final String wireName = 'AdminOpenOrderTicketDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenOrderTicketDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOpenOrderTicketDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOpenOrderTicketDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOpenOrderTicketDto extends AdminOpenOrderTicketDto {
  @override
  final AdminOpenOrderTicketDtoPartyEnum party;
  @override
  final String typeCode;
  @override
  final String description;

  factory _$AdminOpenOrderTicketDto([
    void Function(AdminOpenOrderTicketDtoBuilder)? updates,
  ]) => (AdminOpenOrderTicketDtoBuilder()..update(updates))._build();

  _$AdminOpenOrderTicketDto._({
    required this.party,
    required this.typeCode,
    required this.description,
  }) : super._();
  @override
  AdminOpenOrderTicketDto rebuild(
    void Function(AdminOpenOrderTicketDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOpenOrderTicketDtoBuilder toBuilder() =>
      AdminOpenOrderTicketDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOpenOrderTicketDto &&
        party == other.party &&
        typeCode == other.typeCode &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOpenOrderTicketDto')
          ..add('party', party)
          ..add('typeCode', typeCode)
          ..add('description', description))
        .toString();
  }
}

class AdminOpenOrderTicketDtoBuilder
    implements
        Builder<AdminOpenOrderTicketDto, AdminOpenOrderTicketDtoBuilder> {
  _$AdminOpenOrderTicketDto? _$v;

  AdminOpenOrderTicketDtoPartyEnum? _party;
  AdminOpenOrderTicketDtoPartyEnum? get party => _$this._party;
  set party(AdminOpenOrderTicketDtoPartyEnum? party) => _$this._party = party;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminOpenOrderTicketDtoBuilder() {
    AdminOpenOrderTicketDto._defaults(this);
  }

  AdminOpenOrderTicketDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _party = $v.party;
      _typeCode = $v.typeCode;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOpenOrderTicketDto other) {
    _$v = other as _$AdminOpenOrderTicketDto;
  }

  @override
  void update(void Function(AdminOpenOrderTicketDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOpenOrderTicketDto build() => _build();

  _$AdminOpenOrderTicketDto _build() {
    final _$result =
        _$v ??
        _$AdminOpenOrderTicketDto._(
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'AdminOpenOrderTicketDto',
            'party',
          ),
          typeCode: BuiltValueNullFieldError.checkNotNull(
            typeCode,
            r'AdminOpenOrderTicketDto',
            'typeCode',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'AdminOpenOrderTicketDto',
            'description',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
