// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_schedule_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutputScheduleInner
    extends CustomerRestaurantPageDtoOutputScheduleInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$CustomerRestaurantPageDtoOutputScheduleInner([
    void Function(CustomerRestaurantPageDtoOutputScheduleInnerBuilder)? updates,
  ]) => (CustomerRestaurantPageDtoOutputScheduleInnerBuilder()..update(updates))
      ._build();

  _$CustomerRestaurantPageDtoOutputScheduleInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputScheduleInner rebuild(
    void Function(CustomerRestaurantPageDtoOutputScheduleInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputScheduleInnerBuilder toBuilder() =>
      CustomerRestaurantPageDtoOutputScheduleInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantPageDtoOutputScheduleInner &&
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
            r'CustomerRestaurantPageDtoOutputScheduleInner',
          )
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputScheduleInnerBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputScheduleInner,
          CustomerRestaurantPageDtoOutputScheduleInnerBuilder
        > {
  _$CustomerRestaurantPageDtoOutputScheduleInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  CustomerRestaurantPageDtoOutputScheduleInnerBuilder() {
    CustomerRestaurantPageDtoOutputScheduleInner._defaults(this);
  }

  CustomerRestaurantPageDtoOutputScheduleInnerBuilder get _$this {
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
  void replace(CustomerRestaurantPageDtoOutputScheduleInner other) {
    _$v = other as _$CustomerRestaurantPageDtoOutputScheduleInner;
  }

  @override
  void update(
    void Function(CustomerRestaurantPageDtoOutputScheduleInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputScheduleInner build() => _build();

  _$CustomerRestaurantPageDtoOutputScheduleInner _build() {
    final _$result =
        _$v ??
        _$CustomerRestaurantPageDtoOutputScheduleInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'CustomerRestaurantPageDtoOutputScheduleInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'CustomerRestaurantPageDtoOutputScheduleInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'CustomerRestaurantPageDtoOutputScheduleInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
