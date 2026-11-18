// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_commission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputCommission
    extends AdminRestaurantDraftDtoOutputCommission {
  @override
  final int rateBp;
  @override
  final AdminRestaurantDraftDtoOutputCommissionLaunch? launch;

  factory _$AdminRestaurantDraftDtoOutputCommission([
    void Function(AdminRestaurantDraftDtoOutputCommissionBuilder)? updates,
  ]) => (AdminRestaurantDraftDtoOutputCommissionBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDraftDtoOutputCommission._({
    required this.rateBp,
    this.launch,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputCommission rebuild(
    void Function(AdminRestaurantDraftDtoOutputCommissionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputCommissionBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputCommissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputCommission &&
        rateBp == other.rateBp &&
        launch == other.launch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, launch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputCommission',
          )
          ..add('rateBp', rateBp)
          ..add('launch', launch))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputCommissionBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputCommission,
          AdminRestaurantDraftDtoOutputCommissionBuilder
        > {
  _$AdminRestaurantDraftDtoOutputCommission? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  AdminRestaurantDraftDtoOutputCommissionLaunchBuilder? _launch;
  AdminRestaurantDraftDtoOutputCommissionLaunchBuilder get launch =>
      _$this._launch ??= AdminRestaurantDraftDtoOutputCommissionLaunchBuilder();
  set launch(AdminRestaurantDraftDtoOutputCommissionLaunchBuilder? launch) =>
      _$this._launch = launch;

  AdminRestaurantDraftDtoOutputCommissionBuilder() {
    AdminRestaurantDraftDtoOutputCommission._defaults(this);
  }

  AdminRestaurantDraftDtoOutputCommissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _launch = $v.launch?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputCommission other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputCommission;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputCommissionBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputCommission build() => _build();

  _$AdminRestaurantDraftDtoOutputCommission _build() {
    _$AdminRestaurantDraftDtoOutputCommission _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftDtoOutputCommission._(
            rateBp: BuiltValueNullFieldError.checkNotNull(
              rateBp,
              r'AdminRestaurantDraftDtoOutputCommission',
              'rateBp',
            ),
            launch: _launch?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'launch';
        _launch?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftDtoOutputCommission',
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
