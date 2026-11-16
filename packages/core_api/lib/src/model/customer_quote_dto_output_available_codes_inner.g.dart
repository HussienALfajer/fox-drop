// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_available_codes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum
_$customerQuoteDtoOutputAvailableCodesInnerKindEnum_percentage =
    const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum._('percentage');
const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum
_$customerQuoteDtoOutputAvailableCodesInnerKindEnum_fixedAmount =
    const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum._('fixedAmount');
const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum
_$customerQuoteDtoOutputAvailableCodesInnerKindEnum_freeDelivery =
    const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum._('freeDelivery');

CustomerQuoteDtoOutputAvailableCodesInnerKindEnum
_$customerQuoteDtoOutputAvailableCodesInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'percentage':
      return _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_percentage;
    case 'fixedAmount':
      return _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_fixedAmount;
    case 'freeDelivery':
      return _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_freeDelivery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerQuoteDtoOutputAvailableCodesInnerKindEnum>
_$customerQuoteDtoOutputAvailableCodesInnerKindEnumValues =
    BuiltSet<CustomerQuoteDtoOutputAvailableCodesInnerKindEnum>(
      const <CustomerQuoteDtoOutputAvailableCodesInnerKindEnum>[
        _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_percentage,
        _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_fixedAmount,
        _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_freeDelivery,
      ],
    );

Serializer<CustomerQuoteDtoOutputAvailableCodesInnerKindEnum>
_$customerQuoteDtoOutputAvailableCodesInnerKindEnumSerializer =
    _$CustomerQuoteDtoOutputAvailableCodesInnerKindEnumSerializer();

class _$CustomerQuoteDtoOutputAvailableCodesInnerKindEnumSerializer
    implements
        PrimitiveSerializer<CustomerQuoteDtoOutputAvailableCodesInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'percentage': 'percentage',
    'fixedAmount': 'fixed_amount',
    'freeDelivery': 'free_delivery',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'percentage': 'percentage',
    'fixed_amount': 'fixedAmount',
    'free_delivery': 'freeDelivery',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerQuoteDtoOutputAvailableCodesInnerKindEnum,
  ];
  @override
  final String wireName = 'CustomerQuoteDtoOutputAvailableCodesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputAvailableCodesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerQuoteDtoOutputAvailableCodesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerQuoteDtoOutputAvailableCodesInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerQuoteDtoOutputAvailableCodesInner
    extends CustomerQuoteDtoOutputAvailableCodesInner {
  @override
  final String code;
  @override
  final CustomerQuoteDtoOutputAvailableCodesInnerKindEnum kind;
  @override
  final int? percentBp;
  @override
  final String? amount;
  @override
  final String? maxDiscount;
  @override
  final String? minOrder;
  @override
  final DateTime validTo;
  @override
  final String? discount;
  @override
  final String? missing;

  factory _$CustomerQuoteDtoOutputAvailableCodesInner([
    void Function(CustomerQuoteDtoOutputAvailableCodesInnerBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputAvailableCodesInnerBuilder()..update(updates))
      ._build();

  _$CustomerQuoteDtoOutputAvailableCodesInner._({
    required this.code,
    required this.kind,
    this.percentBp,
    this.amount,
    this.maxDiscount,
    this.minOrder,
    required this.validTo,
    this.discount,
    this.missing,
  }) : super._();
  @override
  CustomerQuoteDtoOutputAvailableCodesInner rebuild(
    void Function(CustomerQuoteDtoOutputAvailableCodesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputAvailableCodesInnerBuilder toBuilder() =>
      CustomerQuoteDtoOutputAvailableCodesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputAvailableCodesInner &&
        code == other.code &&
        kind == other.kind &&
        percentBp == other.percentBp &&
        amount == other.amount &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        validTo == other.validTo &&
        discount == other.discount &&
        missing == other.missing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, percentBp.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, validTo.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, missing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerQuoteDtoOutputAvailableCodesInner',
          )
          ..add('code', code)
          ..add('kind', kind)
          ..add('percentBp', percentBp)
          ..add('amount', amount)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('validTo', validTo)
          ..add('discount', discount)
          ..add('missing', missing))
        .toString();
  }
}

class CustomerQuoteDtoOutputAvailableCodesInnerBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputAvailableCodesInner,
          CustomerQuoteDtoOutputAvailableCodesInnerBuilder
        > {
  _$CustomerQuoteDtoOutputAvailableCodesInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerQuoteDtoOutputAvailableCodesInnerKindEnum? _kind;
  CustomerQuoteDtoOutputAvailableCodesInnerKindEnum? get kind => _$this._kind;
  set kind(CustomerQuoteDtoOutputAvailableCodesInnerKindEnum? kind) =>
      _$this._kind = kind;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  String? _minOrder;
  String? get minOrder => _$this._minOrder;
  set minOrder(String? minOrder) => _$this._minOrder = minOrder;

  DateTime? _validTo;
  DateTime? get validTo => _$this._validTo;
  set validTo(DateTime? validTo) => _$this._validTo = validTo;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  String? _missing;
  String? get missing => _$this._missing;
  set missing(String? missing) => _$this._missing = missing;

  CustomerQuoteDtoOutputAvailableCodesInnerBuilder() {
    CustomerQuoteDtoOutputAvailableCodesInner._defaults(this);
  }

  CustomerQuoteDtoOutputAvailableCodesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _kind = $v.kind;
      _percentBp = $v.percentBp;
      _amount = $v.amount;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _validTo = $v.validTo;
      _discount = $v.discount;
      _missing = $v.missing;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputAvailableCodesInner other) {
    _$v = other as _$CustomerQuoteDtoOutputAvailableCodesInner;
  }

  @override
  void update(
    void Function(CustomerQuoteDtoOutputAvailableCodesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputAvailableCodesInner build() => _build();

  _$CustomerQuoteDtoOutputAvailableCodesInner _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputAvailableCodesInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CustomerQuoteDtoOutputAvailableCodesInner',
            'code',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'CustomerQuoteDtoOutputAvailableCodesInner',
            'kind',
          ),
          percentBp: percentBp,
          amount: amount,
          maxDiscount: maxDiscount,
          minOrder: minOrder,
          validTo: BuiltValueNullFieldError.checkNotNull(
            validTo,
            r'CustomerQuoteDtoOutputAvailableCodesInner',
            'validTo',
          ),
          discount: discount,
          missing: missing,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
