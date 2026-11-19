// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto_rule_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetDeliveryFeeDtoRuleOneOfKindEnum
_$adminSetDeliveryFeeDtoRuleOneOfKindEnum_flat =
    const AdminSetDeliveryFeeDtoRuleOneOfKindEnum._('flat');

AdminSetDeliveryFeeDtoRuleOneOfKindEnum
_$adminSetDeliveryFeeDtoRuleOneOfKindEnumValueOf(String name) {
  switch (name) {
    case 'flat':
      return _$adminSetDeliveryFeeDtoRuleOneOfKindEnum_flat;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetDeliveryFeeDtoRuleOneOfKindEnum>
_$adminSetDeliveryFeeDtoRuleOneOfKindEnumValues =
    BuiltSet<AdminSetDeliveryFeeDtoRuleOneOfKindEnum>(
      const <AdminSetDeliveryFeeDtoRuleOneOfKindEnum>[
        _$adminSetDeliveryFeeDtoRuleOneOfKindEnum_flat,
      ],
    );

Serializer<AdminSetDeliveryFeeDtoRuleOneOfKindEnum>
_$adminSetDeliveryFeeDtoRuleOneOfKindEnumSerializer =
    _$AdminSetDeliveryFeeDtoRuleOneOfKindEnumSerializer();

class _$AdminSetDeliveryFeeDtoRuleOneOfKindEnumSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleOneOfKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'flat': 'flat',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'flat': 'flat',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSetDeliveryFeeDtoRuleOneOfKindEnum,
  ];
  @override
  final String wireName = 'AdminSetDeliveryFeeDtoRuleOneOfKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleOneOfKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetDeliveryFeeDtoRuleOneOfKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetDeliveryFeeDtoRuleOneOfKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetDeliveryFeeDtoRuleOneOf
    extends AdminSetDeliveryFeeDtoRuleOneOf {
  @override
  final AdminSetDeliveryFeeDtoRuleOneOfKindEnum kind;
  @override
  final String flatFee;
  @override
  final String currency;
  @override
  final String? minimumFee;
  @override
  final String? freeDeliveryFrom;

  factory _$AdminSetDeliveryFeeDtoRuleOneOf([
    void Function(AdminSetDeliveryFeeDtoRuleOneOfBuilder)? updates,
  ]) => (AdminSetDeliveryFeeDtoRuleOneOfBuilder()..update(updates))._build();

  _$AdminSetDeliveryFeeDtoRuleOneOf._({
    required this.kind,
    required this.flatFee,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
  }) : super._();
  @override
  AdminSetDeliveryFeeDtoRuleOneOf rebuild(
    void Function(AdminSetDeliveryFeeDtoRuleOneOfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoRuleOneOfBuilder toBuilder() =>
      AdminSetDeliveryFeeDtoRuleOneOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDtoRuleOneOf &&
        kind == other.kind &&
        flatFee == other.flatFee &&
        currency == other.currency &&
        minimumFee == other.minimumFee &&
        freeDeliveryFrom == other.freeDeliveryFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, flatFee.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, minimumFee.hashCode);
    _$hash = $jc(_$hash, freeDeliveryFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetDeliveryFeeDtoRuleOneOf')
          ..add('kind', kind)
          ..add('flatFee', flatFee)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom))
        .toString();
  }
}

class AdminSetDeliveryFeeDtoRuleOneOfBuilder
    implements
        Builder<
          AdminSetDeliveryFeeDtoRuleOneOf,
          AdminSetDeliveryFeeDtoRuleOneOfBuilder
        > {
  _$AdminSetDeliveryFeeDtoRuleOneOf? _$v;

  AdminSetDeliveryFeeDtoRuleOneOfKindEnum? _kind;
  AdminSetDeliveryFeeDtoRuleOneOfKindEnum? get kind => _$this._kind;
  set kind(AdminSetDeliveryFeeDtoRuleOneOfKindEnum? kind) =>
      _$this._kind = kind;

  String? _flatFee;
  String? get flatFee => _$this._flatFee;
  set flatFee(String? flatFee) => _$this._flatFee = flatFee;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _minimumFee;
  String? get minimumFee => _$this._minimumFee;
  set minimumFee(String? minimumFee) => _$this._minimumFee = minimumFee;

  String? _freeDeliveryFrom;
  String? get freeDeliveryFrom => _$this._freeDeliveryFrom;
  set freeDeliveryFrom(String? freeDeliveryFrom) =>
      _$this._freeDeliveryFrom = freeDeliveryFrom;

  AdminSetDeliveryFeeDtoRuleOneOfBuilder() {
    AdminSetDeliveryFeeDtoRuleOneOf._defaults(this);
  }

  AdminSetDeliveryFeeDtoRuleOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _flatFee = $v.flatFee;
      _currency = $v.currency;
      _minimumFee = $v.minimumFee;
      _freeDeliveryFrom = $v.freeDeliveryFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetDeliveryFeeDtoRuleOneOf other) {
    _$v = other as _$AdminSetDeliveryFeeDtoRuleOneOf;
  }

  @override
  void update(void Function(AdminSetDeliveryFeeDtoRuleOneOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDtoRuleOneOf build() => _build();

  _$AdminSetDeliveryFeeDtoRuleOneOf _build() {
    final _$result =
        _$v ??
        _$AdminSetDeliveryFeeDtoRuleOneOf._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminSetDeliveryFeeDtoRuleOneOf',
            'kind',
          ),
          flatFee: BuiltValueNullFieldError.checkNotNull(
            flatFee,
            r'AdminSetDeliveryFeeDtoRuleOneOf',
            'flatFee',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSetDeliveryFeeDtoRuleOneOf',
            'currency',
          ),
          minimumFee: minimumFee,
          freeDeliveryFrom: freeDeliveryFrom,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
