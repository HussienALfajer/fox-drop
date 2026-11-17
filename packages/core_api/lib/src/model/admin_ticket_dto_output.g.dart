// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketDtoOutputPartyEnum _$adminTicketDtoOutputPartyEnum_customer =
    const AdminTicketDtoOutputPartyEnum._('customer');
const AdminTicketDtoOutputPartyEnum _$adminTicketDtoOutputPartyEnum_restaurant =
    const AdminTicketDtoOutputPartyEnum._('restaurant');
const AdminTicketDtoOutputPartyEnum _$adminTicketDtoOutputPartyEnum_captain =
    const AdminTicketDtoOutputPartyEnum._('captain');

AdminTicketDtoOutputPartyEnum _$adminTicketDtoOutputPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customer':
      return _$adminTicketDtoOutputPartyEnum_customer;
    case 'restaurant':
      return _$adminTicketDtoOutputPartyEnum_restaurant;
    case 'captain':
      return _$adminTicketDtoOutputPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketDtoOutputPartyEnum>
_$adminTicketDtoOutputPartyEnumValues = BuiltSet<AdminTicketDtoOutputPartyEnum>(
  const <AdminTicketDtoOutputPartyEnum>[
    _$adminTicketDtoOutputPartyEnum_customer,
    _$adminTicketDtoOutputPartyEnum_restaurant,
    _$adminTicketDtoOutputPartyEnum_captain,
  ],
);

const AdminTicketDtoOutputStatusEnum _$adminTicketDtoOutputStatusEnum_new_ =
    const AdminTicketDtoOutputStatusEnum._('new_');
const AdminTicketDtoOutputStatusEnum
_$adminTicketDtoOutputStatusEnum_inProgress =
    const AdminTicketDtoOutputStatusEnum._('inProgress');
const AdminTicketDtoOutputStatusEnum _$adminTicketDtoOutputStatusEnum_waiting =
    const AdminTicketDtoOutputStatusEnum._('waiting');
const AdminTicketDtoOutputStatusEnum _$adminTicketDtoOutputStatusEnum_resolved =
    const AdminTicketDtoOutputStatusEnum._('resolved');
const AdminTicketDtoOutputStatusEnum _$adminTicketDtoOutputStatusEnum_closed =
    const AdminTicketDtoOutputStatusEnum._('closed');

AdminTicketDtoOutputStatusEnum _$adminTicketDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'new_':
      return _$adminTicketDtoOutputStatusEnum_new_;
    case 'inProgress':
      return _$adminTicketDtoOutputStatusEnum_inProgress;
    case 'waiting':
      return _$adminTicketDtoOutputStatusEnum_waiting;
    case 'resolved':
      return _$adminTicketDtoOutputStatusEnum_resolved;
    case 'closed':
      return _$adminTicketDtoOutputStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketDtoOutputStatusEnum>
_$adminTicketDtoOutputStatusEnumValues =
    BuiltSet<AdminTicketDtoOutputStatusEnum>(
      const <AdminTicketDtoOutputStatusEnum>[
        _$adminTicketDtoOutputStatusEnum_new_,
        _$adminTicketDtoOutputStatusEnum_inProgress,
        _$adminTicketDtoOutputStatusEnum_waiting,
        _$adminTicketDtoOutputStatusEnum_resolved,
        _$adminTicketDtoOutputStatusEnum_closed,
      ],
    );

Serializer<AdminTicketDtoOutputPartyEnum>
_$adminTicketDtoOutputPartyEnumSerializer =
    _$AdminTicketDtoOutputPartyEnumSerializer();
Serializer<AdminTicketDtoOutputStatusEnum>
_$adminTicketDtoOutputStatusEnumSerializer =
    _$AdminTicketDtoOutputStatusEnumSerializer();

