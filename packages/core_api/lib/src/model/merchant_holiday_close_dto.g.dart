// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_holiday_close_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantHolidayCloseDto extends MerchantHolidayCloseDto {
  @override
  final DateTime? startsAt;
  @override
  final DateTime endsAt;
  @override
  final String? message;

  factory _$MerchantHolidayCloseDto([
    void Function(MerchantHolidayCloseDtoBuilder)? updates,
  ]) => (MerchantHolidayCloseDtoBuilder()..update(updates))._build();

  _$MerchantHolidayCloseDto._({
    this.startsAt,
    required this.endsAt,
    this.message,
  }) : super._();
  @override
  MerchantHolidayCloseDto rebuild(
    void Function(MerchantHolidayCloseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantHolidayCloseDtoBuilder toBuilder() =>
      MerchantHolidayCloseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantHolidayCloseDto &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantHolidayCloseDto')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('message', message))
        .toString();
  }
}

class MerchantHolidayCloseDtoBuilder
    implements
        Builder<MerchantHolidayCloseDto, MerchantHolidayCloseDtoBuilder> {
  _$MerchantHolidayCloseDto? _$v;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  MerchantHolidayCloseDtoBuilder() {
    MerchantHolidayCloseDto._defaults(this);
  }

  MerchantHolidayCloseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantHolidayCloseDto other) {
    _$v = other as _$MerchantHolidayCloseDto;
  }

  @override
  void update(void Function(MerchantHolidayCloseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantHolidayCloseDto build() => _build();

  _$MerchantHolidayCloseDto _build() {
    final _$result =
        _$v ??
        _$MerchantHolidayCloseDto._(
          startsAt: startsAt,
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'MerchantHolidayCloseDto',
            'endsAt',
          ),
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
