// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_dto_output_order_pickup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrderDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderDtoOutputOrderPickupRequestStatusEnum_open =
    const MerchantOrderDtoOutputOrderPickupRequestStatusEnum._('open');
const MerchantOrderDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderDtoOutputOrderPickupRequestStatusEnum_confirmed =
    const MerchantOrderDtoOutputOrderPickupRequestStatusEnum._('confirmed');
const MerchantOrderDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderDtoOutputOrderPickupRequestStatusEnum_rejected =
    const MerchantOrderDtoOutputOrderPickupRequestStatusEnum._('rejected');
const MerchantOrderDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderDtoOutputOrderPickupRequestStatusEnum_voided =
    const MerchantOrderDtoOutputOrderPickupRequestStatusEnum._('voided');

MerchantOrderDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderDtoOutputOrderPickupRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_open;
    case 'confirmed':
      return _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_confirmed;
    case 'rejected':
      return _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_rejected;
    case 'voided':
      return _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_voided;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrderDtoOutputOrderPickupRequestStatusEnum>
_$merchantOrderDtoOutputOrderPickupRequestStatusEnumValues =
    BuiltSet<MerchantOrderDtoOutputOrderPickupRequestStatusEnum>(
      const <MerchantOrderDtoOutputOrderPickupRequestStatusEnum>[
        _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_open,
        _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_confirmed,
        _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_rejected,
        _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_voided,
      ],
    );

const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant =
    const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._('restaurant');
const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic =
    const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._('automatic');
const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_operations =
    const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._('operations');
const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect =
    const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._(
      'amountIncorrect',
    );
const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete =
    const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._('incomplete');
const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled =
    const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._('cancelled');

MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
    case 'automatic':
      return _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic;
    case 'operations':
      return _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_operations;
    case 'amountIncorrect':
      return _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
    case 'incomplete':
      return _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
    case 'cancelled':
      return _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum>
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnumValues =
    BuiltSet<MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum>(
      const <MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum>[
        _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant,
        _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic,
        _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_operations,
        _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect,
        _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete,
        _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled,
      ],
    );

Serializer<MerchantOrderDtoOutputOrderPickupRequestStatusEnum>
_$merchantOrderDtoOutputOrderPickupRequestStatusEnumSerializer =
    _$MerchantOrderDtoOutputOrderPickupRequestStatusEnumSerializer();
Serializer<MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum>
_$merchantOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer =
    _$MerchantOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer();

class _$MerchantOrderDtoOutputOrderPickupRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderDtoOutputOrderPickupRequestStatusEnum
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
    MerchantOrderDtoOutputOrderPickupRequestStatusEnum,
  ];
  @override
  final String wireName = 'MerchantOrderDtoOutputOrderPickupRequestStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderDtoOutputOrderPickupRequestStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrderDtoOutputOrderPickupRequestStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrderDtoOutputOrderPickupRequestStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
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
    MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum,
  ];
  @override
  final String wireName = 'MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrderDtoOutputOrderPickupRequest
    extends MerchantOrderDtoOutputOrderPickupRequest {
  @override
  final String id;
  @override
  final MerchantOrderDtoOutputOrderPickupRequestStatusEnum status;
  @override
  final MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum? outcome;
  @override
  final CaptainAvailabilityDtoOutputCustodyLimit amount;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> lines;
  @override
  final String baseEquivalent;
  @override
  final DateTime confirmBy;
  @override
  final DateTime? closedAt;
  @override
  final String? closedByDeviceName;

  factory _$MerchantOrderDtoOutputOrderPickupRequest([
    void Function(MerchantOrderDtoOutputOrderPickupRequestBuilder)? updates,
  ]) => (MerchantOrderDtoOutputOrderPickupRequestBuilder()..update(updates))
      ._build();

  _$MerchantOrderDtoOutputOrderPickupRequest._({
    required this.id,
    required this.status,
    this.outcome,
    required this.amount,
    required this.lines,
    required this.baseEquivalent,
    required this.confirmBy,
    this.closedAt,
    this.closedByDeviceName,
  }) : super._();
  @override
  MerchantOrderDtoOutputOrderPickupRequest rebuild(
    void Function(MerchantOrderDtoOutputOrderPickupRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderDtoOutputOrderPickupRequestBuilder toBuilder() =>
      MerchantOrderDtoOutputOrderPickupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderDtoOutputOrderPickupRequest &&
        id == other.id &&
        status == other.status &&
        outcome == other.outcome &&
        amount == other.amount &&
        lines == other.lines &&
        baseEquivalent == other.baseEquivalent &&
        confirmBy == other.confirmBy &&
        closedAt == other.closedAt &&
        closedByDeviceName == other.closedByDeviceName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, baseEquivalent.hashCode);
    _$hash = $jc(_$hash, confirmBy.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closedByDeviceName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrderDtoOutputOrderPickupRequest',
          )
          ..add('id', id)
          ..add('status', status)
          ..add('outcome', outcome)
          ..add('amount', amount)
          ..add('lines', lines)
          ..add('baseEquivalent', baseEquivalent)
          ..add('confirmBy', confirmBy)
          ..add('closedAt', closedAt)
          ..add('closedByDeviceName', closedByDeviceName))
        .toString();
  }
}

