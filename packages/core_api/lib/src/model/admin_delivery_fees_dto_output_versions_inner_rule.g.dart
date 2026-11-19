// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_versions_inner_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands =
    const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum._(
      'distanceBands',
    );

AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumValueOf(String name) {
  switch (name) {
    case 'distanceBands':
      return _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumValues =
    BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>(
      const <AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>[
        _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands,
      ],
    );

Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer =
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer();

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum,
  ];
  @override
  final String wireName = 'AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRule
    extends AdminDeliveryFeesDtoOutputVersionsInnerRule {
  @override
  final OneOf oneOf;

  factory _$AdminDeliveryFeesDtoOutputVersionsInnerRule([
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder)? updates,
  ]) => (AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder()..update(updates))
      ._build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRule._({required this.oneOf})
    : super._();
  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRule rebuild(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputVersionsInnerRule &&
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
      r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
    )..add('oneOf', oneOf)).toString();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputVersionsInnerRule,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder
        > {
  _$AdminDeliveryFeesDtoOutputVersionsInnerRule? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder() {
    AdminDeliveryFeesDtoOutputVersionsInnerRule._defaults(this);
  }

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeesDtoOutputVersionsInnerRule other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputVersionsInnerRule;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRule build() => _build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRule _build() {
    final _$result =
        _$v ??
        _$AdminDeliveryFeesDtoOutputVersionsInnerRule._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
