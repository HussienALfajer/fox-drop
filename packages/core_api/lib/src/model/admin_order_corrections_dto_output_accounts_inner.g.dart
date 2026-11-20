// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_corrections_dto_output_accounts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_captain =
    const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum._('captain');
const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_restaurant =
    const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum._(
      'restaurant',
    );
const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_customer =
    const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum._(
      'customer',
    );

AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_captain;
    case 'restaurant':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_restaurant;
    case 'customer':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum>
_$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumValues =
    BuiltSet<AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum>(
      const <AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum>[
        _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_captain,
        _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_restaurant,
        _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_customer,
      ],
    );

const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodCustody =
    const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum._(
      'captainPeriodCustody',
    );
const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodEarnings =
    const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum._(
      'captainPeriodEarnings',
    );
const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_merchantPeriodAccount =
    const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum._(
      'merchantPeriodAccount',
    );
const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_customerPeriodDues =
    const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum._(
      'customerPeriodDues',
    );

AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnumValueOf(String name) {
  switch (name) {
    case 'captainPeriodCustody':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodCustody;
    case 'captainPeriodEarnings':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodEarnings;
    case 'merchantPeriodAccount':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_merchantPeriodAccount;
    case 'customerPeriodDues':
      return _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_customerPeriodDues;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum>
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnumValues =
    BuiltSet<AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum>(const <
      AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
    >[
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodCustody,
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodEarnings,
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_merchantPeriodAccount,
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_customerPeriodDues,
    ]);

Serializer<AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum>
_$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumSerializer =
    _$AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumSerializer();
Serializer<AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum>
_$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnumSerializer =
    _$AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnumSerializer();

class _$AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
        > {
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
  final Iterable<Type> types = const <Type>[
    AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum,
  ];
  @override
  final String wireName =
      'AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
        > {
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
    AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum,
  ];
  @override
  final String wireName =
      'AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCorrectionsDtoOutputAccountsInner
    extends AdminOrderCorrectionsDtoOutputAccountsInner {
  @override
  final AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum partyKind;
  @override
  final String partyId;
  @override
  final String partyName;
  @override
  final AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum account;
  @override
  final BuiltList<String> currencies;

  factory _$AdminOrderCorrectionsDtoOutputAccountsInner([
    void Function(AdminOrderCorrectionsDtoOutputAccountsInnerBuilder)? updates,
  ]) => (AdminOrderCorrectionsDtoOutputAccountsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderCorrectionsDtoOutputAccountsInner._({
    required this.partyKind,
    required this.partyId,
    required this.partyName,
    required this.account,
    required this.currencies,
  }) : super._();
  @override
  AdminOrderCorrectionsDtoOutputAccountsInner rebuild(
    void Function(AdminOrderCorrectionsDtoOutputAccountsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCorrectionsDtoOutputAccountsInnerBuilder toBuilder() =>
      AdminOrderCorrectionsDtoOutputAccountsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCorrectionsDtoOutputAccountsInner &&
        partyKind == other.partyKind &&
        partyId == other.partyId &&
        partyName == other.partyName &&
        account == other.account &&
        currencies == other.currencies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, partyKind.hashCode);
    _$hash = $jc(_$hash, partyId.hashCode);
    _$hash = $jc(_$hash, partyName.hashCode);
    _$hash = $jc(_$hash, account.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderCorrectionsDtoOutputAccountsInner',
          )
          ..add('partyKind', partyKind)
          ..add('partyId', partyId)
          ..add('partyName', partyName)
          ..add('account', account)
          ..add('currencies', currencies))
        .toString();
  }
}

class AdminOrderCorrectionsDtoOutputAccountsInnerBuilder
    implements
        Builder<
          AdminOrderCorrectionsDtoOutputAccountsInner,
          AdminOrderCorrectionsDtoOutputAccountsInnerBuilder
        > {
  _$AdminOrderCorrectionsDtoOutputAccountsInner? _$v;

  AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum? _partyKind;
  AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum? get partyKind =>
      _$this._partyKind;
  set partyKind(
    AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum? partyKind,
  ) => _$this._partyKind = partyKind;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  String? _partyName;
  String? get partyName => _$this._partyName;
  set partyName(String? partyName) => _$this._partyName = partyName;

  AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum? _account;
  AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum? get account =>
      _$this._account;
  set account(
    AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum? account,
  ) => _$this._account = account;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  AdminOrderCorrectionsDtoOutputAccountsInnerBuilder() {
    AdminOrderCorrectionsDtoOutputAccountsInner._defaults(this);
  }

  AdminOrderCorrectionsDtoOutputAccountsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _partyKind = $v.partyKind;
      _partyId = $v.partyId;
      _partyName = $v.partyName;
      _account = $v.account;
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCorrectionsDtoOutputAccountsInner other) {
    _$v = other as _$AdminOrderCorrectionsDtoOutputAccountsInner;
  }

  @override
  void update(
    void Function(AdminOrderCorrectionsDtoOutputAccountsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCorrectionsDtoOutputAccountsInner build() => _build();

  _$AdminOrderCorrectionsDtoOutputAccountsInner _build() {
    _$AdminOrderCorrectionsDtoOutputAccountsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderCorrectionsDtoOutputAccountsInner._(
            partyKind: BuiltValueNullFieldError.checkNotNull(
              partyKind,
              r'AdminOrderCorrectionsDtoOutputAccountsInner',
              'partyKind',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminOrderCorrectionsDtoOutputAccountsInner',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminOrderCorrectionsDtoOutputAccountsInner',
              'partyName',
            ),
            account: BuiltValueNullFieldError.checkNotNull(
              account,
              r'AdminOrderCorrectionsDtoOutputAccountsInner',
              'account',
            ),
            currencies: currencies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderCorrectionsDtoOutputAccountsInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
