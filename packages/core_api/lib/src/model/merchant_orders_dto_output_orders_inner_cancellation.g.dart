// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_cancellation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerCancellation
    extends MerchantOrdersDtoOutputOrdersInnerCancellation {
  @override
  final DateTime at;
  @override
  final String reason;
  @override
  final String label;
  @override
  final bool byOperations;

  factory _$MerchantOrdersDtoOutputOrdersInnerCancellation([
    void Function(MerchantOrdersDtoOutputOrdersInnerCancellationBuilder)?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerCancellationBuilder()..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerCancellation._({
    required this.at,
    required this.reason,
    required this.label,
    required this.byOperations,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerCancellation rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerCancellationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerCancellationBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerCancellationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerCancellation &&
        at == other.at &&
        reason == other.reason &&
        label == other.label &&
        byOperations == other.byOperations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, byOperations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerCancellation',
          )
          ..add('at', at)
          ..add('reason', reason)
          ..add('label', label)
          ..add('byOperations', byOperations))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerCancellationBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerCancellation,
          MerchantOrdersDtoOutputOrdersInnerCancellationBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerCancellation? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _byOperations;
  bool? get byOperations => _$this._byOperations;
  set byOperations(bool? byOperations) => _$this._byOperations = byOperations;

  MerchantOrdersDtoOutputOrdersInnerCancellationBuilder() {
    MerchantOrdersDtoOutputOrdersInnerCancellation._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerCancellationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _reason = $v.reason;
      _label = $v.label;
      _byOperations = $v.byOperations;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerCancellation other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerCancellation;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerCancellationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCancellation build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerCancellation _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerCancellation._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'MerchantOrdersDtoOutputOrdersInnerCancellation',
            'at',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'MerchantOrdersDtoOutputOrdersInnerCancellation',
            'reason',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'MerchantOrdersDtoOutputOrdersInnerCancellation',
            'label',
          ),
          byOperations: BuiltValueNullFieldError.checkNotNull(
            byOperations,
            r'MerchantOrdersDtoOutputOrdersInnerCancellation',
            'byOperations',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
