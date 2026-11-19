// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_restaurant_delivery_fee_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetRestaurantDeliveryFeeDto
    extends AdminSetRestaurantDeliveryFeeDto {
  @override
  final String cityId;
  @override
  final AdminSetRestaurantDeliveryFeeDtoRule? rule;
  @override
  final String? reason;

  factory _$AdminSetRestaurantDeliveryFeeDto([
    void Function(AdminSetRestaurantDeliveryFeeDtoBuilder)? updates,
  ]) => (AdminSetRestaurantDeliveryFeeDtoBuilder()..update(updates))._build();

  _$AdminSetRestaurantDeliveryFeeDto._({
    required this.cityId,
    this.rule,
    this.reason,
  }) : super._();
  @override
  AdminSetRestaurantDeliveryFeeDto rebuild(
    void Function(AdminSetRestaurantDeliveryFeeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetRestaurantDeliveryFeeDtoBuilder toBuilder() =>
      AdminSetRestaurantDeliveryFeeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetRestaurantDeliveryFeeDto &&
        cityId == other.cityId &&
        rule == other.rule &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, rule.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetRestaurantDeliveryFeeDto')
          ..add('cityId', cityId)
          ..add('rule', rule)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSetRestaurantDeliveryFeeDtoBuilder
    implements
        Builder<
          AdminSetRestaurantDeliveryFeeDto,
          AdminSetRestaurantDeliveryFeeDtoBuilder
        > {
  _$AdminSetRestaurantDeliveryFeeDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminSetRestaurantDeliveryFeeDtoRuleBuilder? _rule;
  AdminSetRestaurantDeliveryFeeDtoRuleBuilder get rule =>
      _$this._rule ??= AdminSetRestaurantDeliveryFeeDtoRuleBuilder();
  set rule(AdminSetRestaurantDeliveryFeeDtoRuleBuilder? rule) =>
      _$this._rule = rule;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSetRestaurantDeliveryFeeDtoBuilder() {
    AdminSetRestaurantDeliveryFeeDto._defaults(this);
  }

  AdminSetRestaurantDeliveryFeeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _rule = $v.rule?.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetRestaurantDeliveryFeeDto other) {
    _$v = other as _$AdminSetRestaurantDeliveryFeeDto;
  }

  @override
  void update(void Function(AdminSetRestaurantDeliveryFeeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetRestaurantDeliveryFeeDto build() => _build();

  _$AdminSetRestaurantDeliveryFeeDto _build() {
    _$AdminSetRestaurantDeliveryFeeDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetRestaurantDeliveryFeeDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminSetRestaurantDeliveryFeeDto',
              'cityId',
            ),
            rule: _rule?.build(),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rule';
        _rule?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetRestaurantDeliveryFeeDto',
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
