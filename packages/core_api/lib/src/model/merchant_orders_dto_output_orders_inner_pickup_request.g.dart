// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_pickup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_open =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum._('open');
const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_confirmed =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum._(
      'confirmed',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_rejected =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum._(
      'rejected',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_voided =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum._('voided');

MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'open':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_open;
    case 'confirmed':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_confirmed;
    case 'rejected':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_rejected;
    case 'voided':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_voided;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum>
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumValues =
    BuiltSet<MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum>(
      const <MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum>[
        _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_open,
        _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_confirmed,
        _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_rejected,
        _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_voided,
      ],
    );

const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_restaurant =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(
      'restaurant',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_automatic =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(
      'automatic',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_operations =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(
      'operations',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_amountIncorrect =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(
      'amountIncorrect',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_incomplete =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(
      'incomplete',
    );
const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_cancelled =
    const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(
      'cancelled',
    );

MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurant':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_restaurant;
    case 'automatic':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_automatic;
    case 'operations':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_operations;
    case 'amountIncorrect':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_amountIncorrect;
    case 'incomplete':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_incomplete;
    case 'cancelled':
      return _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum>
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumValues =
    BuiltSet<MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum>(const <
      MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
    >[
      _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_restaurant,
      _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_automatic,
      _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_operations,
      _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_amountIncorrect,
      _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_incomplete,
      _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_cancelled,
    ]);

Serializer<MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum>
_$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumSerializer =
    _$MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumSerializer();
Serializer<MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum>
_$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumSerializer =
    _$MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumSerializer();

class _$MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum
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
    MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum,
  ];
  @override
  final String wireName =
      'MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum
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
    MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum,
  ];
  @override
  final String wireName =
      'MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrdersDtoOutputOrdersInnerPickupRequest
    extends MerchantOrdersDtoOutputOrdersInnerPickupRequest {
  @override
  final String id;
  @override
  final MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum status;
  @override
  final MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum? outcome;
  @override
  final CaptainWentOfflineDtoOutputHandIn? amount;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> lines;
  @override
  final String baseEquivalent;
  @override
  final DateTime confirmBy;
  @override
  final DateTime? closedAt;
  @override
  final String? closedByDeviceName;

  factory _$MerchantOrdersDtoOutputOrdersInnerPickupRequest([
    void Function(MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder)?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerPickupRequest._({
    required this.id,
    required this.status,
    this.outcome,
    this.amount,
    required this.lines,
    required this.baseEquivalent,
    required this.confirmBy,
    this.closedAt,
    this.closedByDeviceName,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerPickupRequest rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerPickupRequest &&
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
            r'MerchantOrdersDtoOutputOrdersInnerPickupRequest',
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

class MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerPickupRequest,
          MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerPickupRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum? _status;
  MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum? get status =>
      _$this._status;
  set status(
    MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum? status,
  ) => _$this._status = status;

  MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum? _outcome;
  MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(
    MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  CaptainWentOfflineDtoOutputHandInBuilder? _amount;
  CaptainWentOfflineDtoOutputHandInBuilder get amount =>
      _$this._amount ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set amount(CaptainWentOfflineDtoOutputHandInBuilder? amount) =>
      _$this._amount = amount;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _lines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get lines =>
      _$this._lines ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set lines(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? lines) =>
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

  MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder() {
    MerchantOrdersDtoOutputOrdersInnerPickupRequest._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _outcome = $v.outcome;
      _amount = $v.amount?.toBuilder();
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
  void replace(MerchantOrdersDtoOutputOrdersInnerPickupRequest other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerPickupRequest;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerPickupRequest build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerPickupRequest _build() {
    _$MerchantOrdersDtoOutputOrdersInnerPickupRequest _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputOrdersInnerPickupRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantOrdersDtoOutputOrdersInnerPickupRequest',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantOrdersDtoOutputOrdersInnerPickupRequest',
              'status',
            ),
            outcome: outcome,
            amount: _amount?.build(),
            lines: lines.build(),
            baseEquivalent: BuiltValueNullFieldError.checkNotNull(
              baseEquivalent,
              r'MerchantOrdersDtoOutputOrdersInnerPickupRequest',
              'baseEquivalent',
            ),
            confirmBy: BuiltValueNullFieldError.checkNotNull(
              confirmBy,
              r'MerchantOrdersDtoOutputOrdersInnerPickupRequest',
              'confirmBy',
            ),
            closedAt: closedAt,
            closedByDeviceName: closedByDeviceName,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        _amount?.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutputOrdersInnerPickupRequest',
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
