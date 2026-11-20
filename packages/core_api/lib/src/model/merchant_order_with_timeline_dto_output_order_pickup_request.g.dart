// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_with_timeline_dto_output_order_pickup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_open =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum._(
      'open',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_confirmed =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum._(
      'confirmed',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_rejected =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum._(
      'rejected',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_voided =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum._(
      'voided',
    );

MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'open':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_open;
    case 'confirmed':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_confirmed;
    case 'rejected':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_rejected;
    case 'voided':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_voided;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum>
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumValues =
    BuiltSet<
      MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
    >(const <MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum>[
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_open,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_confirmed,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_rejected,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_voided,
    ]);

const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_restaurant =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
      'restaurant',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_automatic =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
      'automatic',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_operations =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
      'operations',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
      'amountIncorrect',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_incomplete =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
      'incomplete',
    );
const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_cancelled =
    const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
      'cancelled',
    );

MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurant':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
    case 'automatic':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_automatic;
    case 'operations':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_operations;
    case 'amountIncorrect':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
    case 'incomplete':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
    case 'cancelled':
      return _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum>
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumValues =
    BuiltSet<
      MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
    >(const <MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum>[
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_restaurant,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_automatic,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_operations,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_incomplete,
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_cancelled,
    ]);

Serializer<MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum>
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumSerializer =
    _$MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumSerializer();
Serializer<MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum>
_$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumSerializer =
    _$MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumSerializer();

class _$MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
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
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum,
  ];
  @override
  final String wireName =
      'MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
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
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum,
  ];
  @override
  final String wireName =
      'MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest
    extends MerchantOrderWithTimelineDtoOutputOrderPickupRequest {
  @override
  final String id;
  @override
  final MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum status;
  @override
  final MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum?
  outcome;
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
  final String? closedByUserName;
  @override
  final String? closedByDeviceName;

  factory _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest([
    void Function(MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder)?
    updates,
  ]) =>
      (MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest._({
    required this.id,
    required this.status,
    this.outcome,
    required this.amount,
    required this.lines,
    required this.baseEquivalent,
    required this.confirmBy,
    this.closedAt,
    this.closedByUserName,
    this.closedByDeviceName,
  }) : super._();
  @override
  MerchantOrderWithTimelineDtoOutputOrderPickupRequest rebuild(
    void Function(MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder toBuilder() =>
      MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderWithTimelineDtoOutputOrderPickupRequest &&
        id == other.id &&
        status == other.status &&
        outcome == other.outcome &&
        amount == other.amount &&
        lines == other.lines &&
        baseEquivalent == other.baseEquivalent &&
        confirmBy == other.confirmBy &&
        closedAt == other.closedAt &&
        closedByUserName == other.closedByUserName &&
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
    _$hash = $jc(_$hash, closedByUserName.hashCode);
    _$hash = $jc(_$hash, closedByDeviceName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest',
          )
          ..add('id', id)
          ..add('status', status)
          ..add('outcome', outcome)
          ..add('amount', amount)
          ..add('lines', lines)
          ..add('baseEquivalent', baseEquivalent)
          ..add('confirmBy', confirmBy)
          ..add('closedAt', closedAt)
          ..add('closedByUserName', closedByUserName)
          ..add('closedByDeviceName', closedByDeviceName))
        .toString();
  }
}

class MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder
    implements
        Builder<
          MerchantOrderWithTimelineDtoOutputOrderPickupRequest,
          MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder
        > {
  _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum? _status;
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum? get status =>
      _$this._status;
  set status(
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum? status,
  ) => _$this._status = status;

  MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum? _outcome;
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum?
  get outcome => _$this._outcome;
  set outcome(
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

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

  String? _closedByUserName;
  String? get closedByUserName => _$this._closedByUserName;
  set closedByUserName(String? closedByUserName) =>
      _$this._closedByUserName = closedByUserName;

  String? _closedByDeviceName;
  String? get closedByDeviceName => _$this._closedByDeviceName;
  set closedByDeviceName(String? closedByDeviceName) =>
      _$this._closedByDeviceName = closedByDeviceName;

  MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder() {
    MerchantOrderWithTimelineDtoOutputOrderPickupRequest._defaults(this);
  }

  MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder get _$this {
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
      _closedByUserName = $v.closedByUserName;
      _closedByDeviceName = $v.closedByDeviceName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderWithTimelineDtoOutputOrderPickupRequest other) {
    _$v = other as _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest;
  }

  @override
  void update(
    void Function(MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderWithTimelineDtoOutputOrderPickupRequest build() => _build();

  _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest _build() {
    _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest',
              'status',
            ),
            outcome: outcome,
            amount: amount.build(),
            lines: lines.build(),
            baseEquivalent: BuiltValueNullFieldError.checkNotNull(
              baseEquivalent,
              r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest',
              'baseEquivalent',
            ),
            confirmBy: BuiltValueNullFieldError.checkNotNull(
              confirmBy,
              r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest',
              'confirmBy',
            ),
            closedAt: closedAt,
            closedByUserName: closedByUserName,
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
          r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest',
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
