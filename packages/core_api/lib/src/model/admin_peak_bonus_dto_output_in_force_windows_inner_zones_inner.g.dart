// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner
    extends AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner([
    void Function(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder)?
    updates,
  ]) =>
      (AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner._({
    required this.id,
    required this.name,
  }) : super._();
  @override
  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner rebuild(
    void Function(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder toBuilder() =>
      AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner &&
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
            r'AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner',
          )
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder
    implements
        Builder<
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder
        > {
  _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder() {
    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner._defaults(this);
  }

  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner other) {
    _$v = other as _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner;
  }

  @override
  void update(
    void Function(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner build() => _build();

  _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner _build() {
    final _$result =
        _$v ??
        _$AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
