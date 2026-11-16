// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_dto_compensation_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCancelDtoCompensationValueKindEnum
_$adminCancelDtoCompensationValueKindEnum_fixedAmount =
    const AdminCancelDtoCompensationValueKindEnum._('fixedAmount');
const AdminCancelDtoCompensationValueKindEnum
_$adminCancelDtoCompensationValueKindEnum_percentage =
    const AdminCancelDtoCompensationValueKindEnum._('percentage');

AdminCancelDtoCompensationValueKindEnum
_$adminCancelDtoCompensationValueKindEnumValueOf(String name) {
  switch (name) {
    case 'fixedAmount':
      return _$adminCancelDtoCompensationValueKindEnum_fixedAmount;
    case 'percentage':
      return _$adminCancelDtoCompensationValueKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCancelDtoCompensationValueKindEnum>
_$adminCancelDtoCompensationValueKindEnumValues =
    BuiltSet<AdminCancelDtoCompensationValueKindEnum>(
      const <AdminCancelDtoCompensationValueKindEnum>[
        _$adminCancelDtoCompensationValueKindEnum_fixedAmount,
        _$adminCancelDtoCompensationValueKindEnum_percentage,
      ],
    );

Serializer<AdminCancelDtoCompensationValueKindEnum>
_$adminCancelDtoCompensationValueKindEnumSerializer =
    _$AdminCancelDtoCompensationValueKindEnumSerializer();

class _$AdminCancelDtoCompensationValueKindEnumSerializer
    implements PrimitiveSerializer<AdminCancelDtoCompensationValueKindEnum> {
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
    AdminCancelDtoCompensationValueKindEnum,
  ];
  @override
  final String wireName = 'AdminCancelDtoCompensationValueKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelDtoCompensationValueKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCancelDtoCompensationValueKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCancelDtoCompensationValueKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCancelDtoCompensationValue
    extends AdminCancelDtoCompensationValue {
  @override
  final AdminCancelDtoCompensationValueKindEnum kind;
  @override
  final String? amount;
  @override
  final int? percentBp;
  @override
  final String? maxDiscount;

  factory _$AdminCancelDtoCompensationValue([
    void Function(AdminCancelDtoCompensationValueBuilder)? updates,
  ]) => (AdminCancelDtoCompensationValueBuilder()..update(updates))._build();

  _$AdminCancelDtoCompensationValue._({
    required this.kind,
    this.amount,
    this.percentBp,
    this.maxDiscount,
  }) : super._();
  @override
  AdminCancelDtoCompensationValue rebuild(
    void Function(AdminCancelDtoCompensationValueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelDtoCompensationValueBuilder toBuilder() =>
      AdminCancelDtoCompensationValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelDtoCompensationValue &&
        kind == other.kind &&
        amount == other.amount &&
        percentBp == other.percentBp &&
        maxDiscount == other.maxDiscount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, percentBp.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCancelDtoCompensationValue')
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('percentBp', percentBp)
          ..add('maxDiscount', maxDiscount))
        .toString();
  }
}

class AdminCancelDtoCompensationValueBuilder
    implements
        Builder<
          AdminCancelDtoCompensationValue,
          AdminCancelDtoCompensationValueBuilder
        > {
  _$AdminCancelDtoCompensationValue? _$v;

  AdminCancelDtoCompensationValueKindEnum? _kind;
  AdminCancelDtoCompensationValueKindEnum? get kind => _$this._kind;
  set kind(AdminCancelDtoCompensationValueKindEnum? kind) =>
      _$this._kind = kind;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  AdminCancelDtoCompensationValueBuilder() {
    AdminCancelDtoCompensationValue._defaults(this);
  }

  AdminCancelDtoCompensationValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _amount = $v.amount;
      _percentBp = $v.percentBp;
      _maxDiscount = $v.maxDiscount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelDtoCompensationValue other) {
    _$v = other as _$AdminCancelDtoCompensationValue;
  }

  @override
  void update(void Function(AdminCancelDtoCompensationValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelDtoCompensationValue build() => _build();

  _$AdminCancelDtoCompensationValue _build() {
    final _$result =
        _$v ??
        _$AdminCancelDtoCompensationValue._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCancelDtoCompensationValue',
            'kind',
          ),
          amount: amount,
          percentBp: percentBp,
          maxDiscount: maxDiscount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
