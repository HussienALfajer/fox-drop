// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_compensate_dto_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCompensateDtoValueKindEnum
_$adminCompensateDtoValueKindEnum_fixedAmount =
    const AdminCompensateDtoValueKindEnum._('fixedAmount');
const AdminCompensateDtoValueKindEnum
_$adminCompensateDtoValueKindEnum_percentage =
    const AdminCompensateDtoValueKindEnum._('percentage');

AdminCompensateDtoValueKindEnum _$adminCompensateDtoValueKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'fixedAmount':
      return _$adminCompensateDtoValueKindEnum_fixedAmount;
    case 'percentage':
      return _$adminCompensateDtoValueKindEnum_percentage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCompensateDtoValueKindEnum>
_$adminCompensateDtoValueKindEnumValues =
    BuiltSet<AdminCompensateDtoValueKindEnum>(
      const <AdminCompensateDtoValueKindEnum>[
        _$adminCompensateDtoValueKindEnum_fixedAmount,
        _$adminCompensateDtoValueKindEnum_percentage,
      ],
    );

Serializer<AdminCompensateDtoValueKindEnum>
_$adminCompensateDtoValueKindEnumSerializer =
    _$AdminCompensateDtoValueKindEnumSerializer();

class _$AdminCompensateDtoValueKindEnumSerializer
    implements PrimitiveSerializer<AdminCompensateDtoValueKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fixedAmount': 'fixed_amount',
    'percentage': 'percentage',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fixed_amount': 'fixedAmount',
    'percentage': 'percentage',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCompensateDtoValueKindEnum];
  @override
  final String wireName = 'AdminCompensateDtoValueKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensateDtoValueKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCompensateDtoValueKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCompensateDtoValueKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCompensateDtoValue extends AdminCompensateDtoValue {
  @override
  final AdminCompensateDtoValueKindEnum kind;
  @override
  final String? amount;
  @override
  final int? percentBp;
  @override
  final String? maxDiscount;

  factory _$AdminCompensateDtoValue([
    void Function(AdminCompensateDtoValueBuilder)? updates,
  ]) => (AdminCompensateDtoValueBuilder()..update(updates))._build();

  _$AdminCompensateDtoValue._({
    required this.kind,
    this.amount,
    this.percentBp,
    this.maxDiscount,
  }) : super._();
  @override
  AdminCompensateDtoValue rebuild(
    void Function(AdminCompensateDtoValueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCompensateDtoValueBuilder toBuilder() =>
      AdminCompensateDtoValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCompensateDtoValue &&
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
    return (newBuiltValueToStringHelper(r'AdminCompensateDtoValue')
          ..add('kind', kind)
          ..add('amount', amount)
          ..add('percentBp', percentBp)
          ..add('maxDiscount', maxDiscount))
        .toString();
  }
}

class AdminCompensateDtoValueBuilder
    implements
        Builder<AdminCompensateDtoValue, AdminCompensateDtoValueBuilder> {
  _$AdminCompensateDtoValue? _$v;

  AdminCompensateDtoValueKindEnum? _kind;
  AdminCompensateDtoValueKindEnum? get kind => _$this._kind;
  set kind(AdminCompensateDtoValueKindEnum? kind) => _$this._kind = kind;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  AdminCompensateDtoValueBuilder() {
    AdminCompensateDtoValue._defaults(this);
  }

  AdminCompensateDtoValueBuilder get _$this {
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
  void replace(AdminCompensateDtoValue other) {
    _$v = other as _$AdminCompensateDtoValue;
  }

  @override
  void update(void Function(AdminCompensateDtoValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCompensateDtoValue build() => _build();

  _$AdminCompensateDtoValue _build() {
    final _$result =
        _$v ??
        _$AdminCompensateDtoValue._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCompensateDtoValue',
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
