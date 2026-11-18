// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_operations_periods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner
    extends AdminRestaurantDraftDtoOutputOperationsPeriodsInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner([
    void Function(AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputOperationsPeriodsInner rebuild(
    void Function(AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputOperationsPeriodsInner &&
        weekday == other.weekday &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputOperationsPeriodsInner',
          )
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputOperationsPeriodsInner,
          AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder
        > {
  _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder() {
    AdminRestaurantDraftDtoOutputOperationsPeriodsInner._defaults(this);
  }

  AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputOperationsPeriodsInner other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputOperationsPeriodsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsPeriodsInner build() => _build();

  _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputOperationsPeriodsInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'AdminRestaurantDraftDtoOutputOperationsPeriodsInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'AdminRestaurantDraftDtoOutputOperationsPeriodsInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'AdminRestaurantDraftDtoOutputOperationsPeriodsInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
