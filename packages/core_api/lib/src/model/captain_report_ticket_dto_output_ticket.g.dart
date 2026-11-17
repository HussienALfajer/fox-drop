// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_report_ticket_dto_output_ticket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainReportTicketDtoOutputTicketStatusEnum
_$captainReportTicketDtoOutputTicketStatusEnum_new_ =
    const CaptainReportTicketDtoOutputTicketStatusEnum._('new_');
const CaptainReportTicketDtoOutputTicketStatusEnum
_$captainReportTicketDtoOutputTicketStatusEnum_inProgress =
    const CaptainReportTicketDtoOutputTicketStatusEnum._('inProgress');
const CaptainReportTicketDtoOutputTicketStatusEnum
_$captainReportTicketDtoOutputTicketStatusEnum_waiting =
    const CaptainReportTicketDtoOutputTicketStatusEnum._('waiting');
const CaptainReportTicketDtoOutputTicketStatusEnum
_$captainReportTicketDtoOutputTicketStatusEnum_resolved =
    const CaptainReportTicketDtoOutputTicketStatusEnum._('resolved');
const CaptainReportTicketDtoOutputTicketStatusEnum
_$captainReportTicketDtoOutputTicketStatusEnum_closed =
    const CaptainReportTicketDtoOutputTicketStatusEnum._('closed');

CaptainReportTicketDtoOutputTicketStatusEnum
_$captainReportTicketDtoOutputTicketStatusEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$captainReportTicketDtoOutputTicketStatusEnum_new_;
    case 'inProgress':
      return _$captainReportTicketDtoOutputTicketStatusEnum_inProgress;
    case 'waiting':
      return _$captainReportTicketDtoOutputTicketStatusEnum_waiting;
    case 'resolved':
      return _$captainReportTicketDtoOutputTicketStatusEnum_resolved;
    case 'closed':
      return _$captainReportTicketDtoOutputTicketStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainReportTicketDtoOutputTicketStatusEnum>
_$captainReportTicketDtoOutputTicketStatusEnumValues =
    BuiltSet<CaptainReportTicketDtoOutputTicketStatusEnum>(
      const <CaptainReportTicketDtoOutputTicketStatusEnum>[
        _$captainReportTicketDtoOutputTicketStatusEnum_new_,
        _$captainReportTicketDtoOutputTicketStatusEnum_inProgress,
        _$captainReportTicketDtoOutputTicketStatusEnum_waiting,
        _$captainReportTicketDtoOutputTicketStatusEnum_resolved,
        _$captainReportTicketDtoOutputTicketStatusEnum_closed,
      ],
    );

const CaptainReportTicketDtoOutputTicketOpenedByEnum
_$captainReportTicketDtoOutputTicketOpenedByEnum_me =
    const CaptainReportTicketDtoOutputTicketOpenedByEnum._('me');
const CaptainReportTicketDtoOutputTicketOpenedByEnum
_$captainReportTicketDtoOutputTicketOpenedByEnum_operations =
    const CaptainReportTicketDtoOutputTicketOpenedByEnum._('operations');

