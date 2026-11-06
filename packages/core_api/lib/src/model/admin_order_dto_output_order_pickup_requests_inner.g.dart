// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_pickup_requests_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_open =
    const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum._('open');
const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_confirmed =
    const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum._('confirmed');
const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_rejected =
    const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum._('rejected');
const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_voided =
    const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum._('voided');

AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_open;
    case 'confirmed':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_confirmed;
    case 'rejected':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_rejected;
    case 'voided':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_voided;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum>
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum>(
      const <AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum>[
        _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_open,
        _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_confirmed,
        _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_rejected,
        _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_voided,
      ],
    );

const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_restaurant =
    const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._(
      'restaurant',
    );
const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_automatic =
    const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._('automatic');
const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_operations =
    const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._(
      'operations',
    );
const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_amountIncorrect =
    const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._(
      'amountIncorrect',
    );
const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_incomplete =
    const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._(
      'incomplete',
    );
const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_cancelled =
    const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._('cancelled');

AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_restaurant;
    case 'automatic':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_automatic;
    case 'operations':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_operations;
    case 'amountIncorrect':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_amountIncorrect;
    case 'incomplete':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_incomplete;
    case 'cancelled':
      return _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum>
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum>(const <
      AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
    >[
      _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_restaurant,
      _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_automatic,
      _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_operations,
      _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_amountIncorrect,
      _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_incomplete,
      _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_cancelled,
    ]);

Serializer<AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum>
_$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnumSerializer =
    _$AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnumSerializer();
Serializer<AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum>
_$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumSerializer =
    _$AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumSerializer();

class _$AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'confirmed': 'confirmed',
    'rejected': 'rejected',
    'voided': 'voided',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'confirmed': 'confirmed',
    'rejected': 'rejected',
    'voided': 'voided',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'automatic': 'automatic',
    'operations': 'operations',
    'amountIncorrect': 'amount_incorrect',
    'incomplete': 'incomplete',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'automatic': 'automatic',
    'operations': 'operations',
    'amount_incorrect': 'amountIncorrect',
    'incomplete': 'incomplete',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderPickupRequestsInner
    extends AdminOrderDtoOutputOrderPickupRequestsInner {
  @override
  final String id;
  @override
  final AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum status;
  @override
  final AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum? outcome;
  @override
  final String captainId;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> lines;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?>? bookedLines;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? receivedLines;
  @override
  final DateTime openedAt;
  @override
  final DateTime? closedAt;
  @override
  final AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy? closedBy;

  factory _$AdminOrderDtoOutputOrderPickupRequestsInner([
    void Function(AdminOrderDtoOutputOrderPickupRequestsInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderPickupRequestsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderPickupRequestsInner._({
    required this.id,
    required this.status,
    this.outcome,
    required this.captainId,
    required this.lines,
    this.bookedLines,
    this.receivedLines,
    required this.openedAt,
    this.closedAt,
    this.closedBy,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderPickupRequestsInner rebuild(
    void Function(AdminOrderDtoOutputOrderPickupRequestsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderPickupRequestsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderPickupRequestsInner &&
        id == other.id &&
        status == other.status &&
        outcome == other.outcome &&
        captainId == other.captainId &&
        lines == other.lines &&
        bookedLines == other.bookedLines &&
        receivedLines == other.receivedLines &&
        openedAt == other.openedAt &&
        closedAt == other.closedAt &&
        closedBy == other.closedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, bookedLines.hashCode);
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderPickupRequestsInner',
          )
          ..add('id', id)
          ..add('status', status)
          ..add('outcome', outcome)
          ..add('captainId', captainId)
          ..add('lines', lines)
          ..add('bookedLines', bookedLines)
          ..add('receivedLines', receivedLines)
          ..add('openedAt', openedAt)
          ..add('closedAt', closedAt)
          ..add('closedBy', closedBy))
        .toString();
  }
}

class AdminOrderDtoOutputOrderPickupRequestsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderPickupRequestsInner,
          AdminOrderDtoOutputOrderPickupRequestsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderPickupRequestsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum? _status;
  AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum? status) =>
      _$this._status = status;

  AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum? _outcome;
  AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(
    AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _lines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get lines =>
      _$this._lines ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set lines(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? lines) =>
      _$this._lines = lines;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _bookedLines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get bookedLines =>
      _$this._bookedLines ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set bookedLines(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? bookedLines,
  ) => _$this._bookedLines = bookedLines;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _receivedLines;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get receivedLines =>
      _$this._receivedLines ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set receivedLines(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? receivedLines,
  ) => _$this._receivedLines = receivedLines;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(DateTime? openedAt) => _$this._openedAt = openedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder? _closedBy;
  AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder get closedBy =>
      _$this._closedBy ??=
          AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder();
  set closedBy(
    AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder? closedBy,
  ) => _$this._closedBy = closedBy;

  AdminOrderDtoOutputOrderPickupRequestsInnerBuilder() {
    AdminOrderDtoOutputOrderPickupRequestsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderPickupRequestsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _outcome = $v.outcome;
      _captainId = $v.captainId;
      _lines = $v.lines.toBuilder();
      _bookedLines = $v.bookedLines?.toBuilder();
      _receivedLines = $v.receivedLines?.toBuilder();
      _openedAt = $v.openedAt;
      _closedAt = $v.closedAt;
      _closedBy = $v.closedBy?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderPickupRequestsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderPickupRequestsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderPickupRequestsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderPickupRequestsInner build() => _build();

  _$AdminOrderDtoOutputOrderPickupRequestsInner _build() {
    _$AdminOrderDtoOutputOrderPickupRequestsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderPickupRequestsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderDtoOutputOrderPickupRequestsInner',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderDtoOutputOrderPickupRequestsInner',
              'status',
            ),
            outcome: outcome,
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminOrderDtoOutputOrderPickupRequestsInner',
              'captainId',
            ),
            lines: lines.build(),
            bookedLines: _bookedLines?.build(),
            receivedLines: _receivedLines?.build(),
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminOrderDtoOutputOrderPickupRequestsInner',
              'openedAt',
            ),
            closedAt: closedAt,
            closedBy: _closedBy?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'bookedLines';
        _bookedLines?.build();
        _$failedField = 'receivedLines';
        _receivedLines?.build();

        _$failedField = 'closedBy';
        _closedBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderPickupRequestsInner',
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
