// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_now.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputNow extends AdminDailyReportDtoOutputNow {
  @override
  final int captainsBlocked;
  @override
  final BuiltList<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>
  overdueRestaurants;

  factory _$AdminDailyReportDtoOutputNow([
    void Function(AdminDailyReportDtoOutputNowBuilder)? updates,
  ]) => (AdminDailyReportDtoOutputNowBuilder()..update(updates))._build();

  _$AdminDailyReportDtoOutputNow._({
    required this.captainsBlocked,
    required this.overdueRestaurants,
  }) : super._();
  @override
  AdminDailyReportDtoOutputNow rebuild(
    void Function(AdminDailyReportDtoOutputNowBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputNowBuilder toBuilder() =>
      AdminDailyReportDtoOutputNowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputNow &&
        captainsBlocked == other.captainsBlocked &&
        overdueRestaurants == other.overdueRestaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainsBlocked.hashCode);
    _$hash = $jc(_$hash, overdueRestaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportDtoOutputNow')
          ..add('captainsBlocked', captainsBlocked)
          ..add('overdueRestaurants', overdueRestaurants))
        .toString();
  }
}

class AdminDailyReportDtoOutputNowBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputNow,
          AdminDailyReportDtoOutputNowBuilder
        > {
  _$AdminDailyReportDtoOutputNow? _$v;

  int? _captainsBlocked;
  int? get captainsBlocked => _$this._captainsBlocked;
  set captainsBlocked(int? captainsBlocked) =>
      _$this._captainsBlocked = captainsBlocked;

  ListBuilder<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>?
  _overdueRestaurants;
  ListBuilder<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>
  get overdueRestaurants => _$this._overdueRestaurants ??=
      ListBuilder<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>();
  set overdueRestaurants(
    ListBuilder<AdminDailyReportDtoOutputNowOverdueRestaurantsInner>?
    overdueRestaurants,
  ) => _$this._overdueRestaurants = overdueRestaurants;

  AdminDailyReportDtoOutputNowBuilder() {
    AdminDailyReportDtoOutputNow._defaults(this);
  }

  AdminDailyReportDtoOutputNowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainsBlocked = $v.captainsBlocked;
      _overdueRestaurants = $v.overdueRestaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputNow other) {
    _$v = other as _$AdminDailyReportDtoOutputNow;
  }

  @override
  void update(void Function(AdminDailyReportDtoOutputNowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputNow build() => _build();

  _$AdminDailyReportDtoOutputNow _build() {
    _$AdminDailyReportDtoOutputNow _$result;
    try {
      _$result =
          _$v ??
          _$AdminDailyReportDtoOutputNow._(
            captainsBlocked: BuiltValueNullFieldError.checkNotNull(
              captainsBlocked,
              r'AdminDailyReportDtoOutputNow',
              'captainsBlocked',
            ),
            overdueRestaurants: overdueRestaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'overdueRestaurants';
        overdueRestaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDailyReportDtoOutputNow',
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