class _$AdminTicketDtoOutputPartyEnumSerializer
    implements PrimitiveSerializer<AdminTicketDtoOutputPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customer': 'customer',
    'restaurant': 'restaurant',
    'captain': 'captain',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer': 'customer',
    'restaurant': 'restaurant',
    'captain': 'captain',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminTicketDtoOutputPartyEnum];
  @override
  final String wireName = 'AdminTicketDtoOutputPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketDtoOutputPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketDtoOutputPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketDtoOutputPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminTicketDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminTicketDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminTicketDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketDtoOutput extends AdminTicketDtoOutput {
  @override
  final String id;
  @override
  final String number;
  @override
  final String source_;
  @override
  final AdminTicketDtoOutputPartyEnum party;
  @override
  final String partyId;
  @override
  final String partyName;
  @override
  final String? orderId;
  @override
  final String? orderNumber;
  @override
  final bool urgent;
  @override
  final String typeCode;
  @override
  final String typeLabel;
  @override
  final String description;
  @override
  final AdminTicketDtoOutputStatusEnum status;
  @override
  final String? assigneeId;
  @override
  final String? assigneeName;
  @override
  final AdminOrderTicketsDtoOutputTicketsInnerSla sla;
  @override
  final String? openedByName;
  @override
  final DateTime openedAt;
  @override
  final DateTime updatedAt;

  factory _$AdminTicketDtoOutput([
    void Function(AdminTicketDtoOutputBuilder)? updates,
  ]) => (AdminTicketDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketDtoOutput._({
    required this.id,
    required this.number,
    required this.source_,
    required this.party,
    required this.partyId,
    required this.partyName,
    this.orderId,
    this.orderNumber,
    required this.urgent,
    required this.typeCode,
    required this.typeLabel,
    required this.description,
    required this.status,
    this.assigneeId,
    this.assigneeName,
    required this.sla,
    this.openedByName,
    required this.openedAt,
    required this.updatedAt,
  }) : super._();
  @override
  AdminTicketDtoOutput rebuild(
    void Function(AdminTicketDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketDtoOutputBuilder toBuilder() =>
      AdminTicketDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketDtoOutput &&
        id == other.id &&
        number == other.number &&
        source_ == other.source_ &&
        party == other.party &&
        partyId == other.partyId &&
        partyName == other.partyName &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        urgent == other.urgent &&
        typeCode == other.typeCode &&
        typeLabel == other.typeLabel &&
        description == other.description &&
        status == other.status &&
        assigneeId == other.assigneeId &&
        assigneeName == other.assigneeName &&
        sla == other.sla &&
        openedByName == other.openedByName &&
        openedAt == other.openedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, partyId.hashCode);
    _$hash = $jc(_$hash, partyName.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, urgent.hashCode);
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, typeLabel.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, assigneeId.hashCode);
    _$hash = $jc(_$hash, assigneeName.hashCode);
    _$hash = $jc(_$hash, sla.hashCode);
    _$hash = $jc(_$hash, openedByName.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketDtoOutput')
          ..add('id', id)
          ..add('number', number)
          ..add('source_', source_)
          ..add('party', party)
          ..add('partyId', partyId)
          ..add('partyName', partyName)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('urgent', urgent)
          ..add('typeCode', typeCode)
          ..add('typeLabel', typeLabel)
          ..add('description', description)
          ..add('status', status)
          ..add('assigneeId', assigneeId)
          ..add('assigneeName', assigneeName)
          ..add('sla', sla)
          ..add('openedByName', openedByName)
          ..add('openedAt', openedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AdminTicketDtoOutputBuilder
    implements Builder<AdminTicketDtoOutput, AdminTicketDtoOutputBuilder> {
  _$AdminTicketDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  AdminTicketDtoOutputPartyEnum? _party;
  AdminTicketDtoOutputPartyEnum? get party => _$this._party;
  set party(AdminTicketDtoOutputPartyEnum? party) => _$this._party = party;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  String? _partyName;
  String? get partyName => _$this._partyName;
  set partyName(String? partyName) => _$this._partyName = partyName;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  bool? _urgent;
  bool? get urgent => _$this._urgent;
  set urgent(bool? urgent) => _$this._urgent = urgent;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _typeLabel;
  String? get typeLabel => _$this._typeLabel;
  set typeLabel(String? typeLabel) => _$this._typeLabel = typeLabel;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminTicketDtoOutputStatusEnum? _status;
  AdminTicketDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminTicketDtoOutputStatusEnum? status) => _$this._status = status;

  String? _assigneeId;
  String? get assigneeId => _$this._assigneeId;
  set assigneeId(String? assigneeId) => _$this._assigneeId = assigneeId;

  String? _assigneeName;
  String? get assigneeName => _$this._assigneeName;
  set assigneeName(String? assigneeName) => _$this._assigneeName = assigneeName;

  AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder? _sla;
  AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder get sla =>
      _$this._sla ??= AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder();
  set sla(AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder? sla) =>
      _$this._sla = sla;

  String? _openedByName;
  String? get openedByName => _$this._openedByName;
  set openedByName(String? openedByName) => _$this._openedByName = openedByName;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(DateTime? openedAt) => _$this._openedAt = openedAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AdminTicketDtoOutputBuilder() {
    AdminTicketDtoOutput._defaults(this);
  }

  AdminTicketDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _source_ = $v.source_;
      _party = $v.party;
      _partyId = $v.partyId;
      _partyName = $v.partyName;
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _urgent = $v.urgent;
      _typeCode = $v.typeCode;
      _typeLabel = $v.typeLabel;
      _description = $v.description;
      _status = $v.status;
      _assigneeId = $v.assigneeId;
      _assigneeName = $v.assigneeName;
      _sla = $v.sla.toBuilder();
      _openedByName = $v.openedByName;
      _openedAt = $v.openedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketDtoOutput other) {
    _$v = other as _$AdminTicketDtoOutput;
  }

  @override
  void update(void Function(AdminTicketDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketDtoOutput build() => _build();

  _$AdminTicketDtoOutput _build() {
    _$AdminTicketDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminTicketDtoOutput',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminTicketDtoOutput',
              'number',
            ),
            source_: BuiltValueNullFieldError.checkNotNull(
              source_,
              r'AdminTicketDtoOutput',
              'source_',
            ),
            party: BuiltValueNullFieldError.checkNotNull(
              party,
              r'AdminTicketDtoOutput',
              'party',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminTicketDtoOutput',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminTicketDtoOutput',
              'partyName',
            ),
            orderId: orderId,
            orderNumber: orderNumber,
            urgent: BuiltValueNullFieldError.checkNotNull(
              urgent,
              r'AdminTicketDtoOutput',
              'urgent',
            ),
            typeCode: BuiltValueNullFieldError.checkNotNull(
              typeCode,
              r'AdminTicketDtoOutput',
              'typeCode',
            ),
            typeLabel: BuiltValueNullFieldError.checkNotNull(
              typeLabel,
              r'AdminTicketDtoOutput',
              'typeLabel',
            ),
            description: BuiltValueNullFieldError.checkNotNull(
              description,
              r'AdminTicketDtoOutput',
              'description',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminTicketDtoOutput',
              'status',
            ),
            assigneeId: assigneeId,
            assigneeName: assigneeName,
            sla: sla.build(),
            openedByName: openedByName,
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminTicketDtoOutput',
              'openedAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'AdminTicketDtoOutput',
              'updatedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sla';
        sla.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketDtoOutput',
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
