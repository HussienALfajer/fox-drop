// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output_parties_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCostReportDtoOutputPartiesInnerPartyEnum
_$adminCostReportDtoOutputPartiesInnerPartyEnum_restaurant =
    const AdminCostReportDtoOutputPartiesInnerPartyEnum._('restaurant');
const AdminCostReportDtoOutputPartiesInnerPartyEnum
_$adminCostReportDtoOutputPartiesInnerPartyEnum_captain =
    const AdminCostReportDtoOutputPartiesInnerPartyEnum._('captain');
const AdminCostReportDtoOutputPartiesInnerPartyEnum
_$adminCostReportDtoOutputPartiesInnerPartyEnum_customer =
    const AdminCostReportDtoOutputPartiesInnerPartyEnum._('customer');
const AdminCostReportDtoOutputPartiesInnerPartyEnum
_$adminCostReportDtoOutputPartiesInnerPartyEnum_platform =
    const AdminCostReportDtoOutputPartiesInnerPartyEnum._('platform');

AdminCostReportDtoOutputPartiesInnerPartyEnum
_$adminCostReportDtoOutputPartiesInnerPartyEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminCostReportDtoOutputPartiesInnerPartyEnum_restaurant;
    case 'captain':
      return _$adminCostReportDtoOutputPartiesInnerPartyEnum_captain;
    case 'customer':
      return _$adminCostReportDtoOutputPartiesInnerPartyEnum_customer;
    case 'platform':
      return _$adminCostReportDtoOutputPartiesInnerPartyEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCostReportDtoOutputPartiesInnerPartyEnum>
_$adminCostReportDtoOutputPartiesInnerPartyEnumValues =
    BuiltSet<AdminCostReportDtoOutputPartiesInnerPartyEnum>(
      const <AdminCostReportDtoOutputPartiesInnerPartyEnum>[
        _$adminCostReportDtoOutputPartiesInnerPartyEnum_restaurant,
        _$adminCostReportDtoOutputPartiesInnerPartyEnum_captain,
        _$adminCostReportDtoOutputPartiesInnerPartyEnum_customer,
        _$adminCostReportDtoOutputPartiesInnerPartyEnum_platform,
      ],
    );

Serializer<AdminCostReportDtoOutputPartiesInnerPartyEnum>
_$adminCostReportDtoOutputPartiesInnerPartyEnumSerializer =
    _$AdminCostReportDtoOutputPartiesInnerPartyEnumSerializer();

class _$AdminCostReportDtoOutputPartiesInnerPartyEnumSerializer
    implements
        PrimitiveSerializer<AdminCostReportDtoOutputPartiesInnerPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCostReportDtoOutputPartiesInnerPartyEnum,
  ];
  @override
  final String wireName = 'AdminCostReportDtoOutputPartiesInnerPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportDtoOutputPartiesInnerPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCostReportDtoOutputPartiesInnerPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCostReportDtoOutputPartiesInnerPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCostReportDtoOutputPartiesInner
    extends AdminCostReportDtoOutputPartiesInner {
  @override
  final AdminCostReportDtoOutputPartiesInnerPartyEnum? party;
  @override
  final int orders;
  @override
  final String amount;

  factory _$AdminCostReportDtoOutputPartiesInner([
    void Function(AdminCostReportDtoOutputPartiesInnerBuilder)? updates,
  ]) =>
      (AdminCostReportDtoOutputPartiesInnerBuilder()..update(updates))._build();

  _$AdminCostReportDtoOutputPartiesInner._({
    this.party,
    required this.orders,
    required this.amount,
  }) : super._();
  @override
  AdminCostReportDtoOutputPartiesInner rebuild(
    void Function(AdminCostReportDtoOutputPartiesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputPartiesInnerBuilder toBuilder() =>
      AdminCostReportDtoOutputPartiesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutputPartiesInner &&
        party == other.party &&
        orders == other.orders &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCostReportDtoOutputPartiesInner')
          ..add('party', party)
          ..add('orders', orders)
          ..add('amount', amount))
        .toString();
  }
}

class AdminCostReportDtoOutputPartiesInnerBuilder
    implements
        Builder<
          AdminCostReportDtoOutputPartiesInner,
          AdminCostReportDtoOutputPartiesInnerBuilder
        > {
  _$AdminCostReportDtoOutputPartiesInner? _$v;

  AdminCostReportDtoOutputPartiesInnerPartyEnum? _party;
  AdminCostReportDtoOutputPartiesInnerPartyEnum? get party => _$this._party;
  set party(AdminCostReportDtoOutputPartiesInnerPartyEnum? party) =>
      _$this._party = party;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminCostReportDtoOutputPartiesInnerBuilder() {
    AdminCostReportDtoOutputPartiesInner._defaults(this);
  }

  AdminCostReportDtoOutputPartiesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _party = $v.party;
      _orders = $v.orders;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutputPartiesInner other) {
    _$v = other as _$AdminCostReportDtoOutputPartiesInner;
  }

  @override
  void update(
    void Function(AdminCostReportDtoOutputPartiesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutputPartiesInner build() => _build();

  _$AdminCostReportDtoOutputPartiesInner _build() {
    final _$result =
        _$v ??
        _$AdminCostReportDtoOutputPartiesInner._(
          party: party,
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminCostReportDtoOutputPartiesInner',
            'orders',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCostReportDtoOutputPartiesInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
