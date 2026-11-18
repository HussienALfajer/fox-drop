// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_commission_launch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputCommissionLaunch
    extends AdminRestaurantDraftDtoOutputCommissionLaunch {
  @override
  final int rateBp;
  @override
  final DateTime until;

  factory _$AdminRestaurantDraftDtoOutputCommissionLaunch([
    void Function(AdminRestaurantDraftDtoOutputCommissionLaunchBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputCommissionLaunchBuilder()..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputCommissionLaunch._({
    required this.rateBp,
    required this.until,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputCommissionLaunch rebuild(
    void Function(AdminRestaurantDraftDtoOutputCommissionLaunchBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputCommissionLaunchBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputCommissionLaunchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputCommissionLaunch &&
        rateBp == other.rateBp &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputCommissionLaunch',
          )
          ..add('rateBp', rateBp)
          ..add('until', until))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputCommissionLaunchBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputCommissionLaunch,
          AdminRestaurantDraftDtoOutputCommissionLaunchBuilder
        > {
  _$AdminRestaurantDraftDtoOutputCommissionLaunch? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  AdminRestaurantDraftDtoOutputCommissionLaunchBuilder() {
    AdminRestaurantDraftDtoOutputCommissionLaunch._defaults(this);
  }

  AdminRestaurantDraftDtoOutputCommissionLaunchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputCommissionLaunch other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputCommissionLaunch;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputCommissionLaunchBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputCommissionLaunch build() => _build();

  _$AdminRestaurantDraftDtoOutputCommissionLaunch _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputCommissionLaunch._(
          rateBp: BuiltValueNullFieldError.checkNotNull(
            rateBp,
            r'AdminRestaurantDraftDtoOutputCommissionLaunch',
            'rateBp',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminRestaurantDraftDtoOutputCommissionLaunch',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
