// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_parties_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualPartiesDtoOutput extends AdminManualPartiesDtoOutput {
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  parties;

  factory _$AdminManualPartiesDtoOutput([
    void Function(AdminManualPartiesDtoOutputBuilder)? updates,
  ]) => (AdminManualPartiesDtoOutputBuilder()..update(updates))._build();

  _$AdminManualPartiesDtoOutput._({required this.parties}) : super._();
  @override
  AdminManualPartiesDtoOutput rebuild(
    void Function(AdminManualPartiesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualPartiesDtoOutputBuilder toBuilder() =>
      AdminManualPartiesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualPartiesDtoOutput && parties == other.parties;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parties.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminManualPartiesDtoOutput',
    )..add('parties', parties)).toString();
  }
}

class AdminManualPartiesDtoOutputBuilder
    implements
        Builder<
          AdminManualPartiesDtoOutput,
          AdminManualPartiesDtoOutputBuilder
        > {
  _$AdminManualPartiesDtoOutput? _$v;

  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>? _parties;
  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get parties => _$this._parties ??=
      ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>();
  set parties(
    ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>? parties,
  ) => _$this._parties = parties;

  AdminManualPartiesDtoOutputBuilder() {
    AdminManualPartiesDtoOutput._defaults(this);
  }

  AdminManualPartiesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _parties = $v.parties.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualPartiesDtoOutput other) {
    _$v = other as _$AdminManualPartiesDtoOutput;
  }

  @override
  void update(void Function(AdminManualPartiesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualPartiesDtoOutput build() => _build();

  _$AdminManualPartiesDtoOutput _build() {
    _$AdminManualPartiesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminManualPartiesDtoOutput._(parties: parties.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parties';
        parties.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminManualPartiesDtoOutput',
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
