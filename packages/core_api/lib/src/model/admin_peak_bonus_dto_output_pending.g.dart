// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output_pending.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutputPending extends AdminPeakBonusDtoOutputPending {
  @override
  final bool enabled;
  @override
  final String currency;
  @override
  final DateTime effectiveFrom;
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInner> windows;

  factory _$AdminPeakBonusDtoOutputPending([
    void Function(AdminPeakBonusDtoOutputPendingBuilder)? updates,
  ]) => (AdminPeakBonusDtoOutputPendingBuilder()..update(updates))._build();

  _$AdminPeakBonusDtoOutputPending._({
    required this.enabled,
    required this.currency,
    required this.effectiveFrom,
    required this.windows,
  }) : super._();
  @override
  AdminPeakBonusDtoOutputPending rebuild(
    void Function(AdminPeakBonusDtoOutputPendingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputPendingBuilder toBuilder() =>
      AdminPeakBonusDtoOutputPendingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutputPending &&
        enabled == other.enabled &&
        currency == other.currency &&
        effectiveFrom == other.effectiveFrom &&
        windows == other.windows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, windows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPeakBonusDtoOutputPending')
          ..add('enabled', enabled)
          ..add('currency', currency)
          ..add('effectiveFrom', effectiveFrom)
          ..add('windows', windows))
        .toString();
  }
}

class AdminPeakBonusDtoOutputPendingBuilder
    implements
        Builder<
          AdminPeakBonusDtoOutputPending,
          AdminPeakBonusDtoOutputPendingBuilder
        > {
  _$AdminPeakBonusDtoOutputPending? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInner>? _windows;
  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInner> get windows =>
      _$this._windows ??=
          ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInner>();
  set windows(
    ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInner>? windows,
  ) => _$this._windows = windows;

  AdminPeakBonusDtoOutputPendingBuilder() {
    AdminPeakBonusDtoOutputPending._defaults(this);
  }

  AdminPeakBonusDtoOutputPendingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _currency = $v.currency;
      _effectiveFrom = $v.effectiveFrom;
      _windows = $v.windows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPeakBonusDtoOutputPending other) {
    _$v = other as _$AdminPeakBonusDtoOutputPending;
  }

  @override
  void update(void Function(AdminPeakBonusDtoOutputPendingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutputPending build() => _build();

  _$AdminPeakBonusDtoOutputPending _build() {
    _$AdminPeakBonusDtoOutputPending _$result;
    try {
      _$result =
          _$v ??
          _$AdminPeakBonusDtoOutputPending._(
            enabled: BuiltValueNullFieldError.checkNotNull(
              enabled,
              r'AdminPeakBonusDtoOutputPending',
              'enabled',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminPeakBonusDtoOutputPending',
              'currency',
            ),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'AdminPeakBonusDtoOutputPending',
              'effectiveFrom',
            ),
            windows: windows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'windows';
        windows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPeakBonusDtoOutputPending',
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