CaptainReportTicketDtoOutputTicketOpenedByEnum
_$captainReportTicketDtoOutputTicketOpenedByEnumValueOf(String name) {
  switch (name) {
    case 'me':
      return _$captainReportTicketDtoOutputTicketOpenedByEnum_me;
    case 'operations':
      return _$captainReportTicketDtoOutputTicketOpenedByEnum_operations;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainReportTicketDtoOutputTicketOpenedByEnum>
_$captainReportTicketDtoOutputTicketOpenedByEnumValues =
    BuiltSet<CaptainReportTicketDtoOutputTicketOpenedByEnum>(
      const <CaptainReportTicketDtoOutputTicketOpenedByEnum>[
        _$captainReportTicketDtoOutputTicketOpenedByEnum_me,
        _$captainReportTicketDtoOutputTicketOpenedByEnum_operations,
      ],
    );

Serializer<CaptainReportTicketDtoOutputTicketStatusEnum>
_$captainReportTicketDtoOutputTicketStatusEnumSerializer =
    _$CaptainReportTicketDtoOutputTicketStatusEnumSerializer();
Serializer<CaptainReportTicketDtoOutputTicketOpenedByEnum>
_$captainReportTicketDtoOutputTicketOpenedByEnumSerializer =
    _$CaptainReportTicketDtoOutputTicketOpenedByEnumSerializer();

class _$CaptainReportTicketDtoOutputTicketStatusEnumSerializer
    implements
        PrimitiveSerializer<CaptainReportTicketDtoOutputTicketStatusEnum> {
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
    CaptainReportTicketDtoOutputTicketStatusEnum,
  ];
  @override
  final String wireName = 'CaptainReportTicketDtoOutputTicketStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainReportTicketDtoOutputTicketStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainReportTicketDtoOutputTicketStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainReportTicketDtoOutputTicketStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainReportTicketDtoOutputTicketOpenedByEnumSerializer
    implements
        PrimitiveSerializer<CaptainReportTicketDtoOutputTicketOpenedByEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'me': 'me',
    'operations': 'operations',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'me': 'me',
    'operations': 'operations',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainReportTicketDtoOutputTicketOpenedByEnum,
  ];
  @override
  final String wireName = 'CaptainReportTicketDtoOutputTicketOpenedByEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainReportTicketDtoOutputTicketOpenedByEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainReportTicketDtoOutputTicketOpenedByEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainReportTicketDtoOutputTicketOpenedByEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainReportTicketDtoOutputTicket
    extends CaptainReportTicketDtoOutputTicket {
  @override
  final String id;
  @override
  final String number;
  @override
  final String typeLabel;
  @override
  final String? orderId;
  @override
  final String? orderNumber;
  @override
  final String description;
  @override
  final CaptainReportTicketDtoOutputTicketStatusEnum status;
  @override
  final DateTime openedAt;
  @override
  final CaptainReportTicketDtoOutputTicketOpenedByEnum openedBy;
  @override
  final int replyWithinMinutes;
  @override
  final String? message;
  @override
  final DateTime? resolvedAt;

  factory _$CaptainReportTicketDtoOutputTicket([
    void Function(CaptainReportTicketDtoOutputTicketBuilder)? updates,
  ]) => (CaptainReportTicketDtoOutputTicketBuilder()..update(updates))._build();

  _$CaptainReportTicketDtoOutputTicket._({
    required this.id,
    required this.number,
    required this.typeLabel,
    this.orderId,
    this.orderNumber,
    required this.description,
    required this.status,
    required this.openedAt,
    required this.openedBy,
    required this.replyWithinMinutes,
    this.message,
    this.resolvedAt,
  }) : super._();
  @override
  CaptainReportTicketDtoOutputTicket rebuild(
    void Function(CaptainReportTicketDtoOutputTicketBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainReportTicketDtoOutputTicketBuilder toBuilder() =>
      CaptainReportTicketDtoOutputTicketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainReportTicketDtoOutputTicket &&
        id == other.id &&
        number == other.number &&
        typeLabel == other.typeLabel &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        description == other.description &&
        status == other.status &&
        openedAt == other.openedAt &&
        openedBy == other.openedBy &&
        replyWithinMinutes == other.replyWithinMinutes &&
        message == other.message &&
        resolvedAt == other.resolvedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, typeLabel.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, openedBy.hashCode);
    _$hash = $jc(_$hash, replyWithinMinutes.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainReportTicketDtoOutputTicket')
          ..add('id', id)
          ..add('number', number)
          ..add('typeLabel', typeLabel)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('description', description)
          ..add('status', status)
          ..add('openedAt', openedAt)
          ..add('openedBy', openedBy)
          ..add('replyWithinMinutes', replyWithinMinutes)
          ..add('message', message)
          ..add('resolvedAt', resolvedAt))
        .toString();
  }
}

class CaptainReportTicketDtoOutputTicketBuilder
    implements
        Builder<
          CaptainReportTicketDtoOutputTicket,
          CaptainReportTicketDtoOutputTicketBuilder
        > {
  _$CaptainReportTicketDtoOutputTicket? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _typeLabel;
  String? get typeLabel => _$this._typeLabel;
  set typeLabel(String? typeLabel) => _$this._typeLabel = typeLabel;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  CaptainReportTicketDtoOutputTicketStatusEnum? _status;
  CaptainReportTicketDtoOutputTicketStatusEnum? get status => _$this._status;
  set status(CaptainReportTicketDtoOutputTicketStatusEnum? status) =>
      _$this._status = status;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(DateTime? openedAt) => _$this._openedAt = openedAt;

  CaptainReportTicketDtoOutputTicketOpenedByEnum? _openedBy;
  CaptainReportTicketDtoOutputTicketOpenedByEnum? get openedBy =>
      _$this._openedBy;
  set openedBy(CaptainReportTicketDtoOutputTicketOpenedByEnum? openedBy) =>
      _$this._openedBy = openedBy;

  int? _replyWithinMinutes;
  int? get replyWithinMinutes => _$this._replyWithinMinutes;
  set replyWithinMinutes(int? replyWithinMinutes) =>
      _$this._replyWithinMinutes = replyWithinMinutes;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  CaptainReportTicketDtoOutputTicketBuilder() {
    CaptainReportTicketDtoOutputTicket._defaults(this);
  }

  CaptainReportTicketDtoOutputTicketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _typeLabel = $v.typeLabel;
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _description = $v.description;
      _status = $v.status;
      _openedAt = $v.openedAt;
      _openedBy = $v.openedBy;
      _replyWithinMinutes = $v.replyWithinMinutes;
      _message = $v.message;
      _resolvedAt = $v.resolvedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainReportTicketDtoOutputTicket other) {
    _$v = other as _$CaptainReportTicketDtoOutputTicket;
  }

  @override
  void update(
    void Function(CaptainReportTicketDtoOutputTicketBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainReportTicketDtoOutputTicket build() => _build();

  _$CaptainReportTicketDtoOutputTicket _build() {
    final _$result =
        _$v ??
        _$CaptainReportTicketDtoOutputTicket._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CaptainReportTicketDtoOutputTicket',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CaptainReportTicketDtoOutputTicket',
            'number',
          ),
          typeLabel: BuiltValueNullFieldError.checkNotNull(
            typeLabel,
            r'CaptainReportTicketDtoOutputTicket',
            'typeLabel',
          ),
          orderId: orderId,
          orderNumber: orderNumber,
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'CaptainReportTicketDtoOutputTicket',
            'description',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'CaptainReportTicketDtoOutputTicket',
            'status',
          ),
          openedAt: BuiltValueNullFieldError.checkNotNull(
            openedAt,
            r'CaptainReportTicketDtoOutputTicket',
            'openedAt',
          ),
          openedBy: BuiltValueNullFieldError.checkNotNull(
            openedBy,
            r'CaptainReportTicketDtoOutputTicket',
            'openedBy',
          ),
          replyWithinMinutes: BuiltValueNullFieldError.checkNotNull(
            replyWithinMinutes,
            r'CaptainReportTicketDtoOutputTicket',
            'replyWithinMinutes',
          ),
          message: message,
          resolvedAt: resolvedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
