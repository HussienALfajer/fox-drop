// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_versions_inner_rule_bands_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner
    extends AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner {
  @override
  final int? upToMetres;
  @override
  final String fee;

  factory _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner([
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder)?
    updates,
  ]) =>
      (AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner._({
    this.upToMetres,
    required this.fee,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner rebuild(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner &&
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
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner',
          )
          ..add('upToMetres', upToMetres)
          ..add('fee', fee))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder
        > {
  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner? _$v;

  int? _upToMetres;
  int? get upToMetres => _$this._upToMetres;
  set upToMetres(int? upToMetres) => _$this._upToMetres = upToMetres;

  String? _fee;
  String? get fee => _$this._fee;
  set fee(String? fee) => _$this._fee = fee;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder() {
    AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner._defaults(this);
  }

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _upToMetres = $v.upToMetres;
      _fee = $v.fee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner build() => _build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner _build() {
    final _$result =
        _$v ??
        _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner._(
          upToMetres: upToMetres,
          fee: BuiltValueNullFieldError.checkNotNull(
            fee,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner',
            'fee',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
