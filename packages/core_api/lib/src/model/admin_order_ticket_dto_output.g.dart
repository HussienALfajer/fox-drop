// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_ticket_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderTicketDtoOutputSource_Enum
_$adminOrderTicketDtoOutputSourceEnum_manual =
    const AdminOrderTicketDtoOutputSource_Enum._('manual');

AdminOrderTicketDtoOutputSource_Enum
_$adminOrderTicketDtoOutputSourceEnumValueOf(String name) {
  switch (name) {
    case 'manual':
      return _$adminOrderTicketDtoOutputSourceEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderTicketDtoOutputSource_Enum>
_$adminOrderTicketDtoOutputSourceEnumValues =
    BuiltSet<AdminOrderTicketDtoOutputSource_Enum>(
      const <AdminOrderTicketDtoOutputSource_Enum>[
        _$adminOrderTicketDtoOutputSourceEnum_manual,
      ],
    );

const AdminOrderTicketDtoOutputPartyEnum
_$adminOrderTicketDtoOutputPartyEnum_customer =
    const AdminOrderTicketDtoOutputPartyEnum._('customer');
const AdminOrderTicketDtoOutputPartyEnum
_$adminOrderTicketDtoOutputPartyEnum_restaurant =
    const AdminOrderTicketDtoOutputPartyEnum._('restaurant');
const AdminOrderTicketDtoOutputPartyEnum
_$adminOrderTicketDtoOutputPartyEnum_captain =
    const AdminOrderTicketDtoOutputPartyEnum._('captain');

AdminOrderTicketDtoOutputPartyEnum _$adminOrderTicketDtoOutputPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customer':
      return _$adminOrderTicketDtoOutputPartyEnum_customer;
    case 'restaurant':
      return _$adminOrderTicketDtoOutputPartyEnum_restaurant;
    case 'captain':
      return _$adminOrderTicketDtoOutputPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderTicketDtoOutputPartyEnum>
_$adminOrderTicketDtoOutputPartyEnumValues =
    BuiltSet<AdminOrderTicketDtoOutputPartyEnum>(
      const <AdminOrderTicketDtoOutputPartyEnum>[
        _$adminOrderTicketDtoOutputPartyEnum_customer,
        _$adminOrderTicketDtoOutputPartyEnum_restaurant,
        _$adminOrderTicketDtoOutputPartyEnum_captain,
      ],
    );

const AdminOrderTicketDtoOutputStatusEnum
_$adminOrderTicketDtoOutputStatusEnum_new_ =
    const AdminOrderTicketDtoOutputStatusEnum._('new_');
const AdminOrderTicketDtoOutputStatusEnum
_$adminOrderTicketDtoOutputStatusEnum_inProgress =
    const AdminOrderTicketDtoOutputStatusEnum._('inProgress');
const AdminOrderTicketDtoOutputStatusEnum
_$adminOrderTicketDtoOutputStatusEnum_waiting =
    const AdminOrderTicketDtoOutputStatusEnum._('waiting');
const AdminOrderTicketDtoOutputStatusEnum
_$adminOrderTicketDtoOutputStatusEnum_resolved =
    const AdminOrderTicketDtoOutputStatusEnum._('resolved');
const AdminOrderTicketDtoOutputStatusEnum
_$adminOrderTicketDtoOutputStatusEnum_closed =
    const AdminOrderTicketDtoOutputStatusEnum._('closed');

AdminOrderTicketDtoOutputStatusEnum
_$adminOrderTicketDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$adminOrderTicketDtoOutputStatusEnum_new_;
    case 'inProgress':
      return _$adminOrderTicketDtoOutputStatusEnum_inProgress;
    case 'waiting':
      return _$adminOrderTicketDtoOutputStatusEnum_waiting;
    case 'resolved':
      return _$adminOrderTicketDtoOutputStatusEnum_resolved;
    case 'closed':
      return _$adminOrderTicketDtoOutputStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderTicketDtoOutputStatusEnum>
_$adminOrderTicketDtoOutputStatusEnumValues =
    BuiltSet<AdminOrderTicketDtoOutputStatusEnum>(
      const <AdminOrderTicketDtoOutputStatusEnum>[
        _$adminOrderTicketDtoOutputStatusEnum_new_,
        _$adminOrderTicketDtoOutputStatusEnum_inProgress,
        _$adminOrderTicketDtoOutputStatusEnum_waiting,
        _$adminOrderTicketDtoOutputStatusEnum_resolved,
        _$adminOrderTicketDtoOutputStatusEnum_closed,
      ],
    );

Serializer<AdminOrderTicketDtoOutputSource_Enum>
_$adminOrderTicketDtoOutputSourceEnumSerializer =
    _$AdminOrderTicketDtoOutputSource_EnumSerializer();
Serializer<AdminOrderTicketDtoOutputPartyEnum>
_$adminOrderTicketDtoOutputPartyEnumSerializer =
    _$AdminOrderTicketDtoOutputPartyEnumSerializer();
Serializer<AdminOrderTicketDtoOutputStatusEnum>
_$adminOrderTicketDtoOutputStatusEnumSerializer =
    _$AdminOrderTicketDtoOutputStatusEnumSerializer();

class _$AdminOrderTicketDtoOutputSource_EnumSerializer
    implements PrimitiveSerializer<AdminOrderTicketDtoOutputSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderTicketDtoOutputSource_Enum,
  ];
  @override
  final String wireName = 'AdminOrderTicketDtoOutputSource_Enum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketDtoOutputSource_Enum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderTicketDtoOutputSource_Enum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderTicketDtoOutputSource_Enum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderTicketDtoOutputPartyEnumSerializer
    implements PrimitiveSerializer<AdminOrderTicketDtoOutputPartyEnum> {
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
  final Iterable<Type> types = const <Type>[AdminOrderTicketDtoOutputPartyEnum];
  @override
  final String wireName = 'AdminOrderTicketDtoOutputPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketDtoOutputPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderTicketDtoOutputPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderTicketDtoOutputPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderTicketDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminOrderTicketDtoOutputStatusEnum> {
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
    AdminOrderTicketDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminOrderTicketDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderTicketDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderTicketDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderTicketDtoOutput extends AdminOrderTicketDtoOutput {
  @override
  final String id;
  @override
  final String number;
  @override
  final AdminOrderTicketDtoOutputSource_Enum source_;
  @override
  final AdminOrderTicketDtoOutputPartyEnum party;
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
  final AdminOrderTicketDtoOutputStatusEnum status;
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

  factory _$AdminOrderTicketDtoOutput([
    void Function(AdminOrderTicketDtoOutputBuilder)? updates,
  ]) => (AdminOrderTicketDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderTicketDtoOutput._({
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
  AdminOrderTicketDtoOutput rebuild(
    void Function(AdminOrderTicketDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketDtoOutputBuilder toBuilder() =>
      AdminOrderTicketDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderTicketDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderTicketDtoOutput')
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

class AdminOrderTicketDtoOutputBuilder
    implements
        Builder<AdminOrderTicketDtoOutput, AdminOrderTicketDtoOutputBuilder> {
  _$AdminOrderTicketDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminOrderTicketDtoOutputSource_Enum? _source_;
  AdminOrderTicketDtoOutputSource_Enum? get source_ => _$this._source_;
  set source_(AdminOrderTicketDtoOutputSource_Enum? source_) =>
      _$this._source_ = source_;

  AdminOrderTicketDtoOutputPartyEnum? _party;
  AdminOrderTicketDtoOutputPartyEnum? get party => _$this._party;
  set party(AdminOrderTicketDtoOutputPartyEnum? party) => _$this._party = party;

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

  AdminOrderTicketDtoOutputStatusEnum? _status;
  AdminOrderTicketDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminOrderTicketDtoOutputStatusEnum? status) =>
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

  AdminOrderTicketDtoOutputBuilder() {
    AdminOrderTicketDtoOutput._defaults(this);
  }

  AdminOrderTicketDtoOutputBuilder get _$this {
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
  void replace(AdminOrderTicketDtoOutput other) {
    _$v = other as _$AdminOrderTicketDtoOutput;
  }

  @override
  void update(void Function(AdminOrderTicketDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketDtoOutput build() => _build();

  _$AdminOrderTicketDtoOutput _build() {
    _$AdminOrderTicketDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderTicketDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderTicketDtoOutput',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminOrderTicketDtoOutput',
              'number',
            ),
            source_: BuiltValueNullFieldError.checkNotNull(
              source_,
              r'AdminOrderTicketDtoOutput',
              'source_',
            ),
            party: BuiltValueNullFieldError.checkNotNull(
              party,
              r'AdminOrderTicketDtoOutput',
              'party',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminOrderTicketDtoOutput',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminOrderTicketDtoOutput',
              'partyName',
            ),
            orderId: orderId,
            orderNumber: orderNumber,
            urgent: BuiltValueNullFieldError.checkNotNull(
              urgent,
              r'AdminOrderTicketDtoOutput',
              'urgent',
            ),
            typeCode: BuiltValueNullFieldError.checkNotNull(
              typeCode,
              r'AdminOrderTicketDtoOutput',
              'typeCode',
            ),
            typeLabel: BuiltValueNullFieldError.checkNotNull(
              typeLabel,
              r'AdminOrderTicketDtoOutput',
              'typeLabel',
            ),
            description: BuiltValueNullFieldError.checkNotNull(
              description,
              r'AdminOrderTicketDtoOutput',
              'description',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderTicketDtoOutput',
              'status',
            ),
            assigneeId: assigneeId,
            assigneeName: assigneeName,
            sla: sla.build(),
            openedByName: openedByName,
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminOrderTicketDtoOutput',
              'openedAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'AdminOrderTicketDtoOutput',
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
          r'AdminOrderTicketDtoOutput',
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
