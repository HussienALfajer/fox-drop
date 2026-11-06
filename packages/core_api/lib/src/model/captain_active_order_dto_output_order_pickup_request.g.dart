// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_pickup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_open =
    const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum._('open');
const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_confirmed =
    const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum._(
      'confirmed',
    );
const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_rejected =
    const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum._('rejected');
const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_voided =
    const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum._('voided');

CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_open;
    case 'confirmed':
      return _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_confirmed;
    case 'rejected':
      return _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_rejected;
    case 'voided':
      return _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_voided;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum>
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum>(
      const <CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum>[
        _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_open,
        _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_confirmed,
        _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_rejected,
        _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_voided,
      ],
    );

const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant =
    const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'restaurant',
    );
const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic =
    const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'automatic',
    );
const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_operations =
    const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'operations',
    );
const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect =
    const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'amountIncorrect',
    );
const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete =
    const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'incomplete',
    );
const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled =
    const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'cancelled',
    );

CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
    case 'automatic':
      return _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic;
    case 'operations':
      return _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_operations;
    case 'amountIncorrect':
      return _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
    case 'incomplete':
      return _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
    case 'cancelled':
      return _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum>
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum>(const <
      CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
    >[
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant,
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic,
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_operations,
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect,
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete,
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled,
    ]);

Serializer<CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum>
_$captainActiveOrderDtoOutputOrderPickupRequestStatusEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnumSerializer();
Serializer<CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum>
_$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer();

class _$CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
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
    CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum,
  ];
  @override
  final String wireName =
      'CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
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
    CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum,
  ];
  @override
  final String wireName =
      'CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderPickupRequest
    extends CaptainActiveOrderDtoOutputOrderPickupRequest {
  @override
  final String id;
  @override
  final CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum status;
  @override
  final CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum? outcome;
  @override
  final CaptainActiveOrderDtoOutputOrderPickupRequestAmount amount;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> lines;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? receivedLines;
  @override
  final DateTime openedAt;
  @override
  final DateTime confirmBy;
  @override
  final DateTime? closedAt;

  factory _$CaptainActiveOrderDtoOutputOrderPickupRequest([
    void Function(CaptainActiveOrderDtoOutputOrderPickupRequestBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderPickupRequestBuilder()..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderPickupRequest._({
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
  CaptainActiveOrderDtoOutputOrderPickupRequest rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderPickupRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderPickupRequestBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderPickupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderPickupRequest &&
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
            r'CaptainActiveOrderDtoOutputOrderPickupRequest',
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

class CaptainActiveOrderDtoOutputOrderPickupRequestBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderPickupRequest,
          CaptainActiveOrderDtoOutputOrderPickupRequestBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderPickupRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum? _status;
  CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum? get status =>
      _$this._status;
  set status(CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum? status) =>
      _$this._status = status;

  CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum? _outcome;
  CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(
    CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder? _amount;
  CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder get amount =>
      _$this._amount ??=
          CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder();
  set amount(
    CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder? amount,
  ) => _$this._amount = amount;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _lines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get lines =>
      _$this._lines ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set lines(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? lines) =>
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

  CaptainActiveOrderDtoOutputOrderPickupRequestBuilder() {
    CaptainActiveOrderDtoOutputOrderPickupRequest._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderPickupRequestBuilder get _$this {
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
  void replace(CaptainActiveOrderDtoOutputOrderPickupRequest other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderPickupRequest;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderPickupRequestBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderPickupRequest build() => _build();

  _$CaptainActiveOrderDtoOutputOrderPickupRequest _build() {
    _$CaptainActiveOrderDtoOutputOrderPickupRequest _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderPickupRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainActiveOrderDtoOutputOrderPickupRequest',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CaptainActiveOrderDtoOutputOrderPickupRequest',
              'status',
            ),
            outcome: outcome,
            amount: amount.build(),
            lines: lines.build(),
            receivedLines: _receivedLines?.build(),
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'CaptainActiveOrderDtoOutputOrderPickupRequest',
              'openedAt',
            ),
            confirmBy: BuiltValueNullFieldError.checkNotNull(
              confirmBy,
              r'CaptainActiveOrderDtoOutputOrderPickupRequest',
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
          r'CaptainActiveOrderDtoOutputOrderPickupRequest',
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
