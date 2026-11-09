// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_status_dto_output_holiday.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantStatusDtoOutputHoliday extends MerchantStatusDtoOutputHoliday {
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final String? message;

  factory _$MerchantStatusDtoOutputHoliday([
    void Function(MerchantStatusDtoOutputHolidayBuilder)? updates,
  ]) => (MerchantStatusDtoOutputHolidayBuilder()..update(updates))._build();

  _$MerchantStatusDtoOutputHoliday._({
    required this.startsAt,
    required this.endsAt,
    this.message,
  }) : super._();
  @override
  MerchantStatusDtoOutputHoliday rebuild(
    void Function(MerchantStatusDtoOutputHolidayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatusDtoOutputHolidayBuilder toBuilder() =>
      MerchantStatusDtoOutputHolidayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatusDtoOutputHoliday &&
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
    return (newBuiltValueToStringHelper(r'MerchantStatusDtoOutputHoliday')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('message', message))
        .toString();
  }
}

class MerchantStatusDtoOutputHolidayBuilder
    implements
        Builder<
          MerchantStatusDtoOutputHoliday,
          MerchantStatusDtoOutputHolidayBuilder
        > {
  _$MerchantStatusDtoOutputHoliday? _$v;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  MerchantStatusDtoOutputHolidayBuilder() {
    MerchantStatusDtoOutputHoliday._defaults(this);
  }

  MerchantStatusDtoOutputHolidayBuilder get _$this {
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
  void replace(MerchantStatusDtoOutputHoliday other) {
    _$v = other as _$MerchantStatusDtoOutputHoliday;
  }

  @override
  void update(void Function(MerchantStatusDtoOutputHolidayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatusDtoOutputHoliday build() => _build();

  _$MerchantStatusDtoOutputHoliday _build() {
    final _$result =
        _$v ??
        _$MerchantStatusDtoOutputHoliday._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
            startsAt,
            r'MerchantStatusDtoOutputHoliday',
            'startsAt',
          ),
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'MerchantStatusDtoOutputHoliday',
            'endsAt',
          ),
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
