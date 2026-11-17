// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketPageDtoOutputSource_Enum
_$adminTicketPageDtoOutputSourceEnum_manual =
    const AdminTicketPageDtoOutputSource_Enum._('manual');

AdminTicketPageDtoOutputSource_Enum _$adminTicketPageDtoOutputSourceEnumValueOf(
  String name,
) {
  switch (name) {
    case 'manual':
      return _$adminTicketPageDtoOutputSourceEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketPageDtoOutputSource_Enum>
_$adminTicketPageDtoOutputSourceEnumValues =
    BuiltSet<AdminTicketPageDtoOutputSource_Enum>(
      const <AdminTicketPageDtoOutputSource_Enum>[
        _$adminTicketPageDtoOutputSourceEnum_manual,
      ],
    );

const AdminTicketPageDtoOutputPartyEnum
_$adminTicketPageDtoOutputPartyEnum_customer =
    const AdminTicketPageDtoOutputPartyEnum._('customer');
const AdminTicketPageDtoOutputPartyEnum
_$adminTicketPageDtoOutputPartyEnum_restaurant =
    const AdminTicketPageDtoOutputPartyEnum._('restaurant');
const AdminTicketPageDtoOutputPartyEnum
_$adminTicketPageDtoOutputPartyEnum_captain =
    const AdminTicketPageDtoOutputPartyEnum._('captain');

AdminTicketPageDtoOutputPartyEnum _$adminTicketPageDtoOutputPartyEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customer':
      return _$adminTicketPageDtoOutputPartyEnum_customer;
    case 'restaurant':
      return _$adminTicketPageDtoOutputPartyEnum_restaurant;
    case 'captain':
      return _$adminTicketPageDtoOutputPartyEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketPageDtoOutputPartyEnum>
_$adminTicketPageDtoOutputPartyEnumValues =
    BuiltSet<AdminTicketPageDtoOutputPartyEnum>(
      const <AdminTicketPageDtoOutputPartyEnum>[
        _$adminTicketPageDtoOutputPartyEnum_customer,
        _$adminTicketPageDtoOutputPartyEnum_restaurant,
        _$adminTicketPageDtoOutputPartyEnum_captain,
      ],
    );

const AdminTicketPageDtoOutputStatusEnum
_$adminTicketPageDtoOutputStatusEnum_new_ =
    const AdminTicketPageDtoOutputStatusEnum._('new_');
const AdminTicketPageDtoOutputStatusEnum
_$adminTicketPageDtoOutputStatusEnum_inProgress =
    const AdminTicketPageDtoOutputStatusEnum._('inProgress');
const AdminTicketPageDtoOutputStatusEnum
_$adminTicketPageDtoOutputStatusEnum_waiting =
    const AdminTicketPageDtoOutputStatusEnum._('waiting');
const AdminTicketPageDtoOutputStatusEnum
_$adminTicketPageDtoOutputStatusEnum_resolved =
    const AdminTicketPageDtoOutputStatusEnum._('resolved');
const AdminTicketPageDtoOutputStatusEnum
_$adminTicketPageDtoOutputStatusEnum_closed =
    const AdminTicketPageDtoOutputStatusEnum._('closed');

AdminTicketPageDtoOutputStatusEnum _$adminTicketPageDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'new_':
      return _$adminTicketPageDtoOutputStatusEnum_new_;
    case 'inProgress':
      return _$adminTicketPageDtoOutputStatusEnum_inProgress;
    case 'waiting':
      return _$adminTicketPageDtoOutputStatusEnum_waiting;
    case 'resolved':
      return _$adminTicketPageDtoOutputStatusEnum_resolved;
    case 'closed':
      return _$adminTicketPageDtoOutputStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketPageDtoOutputStatusEnum>
_$adminTicketPageDtoOutputStatusEnumValues =
    BuiltSet<AdminTicketPageDtoOutputStatusEnum>(
      const <AdminTicketPageDtoOutputStatusEnum>[
        _$adminTicketPageDtoOutputStatusEnum_new_,
        _$adminTicketPageDtoOutputStatusEnum_inProgress,
        _$adminTicketPageDtoOutputStatusEnum_waiting,
        _$adminTicketPageDtoOutputStatusEnum_resolved,
        _$adminTicketPageDtoOutputStatusEnum_closed,
      ],
    );

Serializer<AdminTicketPageDtoOutputSource_Enum>
_$adminTicketPageDtoOutputSourceEnumSerializer =
    _$AdminTicketPageDtoOutputSource_EnumSerializer();
Serializer<AdminTicketPageDtoOutputPartyEnum>
_$adminTicketPageDtoOutputPartyEnumSerializer =
    _$AdminTicketPageDtoOutputPartyEnumSerializer();
Serializer<AdminTicketPageDtoOutputStatusEnum>
_$adminTicketPageDtoOutputStatusEnumSerializer =
    _$AdminTicketPageDtoOutputStatusEnumSerializer();

class _$AdminTicketPageDtoOutputSource_EnumSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminTicketPageDtoOutputSource_Enum,
  ];
  @override
  final String wireName = 'AdminTicketPageDtoOutputSource_Enum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputSource_Enum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketPageDtoOutputSource_Enum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketPageDtoOutputSource_Enum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketPageDtoOutputPartyEnumSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputPartyEnum> {
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
  final Iterable<Type> types = const <Type>[AdminTicketPageDtoOutputPartyEnum];
  @override
  final String wireName = 'AdminTicketPageDtoOutputPartyEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputPartyEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketPageDtoOutputPartyEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketPageDtoOutputPartyEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketPageDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminTicketPageDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminTicketPageDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketPageDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketPageDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketPageDtoOutput extends AdminTicketPageDtoOutput {
  @override
  final String id;
  @override
  final String number;
  @override
  final AdminTicketPageDtoOutputSource_Enum source_;
  @override
  final AdminTicketPageDtoOutputPartyEnum party;
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
  final AdminTicketPageDtoOutputStatusEnum status;
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
  @override
  final BuiltList<AdminTicketPageDtoOutputNotesInner> notes;

  factory _$AdminTicketPageDtoOutput([
    void Function(AdminTicketPageDtoOutputBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketPageDtoOutput._({
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
    required this.notes,
  }) : super._();
  @override
  AdminTicketPageDtoOutput rebuild(
    void Function(AdminTicketPageDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputBuilder toBuilder() =>
      AdminTicketPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutput &&
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
        updatedAt == other.updatedAt &&
        notes == other.notes;
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
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketPageDtoOutput')
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
          ..add('updatedAt', updatedAt)
          ..add('notes', notes))
        .toString();
  }
}

class AdminTicketPageDtoOutputBuilder
    implements
        Builder<AdminTicketPageDtoOutput, AdminTicketPageDtoOutputBuilder> {
  _$AdminTicketPageDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminTicketPageDtoOutputSource_Enum? _source_;
  AdminTicketPageDtoOutputSource_Enum? get source_ => _$this._source_;
  set source_(AdminTicketPageDtoOutputSource_Enum? source_) =>
      _$this._source_ = source_;

  AdminTicketPageDtoOutputPartyEnum? _party;
  AdminTicketPageDtoOutputPartyEnum? get party => _$this._party;
  set party(AdminTicketPageDtoOutputPartyEnum? party) => _$this._party = party;

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

  AdminTicketPageDtoOutputStatusEnum? _status;
  AdminTicketPageDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminTicketPageDtoOutputStatusEnum? status) =>
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

  ListBuilder<AdminTicketPageDtoOutputNotesInner>? _notes;
  ListBuilder<AdminTicketPageDtoOutputNotesInner> get notes =>
      _$this._notes ??= ListBuilder<AdminTicketPageDtoOutputNotesInner>();
  set notes(ListBuilder<AdminTicketPageDtoOutputNotesInner>? notes) =>
      _$this._notes = notes;

  AdminTicketPageDtoOutputBuilder() {
    AdminTicketPageDtoOutput._defaults(this);
  }

  AdminTicketPageDtoOutputBuilder get _$this {
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
      _notes = $v.notes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutput other) {
    _$v = other as _$AdminTicketPageDtoOutput;
  }

  @override
  void update(void Function(AdminTicketPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutput build() => _build();

  _$AdminTicketPageDtoOutput _build() {
    _$AdminTicketPageDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketPageDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminTicketPageDtoOutput',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminTicketPageDtoOutput',
              'number',
            ),
            source_: BuiltValueNullFieldError.checkNotNull(
              source_,
              r'AdminTicketPageDtoOutput',
              'source_',
            ),
            party: BuiltValueNullFieldError.checkNotNull(
              party,
              r'AdminTicketPageDtoOutput',
              'party',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminTicketPageDtoOutput',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminTicketPageDtoOutput',
              'partyName',
            ),
            orderId: orderId,
            orderNumber: orderNumber,
            urgent: BuiltValueNullFieldError.checkNotNull(
              urgent,
              r'AdminTicketPageDtoOutput',
              'urgent',
            ),
            typeCode: BuiltValueNullFieldError.checkNotNull(
              typeCode,
              r'AdminTicketPageDtoOutput',
              'typeCode',
            ),
            typeLabel: BuiltValueNullFieldError.checkNotNull(
              typeLabel,
              r'AdminTicketPageDtoOutput',
              'typeLabel',
            ),
            description: BuiltValueNullFieldError.checkNotNull(
              description,
              r'AdminTicketPageDtoOutput',
              'description',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminTicketPageDtoOutput',
              'status',
            ),
            assigneeId: assigneeId,
            assigneeName: assigneeName,
            sla: sla.build(),
            openedByName: openedByName,
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminTicketPageDtoOutput',
              'openedAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'AdminTicketPageDtoOutput',
              'updatedAt',
            ),
            notes: notes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sla';
        sla.build();

        _$failedField = 'notes';
        notes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketPageDtoOutput',
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
