// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputStatus extends AdminDashboardDtoOutputStatus {
  @override
  final AdminDashboardDtoOutputStatusCaptains captains;
  @override
  final AdminDashboardDtoOutputStatusRestaurants restaurants;
  @override
  final int withoutDevice;

  factory _$AdminDashboardDtoOutputStatus([
    void Function(AdminDashboardDtoOutputStatusBuilder)? updates,
  ]) => (AdminDashboardDtoOutputStatusBuilder()..update(updates))._build();

  _$AdminDashboardDtoOutputStatus._({
    required this.captains,
    required this.restaurants,
    required this.withoutDevice,
  }) : super._();
  @override
  AdminDashboardDtoOutputStatus rebuild(
    void Function(AdminDashboardDtoOutputStatusBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputStatusBuilder toBuilder() =>
      AdminDashboardDtoOutputStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputStatus &&
        captains == other.captains &&
        restaurants == other.restaurants &&
        withoutDevice == other.withoutDevice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, withoutDevice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardDtoOutputStatus')
          ..add('captains', captains)
          ..add('restaurants', restaurants)
          ..add('withoutDevice', withoutDevice))
        .toString();
  }
}

class AdminDashboardDtoOutputStatusBuilder
    implements
        Builder<
          AdminDashboardDtoOutputStatus,
          AdminDashboardDtoOutputStatusBuilder
        > {
  _$AdminDashboardDtoOutputStatus? _$v;

  AdminDashboardDtoOutputStatusCaptainsBuilder? _captains;
  AdminDashboardDtoOutputStatusCaptainsBuilder get captains =>
      _$this._captains ??= AdminDashboardDtoOutputStatusCaptainsBuilder();
  set captains(AdminDashboardDtoOutputStatusCaptainsBuilder? captains) =>
      _$this._captains = captains;

  AdminDashboardDtoOutputStatusRestaurantsBuilder? _restaurants;
  AdminDashboardDtoOutputStatusRestaurantsBuilder get restaurants =>
      _$this._restaurants ??= AdminDashboardDtoOutputStatusRestaurantsBuilder();
  set restaurants(
    AdminDashboardDtoOutputStatusRestaurantsBuilder? restaurants,
  ) => _$this._restaurants = restaurants;

  int? _withoutDevice;
  int? get withoutDevice => _$this._withoutDevice;
  set withoutDevice(int? withoutDevice) =>
      _$this._withoutDevice = withoutDevice;

  AdminDashboardDtoOutputStatusBuilder() {
    AdminDashboardDtoOutputStatus._defaults(this);
  }

  AdminDashboardDtoOutputStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captains = $v.captains.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _withoutDevice = $v.withoutDevice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputStatus other) {
    _$v = other as _$AdminDashboardDtoOutputStatus;
  }

  @override
  void update(void Function(AdminDashboardDtoOutputStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputStatus build() => _build();

  _$AdminDashboardDtoOutputStatus _build() {
    _$AdminDashboardDtoOutputStatus _$result;
    try {
      _$result =
          _$v ??
          _$AdminDashboardDtoOutputStatus._(
            captains: captains.build(),
            restaurants: restaurants.build(),
            withoutDevice: BuiltValueNullFieldError.checkNotNull(
              withoutDevice,
              r'AdminDashboardDtoOutputStatus',
              'withoutDevice',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDashboardDtoOutputStatus',
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
