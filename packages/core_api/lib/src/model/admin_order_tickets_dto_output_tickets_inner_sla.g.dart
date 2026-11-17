// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_tickets_dto_output_tickets_inner_sla.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum
_$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_firstResponse =
    const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum._('firstResponse');
const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum
_$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_resolution =
    const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum._('resolution');

AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum
_$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnumValueOf(String name) {
  switch (name) {
    case 'firstResponse':
      return _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_firstResponse;
    case 'resolution':
      return _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_resolution;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum>
_$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnumValues =
    BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum>(
      const <AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum>[
        _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_firstResponse,
        _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_resolution,
      ],
    );

Serializer<AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum>
_$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnumSerializer =
    _$AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnumSerializer();

class _$AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'firstResponse': 'first_response',
    'resolution': 'resolution',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'first_response': 'firstResponse',
    'resolution': 'resolution',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum,
  ];
  @override
  final String wireName = 'AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderTicketsDtoOutputTicketsInnerSla
    extends AdminOrderTicketsDtoOutputTicketsInnerSla {
  @override
  final AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum kind;
  @override
  final DateTime startedAt;
  @override
  final DateTime dueAt;
  @override
  final DateTime? stoppedAt;

  factory _$AdminOrderTicketsDtoOutputTicketsInnerSla([
    void Function(AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder)? updates,
  ]) => (AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder()..update(updates))
      ._build();

  _$AdminOrderTicketsDtoOutputTicketsInnerSla._({
    required this.kind,
    required this.startedAt,
    required this.dueAt,
    this.stoppedAt,
  }) : super._();
  @override
  AdminOrderTicketsDtoOutputTicketsInnerSla rebuild(
    void Function(AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder toBuilder() =>
      AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderTicketsDtoOutputTicketsInnerSla &&
        kind == other.kind &&
        startedAt == other.startedAt &&
        dueAt == other.dueAt &&
        stoppedAt == other.stoppedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, stoppedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderTicketsDtoOutputTicketsInnerSla',
          )
          ..add('kind', kind)
          ..add('startedAt', startedAt)
          ..add('dueAt', dueAt)
          ..add('stoppedAt', stoppedAt))
        .toString();
  }
}

class AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder
    implements
        Builder<
          AdminOrderTicketsDtoOutputTicketsInnerSla,
          AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder
        > {
  _$AdminOrderTicketsDtoOutputTicketsInnerSla? _$v;

  AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum? _kind;
  AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum? get kind => _$this._kind;
  set kind(AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum? kind) =>
      _$this._kind = kind;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  DateTime? _stoppedAt;
  DateTime? get stoppedAt => _$this._stoppedAt;
  set stoppedAt(DateTime? stoppedAt) => _$this._stoppedAt = stoppedAt;

  AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder() {
    AdminOrderTicketsDtoOutputTicketsInnerSla._defaults(this);
  }

  AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _startedAt = $v.startedAt;
      _dueAt = $v.dueAt;
      _stoppedAt = $v.stoppedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderTicketsDtoOutputTicketsInnerSla other) {
    _$v = other as _$AdminOrderTicketsDtoOutputTicketsInnerSla;
  }

  @override
  void update(
    void Function(AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerSla build() => _build();

  _$AdminOrderTicketsDtoOutputTicketsInnerSla _build() {
    final _$result =
        _$v ??
        _$AdminOrderTicketsDtoOutputTicketsInnerSla._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminOrderTicketsDtoOutputTicketsInnerSla',
            'kind',
          ),
          startedAt: BuiltValueNullFieldError.checkNotNull(
            startedAt,
            r'AdminOrderTicketsDtoOutputTicketsInnerSla',
            'startedAt',
          ),
          dueAt: BuiltValueNullFieldError.checkNotNull(
            dueAt,
            r'AdminOrderTicketsDtoOutputTicketsInnerSla',
            'dueAt',
          ),
          stoppedAt: stoppedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
