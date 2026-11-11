// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutput extends AdminPeakBonusDtoOutput {
  @override
  final AdminPeakBonusDtoOutputInForce? inForce;
  @override
  final AdminPeakBonusDtoOutputPending? pending;
  @override
  final BuiltList<AdminPeakBonusDtoOutputZonesInner> zones;
  @override
  final String? baseCurrency;

  factory _$AdminPeakBonusDtoOutput([
    void Function(AdminPeakBonusDtoOutputBuilder)? updates,
  ]) => (AdminPeakBonusDtoOutputBuilder()..update(updates))._build();

  _$AdminPeakBonusDtoOutput._({
    this.inForce,
    this.pending,
    required this.zones,
    this.baseCurrency,
  }) : super._();
  @override
  AdminPeakBonusDtoOutput rebuild(
    void Function(AdminPeakBonusDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputBuilder toBuilder() =>
      AdminPeakBonusDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutput &&
        inForce == other.inForce &&
        pending == other.pending &&
        zones == other.zones &&
        baseCurrency == other.baseCurrency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inForce.hashCode);
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPeakBonusDtoOutput')
          ..add('inForce', inForce)
          ..add('pending', pending)
          ..add('zones', zones)
          ..add('baseCurrency', baseCurrency))
        .toString();
  }
}

class AdminPeakBonusDtoOutputBuilder
    implements
        Builder<AdminPeakBonusDtoOutput, AdminPeakBonusDtoOutputBuilder> {
  _$AdminPeakBonusDtoOutput? _$v;

  AdminPeakBonusDtoOutputInForceBuilder? _inForce;
  AdminPeakBonusDtoOutputInForceBuilder get inForce =>
      _$this._inForce ??= AdminPeakBonusDtoOutputInForceBuilder();
  set inForce(AdminPeakBonusDtoOutputInForceBuilder? inForce) =>
      _$this._inForce = inForce;

  AdminPeakBonusDtoOutputPendingBuilder? _pending;
  AdminPeakBonusDtoOutputPendingBuilder get pending =>
      _$this._pending ??= AdminPeakBonusDtoOutputPendingBuilder();
  set pending(AdminPeakBonusDtoOutputPendingBuilder? pending) =>
      _$this._pending = pending;

  ListBuilder<AdminPeakBonusDtoOutputZonesInner>? _zones;
  ListBuilder<AdminPeakBonusDtoOutputZonesInner> get zones =>
      _$this._zones ??= ListBuilder<AdminPeakBonusDtoOutputZonesInner>();
  set zones(ListBuilder<AdminPeakBonusDtoOutputZonesInner>? zones) =>
      _$this._zones = zones;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  AdminPeakBonusDtoOutputBuilder() {
    AdminPeakBonusDtoOutput._defaults(this);
  }

  AdminPeakBonusDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inForce = $v.inForce?.toBuilder();
      _pending = $v.pending?.toBuilder();
      _zones = $v.zones.toBuilder();
      _baseCurrency = $v.baseCurrency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPeakBonusDtoOutput other) {
    _$v = other as _$AdminPeakBonusDtoOutput;
  }

  @override
  void update(void Function(AdminPeakBonusDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutput build() => _build();

  _$AdminPeakBonusDtoOutput _build() {
    _$AdminPeakBonusDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminPeakBonusDtoOutput._(
            inForce: _inForce?.build(),
            pending: _pending?.build(),
            zones: zones.build(),
            baseCurrency: baseCurrency,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'inForce';
        _inForce?.build();
        _$failedField = 'pending';
        _pending?.build();
        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPeakBonusDtoOutput',
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
