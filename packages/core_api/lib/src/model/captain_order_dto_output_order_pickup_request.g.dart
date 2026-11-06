// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_dto_output_order_pickup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainOrderDtoOutputOrderPickupRequestStatusEnum
_$captainOrderDtoOutputOrderPickupRequestStatusEnum_open =
    const CaptainOrderDtoOutputOrderPickupRequestStatusEnum._('open');
const CaptainOrderDtoOutputOrderPickupRequestStatusEnum
_$captainOrderDtoOutputOrderPickupRequestStatusEnum_confirmed =
    const CaptainOrderDtoOutputOrderPickupRequestStatusEnum._('confirmed');
const CaptainOrderDtoOutputOrderPickupRequestStatusEnum
_$captainOrderDtoOutputOrderPickupRequestStatusEnum_rejected =
    const CaptainOrderDtoOutputOrderPickupRequestStatusEnum._('rejected');
const CaptainOrderDtoOutputOrderPickupRequestStatusEnum
_$captainOrderDtoOutputOrderPickupRequestStatusEnum_voided =
    const CaptainOrderDtoOutputOrderPickupRequestStatusEnum._('voided');

CaptainOrderDtoOutputOrderPickupRequestStatusEnum
_$captainOrderDtoOutputOrderPickupRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$captainOrderDtoOutputOrderPickupRequestStatusEnum_open;
    case 'confirmed':
      return _$captainOrderDtoOutputOrderPickupRequestStatusEnum_confirmed;
    case 'rejected':
      return _$captainOrderDtoOutputOrderPickupRequestStatusEnum_rejected;
    case 'voided':
      return _$captainOrderDtoOutputOrderPickupRequestStatusEnum_voided;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainOrderDtoOutputOrderPickupRequestStatusEnum>
_$captainOrderDtoOutputOrderPickupRequestStatusEnumValues =
    BuiltSet<CaptainOrderDtoOutputOrderPickupRequestStatusEnum>(
      const <CaptainOrderDtoOutputOrderPickupRequestStatusEnum>[
        _$captainOrderDtoOutputOrderPickupRequestStatusEnum_open,
        _$captainOrderDtoOutputOrderPickupRequestStatusEnum_confirmed,
        _$captainOrderDtoOutputOrderPickupRequestStatusEnum_rejected,
        _$captainOrderDtoOutputOrderPickupRequestStatusEnum_voided,
      ],
    );

const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant =
    const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._('restaurant');
const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic =
    const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._('automatic');
const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_operations =
    const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._('operations');
const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect =
    const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'amountIncorrect',
    );
const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete =
    const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._('incomplete');
const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled =
    const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._('cancelled');

CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
    case 'automatic':
      return _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic;
    case 'operations':
      return _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_operations;
    case 'amountIncorrect':
      return _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
    case 'incomplete':
      return _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
    case 'cancelled':
      return _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum>
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnumValues =
    BuiltSet<CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum>(
      const <CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum>[
        _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant,
        _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic,
        _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_operations,
        _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect,
        _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete,
        _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled,
      ],
    );

Serializer<CaptainOrderDtoOutputOrderPickupRequestStatusEnum>
_$captainOrderDtoOutputOrderPickupRequestStatusEnumSerializer =
    _$CaptainOrderDtoOutputOrderPickupRequestStatusEnumSerializer();
Serializer<CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum>
_$captainOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer =
    _$CaptainOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer();

