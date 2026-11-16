// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_adjustment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminManualAdjustmentDtoPartyEnum
_$adminManualAdjustmentDtoPartyEnum_captain =
    const AdminManualAdjustmentDtoPartyEnum._('captain');
const AdminManualAdjustmentDtoPartyEnum
_$adminManualAdjustmentDtoPartyEnum_restaurant =
    const AdminManualAdjustmentDtoPartyEnum._('restaurant');
const AdminManualAdjustmentDtoPartyEnum
_$adminManualAdjustmentDtoPartyEnum_customer =
    const AdminManualAdjustmentDtoPartyEnum._('customer');

AdminManualAdjustmentDtoPartyEnum _$adminManualAdjustmentDtoPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'captain':
      return _$adminManualAdjustmentDtoPartyEnum_captain;
    case 'restaurant':
      return _$adminManualAdjustmentDtoPartyEnum_restaurant;
    case 'customer':
      return _$adminManualAdjustmentDtoPartyEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualAdjustmentDtoPartyEnum>
_$adminManualAdjustmentDtoPartyEnumValues =
    BuiltSet<AdminManualAdjustmentDtoPartyEnum>(
      const <AdminManualAdjustmentDtoPartyEnum>[
        _$adminManualAdjustmentDtoPartyEnum_captain,
        _$adminManualAdjustmentDtoPartyEnum_restaurant,
        _$adminManualAdjustmentDtoPartyEnum_customer,
      ],
    );

const AdminManualAdjustmentDtoAccountEnum
_$adminManualAdjustmentDtoAccountEnum_captainPeriodCustody =
    const AdminManualAdjustmentDtoAccountEnum._('captainPeriodCustody');
const AdminManualAdjustmentDtoAccountEnum
_$adminManualAdjustmentDtoAccountEnum_captainPeriodEarnings =
    const AdminManualAdjustmentDtoAccountEnum._('captainPeriodEarnings');
const AdminManualAdjustmentDtoAccountEnum
_$adminManualAdjustmentDtoAccountEnum_merchantPeriodAccount =
    const AdminManualAdjustmentDtoAccountEnum._('merchantPeriodAccount');
const AdminManualAdjustmentDtoAccountEnum
_$adminManualAdjustmentDtoAccountEnum_customerPeriodDues =
    const AdminManualAdjustmentDtoAccountEnum._('customerPeriodDues');

