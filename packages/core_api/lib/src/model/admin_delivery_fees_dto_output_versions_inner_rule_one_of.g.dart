// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_versions_inner_rule_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum_flat =
    const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum._('flat');

AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumValueOf(String name) {
  switch (name) {
    case 'flat':
      return _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum_flat;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumValues =
    BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum>(
      const <AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum>[
        _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum_flat,
      ],
    );

Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumSerializer =
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumSerializer();

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'flat': 'flat',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'flat': 'flat',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum,
  ];
  @override
  final String wireName =
      'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf
    extends AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf {
  @override
  final String id;
  @override
  final AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum kind;
  @override
  final String flatFee;
  @override
  final String currency;
  @override
  final String? minimumFee;
  @override
  final String? freeDeliveryFrom;

  factory _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf([
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder)?
    updates,
  ]) =>
      (AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder()
            ..update(updates))
          ._build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf._({
    required this.id,
    required this.kind,
    required this.flatFee,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf rebuild(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf &&
        id == other.id &&
        kind == other.kind &&
        flatFee == other.flatFee &&
        currency == other.currency &&
        minimumFee == other.minimumFee &&
        freeDeliveryFrom == other.freeDeliveryFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf',
          )
          ..add('id', id)
          ..add('kind', kind)
          ..add('flatFee', flatFee)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder
        > {
  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum? _kind;
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum? get kind =>
      _$this._kind;
  set kind(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum? kind) =>
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

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder() {
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf._defaults(this);
  }

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
  void replace(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf build() => _build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf _build() {
    final _$result =
        _$v ??
        _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf',
            'id',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf',
            'kind',
          ),
          flatFee: BuiltValueNullFieldError.checkNotNull(
            flatFee,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf',
            'flatFee',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf',
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
