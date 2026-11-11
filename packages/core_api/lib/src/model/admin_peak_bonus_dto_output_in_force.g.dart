// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output_in_force.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutputInForce extends AdminPeakBonusDtoOutputInForce {
  @override
  final String id;
  @override
  final bool enabled;
  @override
  final String currency;
  @override
  final DateTime effectiveFrom;
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInner> windows;

  factory _$AdminPeakBonusDtoOutputInForce([
    void Function(AdminPeakBonusDtoOutputInForceBuilder)? updates,
  ]) => (AdminPeakBonusDtoOutputInForceBuilder()..update(updates))._build();

  _$AdminPeakBonusDtoOutputInForce._({
    required this.id,
    required this.enabled,
    required this.currency,
    required this.effectiveFrom,
    required this.windows,
  }) : super._();
  @override
  AdminPeakBonusDtoOutputInForce rebuild(
    void Function(AdminPeakBonusDtoOutputInForceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputInForceBuilder toBuilder() =>
      AdminPeakBonusDtoOutputInForceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutputInForce &&
        id == other.id &&
        enabled == other.enabled &&
        currency == other.currency &&
        effectiveFrom == other.effectiveFrom &&
        windows == other.windows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, windows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPeakBonusDtoOutputInForce')
          ..add('id', id)
          ..add('enabled', enabled)
          ..add('currency', currency)
          ..add('effectiveFrom', effectiveFrom)
          ..add('windows', windows))
        .toString();
  }
}

class AdminPeakBonusDtoOutputInForceBuilder
    implements
        Builder<
          AdminPeakBonusDtoOutputInForce,
          AdminPeakBonusDtoOutputInForceBuilder
        > {
  _$AdminPeakBonusDtoOutputInForce? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  AdminPeakBonusDtoOutputInForceBuilder() {
    AdminPeakBonusDtoOutputInForce._defaults(this);
  }

  AdminPeakBonusDtoOutputInForceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _enabled = $v.enabled;
      _currency = $v.currency;
      _effectiveFrom = $v.effectiveFrom;
      _windows = $v.windows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPeakBonusDtoOutputInForce other) {
    _$v = other as _$AdminPeakBonusDtoOutputInForce;
  }

  @override
  void update(void Function(AdminPeakBonusDtoOutputInForceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutputInForce build() => _build();

  _$AdminPeakBonusDtoOutputInForce _build() {
    _$AdminPeakBonusDtoOutputInForce _$result;
    try {
      _$result =
          _$v ??
          _$AdminPeakBonusDtoOutputInForce._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminPeakBonusDtoOutputInForce',
              'id',
            ),
            enabled: BuiltValueNullFieldError.checkNotNull(
              enabled,
              r'AdminPeakBonusDtoOutputInForce',
              'enabled',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminPeakBonusDtoOutputInForce',
              'currency',
            ),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'AdminPeakBonusDtoOutputInForce',
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
          r'AdminPeakBonusDtoOutputInForce',
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
