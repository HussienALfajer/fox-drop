// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetDeliveryFeeDtoRuleKindEnum
_$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands =
    const AdminSetDeliveryFeeDtoRuleKindEnum._('distanceBands');

AdminSetDeliveryFeeDtoRuleKindEnum _$adminSetDeliveryFeeDtoRuleKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'distanceBands':
      return _$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetDeliveryFeeDtoRuleKindEnum>
_$adminSetDeliveryFeeDtoRuleKindEnumValues =
    BuiltSet<AdminSetDeliveryFeeDtoRuleKindEnum>(
      const <AdminSetDeliveryFeeDtoRuleKindEnum>[
        _$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands,
      ],
    );

Serializer<AdminSetDeliveryFeeDtoRuleKindEnum>
_$adminSetDeliveryFeeDtoRuleKindEnumSerializer =
    _$AdminSetDeliveryFeeDtoRuleKindEnumSerializer();

class _$AdminSetDeliveryFeeDtoRuleKindEnumSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSetDeliveryFeeDtoRuleKindEnum];
  @override
  final String wireName = 'AdminSetDeliveryFeeDtoRuleKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetDeliveryFeeDtoRuleKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetDeliveryFeeDtoRuleKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetDeliveryFeeDtoRule extends AdminSetDeliveryFeeDtoRule {
  @override
  final OneOf oneOf;

  factory _$AdminSetDeliveryFeeDtoRule([
    void Function(AdminSetDeliveryFeeDtoRuleBuilder)? updates,
  ]) => (AdminSetDeliveryFeeDtoRuleBuilder()..update(updates))._build();

  _$AdminSetDeliveryFeeDtoRule._({required this.oneOf}) : super._();
  @override
  AdminSetDeliveryFeeDtoRule rebuild(
    void Function(AdminSetDeliveryFeeDtoRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoRuleBuilder toBuilder() =>
      AdminSetDeliveryFeeDtoRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDtoRule && oneOf == other.oneOf;
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
      r'AdminSetDeliveryFeeDtoRule',
    )..add('oneOf', oneOf)).toString();
  }
}

class AdminSetDeliveryFeeDtoRuleBuilder
    implements
        Builder<AdminSetDeliveryFeeDtoRule, AdminSetDeliveryFeeDtoRuleBuilder> {
  _$AdminSetDeliveryFeeDtoRule? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  AdminSetDeliveryFeeDtoRuleBuilder() {
    AdminSetDeliveryFeeDtoRule._defaults(this);
  }

  AdminSetDeliveryFeeDtoRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetDeliveryFeeDtoRule other) {
    _$v = other as _$AdminSetDeliveryFeeDtoRule;
  }

  @override
  void update(void Function(AdminSetDeliveryFeeDtoRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDtoRule build() => _build();

  _$AdminSetDeliveryFeeDtoRule _build() {
    final _$result =
        _$v ??
        _$AdminSetDeliveryFeeDtoRule._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'AdminSetDeliveryFeeDtoRule',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
