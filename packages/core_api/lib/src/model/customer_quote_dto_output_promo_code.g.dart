// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_promo_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerQuoteDtoOutputPromoCodeKindEnum
_$customerQuoteDtoOutputPromoCodeKindEnum_percentage =
    const CustomerQuoteDtoOutputPromoCodeKindEnum._('percentage');
const CustomerQuoteDtoOutputPromoCodeKindEnum
_$customerQuoteDtoOutputPromoCodeKindEnum_fixedAmount =
    const CustomerQuoteDtoOutputPromoCodeKindEnum._('fixedAmount');
const CustomerQuoteDtoOutputPromoCodeKindEnum
_$customerQuoteDtoOutputPromoCodeKindEnum_freeDelivery =
    const CustomerQuoteDtoOutputPromoCodeKindEnum._('freeDelivery');

CustomerQuoteDtoOutputPromoCodeKindEnum
_$customerQuoteDtoOutputPromoCodeKindEnumValueOf(String name) {
  switch (name) {
    case 'percentage':
      return _$customerQuoteDtoOutputPromoCodeKindEnum_percentage;
    case 'fixedAmount':
      return _$customerQuoteDtoOutputPromoCodeKindEnum_fixedAmount;
    case 'freeDelivery':
      return _$customerQuoteDtoOutputPromoCodeKindEnum_freeDelivery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerQuoteDtoOutputPromoCodeKindEnum>
_$customerQuoteDtoOutputPromoCodeKindEnumValues =
    BuiltSet<CustomerQuoteDtoOutputPromoCodeKindEnum>(
      const <CustomerQuoteDtoOutputPromoCodeKindEnum>[
        _$customerQuoteDtoOutputPromoCodeKindEnum_percentage,
        _$customerQuoteDtoOutputPromoCodeKindEnum_fixedAmount,
        _$customerQuoteDtoOutputPromoCodeKindEnum_freeDelivery,
      ],
    );

Serializer<CustomerQuoteDtoOutputPromoCodeKindEnum>
_$customerQuoteDtoOutputPromoCodeKindEnumSerializer =
    _$CustomerQuoteDtoOutputPromoCodeKindEnumSerializer();

class _$CustomerQuoteDtoOutputPromoCodeKindEnumSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputPromoCodeKindEnum> {
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
    CustomerQuoteDtoOutputPromoCodeKindEnum,
  ];
  @override
  final String wireName = 'CustomerQuoteDtoOutputPromoCodeKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputPromoCodeKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerQuoteDtoOutputPromoCodeKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerQuoteDtoOutputPromoCodeKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerQuoteDtoOutputPromoCode
    extends CustomerQuoteDtoOutputPromoCode {
  @override
  final String code;
  @override
  final CustomerQuoteDtoOutputPromoCodeKindEnum kind;
  @override
  final String discount;
  @override
  final bool fixedAmountAboveItems;

  factory _$CustomerQuoteDtoOutputPromoCode([
    void Function(CustomerQuoteDtoOutputPromoCodeBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputPromoCodeBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputPromoCode._({
    required this.code,
    required this.kind,
    required this.discount,
    required this.fixedAmountAboveItems,
  }) : super._();
  @override
  CustomerQuoteDtoOutputPromoCode rebuild(
    void Function(CustomerQuoteDtoOutputPromoCodeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputPromoCodeBuilder toBuilder() =>
      CustomerQuoteDtoOutputPromoCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputPromoCode &&
        code == other.code &&
        kind == other.kind &&
        discount == other.discount &&
        fixedAmountAboveItems == other.fixedAmountAboveItems;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, fixedAmountAboveItems.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputPromoCode')
          ..add('code', code)
          ..add('kind', kind)
          ..add('discount', discount)
          ..add('fixedAmountAboveItems', fixedAmountAboveItems))
        .toString();
  }
}

class CustomerQuoteDtoOutputPromoCodeBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputPromoCode,
          CustomerQuoteDtoOutputPromoCodeBuilder
        > {
  _$CustomerQuoteDtoOutputPromoCode? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerQuoteDtoOutputPromoCodeKindEnum? _kind;
  CustomerQuoteDtoOutputPromoCodeKindEnum? get kind => _$this._kind;
  set kind(CustomerQuoteDtoOutputPromoCodeKindEnum? kind) =>
      _$this._kind = kind;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  bool? _fixedAmountAboveItems;
  bool? get fixedAmountAboveItems => _$this._fixedAmountAboveItems;
  set fixedAmountAboveItems(bool? fixedAmountAboveItems) =>
      _$this._fixedAmountAboveItems = fixedAmountAboveItems;

  CustomerQuoteDtoOutputPromoCodeBuilder() {
    CustomerQuoteDtoOutputPromoCode._defaults(this);
  }

  CustomerQuoteDtoOutputPromoCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _kind = $v.kind;
      _discount = $v.discount;
      _fixedAmountAboveItems = $v.fixedAmountAboveItems;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputPromoCode other) {
    _$v = other as _$CustomerQuoteDtoOutputPromoCode;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputPromoCodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputPromoCode build() => _build();

  _$CustomerQuoteDtoOutputPromoCode _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputPromoCode._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CustomerQuoteDtoOutputPromoCode',
            'code',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'CustomerQuoteDtoOutputPromoCode',
            'kind',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'CustomerQuoteDtoOutputPromoCode',
            'discount',
          ),
          fixedAmountAboveItems: BuiltValueNullFieldError.checkNotNull(
            fixedAmountAboveItems,
            r'CustomerQuoteDtoOutputPromoCode',
            'fixedAmountAboveItems',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
