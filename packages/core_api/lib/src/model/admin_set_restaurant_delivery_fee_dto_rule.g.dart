// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_restaurant_delivery_fee_dto_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands =
    const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum._('distanceBands');

AdminSetRestaurantDeliveryFeeDtoRuleKindEnum
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnumValueOf(String name) {
  switch (name) {
    case 'distanceBands':
      return _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnumValues =
    BuiltSet<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>(
      const <AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>[
        _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands,
      ],
    );

Serializer<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer =
    _$AdminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer();

class _$AdminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer
    implements
        PrimitiveSerializer<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSetRestaurantDeliveryFeeDtoRuleKindEnum,
  ];
  @override
  final String wireName = 'AdminSetRestaurantDeliveryFeeDtoRuleKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDtoRuleKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetRestaurantDeliveryFeeDtoRuleKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetRestaurantDeliveryFeeDtoRuleKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetRestaurantDeliveryFeeDtoRule
    extends AdminSetRestaurantDeliveryFeeDtoRule {
  @override
  final OneOf oneOf;

  factory _$AdminSetRestaurantDeliveryFeeDtoRule([
    void Function(AdminSetRestaurantDeliveryFeeDtoRuleBuilder)? updates,
  ]) =>
      (AdminSetRestaurantDeliveryFeeDtoRuleBuilder()..update(updates))._build();

  _$AdminSetRestaurantDeliveryFeeDtoRule._({required this.oneOf}) : super._();
  @override
  AdminSetRestaurantDeliveryFeeDtoRule rebuild(
    void Function(AdminSetRestaurantDeliveryFeeDtoRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetRestaurantDeliveryFeeDtoRuleBuilder toBuilder() =>
      AdminSetRestaurantDeliveryFeeDtoRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetRestaurantDeliveryFeeDtoRule &&
        oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminSetRestaurantDeliveryFeeDtoRule',
    )..add('oneOf', oneOf)).toString();
  }
}

class AdminSetRestaurantDeliveryFeeDtoRuleBuilder
    implements
        Builder<
          AdminSetRestaurantDeliveryFeeDtoRule,
          AdminSetRestaurantDeliveryFeeDtoRuleBuilder
        > {
  _$AdminSetRestaurantDeliveryFeeDtoRule? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  AdminSetRestaurantDeliveryFeeDtoRuleBuilder() {
    AdminSetRestaurantDeliveryFeeDtoRule._defaults(this);
  }

  AdminSetRestaurantDeliveryFeeDtoRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetRestaurantDeliveryFeeDtoRule other) {
    _$v = other as _$AdminSetRestaurantDeliveryFeeDtoRule;
  }

  @override
  void update(
    void Function(AdminSetRestaurantDeliveryFeeDtoRuleBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetRestaurantDeliveryFeeDtoRule build() => _build();

  _$AdminSetRestaurantDeliveryFeeDtoRule _build() {
    final _$result =
        _$v ??
        _$AdminSetRestaurantDeliveryFeeDtoRule._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'AdminSetRestaurantDeliveryFeeDtoRule',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
