// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_tickets_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum
_$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_customer =
    const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum._('customer');
const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum
_$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_restaurant =
    const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum._('restaurant');
const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum
_$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_captain =
    const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum._('captain');

AdminOrderTicketsDtoOutputTicketsInnerPartyEnum
_$adminOrderTicketsDtoOutputTicketsInnerPartyEnumValueOf(String name) {
  switch (name) {
    case 'customer':
      return _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_customer;
    case 'restaurant':
      return _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_restaurant;
    case 'captain':
      return _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerPartyEnum>
_$adminOrderTicketsDtoOutputTicketsInnerPartyEnumValues =
    BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerPartyEnum>(
      const <AdminOrderTicketsDtoOutputTicketsInnerPartyEnum>[
        _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_customer,
        _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_restaurant,
        _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_captain,
      ],
    );

const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_new_ =
    const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum._('new_');
const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_inProgress =
    const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum._('inProgress');
const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_waiting =
    const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum._('waiting');
const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_resolved =
    const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum._('resolved');
const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_closed =
    const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum._('closed');

AdminOrderTicketsDtoOutputTicketsInnerStatusEnum
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_new_;
    case 'inProgress':
      return _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_inProgress;
    case 'waiting':
      return _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_waiting;
    case 'resolved':
      return _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_resolved;
    case 'closed':
      return _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerStatusEnum>
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnumValues =
    BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerStatusEnum>(
      const <AdminOrderTicketsDtoOutputTicketsInnerStatusEnum>[
        _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_new_,
        _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_inProgress,
        _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_waiting,
        _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_resolved,
        _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_closed,
      ],
    );

Serializer<AdminOrderTicketsDtoOutputTicketsInnerPartyEnum>
_$adminOrderTicketsDtoOutputTicketsInnerPartyEnumSerializer =
    _$AdminOrderTicketsDtoOutputTicketsInnerPartyEnumSerializer();
Serializer<AdminOrderTicketsDtoOutputTicketsInnerStatusEnum>
_$adminOrderTicketsDtoOutputTicketsInnerStatusEnumSerializer =
    _$AdminOrderTicketsDtoOutputTicketsInnerStatusEnumSerializer();

class _$AdminOrderTicketsDtoOutputTicketsInnerPartyEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInnerPartyEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminOrderTicketsDtoOutputTicketsInnerPartyEnum,
  ];
  @override
  final String wireName = 'AdminOrderTicketsDtoOutputTicketsInnerPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderTicketsDtoOutputTicketsInnerPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderTicketsDtoOutputTicketsInnerPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderTicketsDtoOutputTicketsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInnerStatusEnum> {
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
    AdminOrderTicketsDtoOutputTicketsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminOrderTicketsDtoOutputTicketsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderTicketsDtoOutputTicketsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderTicketsDtoOutputTicketsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderTicketsDtoOutputTicketsInner
    extends AdminOrderTicketsDtoOutputTicketsInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final String source_;
  @override
  final AdminOrderTicketsDtoOutputTicketsInnerPartyEnum party;
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
  final AdminOrderTicketsDtoOutputTicketsInnerStatusEnum status;
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

  factory _$AdminOrderTicketsDtoOutputTicketsInner([
    void Function(AdminOrderTicketsDtoOutputTicketsInnerBuilder)? updates,
  ]) => (AdminOrderTicketsDtoOutputTicketsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderTicketsDtoOutputTicketsInner._({
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
  AdminOrderTicketsDtoOutputTicketsInner rebuild(
    void Function(AdminOrderTicketsDtoOutputTicketsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketsDtoOutputTicketsInnerBuilder toBuilder() =>
      AdminOrderTicketsDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderTicketsDtoOutputTicketsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminOrderTicketsDtoOutputTicketsInner',
          )
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

class AdminOrderTicketsDtoOutputTicketsInnerBuilder
    implements
        Builder<
          AdminOrderTicketsDtoOutputTicketsInner,
          AdminOrderTicketsDtoOutputTicketsInnerBuilder
        > {
  _$AdminOrderTicketsDtoOutputTicketsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  AdminOrderTicketsDtoOutputTicketsInnerPartyEnum? _party;
  AdminOrderTicketsDtoOutputTicketsInnerPartyEnum? get party => _$this._party;
  set party(AdminOrderTicketsDtoOutputTicketsInnerPartyEnum? party) =>
      _$this._party = party;

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

  AdminOrderTicketsDtoOutputTicketsInnerStatusEnum? _status;
  AdminOrderTicketsDtoOutputTicketsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminOrderTicketsDtoOutputTicketsInnerStatusEnum? status) =>
      _$this._status = status;

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

  AdminOrderTicketsDtoOutputTicketsInnerBuilder() {
    AdminOrderTicketsDtoOutputTicketsInner._defaults(this);
  }

  AdminOrderTicketsDtoOutputTicketsInnerBuilder get _$this {
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
  void replace(AdminOrderTicketsDtoOutputTicketsInner other) {
    _$v = other as _$AdminOrderTicketsDtoOutputTicketsInner;
  }

  @override
  void update(
    void Function(AdminOrderTicketsDtoOutputTicketsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInner build() => _build();

  _$AdminOrderTicketsDtoOutputTicketsInner _build() {
    _$AdminOrderTicketsDtoOutputTicketsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderTicketsDtoOutputTicketsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'number',
            ),
            source_: BuiltValueNullFieldError.checkNotNull(
              source_,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'source_',
            ),
            party: BuiltValueNullFieldError.checkNotNull(
              party,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'party',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'partyName',
            ),
            orderId: orderId,
            orderNumber: orderNumber,
            urgent: BuiltValueNullFieldError.checkNotNull(
              urgent,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'urgent',
            ),
            typeCode: BuiltValueNullFieldError.checkNotNull(
              typeCode,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'typeCode',
            ),
            typeLabel: BuiltValueNullFieldError.checkNotNull(
              typeLabel,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'typeLabel',
            ),
            description: BuiltValueNullFieldError.checkNotNull(
              description,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'description',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'status',
            ),
            assigneeId: assigneeId,
            assigneeName: assigneeName,
            sla: sla.build(),
            openedByName: openedByName,
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminOrderTicketsDtoOutputTicketsInner',
              'openedAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'AdminOrderTicketsDtoOutputTicketsInner',
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
          r'AdminOrderTicketsDtoOutputTicketsInner',
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