class _$CaptainOrderDtoOutputOrderPickupRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<CaptainOrderDtoOutputOrderPickupRequestStatusEnum> {
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
    CaptainOrderDtoOutputOrderPickupRequestStatusEnum,
  ];
  @override
  final String wireName = 'CaptainOrderDtoOutputOrderPickupRequestStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrderPickupRequestStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainOrderDtoOutputOrderPickupRequestStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainOrderDtoOutputOrderPickupRequestStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum
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
    CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum,
  ];
  @override
  final String wireName = 'CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainOrderDtoOutputOrderPickupRequest
    extends CaptainOrderDtoOutputOrderPickupRequest {
  @override
  final String id;
  @override
  final CaptainOrderDtoOutputOrderPickupRequestStatusEnum status;
  @override
  final CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum? outcome;
  @override
  final CaptainActiveOrderDtoOutputOrderPickupRequestAmount amount;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> lines;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? receivedLines;
  @override
  final DateTime openedAt;
  @override
  final DateTime confirmBy;
  @override
  final DateTime? closedAt;

  factory _$CaptainOrderDtoOutputOrderPickupRequest([
    void Function(CaptainOrderDtoOutputOrderPickupRequestBuilder)? updates,
  ]) => (CaptainOrderDtoOutputOrderPickupRequestBuilder()..update(updates))
      ._build();

  _$CaptainOrderDtoOutputOrderPickupRequest._({
    required this.id,
    required this.status,
    this.outcome,
    required this.amount,
    required this.lines,
    this.receivedLines,
    required this.openedAt,
    required this.confirmBy,
    this.closedAt,
  }) : super._();
  @override
  CaptainOrderDtoOutputOrderPickupRequest rebuild(
    void Function(CaptainOrderDtoOutputOrderPickupRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderDtoOutputOrderPickupRequestBuilder toBuilder() =>
      CaptainOrderDtoOutputOrderPickupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderDtoOutputOrderPickupRequest &&
        id == other.id &&
        status == other.status &&
        outcome == other.outcome &&
        amount == other.amount &&
        lines == other.lines &&
        receivedLines == other.receivedLines &&
        openedAt == other.openedAt &&
        confirmBy == other.confirmBy &&
        closedAt == other.closedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, confirmBy.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainOrderDtoOutputOrderPickupRequest',
          )
          ..add('id', id)
          ..add('status', status)
          ..add('outcome', outcome)
          ..add('amount', amount)
          ..add('lines', lines)
          ..add('receivedLines', receivedLines)
          ..add('openedAt', openedAt)
          ..add('confirmBy', confirmBy)
          ..add('closedAt', closedAt))
        .toString();
  }
}

class CaptainOrderDtoOutputOrderPickupRequestBuilder
    implements
        Builder<
          CaptainOrderDtoOutputOrderPickupRequest,
          CaptainOrderDtoOutputOrderPickupRequestBuilder
        > {
  _$CaptainOrderDtoOutputOrderPickupRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CaptainOrderDtoOutputOrderPickupRequestStatusEnum? _status;
  CaptainOrderDtoOutputOrderPickupRequestStatusEnum? get status =>
      _$this._status;
  set status(CaptainOrderDtoOutputOrderPickupRequestStatusEnum? status) =>
      _$this._status = status;

  CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum? _outcome;
  CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder? _amount;
  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder get amount =>
      _$this._amount ??=
          CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder();
  set amount(
    CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder? amount,
  ) => _$this._amount = amount;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _lines;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get lines =>
      _$this._lines ??= ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set lines(ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? lines) =>
      _$this._lines = lines;

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

  DateTime? _confirmBy;
  DateTime? get confirmBy => _$this._confirmBy;
  set confirmBy(DateTime? confirmBy) => _$this._confirmBy = confirmBy;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  CaptainOrderDtoOutputOrderPickupRequestBuilder() {
    CaptainOrderDtoOutputOrderPickupRequest._defaults(this);
  }

  CaptainOrderDtoOutputOrderPickupRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _outcome = $v.outcome;
      _amount = $v.amount.toBuilder();
      _lines = $v.lines.toBuilder();
      _receivedLines = $v.receivedLines?.toBuilder();
      _openedAt = $v.openedAt;
      _confirmBy = $v.confirmBy;
      _closedAt = $v.closedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderDtoOutputOrderPickupRequest other) {
    _$v = other as _$CaptainOrderDtoOutputOrderPickupRequest;
  }

  @override
  void update(
    void Function(CaptainOrderDtoOutputOrderPickupRequestBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderDtoOutputOrderPickupRequest build() => _build();

  _$CaptainOrderDtoOutputOrderPickupRequest _build() {
    _$CaptainOrderDtoOutputOrderPickupRequest _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderDtoOutputOrderPickupRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainOrderDtoOutputOrderPickupRequest',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CaptainOrderDtoOutputOrderPickupRequest',
              'status',
            ),
            outcome: outcome,
            amount: amount.build(),
            lines: lines.build(),
            receivedLines: _receivedLines?.build(),
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'CaptainOrderDtoOutputOrderPickupRequest',
              'openedAt',
            ),
            confirmBy: BuiltValueNullFieldError.checkNotNull(
              confirmBy,
              r'CaptainOrderDtoOutputOrderPickupRequest',
              'confirmBy',
            ),
            closedAt: closedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        amount.build();
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'receivedLines';
        _receivedLines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderDtoOutputOrderPickupRequest',
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
