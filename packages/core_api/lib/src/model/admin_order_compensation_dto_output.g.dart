// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_compensation_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderCompensationDtoOutputKindEnum
_$adminOrderCompensationDtoOutputKindEnum_fixedAmount =
    const AdminOrderCompensationDtoOutputKindEnum._('fixedAmount');
const AdminOrderCompensationDtoOutputKindEnum
_$adminOrderCompensationDtoOutputKindEnum_percentage =
    const AdminOrderCompensationDtoOutputKindEnum._('percentage');

AdminOrderCompensationDtoOutputKindEnum
_$adminOrderCompensationDtoOutputKindEnumValueOf(String name) {
  switch (name) {
    case 'fixedAmount':
      return _$adminOrderCompensationDtoOutputKindEnum_fixedAmount;
    case 'percentage':
      return _$adminOrderCompensationDtoOutputKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCompensationDtoOutputKindEnum>
_$adminOrderCompensationDtoOutputKindEnumValues =
    BuiltSet<AdminOrderCompensationDtoOutputKindEnum>(
      const <AdminOrderCompensationDtoOutputKindEnum>[
        _$adminOrderCompensationDtoOutputKindEnum_fixedAmount,
        _$adminOrderCompensationDtoOutputKindEnum_percentage,
      ],
    );

const AdminOrderCompensationDtoOutputStatusEnum
_$adminOrderCompensationDtoOutputStatusEnum_issued =
    const AdminOrderCompensationDtoOutputStatusEnum._('issued');
const AdminOrderCompensationDtoOutputStatusEnum
_$adminOrderCompensationDtoOutputStatusEnum_waiting =
    const AdminOrderCompensationDtoOutputStatusEnum._('waiting');
const AdminOrderCompensationDtoOutputStatusEnum
_$adminOrderCompensationDtoOutputStatusEnum_rejected =
    const AdminOrderCompensationDtoOutputStatusEnum._('rejected');

AdminOrderCompensationDtoOutputStatusEnum
_$adminOrderCompensationDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'issued':
      return _$adminOrderCompensationDtoOutputStatusEnum_issued;
    case 'waiting':
      return _$adminOrderCompensationDtoOutputStatusEnum_waiting;
    case 'rejected':
      return _$adminOrderCompensationDtoOutputStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCompensationDtoOutputStatusEnum>
_$adminOrderCompensationDtoOutputStatusEnumValues =
    BuiltSet<AdminOrderCompensationDtoOutputStatusEnum>(
      const <AdminOrderCompensationDtoOutputStatusEnum>[
        _$adminOrderCompensationDtoOutputStatusEnum_issued,
        _$adminOrderCompensationDtoOutputStatusEnum_waiting,
        _$adminOrderCompensationDtoOutputStatusEnum_rejected,
      ],
    );

Serializer<AdminOrderCompensationDtoOutputKindEnum>
_$adminOrderCompensationDtoOutputKindEnumSerializer =
    _$AdminOrderCompensationDtoOutputKindEnumSerializer();
Serializer<AdminOrderCompensationDtoOutputStatusEnum>
_$adminOrderCompensationDtoOutputStatusEnumSerializer =
    _$AdminOrderCompensationDtoOutputStatusEnumSerializer();

class _$AdminOrderCompensationDtoOutputKindEnumSerializer
    implements PrimitiveSerializer<AdminOrderCompensationDtoOutputKindEnum> {
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
    AdminOrderCompensationDtoOutputKindEnum,
  ];
  @override
  final String wireName = 'AdminOrderCompensationDtoOutputKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCompensationDtoOutputKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCompensationDtoOutputKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCompensationDtoOutputKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCompensationDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminOrderCompensationDtoOutputStatusEnum> {
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
    AdminOrderCompensationDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminOrderCompensationDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCompensationDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCompensationDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCompensationDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCompensationDtoOutput
    extends AdminOrderCompensationDtoOutput {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final AdminOrderCompensationDtoOutputKindEnum kind;
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
  final AdminOrderCompensationDtoOutputStatusEnum status;
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

  factory _$AdminOrderCompensationDtoOutput([
    void Function(AdminOrderCompensationDtoOutputBuilder)? updates,
  ]) => (AdminOrderCompensationDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderCompensationDtoOutput._({
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
  AdminOrderCompensationDtoOutput rebuild(
    void Function(AdminOrderCompensationDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCompensationDtoOutputBuilder toBuilder() =>
      AdminOrderCompensationDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCompensationDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderCompensationDtoOutput')
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

class AdminOrderCompensationDtoOutputBuilder
    implements
        Builder<
          AdminOrderCompensationDtoOutput,
          AdminOrderCompensationDtoOutputBuilder
        > {
  _$AdminOrderCompensationDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  AdminOrderCompensationDtoOutputKindEnum? _kind;
  AdminOrderCompensationDtoOutputKindEnum? get kind => _$this._kind;
  set kind(AdminOrderCompensationDtoOutputKindEnum? kind) =>
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

  AdminOrderCompensationDtoOutputStatusEnum? _status;
  AdminOrderCompensationDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminOrderCompensationDtoOutputStatusEnum? status) =>
      _$this._status = status;

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

  AdminOrderCompensationDtoOutputBuilder() {
    AdminOrderCompensationDtoOutput._defaults(this);
  }

  AdminOrderCompensationDtoOutputBuilder get _$this {
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
  void replace(AdminOrderCompensationDtoOutput other) {
    _$v = other as _$AdminOrderCompensationDtoOutput;
  }

  @override
  void update(void Function(AdminOrderCompensationDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCompensationDtoOutput build() => _build();

  _$AdminOrderCompensationDtoOutput _build() {
    _$AdminOrderCompensationDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderCompensationDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderCompensationDtoOutput',
              'id',
            ),
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminOrderCompensationDtoOutput',
              'orderId',
            ),
            orderNumber: BuiltValueNullFieldError.checkNotNull(
              orderNumber,
              r'AdminOrderCompensationDtoOutput',
              'orderNumber',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminOrderCompensationDtoOutput',
              'kind',
            ),
            amount: amount,
            percentBp: percentBp,
            maxDiscount: maxDiscount,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminOrderCompensationDtoOutput',
              'currency',
            ),
            reason: reason.build(),
            note: note,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderCompensationDtoOutput',
              'status',
            ),
            requestedBy: requestedBy,
            requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt,
              r'AdminOrderCompensationDtoOutput',
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
          r'AdminOrderCompensationDtoOutput',
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
