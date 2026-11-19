// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto_rule_one_of1_bands_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner
    extends AdminSetDeliveryFeeDtoRuleOneOf1BandsInner {
  @override
  final int? upToMetres;
  @override
  final String fee;

  factory _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner([
    void Function(AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder)? updates,
  ]) => (AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder()..update(updates))
      ._build();

  _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner._({
    this.upToMetres,
    required this.fee,
  }) : super._();
  @override
  AdminSetDeliveryFeeDtoRuleOneOf1BandsInner rebuild(
    void Function(AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder toBuilder() =>
      AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDtoRuleOneOf1BandsInner &&
        upToMetres == other.upToMetres &&
        fee == other.fee;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, upToMetres.hashCode);
    _$hash = $jc(_$hash, fee.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSetDeliveryFeeDtoRuleOneOf1BandsInner',
          )
          ..add('upToMetres', upToMetres)
          ..add('fee', fee))
        .toString();
  }
}

class AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder
    implements
        Builder<
          AdminSetDeliveryFeeDtoRuleOneOf1BandsInner,
          AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder
        > {
  _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner? _$v;

  int? _upToMetres;
  int? get upToMetres => _$this._upToMetres;
  set upToMetres(int? upToMetres) => _$this._upToMetres = upToMetres;

  String? _fee;
  String? get fee => _$this._fee;
  set fee(String? fee) => _$this._fee = fee;

  AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder() {
    AdminSetDeliveryFeeDtoRuleOneOf1BandsInner._defaults(this);
  }

  AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _upToMetres = $v.upToMetres;
      _fee = $v.fee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetDeliveryFeeDtoRuleOneOf1BandsInner other) {
    _$v = other as _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner;
  }

  @override
  void update(
    void Function(AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDtoRuleOneOf1BandsInner build() => _build();

  _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner _build() {
    final _$result =
        _$v ??
        _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner._(
          upToMetres: upToMetres,
          fee: BuiltValueNullFieldError.checkNotNull(
            fee,
            r'AdminSetDeliveryFeeDtoRuleOneOf1BandsInner',
            'fee',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
