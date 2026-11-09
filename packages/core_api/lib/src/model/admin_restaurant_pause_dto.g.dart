// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_pause_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantPauseDto extends AdminRestaurantPauseDto {
  @override
  final int? minutes;
  @override
  final DateTime? until;
  @override
  final String? message;
  @override
  final String reason;

  factory _$AdminRestaurantPauseDto([
    void Function(AdminRestaurantPauseDtoBuilder)? updates,
  ]) => (AdminRestaurantPauseDtoBuilder()..update(updates))._build();

  _$AdminRestaurantPauseDto._({
    this.minutes,
    this.until,
    this.message,
    required this.reason,
  }) : super._();
  @override
  AdminRestaurantPauseDto rebuild(
    void Function(AdminRestaurantPauseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantPauseDtoBuilder toBuilder() =>
      AdminRestaurantPauseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantPauseDto &&
        minutes == other.minutes &&
        until == other.until &&
        message == other.message &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minutes.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantPauseDto')
          ..add('minutes', minutes)
          ..add('until', until)
          ..add('message', message)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRestaurantPauseDtoBuilder
    implements
        Builder<AdminRestaurantPauseDto, AdminRestaurantPauseDtoBuilder> {
  _$AdminRestaurantPauseDto? _$v;

  int? _minutes;
  int? get minutes => _$this._minutes;
  set minutes(int? minutes) => _$this._minutes = minutes;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRestaurantPauseDtoBuilder() {
    AdminRestaurantPauseDto._defaults(this);
  }

  AdminRestaurantPauseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minutes = $v.minutes;
      _until = $v.until;
      _message = $v.message;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantPauseDto other) {
    _$v = other as _$AdminRestaurantPauseDto;
  }

  @override
  void update(void Function(AdminRestaurantPauseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantPauseDto build() => _build();

  _$AdminRestaurantPauseDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantPauseDto._(
          minutes: minutes,
          until: until,
          message: message,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRestaurantPauseDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
