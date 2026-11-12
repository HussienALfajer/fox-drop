// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_payMerchant =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('payMerchant');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_collect =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('collect');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_changeGiven =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('changeGiven');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_handIn =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('handIn');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_reimburse =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('reimburse');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_fxConvert =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('fxConvert');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_pickupCorrection =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('pickupCorrection');
const CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnum_adjustment =
    const CaptainCustodyDtoOutputEntriesInnerKindEnum._('adjustment');

CaptainCustodyDtoOutputEntriesInnerKindEnum
_$captainCustodyDtoOutputEntriesInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'payMerchant':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_payMerchant;
    case 'collect':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_collect;
    case 'changeGiven':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_changeGiven;
    case 'handIn':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_handIn;
    case 'reimburse':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_reimburse;
    case 'fxConvert':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_fxConvert;
    case 'pickupCorrection':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_pickupCorrection;
    case 'adjustment':
      return _$captainCustodyDtoOutputEntriesInnerKindEnum_adjustment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainCustodyDtoOutputEntriesInnerKindEnum>
_$captainCustodyDtoOutputEntriesInnerKindEnumValues =
    BuiltSet<CaptainCustodyDtoOutputEntriesInnerKindEnum>(
      const <CaptainCustodyDtoOutputEntriesInnerKindEnum>[
        _$captainCustodyDtoOutputEntriesInnerKindEnum_payMerchant,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_collect,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_changeGiven,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_handIn,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_reimburse,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_fxConvert,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_pickupCorrection,
        _$captainCustodyDtoOutputEntriesInnerKindEnum_adjustment,
      ],
    );

Serializer<CaptainCustodyDtoOutputEntriesInnerKindEnum>
_$captainCustodyDtoOutputEntriesInnerKindEnumSerializer =
    _$CaptainCustodyDtoOutputEntriesInnerKindEnumSerializer();

class _$CaptainCustodyDtoOutputEntriesInnerKindEnumSerializer
    implements
        PrimitiveSerializer<CaptainCustodyDtoOutputEntriesInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'payMerchant': 'pay_merchant',
    'collect': 'collect',
    'changeGiven': 'change_given',
    'handIn': 'hand_in',
    'reimburse': 'reimburse',
    'fxConvert': 'fx_convert',
    'pickupCorrection': 'pickup_correction',
    'adjustment': 'adjustment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pay_merchant': 'payMerchant',
    'collect': 'collect',
    'change_given': 'changeGiven',
    'hand_in': 'handIn',
    'reimburse': 'reimburse',
    'fx_convert': 'fxConvert',
    'pickup_correction': 'pickupCorrection',
    'adjustment': 'adjustment',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainCustodyDtoOutputEntriesInnerKindEnum,
  ];
  @override
  final String wireName = 'CaptainCustodyDtoOutputEntriesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustodyDtoOutputEntriesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainCustodyDtoOutputEntriesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainCustodyDtoOutputEntriesInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainCustodyDtoOutputEntriesInner
    extends CaptainCustodyDtoOutputEntriesInner {
  @override
  final CaptainCustodyDtoOutputEntriesInnerKindEnum? kind;
  @override
  final String? orderNumber;
  @override
  final String? receiptNumber;
  @override
  final CaptainCustodyDtoOutputEntriesInnerAmount amount;
  @override
  final DateTime at;

  factory _$CaptainCustodyDtoOutputEntriesInner([
    void Function(CaptainCustodyDtoOutputEntriesInnerBuilder)? updates,
  ]) =>
      (CaptainCustodyDtoOutputEntriesInnerBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutputEntriesInner._({
    this.kind,
    this.orderNumber,
    this.receiptNumber,
    required this.amount,
    required this.at,
  }) : super._();
  @override
  CaptainCustodyDtoOutputEntriesInner rebuild(
    void Function(CaptainCustodyDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputEntriesInnerBuilder toBuilder() =>
      CaptainCustodyDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputEntriesInner &&
        kind == other.kind &&
        orderNumber == other.orderNumber &&
        receiptNumber == other.receiptNumber &&
        amount == other.amount &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, receiptNumber.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutputEntriesInner')
          ..add('kind', kind)
          ..add('orderNumber', orderNumber)
          ..add('receiptNumber', receiptNumber)
          ..add('amount', amount)
          ..add('at', at))
        .toString();
  }
}

class CaptainCustodyDtoOutputEntriesInnerBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputEntriesInner,
          CaptainCustodyDtoOutputEntriesInnerBuilder
        > {
  _$CaptainCustodyDtoOutputEntriesInner? _$v;

  CaptainCustodyDtoOutputEntriesInnerKindEnum? _kind;
  CaptainCustodyDtoOutputEntriesInnerKindEnum? get kind => _$this._kind;
  set kind(CaptainCustodyDtoOutputEntriesInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  String? _receiptNumber;
  String? get receiptNumber => _$this._receiptNumber;
  set receiptNumber(String? receiptNumber) =>
      _$this._receiptNumber = receiptNumber;

  CaptainCustodyDtoOutputEntriesInnerAmountBuilder? _amount;
  CaptainCustodyDtoOutputEntriesInnerAmountBuilder get amount =>
      _$this._amount ??= CaptainCustodyDtoOutputEntriesInnerAmountBuilder();
  set amount(CaptainCustodyDtoOutputEntriesInnerAmountBuilder? amount) =>
      _$this._amount = amount;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainCustodyDtoOutputEntriesInnerBuilder() {
    CaptainCustodyDtoOutputEntriesInner._defaults(this);
  }

  CaptainCustodyDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _orderNumber = $v.orderNumber;
      _receiptNumber = $v.receiptNumber;
      _amount = $v.amount.toBuilder();
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputEntriesInner other) {
    _$v = other as _$CaptainCustodyDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(CaptainCustodyDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputEntriesInner build() => _build();

  _$CaptainCustodyDtoOutputEntriesInner _build() {
    _$CaptainCustodyDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCustodyDtoOutputEntriesInner._(
            kind: kind,
            orderNumber: orderNumber,
            receiptNumber: receiptNumber,
            amount: amount.build(),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CaptainCustodyDtoOutputEntriesInner',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        amount.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCustodyDtoOutputEntriesInner',
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
