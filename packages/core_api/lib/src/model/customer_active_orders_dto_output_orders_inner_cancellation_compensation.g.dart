// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_cancellation_compensation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
_$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_fixedAmount =
    const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum._(
      'fixedAmount',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
_$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_percentage =
    const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum._(
      'percentage',
    );

CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
_$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'fixedAmount':
      return _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_fixedAmount;
    case 'percentage':
      return _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
>
_$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumValues =
    BuiltSet<
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
    >(const <
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
    >[
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_fixedAmount,
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_percentage,
    ]);

Serializer<
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
>
_$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
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
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
    object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation
    extends CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation {
  @override
  final String code;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  kind;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount? amount;
  @override
  final int? percentBp;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?
  maxDiscount;
  @override
  final DateTime validTo;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation._({
    required this.code,
    required this.kind,
    this.amount,
    this.percentBp,
    this.maxDiscount,
    required this.validTo,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation &&
        code == other.code &&
        kind == other.kind &&
        amount == other.amount &&
        percentBp == other.percentBp &&
        maxDiscount == other.maxDiscount &&
        validTo == other.validTo;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation',
          )
          ..add('code', code)
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('percentBp', percentBp)
          ..add('maxDiscount', maxDiscount)
          ..add('validTo', validTo))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation,
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum?
  _kind;
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum?
  get kind => _$this._kind;
  set kind(
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum?
    kind,
  ) => _$this._kind = kind;

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

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation._defaults(
      this,
    );
  }

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _kind = $v.kind;
      _amount = $v.amount?.toBuilder();
      _percentBp = $v.percentBp;
      _maxDiscount = $v.maxDiscount?.toBuilder();
      _validTo = $v.validTo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation other,
  ) {
    _$v =
        other
            as _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation build() =>
      _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation._(
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation',
              'code',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation',
              'kind',
            ),
            amount: _amount?.build(),
            percentBp: percentBp,
            maxDiscount: _maxDiscount?.build(),
            validTo: BuiltValueNullFieldError.checkNotNull(
              validTo,
              r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation',
              'validTo',
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
          r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation',
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
