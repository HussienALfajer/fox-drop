// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner
    extends CaptainPeakBonusDtoOutputWindowsInnerZonesInner {
  @override
  final String id;
  @override
  final String name;

  factory _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner([
    void Function(CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder)?
    updates,
  ]) =>
      (CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder()
            ..update(updates))
          ._build();

  _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner._({
    required this.id,
    required this.name,
  }) : super._();
  @override
  CaptainPeakBonusDtoOutputWindowsInnerZonesInner rebuild(
    void Function(CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder toBuilder() =>
      CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPeakBonusDtoOutputWindowsInnerZonesInner &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPeakBonusDtoOutputWindowsInnerZonesInner',
          )
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder
    implements
        Builder<
          CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
          CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder
        > {
  _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder() {
    CaptainPeakBonusDtoOutputWindowsInnerZonesInner._defaults(this);
  }

  CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPeakBonusDtoOutputWindowsInnerZonesInner other) {
    _$v = other as _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner;
  }

  @override
  void update(
    void Function(CaptainPeakBonusDtoOutputWindowsInnerZonesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPeakBonusDtoOutputWindowsInnerZonesInner build() => _build();

  _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner _build() {
    final _$result =
        _$v ??
        _$CaptainPeakBonusDtoOutputWindowsInnerZonesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CaptainPeakBonusDtoOutputWindowsInnerZonesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CaptainPeakBonusDtoOutputWindowsInnerZonesInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
