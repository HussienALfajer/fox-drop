// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_holiday_close_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantHolidayCloseDto extends AdminRestaurantHolidayCloseDto {
  @override
  final DateTime? startsAt;
  @override
  final DateTime endsAt;
  @override
  final String? message;
  @override
  final String reason;

  factory _$AdminRestaurantHolidayCloseDto([
    void Function(AdminRestaurantHolidayCloseDtoBuilder)? updates,
  ]) => (AdminRestaurantHolidayCloseDtoBuilder()..update(updates))._build();

  _$AdminRestaurantHolidayCloseDto._({
    this.startsAt,
    required this.endsAt,
    this.message,
    required this.reason,
  }) : super._();
  @override
  AdminRestaurantHolidayCloseDto rebuild(
    void Function(AdminRestaurantHolidayCloseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantHolidayCloseDtoBuilder toBuilder() =>
      AdminRestaurantHolidayCloseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantHolidayCloseDto &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        message == other.message &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantHolidayCloseDto')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('message', message)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRestaurantHolidayCloseDtoBuilder
    implements
        Builder<
          AdminRestaurantHolidayCloseDto,
          AdminRestaurantHolidayCloseDtoBuilder
        > {
  _$AdminRestaurantHolidayCloseDto? _$v;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRestaurantHolidayCloseDtoBuilder() {
    AdminRestaurantHolidayCloseDto._defaults(this);
  }

  AdminRestaurantHolidayCloseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _message = $v.message;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantHolidayCloseDto other) {
    _$v = other as _$AdminRestaurantHolidayCloseDto;
  }

  @override
  void update(void Function(AdminRestaurantHolidayCloseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantHolidayCloseDto build() => _build();

  _$AdminRestaurantHolidayCloseDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantHolidayCloseDto._(
          startsAt: startsAt,
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'AdminRestaurantHolidayCloseDto',
            'endsAt',
          ),
          message: message,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRestaurantHolidayCloseDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
