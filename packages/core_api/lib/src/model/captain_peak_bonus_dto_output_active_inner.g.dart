// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_peak_bonus_dto_output_active_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPeakBonusDtoOutputActiveInner
    extends CaptainPeakBonusDtoOutputActiveInner {
  @override
  final CaptainPeakBonusDtoOutputActiveInnerAmount amount;
  @override
  final DateTime until;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> zones;

  factory _$CaptainPeakBonusDtoOutputActiveInner([
    void Function(CaptainPeakBonusDtoOutputActiveInnerBuilder)? updates,
  ]) =>
      (CaptainPeakBonusDtoOutputActiveInnerBuilder()..update(updates))._build();

  _$CaptainPeakBonusDtoOutputActiveInner._({
    required this.amount,
    required this.until,
    required this.zones,
  }) : super._();
  @override
  CaptainPeakBonusDtoOutputActiveInner rebuild(
    void Function(CaptainPeakBonusDtoOutputActiveInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPeakBonusDtoOutputActiveInnerBuilder toBuilder() =>
      CaptainPeakBonusDtoOutputActiveInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPeakBonusDtoOutputActiveInner &&
        amount == other.amount &&
        until == other.until &&
        zones == other.zones;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPeakBonusDtoOutputActiveInner')
          ..add('amount', amount)
          ..add('until', until)
          ..add('zones', zones))
        .toString();
  }
}

class CaptainPeakBonusDtoOutputActiveInnerBuilder
    implements
        Builder<
          CaptainPeakBonusDtoOutputActiveInner,
          CaptainPeakBonusDtoOutputActiveInnerBuilder
        > {
  _$CaptainPeakBonusDtoOutputActiveInner? _$v;

  CaptainPeakBonusDtoOutputActiveInnerAmountBuilder? _amount;
  CaptainPeakBonusDtoOutputActiveInnerAmountBuilder get amount =>
      _$this._amount ??= CaptainPeakBonusDtoOutputActiveInnerAmountBuilder();
  set amount(CaptainPeakBonusDtoOutputActiveInnerAmountBuilder? amount) =>
      _$this._amount = amount;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? _zones;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get zones =>
      _$this._zones ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>();
  set zones(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? zones,
  ) => _$this._zones = zones;

  CaptainPeakBonusDtoOutputActiveInnerBuilder() {
    CaptainPeakBonusDtoOutputActiveInner._defaults(this);
  }

  CaptainPeakBonusDtoOutputActiveInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount.toBuilder();
      _until = $v.until;
      _zones = $v.zones.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPeakBonusDtoOutputActiveInner other) {
    _$v = other as _$CaptainPeakBonusDtoOutputActiveInner;
  }

  @override
  void update(
    void Function(CaptainPeakBonusDtoOutputActiveInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPeakBonusDtoOutputActiveInner build() => _build();

  _$CaptainPeakBonusDtoOutputActiveInner _build() {
    _$CaptainPeakBonusDtoOutputActiveInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPeakBonusDtoOutputActiveInner._(
            amount: amount.build(),
            until: BuiltValueNullFieldError.checkNotNull(
              until,
              r'CaptainPeakBonusDtoOutputActiveInner',
              'until',
            ),
            zones: zones.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        amount.build();

        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPeakBonusDtoOutputActiveInner',
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
