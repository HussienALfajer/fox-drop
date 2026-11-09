// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_cancelled.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputCancelledCashEnum
_$captainActiveOrderDtoOutputCancelledCashEnum_returned =
    const CaptainActiveOrderDtoOutputCancelledCashEnum._('returned');
const CaptainActiveOrderDtoOutputCancelledCashEnum
_$captainActiveOrderDtoOutputCancelledCashEnum_notReturned =
    const CaptainActiveOrderDtoOutputCancelledCashEnum._('notReturned');
const CaptainActiveOrderDtoOutputCancelledCashEnum
_$captainActiveOrderDtoOutputCancelledCashEnum_notPaid =
    const CaptainActiveOrderDtoOutputCancelledCashEnum._('notPaid');

CaptainActiveOrderDtoOutputCancelledCashEnum
_$captainActiveOrderDtoOutputCancelledCashEnumValueOf(String name) {
  switch (name) {
    case 'returned':
      return _$captainActiveOrderDtoOutputCancelledCashEnum_returned;
    case 'notReturned':
      return _$captainActiveOrderDtoOutputCancelledCashEnum_notReturned;
    case 'notPaid':
      return _$captainActiveOrderDtoOutputCancelledCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputCancelledCashEnum>
_$captainActiveOrderDtoOutputCancelledCashEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputCancelledCashEnum>(
      const <CaptainActiveOrderDtoOutputCancelledCashEnum>[
        _$captainActiveOrderDtoOutputCancelledCashEnum_returned,
        _$captainActiveOrderDtoOutputCancelledCashEnum_notReturned,
        _$captainActiveOrderDtoOutputCancelledCashEnum_notPaid,
      ],
    );

Serializer<CaptainActiveOrderDtoOutputCancelledCashEnum>
_$captainActiveOrderDtoOutputCancelledCashEnumSerializer =
    _$CaptainActiveOrderDtoOutputCancelledCashEnumSerializer();

class _$CaptainActiveOrderDtoOutputCancelledCashEnumSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputCancelledCashEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'returned': 'returned',
    'notReturned': 'not_returned',
    'notPaid': 'not_paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'returned': 'returned',
    'not_returned': 'notReturned',
    'not_paid': 'notPaid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputCancelledCashEnum,
  ];
  @override
  final String wireName = 'CaptainActiveOrderDtoOutputCancelledCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputCancelledCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputCancelledCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputCancelledCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputCancelled
    extends CaptainActiveOrderDtoOutputCancelled {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final String reason;
  @override
  final CaptainActiveOrderDtoOutputCancelledCashEnum? cash;
  @override
  final CaptainWentOfflineDtoOutputHandIn? compensation;
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputCancelled([
    void Function(CaptainActiveOrderDtoOutputCancelledBuilder)? updates,
  ]) =>
      (CaptainActiveOrderDtoOutputCancelledBuilder()..update(updates))._build();

  _$CaptainActiveOrderDtoOutputCancelled._({
    required this.orderId,
    required this.number,
    required this.reason,
    this.cash,
    this.compensation,
    required this.at,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputCancelled rebuild(
    void Function(CaptainActiveOrderDtoOutputCancelledBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputCancelledBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputCancelledBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputCancelled &&
        orderId == other.orderId &&
        number == other.number &&
        reason == other.reason &&
        cash == other.cash &&
        compensation == other.compensation &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, compensation.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainActiveOrderDtoOutputCancelled')
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('reason', reason)
          ..add('cash', cash)
          ..add('compensation', compensation)
          ..add('at', at))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputCancelledBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputCancelled,
          CaptainActiveOrderDtoOutputCancelledBuilder
        > {
  _$CaptainActiveOrderDtoOutputCancelled? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CaptainActiveOrderDtoOutputCancelledCashEnum? _cash;
  CaptainActiveOrderDtoOutputCancelledCashEnum? get cash => _$this._cash;
  set cash(CaptainActiveOrderDtoOutputCancelledCashEnum? cash) =>
      _$this._cash = cash;

  CaptainWentOfflineDtoOutputHandInBuilder? _compensation;
  CaptainWentOfflineDtoOutputHandInBuilder get compensation =>
      _$this._compensation ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set compensation(CaptainWentOfflineDtoOutputHandInBuilder? compensation) =>
      _$this._compensation = compensation;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputCancelledBuilder() {
    CaptainActiveOrderDtoOutputCancelled._defaults(this);
  }

  CaptainActiveOrderDtoOutputCancelledBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _reason = $v.reason;
      _cash = $v.cash;
      _compensation = $v.compensation?.toBuilder();
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputCancelled other) {
    _$v = other as _$CaptainActiveOrderDtoOutputCancelled;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputCancelledBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputCancelled build() => _build();

  _$CaptainActiveOrderDtoOutputCancelled _build() {
    _$CaptainActiveOrderDtoOutputCancelled _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputCancelled._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'CaptainActiveOrderDtoOutputCancelled',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CaptainActiveOrderDtoOutputCancelled',
              'number',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'CaptainActiveOrderDtoOutputCancelled',
              'reason',
            ),
            cash: cash,
            compensation: _compensation?.build(),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CaptainActiveOrderDtoOutputCancelled',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'compensation';
        _compensation?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputCancelled',
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
