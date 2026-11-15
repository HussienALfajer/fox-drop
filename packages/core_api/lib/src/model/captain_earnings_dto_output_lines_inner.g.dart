// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_earnings_dto_output_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainEarningsDtoOutputLinesInnerKindEnum
_$captainEarningsDtoOutputLinesInnerKindEnum_bonus =
    const CaptainEarningsDtoOutputLinesInnerKindEnum._('bonus');
const CaptainEarningsDtoOutputLinesInnerKindEnum
_$captainEarningsDtoOutputLinesInnerKindEnum_charge =
    const CaptainEarningsDtoOutputLinesInnerKindEnum._('charge');
const CaptainEarningsDtoOutputLinesInnerKindEnum
_$captainEarningsDtoOutputLinesInnerKindEnum_instalment =
    const CaptainEarningsDtoOutputLinesInnerKindEnum._('instalment');
const CaptainEarningsDtoOutputLinesInnerKindEnum
_$captainEarningsDtoOutputLinesInnerKindEnum_payout =
    const CaptainEarningsDtoOutputLinesInnerKindEnum._('payout');
const CaptainEarningsDtoOutputLinesInnerKindEnum
_$captainEarningsDtoOutputLinesInnerKindEnum_adjustment =
    const CaptainEarningsDtoOutputLinesInnerKindEnum._('adjustment');

CaptainEarningsDtoOutputLinesInnerKindEnum
_$captainEarningsDtoOutputLinesInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'bonus':
      return _$captainEarningsDtoOutputLinesInnerKindEnum_bonus;
    case 'charge':
      return _$captainEarningsDtoOutputLinesInnerKindEnum_charge;
    case 'instalment':
      return _$captainEarningsDtoOutputLinesInnerKindEnum_instalment;
    case 'payout':
      return _$captainEarningsDtoOutputLinesInnerKindEnum_payout;
    case 'adjustment':
      return _$captainEarningsDtoOutputLinesInnerKindEnum_adjustment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainEarningsDtoOutputLinesInnerKindEnum>
_$captainEarningsDtoOutputLinesInnerKindEnumValues =
    BuiltSet<CaptainEarningsDtoOutputLinesInnerKindEnum>(
      const <CaptainEarningsDtoOutputLinesInnerKindEnum>[
        _$captainEarningsDtoOutputLinesInnerKindEnum_bonus,
        _$captainEarningsDtoOutputLinesInnerKindEnum_charge,
        _$captainEarningsDtoOutputLinesInnerKindEnum_instalment,
        _$captainEarningsDtoOutputLinesInnerKindEnum_payout,
        _$captainEarningsDtoOutputLinesInnerKindEnum_adjustment,
      ],
    );

Serializer<CaptainEarningsDtoOutputLinesInnerKindEnum>
_$captainEarningsDtoOutputLinesInnerKindEnumSerializer =
    _$CaptainEarningsDtoOutputLinesInnerKindEnumSerializer();

class _$CaptainEarningsDtoOutputLinesInnerKindEnumSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputLinesInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bonus': 'bonus',
    'charge': 'charge',
    'instalment': 'instalment',
    'payout': 'payout',
    'adjustment': 'adjustment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'bonus': 'bonus',
    'charge': 'charge',
    'instalment': 'instalment',
    'payout': 'payout',
    'adjustment': 'adjustment',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainEarningsDtoOutputLinesInnerKindEnum,
  ];
  @override
  final String wireName = 'CaptainEarningsDtoOutputLinesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputLinesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainEarningsDtoOutputLinesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainEarningsDtoOutputLinesInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainEarningsDtoOutputLinesInner
    extends CaptainEarningsDtoOutputLinesInner {
  @override
  final CaptainEarningsDtoOutputLinesInnerKindEnum kind;
  @override
  final String amount;
  @override
  final String? reason;
  @override
  final String? orderNumber;
  @override
  final String? receiptNumber;
  @override
  final DateTime at;

  factory _$CaptainEarningsDtoOutputLinesInner([
    void Function(CaptainEarningsDtoOutputLinesInnerBuilder)? updates,
  ]) => (CaptainEarningsDtoOutputLinesInnerBuilder()..update(updates))._build();

  _$CaptainEarningsDtoOutputLinesInner._({
    required this.kind,
    required this.amount,
    this.reason,
    this.orderNumber,
    this.receiptNumber,
    required this.at,
  }) : super._();
  @override
  CaptainEarningsDtoOutputLinesInner rebuild(
    void Function(CaptainEarningsDtoOutputLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEarningsDtoOutputLinesInnerBuilder toBuilder() =>
      CaptainEarningsDtoOutputLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEarningsDtoOutputLinesInner &&
        kind == other.kind &&
        amount == other.amount &&
        reason == other.reason &&
        orderNumber == other.orderNumber &&
        receiptNumber == other.receiptNumber &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, receiptNumber.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainEarningsDtoOutputLinesInner')
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('reason', reason)
          ..add('orderNumber', orderNumber)
          ..add('receiptNumber', receiptNumber)
          ..add('at', at))
        .toString();
  }
}

class CaptainEarningsDtoOutputLinesInnerBuilder
    implements
        Builder<
          CaptainEarningsDtoOutputLinesInner,
          CaptainEarningsDtoOutputLinesInnerBuilder
        > {
  _$CaptainEarningsDtoOutputLinesInner? _$v;

  CaptainEarningsDtoOutputLinesInnerKindEnum? _kind;
  CaptainEarningsDtoOutputLinesInnerKindEnum? get kind => _$this._kind;
  set kind(CaptainEarningsDtoOutputLinesInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  String? _receiptNumber;
  String? get receiptNumber => _$this._receiptNumber;
  set receiptNumber(String? receiptNumber) =>
      _$this._receiptNumber = receiptNumber;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainEarningsDtoOutputLinesInnerBuilder() {
    CaptainEarningsDtoOutputLinesInner._defaults(this);
  }

  CaptainEarningsDtoOutputLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _amount = $v.amount;
      _reason = $v.reason;
      _orderNumber = $v.orderNumber;
      _receiptNumber = $v.receiptNumber;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainEarningsDtoOutputLinesInner other) {
    _$v = other as _$CaptainEarningsDtoOutputLinesInner;
  }

  @override
  void update(
    void Function(CaptainEarningsDtoOutputLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEarningsDtoOutputLinesInner build() => _build();

  _$CaptainEarningsDtoOutputLinesInner _build() {
    final _$result =
        _$v ??
        _$CaptainEarningsDtoOutputLinesInner._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'CaptainEarningsDtoOutputLinesInner',
            'kind',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainEarningsDtoOutputLinesInner',
            'amount',
          ),
          reason: reason,
          orderNumber: orderNumber,
          receiptNumber: receiptNumber,
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainEarningsDtoOutputLinesInner',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
