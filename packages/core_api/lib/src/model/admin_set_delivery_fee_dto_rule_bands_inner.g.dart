// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto_rule_bands_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetDeliveryFeeDtoRuleBandsInner
    extends AdminSetDeliveryFeeDtoRuleBandsInner {
  @override
  final int? upToMetres;
  @override
  final String fee;

  factory _$AdminSetDeliveryFeeDtoRuleBandsInner([
    void Function(AdminSetDeliveryFeeDtoRuleBandsInnerBuilder)? updates,
  ]) =>
      (AdminSetDeliveryFeeDtoRuleBandsInnerBuilder()..update(updates))._build();

  _$AdminSetDeliveryFeeDtoRuleBandsInner._({this.upToMetres, required this.fee})
    : super._();
  @override
  AdminSetDeliveryFeeDtoRuleBandsInner rebuild(
    void Function(AdminSetDeliveryFeeDtoRuleBandsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoRuleBandsInnerBuilder toBuilder() =>
      AdminSetDeliveryFeeDtoRuleBandsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDtoRuleBandsInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSetDeliveryFeeDtoRuleBandsInner')
          ..add('upToMetres', upToMetres)
          ..add('fee', fee))
        .toString();
  }
}

class AdminSetDeliveryFeeDtoRuleBandsInnerBuilder
    implements
        Builder<
          AdminSetDeliveryFeeDtoRuleBandsInner,
          AdminSetDeliveryFeeDtoRuleBandsInnerBuilder
        > {
  _$AdminSetDeliveryFeeDtoRuleBandsInner? _$v;

  int? _upToMetres;
  int? get upToMetres => _$this._upToMetres;
  set upToMetres(int? upToMetres) => _$this._upToMetres = upToMetres;

  String? _fee;
  String? get fee => _$this._fee;
  set fee(String? fee) => _$this._fee = fee;

  AdminSetDeliveryFeeDtoRuleBandsInnerBuilder() {
    AdminSetDeliveryFeeDtoRuleBandsInner._defaults(this);
  }

  AdminSetDeliveryFeeDtoRuleBandsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _upToMetres = $v.upToMetres;
      _fee = $v.fee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetDeliveryFeeDtoRuleBandsInner other) {
    _$v = other as _$AdminSetDeliveryFeeDtoRuleBandsInner;
  }

  @override
  void update(
    void Function(AdminSetDeliveryFeeDtoRuleBandsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDtoRuleBandsInner build() => _build();

  _$AdminSetDeliveryFeeDtoRuleBandsInner _build() {
    final _$result =
        _$v ??
        _$AdminSetDeliveryFeeDtoRuleBandsInner._(
          upToMetres: upToMetres,
          fee: BuiltValueNullFieldError.checkNotNull(
            fee,
            r'AdminSetDeliveryFeeDtoRuleBandsInner',
            'fee',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
