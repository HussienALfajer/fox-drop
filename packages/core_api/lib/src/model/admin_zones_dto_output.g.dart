// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_zones_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminZonesDtoOutput extends AdminZonesDtoOutput {
  @override
  final BuiltList<AdminZonesDtoOutputZonesInner> zones;
  @override
  final BuiltList<AdminZonesDtoOutputVotesInner> votes;

  factory _$AdminZonesDtoOutput([
    void Function(AdminZonesDtoOutputBuilder)? updates,
  ]) => (AdminZonesDtoOutputBuilder()..update(updates))._build();

  _$AdminZonesDtoOutput._({required this.zones, required this.votes})
    : super._();
  @override
  AdminZonesDtoOutput rebuild(
    void Function(AdminZonesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminZonesDtoOutputBuilder toBuilder() =>
      AdminZonesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminZonesDtoOutput &&
        zones == other.zones &&
        votes == other.votes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, votes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminZonesDtoOutput')
          ..add('zones', zones)
          ..add('votes', votes))
        .toString();
  }
}

class AdminZonesDtoOutputBuilder
    implements Builder<AdminZonesDtoOutput, AdminZonesDtoOutputBuilder> {
  _$AdminZonesDtoOutput? _$v;

  ListBuilder<AdminZonesDtoOutputZonesInner>? _zones;
  ListBuilder<AdminZonesDtoOutputZonesInner> get zones =>
      _$this._zones ??= ListBuilder<AdminZonesDtoOutputZonesInner>();
  set zones(ListBuilder<AdminZonesDtoOutputZonesInner>? zones) =>
      _$this._zones = zones;

  ListBuilder<AdminZonesDtoOutputVotesInner>? _votes;
  ListBuilder<AdminZonesDtoOutputVotesInner> get votes =>
      _$this._votes ??= ListBuilder<AdminZonesDtoOutputVotesInner>();
  set votes(ListBuilder<AdminZonesDtoOutputVotesInner>? votes) =>
      _$this._votes = votes;

  AdminZonesDtoOutputBuilder() {
    AdminZonesDtoOutput._defaults(this);
  }

  AdminZonesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zones = $v.zones.toBuilder();
      _votes = $v.votes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminZonesDtoOutput other) {
    _$v = other as _$AdminZonesDtoOutput;
  }

  @override
  void update(void Function(AdminZonesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminZonesDtoOutput build() => _build();

  _$AdminZonesDtoOutput _build() {
    _$AdminZonesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminZonesDtoOutput._(zones: zones.build(), votes: votes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zones';
        zones.build();
        _$failedField = 'votes';
        votes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminZonesDtoOutput',
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
