// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetDeliveryFeeDto extends AdminSetDeliveryFeeDto {
  @override
  final String cityId;
  @override
  final AdminSetDeliveryFeeDtoRule rule;
  @override
  final String? reason;

  factory _$AdminSetDeliveryFeeDto([
    void Function(AdminSetDeliveryFeeDtoBuilder)? updates,
  ]) => (AdminSetDeliveryFeeDtoBuilder()..update(updates))._build();

  _$AdminSetDeliveryFeeDto._({
    required this.cityId,
    required this.rule,
    this.reason,
  }) : super._();
  @override
  AdminSetDeliveryFeeDto rebuild(
    void Function(AdminSetDeliveryFeeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoBuilder toBuilder() =>
      AdminSetDeliveryFeeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDto &&
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
    return (newBuiltValueToStringHelper(r'AdminSetDeliveryFeeDto')
          ..add('cityId', cityId)
          ..add('rule', rule)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSetDeliveryFeeDtoBuilder
    implements Builder<AdminSetDeliveryFeeDto, AdminSetDeliveryFeeDtoBuilder> {
  _$AdminSetDeliveryFeeDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminSetDeliveryFeeDtoRuleBuilder? _rule;
  AdminSetDeliveryFeeDtoRuleBuilder get rule =>
      _$this._rule ??= AdminSetDeliveryFeeDtoRuleBuilder();
  set rule(AdminSetDeliveryFeeDtoRuleBuilder? rule) => _$this._rule = rule;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSetDeliveryFeeDtoBuilder() {
    AdminSetDeliveryFeeDto._defaults(this);
  }

  AdminSetDeliveryFeeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _rule = $v.rule.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetDeliveryFeeDto other) {
    _$v = other as _$AdminSetDeliveryFeeDto;
  }

  @override
  void update(void Function(AdminSetDeliveryFeeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDto build() => _build();

  _$AdminSetDeliveryFeeDto _build() {
    _$AdminSetDeliveryFeeDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetDeliveryFeeDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminSetDeliveryFeeDto',
              'cityId',
            ),
            rule: rule.build(),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rule';
        rule.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetDeliveryFeeDto',
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