AdminManualAdjustmentDtoAccountEnum
_$adminManualAdjustmentDtoAccountEnumValueOf(String name) {
  switch (name) {
    case 'captainPeriodCustody':
      return _$adminManualAdjustmentDtoAccountEnum_captainPeriodCustody;
    case 'captainPeriodEarnings':
      return _$adminManualAdjustmentDtoAccountEnum_captainPeriodEarnings;
    case 'merchantPeriodAccount':
      return _$adminManualAdjustmentDtoAccountEnum_merchantPeriodAccount;
    case 'customerPeriodDues':
      return _$adminManualAdjustmentDtoAccountEnum_customerPeriodDues;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualAdjustmentDtoAccountEnum>
_$adminManualAdjustmentDtoAccountEnumValues =
    BuiltSet<AdminManualAdjustmentDtoAccountEnum>(
      const <AdminManualAdjustmentDtoAccountEnum>[
        _$adminManualAdjustmentDtoAccountEnum_captainPeriodCustody,
        _$adminManualAdjustmentDtoAccountEnum_captainPeriodEarnings,
        _$adminManualAdjustmentDtoAccountEnum_merchantPeriodAccount,
        _$adminManualAdjustmentDtoAccountEnum_customerPeriodDues,
      ],
    );

Serializer<AdminManualAdjustmentDtoPartyEnum>
_$adminManualAdjustmentDtoPartyEnumSerializer =
    _$AdminManualAdjustmentDtoPartyEnumSerializer();
Serializer<AdminManualAdjustmentDtoAccountEnum>
_$adminManualAdjustmentDtoAccountEnumSerializer =
    _$AdminManualAdjustmentDtoAccountEnumSerializer();

class _$AdminManualAdjustmentDtoPartyEnumSerializer
    implements PrimitiveSerializer<AdminManualAdjustmentDtoPartyEnum> {
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
  final Iterable<Type> types = const <Type>[AdminManualAdjustmentDtoPartyEnum];
  @override
  final String wireName = 'AdminManualAdjustmentDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualAdjustmentDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualAdjustmentDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualAdjustmentDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualAdjustmentDtoAccountEnumSerializer
    implements PrimitiveSerializer<AdminManualAdjustmentDtoAccountEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captainPeriodCustody': 'captain.custody',
    'captainPeriodEarnings': 'captain.earnings',
    'merchantPeriodAccount': 'merchant.account',
    'customerPeriodDues': 'customer.dues',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain.custody': 'captainPeriodCustody',
    'captain.earnings': 'captainPeriodEarnings',
    'merchant.account': 'merchantPeriodAccount',
    'customer.dues': 'customerPeriodDues',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminManualAdjustmentDtoAccountEnum,
  ];
  @override
  final String wireName = 'AdminManualAdjustmentDtoAccountEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualAdjustmentDtoAccountEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualAdjustmentDtoAccountEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualAdjustmentDtoAccountEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualAdjustmentDto extends AdminManualAdjustmentDto {
  @override
  final String cityId;
  @override
  final AdminManualAdjustmentDtoPartyEnum party;
  @override
  final String partyId;
  @override
  final AdminManualAdjustmentDtoAccountEnum account;
  @override
  final String currency;
  @override
  final String amount;
  @override
  final String reason;

  factory _$AdminManualAdjustmentDto([
    void Function(AdminManualAdjustmentDtoBuilder)? updates,
  ]) => (AdminManualAdjustmentDtoBuilder()..update(updates))._build();

  _$AdminManualAdjustmentDto._({
    required this.cityId,
    required this.party,
    required this.partyId,
    required this.account,
    required this.currency,
    required this.amount,
    required this.reason,
  }) : super._();
  @override
  AdminManualAdjustmentDto rebuild(
    void Function(AdminManualAdjustmentDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualAdjustmentDtoBuilder toBuilder() =>
      AdminManualAdjustmentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualAdjustmentDto &&
        cityId == other.cityId &&
        party == other.party &&
        partyId == other.partyId &&
        account == other.account &&
        currency == other.currency &&
        amount == other.amount &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, partyId.hashCode);
    _$hash = $jc(_$hash, account.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminManualAdjustmentDto')
          ..add('cityId', cityId)
          ..add('party', party)
          ..add('partyId', partyId)
          ..add('account', account)
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('reason', reason))
        .toString();
  }
}

class AdminManualAdjustmentDtoBuilder
    implements
        Builder<AdminManualAdjustmentDto, AdminManualAdjustmentDtoBuilder> {
  _$AdminManualAdjustmentDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminManualAdjustmentDtoPartyEnum? _party;
  AdminManualAdjustmentDtoPartyEnum? get party => _$this._party;
  set party(AdminManualAdjustmentDtoPartyEnum? party) => _$this._party = party;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  AdminManualAdjustmentDtoAccountEnum? _account;
  AdminManualAdjustmentDtoAccountEnum? get account => _$this._account;
  set account(AdminManualAdjustmentDtoAccountEnum? account) =>
      _$this._account = account;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminManualAdjustmentDtoBuilder() {
    AdminManualAdjustmentDto._defaults(this);
  }

  AdminManualAdjustmentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _party = $v.party;
      _partyId = $v.partyId;
      _account = $v.account;
      _currency = $v.currency;
      _amount = $v.amount;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualAdjustmentDto other) {
    _$v = other as _$AdminManualAdjustmentDto;
  }

  @override
  void update(void Function(AdminManualAdjustmentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualAdjustmentDto build() => _build();

  _$AdminManualAdjustmentDto _build() {
    final _$result =
        _$v ??
        _$AdminManualAdjustmentDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminManualAdjustmentDto',
            'cityId',
          ),
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'AdminManualAdjustmentDto',
            'party',
          ),
          partyId: BuiltValueNullFieldError.checkNotNull(
            partyId,
            r'AdminManualAdjustmentDto',
            'partyId',
          ),
          account: BuiltValueNullFieldError.checkNotNull(
            account,
            r'AdminManualAdjustmentDto',
            'account',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminManualAdjustmentDto',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminManualAdjustmentDto',
            'amount',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminManualAdjustmentDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
