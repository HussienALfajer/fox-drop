// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output_compensation_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_reason =
    const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum._('reason');
const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_lateDelivery =
    const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum._(
      'lateDelivery',
    );
const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredRestaurant =
    const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum._(
      'recoveredRestaurant',
    );
const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredCaptain =
    const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum._(
      'recoveredCaptain',
    );
const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_other =
    const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum._('other');

AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'reason':
      return _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_reason;
    case 'lateDelivery':
      return _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_lateDelivery;
    case 'recoveredRestaurant':
      return _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredRestaurant;
    case 'recoveredCaptain':
      return _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredCaptain;
    case 'other':
      return _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCostReportDtoOutputCompensationReasonsInnerKindEnum>
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnumValues =
    BuiltSet<AdminCostReportDtoOutputCompensationReasonsInnerKindEnum>(const <
      AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
    >[
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_reason,
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_lateDelivery,
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredRestaurant,
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredCaptain,
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_other,
    ]);

Serializer<AdminCostReportDtoOutputCompensationReasonsInnerKindEnum>
_$adminCostReportDtoOutputCompensationReasonsInnerKindEnumSerializer =
    _$AdminCostReportDtoOutputCompensationReasonsInnerKindEnumSerializer();

class _$AdminCostReportDtoOutputCompensationReasonsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'reason': 'reason',
    'lateDelivery': 'late_delivery',
    'recoveredRestaurant': 'recovered_restaurant',
    'recoveredCaptain': 'recovered_captain',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'reason': 'reason',
    'late_delivery': 'lateDelivery',
    'recovered_restaurant': 'recoveredRestaurant',
    'recovered_captain': 'recoveredCaptain',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCostReportDtoOutputCompensationReasonsInnerKindEnum,
  ];
  @override
  final String wireName =
      'AdminCostReportDtoOutputCompensationReasonsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportDtoOutputCompensationReasonsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCostReportDtoOutputCompensationReasonsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCostReportDtoOutputCompensationReasonsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCostReportDtoOutputCompensationReasonsInner
    extends AdminCostReportDtoOutputCompensationReasonsInner {
  @override
  final AdminCostReportDtoOutputCompensationReasonsInnerKindEnum kind;
  @override
  final String? reason;
  @override
  final String? label;
  @override
  final int orders;
  @override
  final String amount;

  factory _$AdminCostReportDtoOutputCompensationReasonsInner([
    void Function(AdminCostReportDtoOutputCompensationReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminCostReportDtoOutputCompensationReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCostReportDtoOutputCompensationReasonsInner._({
    required this.kind,
    this.reason,
    this.label,
    required this.orders,
    required this.amount,
  }) : super._();
  @override
  AdminCostReportDtoOutputCompensationReasonsInner rebuild(
    void Function(AdminCostReportDtoOutputCompensationReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputCompensationReasonsInnerBuilder toBuilder() =>
      AdminCostReportDtoOutputCompensationReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutputCompensationReasonsInner &&
        kind == other.kind &&
        reason == other.reason &&
        label == other.label &&
        orders == other.orders &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCostReportDtoOutputCompensationReasonsInner',
          )
          ..add('kind', kind)
          ..add('reason', reason)
          ..add('label', label)
          ..add('orders', orders)
          ..add('amount', amount))
        .toString();
  }
}

class AdminCostReportDtoOutputCompensationReasonsInnerBuilder
    implements
        Builder<
          AdminCostReportDtoOutputCompensationReasonsInner,
          AdminCostReportDtoOutputCompensationReasonsInnerBuilder
        > {
  _$AdminCostReportDtoOutputCompensationReasonsInner? _$v;

  AdminCostReportDtoOutputCompensationReasonsInnerKindEnum? _kind;
  AdminCostReportDtoOutputCompensationReasonsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(AdminCostReportDtoOutputCompensationReasonsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminCostReportDtoOutputCompensationReasonsInnerBuilder() {
    AdminCostReportDtoOutputCompensationReasonsInner._defaults(this);
  }

  AdminCostReportDtoOutputCompensationReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _reason = $v.reason;
      _label = $v.label;
      _orders = $v.orders;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutputCompensationReasonsInner other) {
    _$v = other as _$AdminCostReportDtoOutputCompensationReasonsInner;
  }

  @override
  void update(
    void Function(AdminCostReportDtoOutputCompensationReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutputCompensationReasonsInner build() => _build();

  _$AdminCostReportDtoOutputCompensationReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminCostReportDtoOutputCompensationReasonsInner._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCostReportDtoOutputCompensationReasonsInner',
            'kind',
          ),
          reason: reason,
          label: label,
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminCostReportDtoOutputCompensationReasonsInner',
            'orders',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCostReportDtoOutputCompensationReasonsInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
