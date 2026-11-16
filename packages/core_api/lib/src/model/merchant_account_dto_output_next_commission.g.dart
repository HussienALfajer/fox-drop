// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account_dto_output_next_commission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccountDtoOutputNextCommission
    extends MerchantAccountDtoOutputNextCommission {
  @override
  final int rateBp;
  @override
  final DateTime from;

  factory _$MerchantAccountDtoOutputNextCommission([
    void Function(MerchantAccountDtoOutputNextCommissionBuilder)? updates,
  ]) => (MerchantAccountDtoOutputNextCommissionBuilder()..update(updates))
      ._build();

  _$MerchantAccountDtoOutputNextCommission._({
    required this.rateBp,
    required this.from,
  }) : super._();
  @override
  MerchantAccountDtoOutputNextCommission rebuild(
    void Function(MerchantAccountDtoOutputNextCommissionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAccountDtoOutputNextCommissionBuilder toBuilder() =>
      MerchantAccountDtoOutputNextCommissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccountDtoOutputNextCommission &&
        rateBp == other.rateBp &&
        from == other.from;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantAccountDtoOutputNextCommission',
          )
          ..add('rateBp', rateBp)
          ..add('from', from))
        .toString();
  }
}

class MerchantAccountDtoOutputNextCommissionBuilder
    implements
        Builder<
          MerchantAccountDtoOutputNextCommission,
          MerchantAccountDtoOutputNextCommissionBuilder
        > {
  _$MerchantAccountDtoOutputNextCommission? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  MerchantAccountDtoOutputNextCommissionBuilder() {
    MerchantAccountDtoOutputNextCommission._defaults(this);
  }

  MerchantAccountDtoOutputNextCommissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _from = $v.from;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccountDtoOutputNextCommission other) {
    _$v = other as _$MerchantAccountDtoOutputNextCommission;
  }

  @override
  void update(
    void Function(MerchantAccountDtoOutputNextCommissionBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccountDtoOutputNextCommission build() => _build();

  _$MerchantAccountDtoOutputNextCommission _build() {
    final _$result =
        _$v ??
        _$MerchantAccountDtoOutputNextCommission._(
          rateBp: BuiltValueNullFieldError.checkNotNull(
            rateBp,
            r'MerchantAccountDtoOutputNextCommission',
            'rateBp',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'MerchantAccountDtoOutputNextCommission',
            'from',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
