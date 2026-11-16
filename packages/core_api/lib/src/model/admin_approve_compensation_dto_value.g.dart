// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_approve_compensation_dto_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminApproveCompensationDtoValueKindEnum
_$adminApproveCompensationDtoValueKindEnum_fixedAmount =
    const AdminApproveCompensationDtoValueKindEnum._('fixedAmount');
const AdminApproveCompensationDtoValueKindEnum
_$adminApproveCompensationDtoValueKindEnum_percentage =
    const AdminApproveCompensationDtoValueKindEnum._('percentage');

AdminApproveCompensationDtoValueKindEnum
_$adminApproveCompensationDtoValueKindEnumValueOf(String name) {
  switch (name) {
    case 'fixedAmount':
      return _$adminApproveCompensationDtoValueKindEnum_fixedAmount;
    case 'percentage':
      return _$adminApproveCompensationDtoValueKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminApproveCompensationDtoValueKindEnum>
_$adminApproveCompensationDtoValueKindEnumValues =
    BuiltSet<AdminApproveCompensationDtoValueKindEnum>(
      const <AdminApproveCompensationDtoValueKindEnum>[
        _$adminApproveCompensationDtoValueKindEnum_fixedAmount,
        _$adminApproveCompensationDtoValueKindEnum_percentage,
      ],
    );

Serializer<AdminApproveCompensationDtoValueKindEnum>
_$adminApproveCompensationDtoValueKindEnumSerializer =
    _$AdminApproveCompensationDtoValueKindEnumSerializer();

class _$AdminApproveCompensationDtoValueKindEnumSerializer
    implements PrimitiveSerializer<AdminApproveCompensationDtoValueKindEnum> {
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
    AdminApproveCompensationDtoValueKindEnum,
  ];
  @override
  final String wireName = 'AdminApproveCompensationDtoValueKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminApproveCompensationDtoValueKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminApproveCompensationDtoValueKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminApproveCompensationDtoValueKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminApproveCompensationDtoValue
    extends AdminApproveCompensationDtoValue {
  @override
  final AdminApproveCompensationDtoValueKindEnum kind;
  @override
  final String? amount;
  @override
  final int? percentBp;
  @override
  final String? maxDiscount;

  factory _$AdminApproveCompensationDtoValue([
    void Function(AdminApproveCompensationDtoValueBuilder)? updates,
  ]) => (AdminApproveCompensationDtoValueBuilder()..update(updates))._build();

  _$AdminApproveCompensationDtoValue._({
    required this.kind,
    this.amount,
    this.percentBp,
    this.maxDiscount,
  }) : super._();
  @override
  AdminApproveCompensationDtoValue rebuild(
    void Function(AdminApproveCompensationDtoValueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminApproveCompensationDtoValueBuilder toBuilder() =>
      AdminApproveCompensationDtoValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApproveCompensationDtoValue &&
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
    return (newBuiltValueToStringHelper(r'AdminApproveCompensationDtoValue')
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('percentBp', percentBp)
          ..add('maxDiscount', maxDiscount))
        .toString();
  }
}

class AdminApproveCompensationDtoValueBuilder
    implements
        Builder<
          AdminApproveCompensationDtoValue,
          AdminApproveCompensationDtoValueBuilder
        > {
  _$AdminApproveCompensationDtoValue? _$v;

  AdminApproveCompensationDtoValueKindEnum? _kind;
  AdminApproveCompensationDtoValueKindEnum? get kind => _$this._kind;
  set kind(AdminApproveCompensationDtoValueKindEnum? kind) =>
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

  AdminApproveCompensationDtoValueBuilder() {
    AdminApproveCompensationDtoValue._defaults(this);
  }

  AdminApproveCompensationDtoValueBuilder get _$this {
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
  void replace(AdminApproveCompensationDtoValue other) {
    _$v = other as _$AdminApproveCompensationDtoValue;
  }

  @override
  void update(void Function(AdminApproveCompensationDtoValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApproveCompensationDtoValue build() => _build();

  _$AdminApproveCompensationDtoValue _build() {
    final _$result =
        _$v ??
        _$AdminApproveCompensationDtoValue._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminApproveCompensationDtoValue',
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
