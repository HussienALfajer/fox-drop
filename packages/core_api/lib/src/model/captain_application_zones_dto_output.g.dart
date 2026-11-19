// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_zones_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationZonesDtoOutput
    extends CaptainApplicationZonesDtoOutput {
  @override
  final BuiltList<CaptainApplicationZonesDtoOutputZonesInner> zones;

  factory _$CaptainApplicationZonesDtoOutput([
    void Function(CaptainApplicationZonesDtoOutputBuilder)? updates,
  ]) => (CaptainApplicationZonesDtoOutputBuilder()..update(updates))._build();

  _$CaptainApplicationZonesDtoOutput._({required this.zones}) : super._();
  @override
  CaptainApplicationZonesDtoOutput rebuild(
    void Function(CaptainApplicationZonesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationZonesDtoOutputBuilder toBuilder() =>
      CaptainApplicationZonesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationZonesDtoOutput && zones == other.zones;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainApplicationZonesDtoOutput',
    )..add('zones', zones)).toString();
  }
}

class CaptainApplicationZonesDtoOutputBuilder
    implements
        Builder<
          CaptainApplicationZonesDtoOutput,
          CaptainApplicationZonesDtoOutputBuilder
        > {
  _$CaptainApplicationZonesDtoOutput? _$v;

  ListBuilder<CaptainApplicationZonesDtoOutputZonesInner>? _zones;
  ListBuilder<CaptainApplicationZonesDtoOutputZonesInner> get zones =>
      _$this._zones ??=
          ListBuilder<CaptainApplicationZonesDtoOutputZonesInner>();
  set zones(ListBuilder<CaptainApplicationZonesDtoOutputZonesInner>? zones) =>
      _$this._zones = zones;

  CaptainApplicationZonesDtoOutputBuilder() {
    CaptainApplicationZonesDtoOutput._defaults(this);
  }

  CaptainApplicationZonesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zones = $v.zones.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationZonesDtoOutput other) {
    _$v = other as _$CaptainApplicationZonesDtoOutput;
  }

  @override
  void update(void Function(CaptainApplicationZonesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationZonesDtoOutput build() => _build();

  _$CaptainApplicationZonesDtoOutput _build() {
    _$CaptainApplicationZonesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainApplicationZonesDtoOutput._(zones: zones.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainApplicationZonesDtoOutput',
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
