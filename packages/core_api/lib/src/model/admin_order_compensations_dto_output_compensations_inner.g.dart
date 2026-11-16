// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_compensations_dto_output_compensations_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_fixedAmount =
    const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum._(
      'fixedAmount',
    );
const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_percentage =
    const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum._(
      'percentage',
    );

AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'fixedAmount':
      return _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_fixedAmount;
    case 'percentage':
      return _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum>
_$adminOrderCompensationsDtoOutputCompensationsInnerKindEnumValues =
    BuiltSet<AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum>(const <
      AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
    >[
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_fixedAmount,
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_percentage,
    ]);

const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_issued =
    const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum._(
      'issued',
    );
const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_waiting =
    const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum._(
      'waiting',
    );
const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_rejected =
    const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum._(
      'rejected',
    );

AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
_$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'issued':
      return _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_issued;
    case 'waiting':
      return _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_waiting;
    case 'rejected':
      return _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum>
_$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnumValues =
    BuiltSet<AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum>(
      const <AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum>[
        _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_issued,
        _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_waiting,
        _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_rejected,
      ],
    );

Serializer<AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum>
_$adminOrderCompensationsDtoOutputCompensationsInnerKindEnumSerializer =
    _$AdminOrderCompensationsDtoOutputCompensationsInnerKindEnumSerializer();
Serializer<AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum>
_$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnumSerializer =
    _$AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnumSerializer();

class _$AdminOrderCompensationsDtoOutputCompensationsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fixedAmount': 'fixed_amount',
    'percentage': 'percentage',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fixed_amount': 'fixedAmount',
    'percentage': 'percentage',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum,
  ];
  @override
  final String wireName =
      'AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'issued': 'issued',
    'waiting': 'waiting',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'issued': 'issued',
    'waiting': 'waiting',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCompensationsDtoOutputCompensationsInner
    extends AdminOrderCompensationsDtoOutputCompensationsInner {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum kind;
  @override
  final String? amount;
  @override
  final int? percentBp;
  @override
  final String? maxDiscount;
  @override
  final String currency;
  @override
  final AdminOrderDtoOutputOrderCancelChoicesReasonsInner reason;
  @override
  final String? note;
  @override
  final AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum status;
  @override
  final String? requestedBy;
  @override
  final DateTime requestedAt;
  @override
  final String? decidedBy;
  @override
  final DateTime? decidedAt;
  @override
  final String? code;
  @override
  final DateTime? codeValidTo;

  factory _$AdminOrderCompensationsDtoOutputCompensationsInner([
    void Function(AdminOrderCompensationsDtoOutputCompensationsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderCompensationsDtoOutputCompensationsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderCompensationsDtoOutputCompensationsInner._({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.kind,
    this.amount,
    this.percentBp,
    this.maxDiscount,
    required this.currency,
    required this.reason,
    this.note,
    required this.status,
    this.requestedBy,
    required this.requestedAt,
    this.decidedBy,
    this.decidedAt,
    this.code,
    this.codeValidTo,
  }) : super._();
  @override
  AdminOrderCompensationsDtoOutputCompensationsInner rebuild(
    void Function(AdminOrderCompensationsDtoOutputCompensationsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCompensationsDtoOutputCompensationsInnerBuilder toBuilder() =>
      AdminOrderCompensationsDtoOutputCompensationsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCompensationsDtoOutputCompensationsInner &&
        id == other.id &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        kind == other.kind &&
        amount == other.amount &&
        percentBp == other.percentBp &&
        maxDiscount == other.maxDiscount &&
        currency == other.currency &&
        reason == other.reason &&
        note == other.note &&
        status == other.status &&
        requestedBy == other.requestedBy &&
        requestedAt == other.requestedAt &&
        decidedBy == other.decidedBy &&
        decidedAt == other.decidedAt &&
        code == other.code &&
        codeValidTo == other.codeValidTo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, percentBp.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, requestedBy.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, decidedBy.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, codeValidTo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderCompensationsDtoOutputCompensationsInner',
          )
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('percentBp', percentBp)
          ..add('maxDiscount', maxDiscount)
          ..add('currency', currency)
          ..add('reason', reason)
          ..add('note', note)
          ..add('status', status)
          ..add('requestedBy', requestedBy)
          ..add('requestedAt', requestedAt)
          ..add('decidedBy', decidedBy)
          ..add('decidedAt', decidedAt)
          ..add('code', code)
          ..add('codeValidTo', codeValidTo))
        .toString();
  }
}

class AdminOrderCompensationsDtoOutputCompensationsInnerBuilder
    implements
        Builder<
          AdminOrderCompensationsDtoOutputCompensationsInner,
          AdminOrderCompensationsDtoOutputCompensationsInnerBuilder
        > {
  _$AdminOrderCompensationsDtoOutputCompensationsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum? _kind;
  AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder? _reason;
  AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder get reason =>
      _$this._reason ??=
          AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder();
  set reason(
    AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder? reason,
  ) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum? _status;
  AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum? get status =>
      _$this._status;
  set status(
    AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum? status,
  ) => _$this._status = status;

  String? _requestedBy;
  String? get requestedBy => _$this._requestedBy;
  set requestedBy(String? requestedBy) => _$this._requestedBy = requestedBy;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  String? _decidedBy;
  String? get decidedBy => _$this._decidedBy;
  set decidedBy(String? decidedBy) => _$this._decidedBy = decidedBy;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  DateTime? _codeValidTo;
  DateTime? get codeValidTo => _$this._codeValidTo;
  set codeValidTo(DateTime? codeValidTo) => _$this._codeValidTo = codeValidTo;

  AdminOrderCompensationsDtoOutputCompensationsInnerBuilder() {
    AdminOrderCompensationsDtoOutputCompensationsInner._defaults(this);
  }

  AdminOrderCompensationsDtoOutputCompensationsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _kind = $v.kind;
      _amount = $v.amount;
      _percentBp = $v.percentBp;
      _maxDiscount = $v.maxDiscount;
      _currency = $v.currency;
      _reason = $v.reason.toBuilder();
      _note = $v.note;
      _status = $v.status;
      _requestedBy = $v.requestedBy;
      _requestedAt = $v.requestedAt;
      _decidedBy = $v.decidedBy;
      _decidedAt = $v.decidedAt;
      _code = $v.code;
      _codeValidTo = $v.codeValidTo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCompensationsDtoOutputCompensationsInner other) {
    _$v = other as _$AdminOrderCompensationsDtoOutputCompensationsInner;
  }

  @override
  void update(
    void Function(AdminOrderCompensationsDtoOutputCompensationsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCompensationsDtoOutputCompensationsInner build() => _build();

  _$AdminOrderCompensationsDtoOutputCompensationsInner _build() {
    _$AdminOrderCompensationsDtoOutputCompensationsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderCompensationsDtoOutputCompensationsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'id',
            ),
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'orderId',
            ),
            orderNumber: BuiltValueNullFieldError.checkNotNull(
              orderNumber,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'orderNumber',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'kind',
            ),
            amount: amount,
            percentBp: percentBp,
            maxDiscount: maxDiscount,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'currency',
            ),
            reason: reason.build(),
            note: note,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'status',
            ),
            requestedBy: requestedBy,
            requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt,
              r'AdminOrderCompensationsDtoOutputCompensationsInner',
              'requestedAt',
            ),
            decidedBy: decidedBy,
            decidedAt: decidedAt,
            code: code,
            codeValidTo: codeValidTo,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reason';
        reason.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderCompensationsDtoOutputCompensationsInner',
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
