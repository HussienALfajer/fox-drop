// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_troubled_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputTroubledRestaurantsInner
    extends AdminDashboardDtoOutputTroubledRestaurantsInner {
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final int rejected;
  @override
  final int late_;

  factory _$AdminDashboardDtoOutputTroubledRestaurantsInner([
    void Function(AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder)?
    updates,
  ]) =>
      (AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminDashboardDtoOutputTroubledRestaurantsInner._({
    required this.restaurantId,
    required this.name,
    required this.rejected,
    required this.late_,
  }) : super._();
  @override
  AdminDashboardDtoOutputTroubledRestaurantsInner rebuild(
    void Function(AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder toBuilder() =>
      AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputTroubledRestaurantsInner &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        rejected == other.rejected &&
        late_ == other.late_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, rejected.hashCode);
    _$hash = $jc(_$hash, late_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardDtoOutputTroubledRestaurantsInner',
          )
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('rejected', rejected)
          ..add('late_', late_))
        .toString();
  }
}

class AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder
    implements
        Builder<
          AdminDashboardDtoOutputTroubledRestaurantsInner,
          AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder
        > {
  _$AdminDashboardDtoOutputTroubledRestaurantsInner? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _rejected;
  int? get rejected => _$this._rejected;
  set rejected(int? rejected) => _$this._rejected = rejected;

  int? _late_;
  int? get late_ => _$this._late_;
  set late_(int? late_) => _$this._late_ = late_;

  AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder() {
    AdminDashboardDtoOutputTroubledRestaurantsInner._defaults(this);
  }

  AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _rejected = $v.rejected;
      _late_ = $v.late_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputTroubledRestaurantsInner other) {
    _$v = other as _$AdminDashboardDtoOutputTroubledRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputTroubledRestaurantsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputTroubledRestaurantsInner build() => _build();

  _$AdminDashboardDtoOutputTroubledRestaurantsInner _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputTroubledRestaurantsInner._(
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'AdminDashboardDtoOutputTroubledRestaurantsInner',
            'restaurantId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminDashboardDtoOutputTroubledRestaurantsInner',
            'name',
          ),
          rejected: BuiltValueNullFieldError.checkNotNull(
            rejected,
            r'AdminDashboardDtoOutputTroubledRestaurantsInner',
            'rejected',
          ),
          late_: BuiltValueNullFieldError.checkNotNull(
            late_,
            r'AdminDashboardDtoOutputTroubledRestaurantsInner',
            'late_',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