class MerchantOrderDtoOutputOrderPickupRequestBuilder
    implements
        Builder<
          MerchantOrderDtoOutputOrderPickupRequest,
          MerchantOrderDtoOutputOrderPickupRequestBuilder
        > {
  _$MerchantOrderDtoOutputOrderPickupRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MerchantOrderDtoOutputOrderPickupRequestStatusEnum? _status;
  MerchantOrderDtoOutputOrderPickupRequestStatusEnum? get status =>
      _$this._status;
  set status(MerchantOrderDtoOutputOrderPickupRequestStatusEnum? status) =>
      _$this._status = status;

  MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum? _outcome;
  MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  CaptainAvailabilityDtoOutputCustodyLimitBuilder? _amount;
  CaptainAvailabilityDtoOutputCustodyLimitBuilder get amount =>
      _$this._amount ??= CaptainAvailabilityDtoOutputCustodyLimitBuilder();
  set amount(CaptainAvailabilityDtoOutputCustodyLimitBuilder? amount) =>
      _$this._amount = amount;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _lines;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get lines =>
      _$this._lines ??= ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set lines(ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? lines) =>
      _$this._lines = lines;

  String? _baseEquivalent;
  String? get baseEquivalent => _$this._baseEquivalent;
  set baseEquivalent(String? baseEquivalent) =>
      _$this._baseEquivalent = baseEquivalent;

  DateTime? _confirmBy;
  DateTime? get confirmBy => _$this._confirmBy;
  set confirmBy(DateTime? confirmBy) => _$this._confirmBy = confirmBy;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _closedByDeviceName;
  String? get closedByDeviceName => _$this._closedByDeviceName;
  set closedByDeviceName(String? closedByDeviceName) =>
      _$this._closedByDeviceName = closedByDeviceName;

  MerchantOrderDtoOutputOrderPickupRequestBuilder() {
    MerchantOrderDtoOutputOrderPickupRequest._defaults(this);
  }

  MerchantOrderDtoOutputOrderPickupRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _outcome = $v.outcome;
      _amount = $v.amount.toBuilder();
      _lines = $v.lines.toBuilder();
      _baseEquivalent = $v.baseEquivalent;
      _confirmBy = $v.confirmBy;
      _closedAt = $v.closedAt;
      _closedByDeviceName = $v.closedByDeviceName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderDtoOutputOrderPickupRequest other) {
    _$v = other as _$MerchantOrderDtoOutputOrderPickupRequest;
  }

  @override
  void update(
    void Function(MerchantOrderDtoOutputOrderPickupRequestBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderDtoOutputOrderPickupRequest build() => _build();

  _$MerchantOrderDtoOutputOrderPickupRequest _build() {
    _$MerchantOrderDtoOutputOrderPickupRequest _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrderDtoOutputOrderPickupRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantOrderDtoOutputOrderPickupRequest',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantOrderDtoOutputOrderPickupRequest',
              'status',
            ),
            outcome: outcome,
            amount: amount.build(),
            lines: lines.build(),
            baseEquivalent: BuiltValueNullFieldError.checkNotNull(
              baseEquivalent,
              r'MerchantOrderDtoOutputOrderPickupRequest',
              'baseEquivalent',
            ),
            confirmBy: BuiltValueNullFieldError.checkNotNull(
              confirmBy,
              r'MerchantOrderDtoOutputOrderPickupRequest',
              'confirmBy',
            ),
            closedAt: closedAt,
            closedByDeviceName: closedByDeviceName,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        amount.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrderDtoOutputOrderPickupRequest',
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
