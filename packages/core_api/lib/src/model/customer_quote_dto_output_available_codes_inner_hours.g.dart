// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_available_codes_inner_hours.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputAvailableCodesInnerHours
    extends CustomerQuoteDtoOutputAvailableCodesInnerHours {
  @override
  final int startMinute;
  @override
  final int endMinute;

  factory _$CustomerQuoteDtoOutputAvailableCodesInnerHours([
    void Function(CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder)?
    updates,
  ]) =>
      (CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder()..update(updates))
          ._build();

  _$CustomerQuoteDtoOutputAvailableCodesInnerHours._({
    required this.startMinute,
    required this.endMinute,
  }) : super._();
  @override
  CustomerQuoteDtoOutputAvailableCodesInnerHours rebuild(
    void Function(CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder toBuilder() =>
      CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputAvailableCodesInnerHours &&
        startMinute == other.startMinute &&
        endMinute == other.endMinute;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startMinute.hashCode);
    _$hash = $jc(_$hash, endMinute.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerQuoteDtoOutputAvailableCodesInnerHours',
          )
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute))
        .toString();
  }
}

class CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputAvailableCodesInnerHours,
          CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder
        > {
  _$CustomerQuoteDtoOutputAvailableCodesInnerHours? _$v;

  int? _startMinute;
  int? get startMinute => _$this._startMinute;
  set startMinute(int? startMinute) => _$this._startMinute = startMinute;

  int? _endMinute;
  int? get endMinute => _$this._endMinute;
  set endMinute(int? endMinute) => _$this._endMinute = endMinute;

  CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder() {
    CustomerQuoteDtoOutputAvailableCodesInnerHours._defaults(this);
  }

  CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startMinute = $v.startMinute;
      _endMinute = $v.endMinute;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputAvailableCodesInnerHours other) {
    _$v = other as _$CustomerQuoteDtoOutputAvailableCodesInnerHours;
  }

  @override
  void update(
    void Function(CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputAvailableCodesInnerHours build() => _build();

  _$CustomerQuoteDtoOutputAvailableCodesInnerHours _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputAvailableCodesInnerHours._(
          startMinute: BuiltValueNullFieldError.checkNotNull(
            startMinute,
            r'CustomerQuoteDtoOutputAvailableCodesInnerHours',
            'startMinute',
          ),
          endMinute: BuiltValueNullFieldError.checkNotNull(
            endMinute,
            r'CustomerQuoteDtoOutputAvailableCodesInnerHours',
            'endMinute',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
