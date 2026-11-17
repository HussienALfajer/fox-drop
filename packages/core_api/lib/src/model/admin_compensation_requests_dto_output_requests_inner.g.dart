// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_compensation_requests_dto_output_requests_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
_$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_fixedAmount =
    const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum._(
      'fixedAmount',
    );
const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
_$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_percentage =
    const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum._(
      'percentage',
    );

AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
_$adminCompensationRequestsDtoOutputRequestsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'fixedAmount':
      return _$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_fixedAmount;
    case 'percentage':
      return _$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCompensationRequestsDtoOutputRequestsInnerKindEnum>
_$adminCompensationRequestsDtoOutputRequestsInnerKindEnumValues =
    BuiltSet<AdminCompensationRequestsDtoOutputRequestsInnerKindEnum>(
      const <AdminCompensationRequestsDtoOutputRequestsInnerKindEnum>[
        _$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_fixedAmount,
        _$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_percentage,
      ],
    );

const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
_$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_issued =
    const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum._('issued');
const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
_$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_waiting =
    const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum._(
      'waiting',
    );
const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
_$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_rejected =
    const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum._(
      'rejected',
    );

AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
_$adminCompensationRequestsDtoOutputRequestsInnerStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'issued':
      return _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_issued;
    case 'waiting':
      return _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_waiting;
    case 'rejected':
      return _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum>
_$adminCompensationRequestsDtoOutputRequestsInnerStatusEnumValues =
    BuiltSet<AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum>(
      const <AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum>[
        _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_issued,
        _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_waiting,
        _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_rejected,
      ],
    );

Serializer<AdminCompensationRequestsDtoOutputRequestsInnerKindEnum>
_$adminCompensationRequestsDtoOutputRequestsInnerKindEnumSerializer =
    _$AdminCompensationRequestsDtoOutputRequestsInnerKindEnumSerializer();
Serializer<AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum>
_$adminCompensationRequestsDtoOutputRequestsInnerStatusEnumSerializer =
    _$AdminCompensationRequestsDtoOutputRequestsInnerStatusEnumSerializer();

class _$AdminCompensationRequestsDtoOutputRequestsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
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
    AdminCompensationRequestsDtoOutputRequestsInnerKindEnum,
  ];
  @override
  final String wireName =
      'AdminCompensationRequestsDtoOutputRequestsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensationRequestsDtoOutputRequestsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCompensationRequestsDtoOutputRequestsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCompensationRequestsDtoOutputRequestsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCompensationRequestsDtoOutputRequestsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
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
    AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCompensationRequestsDtoOutputRequestsInner
    extends AdminCompensationRequestsDtoOutputRequestsInner {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final AdminCompensationRequestsDtoOutputRequestsInnerKindEnum kind;
  @override
  final String? amount;
  @override
  final int? percentBp;
  @override
  final String? maxDiscount;
  @override
  final String currency;
  @override
  final AdminCustomerDtoOutputBlockReasonsInner reason;
  @override
  final String? note;
  @override
  final AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum status;
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

  factory _$AdminCompensationRequestsDtoOutputRequestsInner([
    void Function(AdminCompensationRequestsDtoOutputRequestsInnerBuilder)?
    updates,
  ]) =>
      (AdminCompensationRequestsDtoOutputRequestsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCompensationRequestsDtoOutputRequestsInner._({
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
  AdminCompensationRequestsDtoOutputRequestsInner rebuild(
    void Function(AdminCompensationRequestsDtoOutputRequestsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCompensationRequestsDtoOutputRequestsInnerBuilder toBuilder() =>
      AdminCompensationRequestsDtoOutputRequestsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCompensationRequestsDtoOutputRequestsInner &&
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
            r'AdminCompensationRequestsDtoOutputRequestsInner',
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

class AdminCompensationRequestsDtoOutputRequestsInnerBuilder
    implements
        Builder<
          AdminCompensationRequestsDtoOutputRequestsInner,
          AdminCompensationRequestsDtoOutputRequestsInnerBuilder
        > {
  _$AdminCompensationRequestsDtoOutputRequestsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  AdminCompensationRequestsDtoOutputRequestsInnerKindEnum? _kind;
  AdminCompensationRequestsDtoOutputRequestsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(AdminCompensationRequestsDtoOutputRequestsInnerKindEnum? kind) =>
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

  AdminCustomerDtoOutputBlockReasonsInnerBuilder? _reason;
  AdminCustomerDtoOutputBlockReasonsInnerBuilder get reason =>
      _$this._reason ??= AdminCustomerDtoOutputBlockReasonsInnerBuilder();
  set reason(AdminCustomerDtoOutputBlockReasonsInnerBuilder? reason) =>
      _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum? _status;
  AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum? get status =>
      _$this._status;
  set status(
    AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum? status,
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

  AdminCompensationRequestsDtoOutputRequestsInnerBuilder() {
    AdminCompensationRequestsDtoOutputRequestsInner._defaults(this);
  }

  AdminCompensationRequestsDtoOutputRequestsInnerBuilder get _$this {
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
  void replace(AdminCompensationRequestsDtoOutputRequestsInner other) {
    _$v = other as _$AdminCompensationRequestsDtoOutputRequestsInner;
  }

  @override
  void update(
    void Function(AdminCompensationRequestsDtoOutputRequestsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCompensationRequestsDtoOutputRequestsInner build() => _build();

  _$AdminCompensationRequestsDtoOutputRequestsInner _build() {
    _$AdminCompensationRequestsDtoOutputRequestsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCompensationRequestsDtoOutputRequestsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
              'id',
            ),
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
              'orderId',
            ),
            orderNumber: BuiltValueNullFieldError.checkNotNull(
              orderNumber,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
              'orderNumber',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
              'kind',
            ),
            amount: amount,
            percentBp: percentBp,
            maxDiscount: maxDiscount,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
              'currency',
            ),
            reason: reason.build(),
            note: note,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
              'status',
            ),
            requestedBy: requestedBy,
            requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt,
              r'AdminCompensationRequestsDtoOutputRequestsInner',
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
          r'AdminCompensationRequestsDtoOutputRequestsInner',
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
