// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_new_ =
    const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum._('new_');
const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_inProgress =
    const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum._(
      'inProgress',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_waiting =
    const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum._('waiting');
const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_resolved =
    const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum._(
      'resolved',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_closed =
    const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum._('closed');

CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_new_;
    case 'inProgress':
      return _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_inProgress;
    case 'waiting':
      return _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_waiting;
    case 'resolved':
      return _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_resolved;
    case 'closed':
      return _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum>
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum>(
      const <CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum>[
        _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_new_,
        _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_inProgress,
        _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_waiting,
        _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_resolved,
        _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_closed,
      ],
    );

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum>
_$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'new_': 'new',
    'inProgress': 'in_progress',
    'waiting': 'waiting',
    'resolved': 'resolved',
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'new': 'new_',
    'in_progress': 'inProgress',
    'waiting': 'waiting',
    'resolved': 'resolved',
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerReport
    extends CustomerActiveOrdersDtoOutputOrdersInnerReport {
  @override
  final String ticketId;
  @override
  final String number;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum status;
  @override
  final String? message;
  @override
  final DateTime? resolvedAt;
  @override
  final int replyWithinMinutes;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerReport([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder()..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerReport._({
    required this.ticketId,
    required this.number,
    required this.status,
    this.message,
    this.resolvedAt,
    required this.replyWithinMinutes,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerReport rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerReport &&
        ticketId == other.ticketId &&
        number == other.number &&
        status == other.status &&
        message == other.message &&
        resolvedAt == other.resolvedAt &&
        replyWithinMinutes == other.replyWithinMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, replyWithinMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerReport',
          )
          ..add('ticketId', ticketId)
          ..add('number', number)
          ..add('status', status)
          ..add('message', message)
          ..add('resolvedAt', resolvedAt)
          ..add('replyWithinMinutes', replyWithinMinutes))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerReport,
          CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerReport? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum? _status;
  CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum? get status =>
      _$this._status;
  set status(
    CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum? status,
  ) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  int? _replyWithinMinutes;
  int? get replyWithinMinutes => _$this._replyWithinMinutes;
  set replyWithinMinutes(int? replyWithinMinutes) =>
      _$this._replyWithinMinutes = replyWithinMinutes;

  CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerReport._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _number = $v.number;
      _status = $v.status;
      _message = $v.message;
      _resolvedAt = $v.resolvedAt;
      _replyWithinMinutes = $v.replyWithinMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerReport other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerReport;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerReport build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerReport _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerReport._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
            ticketId,
            r'CustomerActiveOrdersDtoOutputOrdersInnerReport',
            'ticketId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CustomerActiveOrdersDtoOutputOrdersInnerReport',
            'number',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CustomerActiveOrdersDtoOutputOrdersInnerReport',
            'status',
          ),
          message: message,
          resolvedAt: resolvedAt,
          replyWithinMinutes: BuiltValueNullFieldError.checkNotNull(
            replyWithinMinutes,
            r'CustomerActiveOrdersDtoOutputOrdersInnerReport',
            'replyWithinMinutes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
