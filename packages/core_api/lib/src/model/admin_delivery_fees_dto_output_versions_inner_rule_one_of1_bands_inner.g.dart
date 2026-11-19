// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_versions_inner_rule_one_of1_bands_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner
    extends AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner {
  @override
  final int? upToMetres;
  @override
  final String fee;

  factory _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner([
    void Function(
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner._({
    this.upToMetres,
    required this.fee,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner rebuild(
    void Function(
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder
  toBuilder() =>
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner &&
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
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner',
          )
          ..add('upToMetres', upToMetres)
          ..add('fee', fee))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder
        > {
  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner? _$v;

  int? _upToMetres;
  int? get upToMetres => _$this._upToMetres;
  set upToMetres(int? upToMetres) => _$this._upToMetres = upToMetres;

  String? _fee;
  String? get fee => _$this._fee;
  set fee(String? fee) => _$this._fee = fee;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder() {
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner._defaults(this);
  }

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _upToMetres = $v.upToMetres;
      _fee = $v.fee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner other,
  ) {
    _$v =
        other as _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner;
  }

  @override
  void update(
    void Function(
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner build() =>
      _build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner _build() {
    final _$result =
        _$v ??
        _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner._(
          upToMetres: upToMetres,
          fee: BuiltValueNullFieldError.checkNotNull(
            fee,
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner',
            'fee',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
