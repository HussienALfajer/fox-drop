// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_cancellation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderCancellationResponsibleEnum
_$adminOrderDtoOutputOrderCancellationResponsibleEnum_restaurant =
    const AdminOrderDtoOutputOrderCancellationResponsibleEnum._('restaurant');
const AdminOrderDtoOutputOrderCancellationResponsibleEnum
_$adminOrderDtoOutputOrderCancellationResponsibleEnum_captain =
    const AdminOrderDtoOutputOrderCancellationResponsibleEnum._('captain');
const AdminOrderDtoOutputOrderCancellationResponsibleEnum
_$adminOrderDtoOutputOrderCancellationResponsibleEnum_customer =
    const AdminOrderDtoOutputOrderCancellationResponsibleEnum._('customer');
const AdminOrderDtoOutputOrderCancellationResponsibleEnum
_$adminOrderDtoOutputOrderCancellationResponsibleEnum_platform =
    const AdminOrderDtoOutputOrderCancellationResponsibleEnum._('platform');

AdminOrderDtoOutputOrderCancellationResponsibleEnum
_$adminOrderDtoOutputOrderCancellationResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminOrderDtoOutputOrderCancellationResponsibleEnum_restaurant;
    case 'captain':
      return _$adminOrderDtoOutputOrderCancellationResponsibleEnum_captain;
    case 'customer':
      return _$adminOrderDtoOutputOrderCancellationResponsibleEnum_customer;
    case 'platform':
      return _$adminOrderDtoOutputOrderCancellationResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderCancellationResponsibleEnum>
_$adminOrderDtoOutputOrderCancellationResponsibleEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderCancellationResponsibleEnum>(
      const <AdminOrderDtoOutputOrderCancellationResponsibleEnum>[
        _$adminOrderDtoOutputOrderCancellationResponsibleEnum_restaurant,
        _$adminOrderDtoOutputOrderCancellationResponsibleEnum_captain,
        _$adminOrderDtoOutputOrderCancellationResponsibleEnum_customer,
        _$adminOrderDtoOutputOrderCancellationResponsibleEnum_platform,
      ],
    );

const AdminOrderDtoOutputOrderCancellationCashEnum
_$adminOrderDtoOutputOrderCancellationCashEnum_returned =
    const AdminOrderDtoOutputOrderCancellationCashEnum._('returned');
const AdminOrderDtoOutputOrderCancellationCashEnum
_$adminOrderDtoOutputOrderCancellationCashEnum_notReturned =
    const AdminOrderDtoOutputOrderCancellationCashEnum._('notReturned');
const AdminOrderDtoOutputOrderCancellationCashEnum
_$adminOrderDtoOutputOrderCancellationCashEnum_notPaid =
    const AdminOrderDtoOutputOrderCancellationCashEnum._('notPaid');

