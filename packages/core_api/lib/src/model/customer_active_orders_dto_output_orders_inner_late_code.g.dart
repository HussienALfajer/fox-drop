// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_late_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
_$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_fixedAmount =
    const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum._(
      'fixedAmount',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
_$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_percentage =
    const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum._(
      'percentage',
    );

CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
_$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumValueOf(String name) {
  switch (name) {
    case 'fixedAmount':
      return _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_fixedAmount;
    case 'percentage':
      return _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum>
_$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum>(
      const <CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum>[
        _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_fixedAmount,
        _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_percentage,
      ],
    );

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum>
_$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fixedAmount': 'fixed_amount',
    'percentage': 'percentage',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fixed_amount': 'fixedAmount',
    'percentage': 'percentage',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode
    extends CustomerActiveOrdersDtoOutputOrdersInnerLateCode {
  @override
  final String code;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum kind;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount? amount;
  @override
  final int? percentBp;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?
  maxDiscount;
  @override
  final DateTime validTo;
  @override
  final DateTime issuedAt;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode._({
    required this.code,
    required this.kind,
    this.amount,
    this.percentBp,
    this.maxDiscount,
    required this.validTo,
    required this.issuedAt,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCode rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerLateCode &&
        code == other.code &&
        kind == other.kind &&
        amount == other.amount &&
        percentBp == other.percentBp &&
        maxDiscount == other.maxDiscount &&
        validTo == other.validTo &&
        issuedAt == other.issuedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, percentBp.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, validTo.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode',
          )
          ..add('code', code)
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('percentBp', percentBp)
          ..add('maxDiscount', maxDiscount)
          ..add('validTo', validTo)
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCode,
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum? _kind;
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum? get kind =>
      _$this._kind;
  set kind(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum? kind) =>
      _$this._kind = kind;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder? _amount;
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder get amount =>
      _$this._amount ??=
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder();
  set amount(
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmountBuilder? amount,
  ) => _$this._amount = amount;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder?
  _maxDiscount;
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
  get maxDiscount => _$this._maxDiscount ??=
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder();
  set maxDiscount(
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder?
    maxDiscount,
  ) => _$this._maxDiscount = maxDiscount;

  DateTime? _validTo;
  DateTime? get validTo => _$this._validTo;
  set validTo(DateTime? validTo) => _$this._validTo = validTo;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerLateCode._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _kind = $v.kind;
      _amount = $v.amount?.toBuilder();
      _percentBp = $v.percentBp;
      _maxDiscount = $v.maxDiscount?.toBuilder();
      _validTo = $v.validTo;
      _issuedAt = $v.issuedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerLateCode other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCode build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode._(
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode',
              'code',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode',
              'kind',
            ),
            amount: _amount?.build(),
            percentBp: percentBp,
            maxDiscount: _maxDiscount?.build(),
            validTo: BuiltValueNullFieldError.checkNotNull(
              validTo,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode',
              'validTo',
            ),
            issuedAt: BuiltValueNullFieldError.checkNotNull(
              issuedAt,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode',
              'issuedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        _amount?.build();

        _$failedField = 'maxDiscount';
        _maxDiscount?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode',
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
