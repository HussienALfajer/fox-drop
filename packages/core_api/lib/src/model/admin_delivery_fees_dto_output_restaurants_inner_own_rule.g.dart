// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_restaurants_inner_own_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule
    extends AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule {
  @override
  final AdminDeliveryFeesDtoOutputVersionsInnerRule rule;
  @override
  final String? editorName;
  @override
  final String? reason;
  @override
  final DateTime createdAt;

  factory _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule([
    void Function(AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder)?
    updates,
  ]) =>
      (AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder()
            ..update(updates))
          ._build();

  _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule._({
    required this.rule,
    this.editorName,
    this.reason,
    required this.createdAt,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule rebuild(
    void Function(AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule &&
        rule == other.rule &&
        editorName == other.editorName &&
        reason == other.reason &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rule.hashCode);
    _$hash = $jc(_$hash, editorName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule',
          )
          ..add('rule', rule)
          ..add('editorName', editorName)
          ..add('reason', reason)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule,
          AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder
        > {
  _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule? _$v;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder? _rule;
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder get rule =>
      _$this._rule ??= AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder();
  set rule(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder? rule) =>
      _$this._rule = rule;

  String? _editorName;
  String? get editorName => _$this._editorName;
  set editorName(String? editorName) => _$this._editorName = editorName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder() {
    AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule._defaults(this);
  }

  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rule = $v.rule.toBuilder();
      _editorName = $v.editorName;
      _reason = $v.reason;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule build() => _build();

  _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule _build() {
    _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule._(
            rule: rule.build(),
            editorName: editorName,
            reason: reason,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rule';
        rule.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule',
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