AdminOrderDtoOutputOrderCancellationCashEnum
_$adminOrderDtoOutputOrderCancellationCashEnumValueOf(String name) {
  switch (name) {
    case 'returned':
      return _$adminOrderDtoOutputOrderCancellationCashEnum_returned;
    case 'notReturned':
      return _$adminOrderDtoOutputOrderCancellationCashEnum_notReturned;
    case 'notPaid':
      return _$adminOrderDtoOutputOrderCancellationCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderCancellationCashEnum>
_$adminOrderDtoOutputOrderCancellationCashEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderCancellationCashEnum>(
      const <AdminOrderDtoOutputOrderCancellationCashEnum>[
        _$adminOrderDtoOutputOrderCancellationCashEnum_returned,
        _$adminOrderDtoOutputOrderCancellationCashEnum_notReturned,
        _$adminOrderDtoOutputOrderCancellationCashEnum_notPaid,
      ],
    );

Serializer<AdminOrderDtoOutputOrderCancellationResponsibleEnum>
_$adminOrderDtoOutputOrderCancellationResponsibleEnumSerializer =
    _$AdminOrderDtoOutputOrderCancellationResponsibleEnumSerializer();
Serializer<AdminOrderDtoOutputOrderCancellationCashEnum>
_$adminOrderDtoOutputOrderCancellationCashEnumSerializer =
    _$AdminOrderDtoOutputOrderCancellationCashEnumSerializer();

class _$AdminOrderDtoOutputOrderCancellationResponsibleEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderCancellationResponsibleEnum
        > {
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
    AdminOrderDtoOutputOrderCancellationResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderCancellationResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancellationResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderCancellationResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderCancellationResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderCancellationCashEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderCancellationCashEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'returned': 'returned',
    'notReturned': 'not_returned',
    'notPaid': 'not_paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'returned': 'returned',
    'not_returned': 'notReturned',
    'not_paid': 'notPaid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderCancellationCashEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderCancellationCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancellationCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderCancellationCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderCancellationCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderCancellation
    extends AdminOrderDtoOutputOrderCancellation {
  @override
  final DateTime at;
  @override
  final String reason;
  @override
  final String? label;
  @override
  final String? note;
  @override
  final String? customerText;
  @override
  final AdminOrderDtoOutputOrderCancellationBy by;
  @override
  final AdminOrderDtoOutputOrderCancellationResponsibleEnum? responsible;
  @override
  final bool foodPrepared;
  @override
  final AdminOrderDtoOutputOrderCancellationCashEnum? cash;
  @override
  final CaptainWentOfflineDtoOutputHandIn? merchantCredit;
  @override
  final CaptainWentOfflineDtoOutputHandIn? captainCompensation;
  @override
  final DateTime? acknowledgedAt;
  @override
  final DateTime? captainSeenAt;

  factory _$AdminOrderDtoOutputOrderCancellation([
    void Function(AdminOrderDtoOutputOrderCancellationBuilder)? updates,
  ]) =>
      (AdminOrderDtoOutputOrderCancellationBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderCancellation._({
    required this.at,
    required this.reason,
    this.label,
    this.note,
    this.customerText,
    required this.by,
    this.responsible,
    required this.foodPrepared,
    this.cash,
    this.merchantCredit,
    this.captainCompensation,
    this.acknowledgedAt,
    this.captainSeenAt,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCancellation rebuild(
    void Function(AdminOrderDtoOutputOrderCancellationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCancellationBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCancellationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCancellation &&
        at == other.at &&
        reason == other.reason &&
        label == other.label &&
        note == other.note &&
        customerText == other.customerText &&
        by == other.by &&
        responsible == other.responsible &&
        foodPrepared == other.foodPrepared &&
        cash == other.cash &&
        merchantCredit == other.merchantCredit &&
        captainCompensation == other.captainCompensation &&
        acknowledgedAt == other.acknowledgedAt &&
        captainSeenAt == other.captainSeenAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, by.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, foodPrepared.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, merchantCredit.hashCode);
    _$hash = $jc(_$hash, captainCompensation.hashCode);
    _$hash = $jc(_$hash, acknowledgedAt.hashCode);
    _$hash = $jc(_$hash, captainSeenAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderCancellation')
          ..add('at', at)
          ..add('reason', reason)
          ..add('label', label)
          ..add('note', note)
          ..add('customerText', customerText)
          ..add('by', by)
          ..add('responsible', responsible)
          ..add('foodPrepared', foodPrepared)
          ..add('cash', cash)
          ..add('merchantCredit', merchantCredit)
          ..add('captainCompensation', captainCompensation)
          ..add('acknowledgedAt', acknowledgedAt)
          ..add('captainSeenAt', captainSeenAt))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCancellationBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCancellation,
          AdminOrderDtoOutputOrderCancellationBuilder
        > {
  _$AdminOrderDtoOutputOrderCancellation? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  AdminOrderDtoOutputOrderCancellationByBuilder? _by;
  AdminOrderDtoOutputOrderCancellationByBuilder get by =>
      _$this._by ??= AdminOrderDtoOutputOrderCancellationByBuilder();
  set by(AdminOrderDtoOutputOrderCancellationByBuilder? by) => _$this._by = by;

  AdminOrderDtoOutputOrderCancellationResponsibleEnum? _responsible;
  AdminOrderDtoOutputOrderCancellationResponsibleEnum? get responsible =>
      _$this._responsible;
  set responsible(
    AdminOrderDtoOutputOrderCancellationResponsibleEnum? responsible,
  ) => _$this._responsible = responsible;

  bool? _foodPrepared;
  bool? get foodPrepared => _$this._foodPrepared;
  set foodPrepared(bool? foodPrepared) => _$this._foodPrepared = foodPrepared;

  AdminOrderDtoOutputOrderCancellationCashEnum? _cash;
  AdminOrderDtoOutputOrderCancellationCashEnum? get cash => _$this._cash;
  set cash(AdminOrderDtoOutputOrderCancellationCashEnum? cash) =>
      _$this._cash = cash;

  CaptainWentOfflineDtoOutputHandInBuilder? _merchantCredit;
  CaptainWentOfflineDtoOutputHandInBuilder get merchantCredit =>
      _$this._merchantCredit ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set merchantCredit(
    CaptainWentOfflineDtoOutputHandInBuilder? merchantCredit,
  ) => _$this._merchantCredit = merchantCredit;

  CaptainWentOfflineDtoOutputHandInBuilder? _captainCompensation;
  CaptainWentOfflineDtoOutputHandInBuilder get captainCompensation =>
      _$this._captainCompensation ??=
          CaptainWentOfflineDtoOutputHandInBuilder();
  set captainCompensation(
    CaptainWentOfflineDtoOutputHandInBuilder? captainCompensation,
  ) => _$this._captainCompensation = captainCompensation;

  DateTime? _acknowledgedAt;
  DateTime? get acknowledgedAt => _$this._acknowledgedAt;
  set acknowledgedAt(DateTime? acknowledgedAt) =>
      _$this._acknowledgedAt = acknowledgedAt;

  DateTime? _captainSeenAt;
  DateTime? get captainSeenAt => _$this._captainSeenAt;
  set captainSeenAt(DateTime? captainSeenAt) =>
      _$this._captainSeenAt = captainSeenAt;

  AdminOrderDtoOutputOrderCancellationBuilder() {
    AdminOrderDtoOutputOrderCancellation._defaults(this);
  }

  AdminOrderDtoOutputOrderCancellationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _reason = $v.reason;
      _label = $v.label;
      _note = $v.note;
      _customerText = $v.customerText;
      _by = $v.by.toBuilder();
      _responsible = $v.responsible;
      _foodPrepared = $v.foodPrepared;
      _cash = $v.cash;
      _merchantCredit = $v.merchantCredit?.toBuilder();
      _captainCompensation = $v.captainCompensation?.toBuilder();
      _acknowledgedAt = $v.acknowledgedAt;
      _captainSeenAt = $v.captainSeenAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCancellation other) {
    _$v = other as _$AdminOrderDtoOutputOrderCancellation;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCancellationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCancellation build() => _build();

  _$AdminOrderDtoOutputOrderCancellation _build() {
    _$AdminOrderDtoOutputOrderCancellation _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderCancellation._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderCancellation',
              'at',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminOrderDtoOutputOrderCancellation',
              'reason',
            ),
            label: label,
            note: note,
            customerText: customerText,
            by: by.build(),
            responsible: responsible,
            foodPrepared: BuiltValueNullFieldError.checkNotNull(
              foodPrepared,
              r'AdminOrderDtoOutputOrderCancellation',
              'foodPrepared',
            ),
            cash: cash,
            merchantCredit: _merchantCredit?.build(),
            captainCompensation: _captainCompensation?.build(),
            acknowledgedAt: acknowledgedAt,
            captainSeenAt: captainSeenAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'by';
        by.build();

        _$failedField = 'merchantCredit';
        _merchantCredit?.build();
        _$failedField = 'captainCompensation';
        _captainCompensation?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderCancellation',
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
