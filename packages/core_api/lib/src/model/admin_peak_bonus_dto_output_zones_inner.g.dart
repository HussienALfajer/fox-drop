// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_peak_bonus_dto_output_zones_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPeakBonusDtoOutputZonesInner
    extends AdminPeakBonusDtoOutputZonesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool active;

  factory _$AdminPeakBonusDtoOutputZonesInner([
    void Function(AdminPeakBonusDtoOutputZonesInnerBuilder)? updates,
  ]) => (AdminPeakBonusDtoOutputZonesInnerBuilder()..update(updates))._build();

  _$AdminPeakBonusDtoOutputZonesInner._({
    required this.id,
    required this.name,
    required this.active,
  }) : super._();
  @override
  AdminPeakBonusDtoOutputZonesInner rebuild(
    void Function(AdminPeakBonusDtoOutputZonesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPeakBonusDtoOutputZonesInnerBuilder toBuilder() =>
      AdminPeakBonusDtoOutputZonesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPeakBonusDtoOutputZonesInner &&
        id == other.id &&
        name == other.name &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPeakBonusDtoOutputZonesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('active', active))
        .toString();
  }
}

class AdminPeakBonusDtoOutputZonesInnerBuilder
    implements
        Builder<
          AdminPeakBonusDtoOutputZonesInner,
          AdminPeakBonusDtoOutputZonesInnerBuilder
        > {
  _$AdminPeakBonusDtoOutputZonesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  AdminPeakBonusDtoOutputZonesInnerBuilder() {
    AdminPeakBonusDtoOutputZonesInner._defaults(this);
  }

  AdminPeakBonusDtoOutputZonesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPeakBonusDtoOutputZonesInner other) {
    _$v = other as _$AdminPeakBonusDtoOutputZonesInner;
  }

  @override
  void update(
    void Function(AdminPeakBonusDtoOutputZonesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPeakBonusDtoOutputZonesInner build() => _build();

  _$AdminPeakBonusDtoOutputZonesInner _build() {
    final _$result =
        _$v ??
        _$AdminPeakBonusDtoOutputZonesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminPeakBonusDtoOutputZonesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminPeakBonusDtoOutputZonesInner',
            'name',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminPeakBonusDtoOutputZonesInner',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
