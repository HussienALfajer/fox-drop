// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_correction_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderCorrectionDtoPartyEnum
_$adminOrderCorrectionDtoPartyEnum_captain =
    const AdminOrderCorrectionDtoPartyEnum._('captain');
const AdminOrderCorrectionDtoPartyEnum
_$adminOrderCorrectionDtoPartyEnum_restaurant =
    const AdminOrderCorrectionDtoPartyEnum._('restaurant');
const AdminOrderCorrectionDtoPartyEnum
_$adminOrderCorrectionDtoPartyEnum_customer =
    const AdminOrderCorrectionDtoPartyEnum._('customer');

AdminOrderCorrectionDtoPartyEnum _$adminOrderCorrectionDtoPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'captain':
      return _$adminOrderCorrectionDtoPartyEnum_captain;
    case 'restaurant':
      return _$adminOrderCorrectionDtoPartyEnum_restaurant;
    case 'customer':
      return _$adminOrderCorrectionDtoPartyEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCorrectionDtoPartyEnum>
_$adminOrderCorrectionDtoPartyEnumValues =
    BuiltSet<AdminOrderCorrectionDtoPartyEnum>(
      const <AdminOrderCorrectionDtoPartyEnum>[
        _$adminOrderCorrectionDtoPartyEnum_captain,
        _$adminOrderCorrectionDtoPartyEnum_restaurant,
        _$adminOrderCorrectionDtoPartyEnum_customer,
      ],
    );

const AdminOrderCorrectionDtoAccountEnum
_$adminOrderCorrectionDtoAccountEnum_captainPeriodCustody =
    const AdminOrderCorrectionDtoAccountEnum._('captainPeriodCustody');
const AdminOrderCorrectionDtoAccountEnum
_$adminOrderCorrectionDtoAccountEnum_captainPeriodEarnings =
    const AdminOrderCorrectionDtoAccountEnum._('captainPeriodEarnings');
const AdminOrderCorrectionDtoAccountEnum
_$adminOrderCorrectionDtoAccountEnum_merchantPeriodAccount =
    const AdminOrderCorrectionDtoAccountEnum._('merchantPeriodAccount');
const AdminOrderCorrectionDtoAccountEnum
_$adminOrderCorrectionDtoAccountEnum_customerPeriodDues =
    const AdminOrderCorrectionDtoAccountEnum._('customerPeriodDues');

AdminOrderCorrectionDtoAccountEnum _$adminOrderCorrectionDtoAccountEnumValueOf(
  String name,
) {
  switch (name) {
    case 'captainPeriodCustody':
      return _$adminOrderCorrectionDtoAccountEnum_captainPeriodCustody;
    case 'captainPeriodEarnings':
      return _$adminOrderCorrectionDtoAccountEnum_captainPeriodEarnings;
    case 'merchantPeriodAccount':
      return _$adminOrderCorrectionDtoAccountEnum_merchantPeriodAccount;
    case 'customerPeriodDues':
      return _$adminOrderCorrectionDtoAccountEnum_customerPeriodDues;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCorrectionDtoAccountEnum>
_$adminOrderCorrectionDtoAccountEnumValues =
    BuiltSet<AdminOrderCorrectionDtoAccountEnum>(
      const <AdminOrderCorrectionDtoAccountEnum>[
        _$adminOrderCorrectionDtoAccountEnum_captainPeriodCustody,
        _$adminOrderCorrectionDtoAccountEnum_captainPeriodEarnings,
        _$adminOrderCorrectionDtoAccountEnum_merchantPeriodAccount,
        _$adminOrderCorrectionDtoAccountEnum_customerPeriodDues,
      ],
    );

Serializer<AdminOrderCorrectionDtoPartyEnum>
_$adminOrderCorrectionDtoPartyEnumSerializer =
    _$AdminOrderCorrectionDtoPartyEnumSerializer();
Serializer<AdminOrderCorrectionDtoAccountEnum>
_$adminOrderCorrectionDtoAccountEnumSerializer =
    _$AdminOrderCorrectionDtoAccountEnumSerializer();

class _$AdminOrderCorrectionDtoPartyEnumSerializer
    implements PrimitiveSerializer<AdminOrderCorrectionDtoPartyEnum> {
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
  final Iterable<Type> types = const <Type>[AdminOrderCorrectionDtoPartyEnum];
  @override
  final String wireName = 'AdminOrderCorrectionDtoPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCorrectionDtoPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCorrectionDtoPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCorrectionDtoPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCorrectionDtoAccountEnumSerializer
    implements PrimitiveSerializer<AdminOrderCorrectionDtoAccountEnum> {
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
  final Iterable<Type> types = const <Type>[AdminOrderCorrectionDtoAccountEnum];
  @override
  final String wireName = 'AdminOrderCorrectionDtoAccountEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCorrectionDtoAccountEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCorrectionDtoAccountEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCorrectionDtoAccountEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCorrectionDto extends AdminOrderCorrectionDto {
  @override
  final AdminOrderCorrectionDtoPartyEnum party;
  @override
  final String partyId;
  @override
  final AdminOrderCorrectionDtoAccountEnum account;
  @override
  final String currency;
  @override
  final String amount;
  @override
  final String reason;

  factory _$AdminOrderCorrectionDto([
    void Function(AdminOrderCorrectionDtoBuilder)? updates,
  ]) => (AdminOrderCorrectionDtoBuilder()..update(updates))._build();

  _$AdminOrderCorrectionDto._({
    required this.party,
    required this.partyId,
    required this.account,
    required this.currency,
    required this.amount,
    required this.reason,
  }) : super._();
  @override
  AdminOrderCorrectionDto rebuild(
    void Function(AdminOrderCorrectionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCorrectionDtoBuilder toBuilder() =>
      AdminOrderCorrectionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCorrectionDto &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderCorrectionDto')
          ..add('party', party)
          ..add('partyId', partyId)
          ..add('account', account)
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('reason', reason))
        .toString();
  }
}

class AdminOrderCorrectionDtoBuilder
    implements
        Builder<AdminOrderCorrectionDto, AdminOrderCorrectionDtoBuilder> {
  _$AdminOrderCorrectionDto? _$v;

  AdminOrderCorrectionDtoPartyEnum? _party;
  AdminOrderCorrectionDtoPartyEnum? get party => _$this._party;
  set party(AdminOrderCorrectionDtoPartyEnum? party) => _$this._party = party;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  AdminOrderCorrectionDtoAccountEnum? _account;
  AdminOrderCorrectionDtoAccountEnum? get account => _$this._account;
  set account(AdminOrderCorrectionDtoAccountEnum? account) =>
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

  AdminOrderCorrectionDtoBuilder() {
    AdminOrderCorrectionDto._defaults(this);
  }

  AdminOrderCorrectionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(AdminOrderCorrectionDto other) {
    _$v = other as _$AdminOrderCorrectionDto;
  }

  @override
  void update(void Function(AdminOrderCorrectionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCorrectionDto build() => _build();

  _$AdminOrderCorrectionDto _build() {
    final _$result =
        _$v ??
        _$AdminOrderCorrectionDto._(
          party: BuiltValueNullFieldError.checkNotNull(
            party,
            r'AdminOrderCorrectionDto',
            'party',
          ),
          partyId: BuiltValueNullFieldError.checkNotNull(
            partyId,
            r'AdminOrderCorrectionDto',
            'partyId',
          ),
          account: BuiltValueNullFieldError.checkNotNull(
            account,
            r'AdminOrderCorrectionDto',
            'account',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOrderCorrectionDto',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOrderCorrectionDto',
            'amount',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderCorrectionDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
