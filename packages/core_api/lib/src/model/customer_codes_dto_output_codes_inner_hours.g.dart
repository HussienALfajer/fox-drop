// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_codes_dto_output_codes_inner_hours.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCodesDtoOutputCodesInnerHours
    extends CustomerCodesDtoOutputCodesInnerHours {
  @override
  final int startMinute;
  @override
  final int endMinute;

  factory _$CustomerCodesDtoOutputCodesInnerHours([
    void Function(CustomerCodesDtoOutputCodesInnerHoursBuilder)? updates,
  ]) => (CustomerCodesDtoOutputCodesInnerHoursBuilder()..update(updates))
      ._build();

  _$CustomerCodesDtoOutputCodesInnerHours._({
    required this.startMinute,
    required this.endMinute,
  }) : super._();
  @override
  CustomerCodesDtoOutputCodesInnerHours rebuild(
    void Function(CustomerCodesDtoOutputCodesInnerHoursBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCodesDtoOutputCodesInnerHoursBuilder toBuilder() =>
      CustomerCodesDtoOutputCodesInnerHoursBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCodesDtoOutputCodesInnerHours &&
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
            r'CustomerCodesDtoOutputCodesInnerHours',
          )
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute))
        .toString();
  }
}

class CustomerCodesDtoOutputCodesInnerHoursBuilder
    implements
        Builder<
          CustomerCodesDtoOutputCodesInnerHours,
          CustomerCodesDtoOutputCodesInnerHoursBuilder
        > {
  _$CustomerCodesDtoOutputCodesInnerHours? _$v;

  int? _startMinute;
  int? get startMinute => _$this._startMinute;
  set startMinute(int? startMinute) => _$this._startMinute = startMinute;

  int? _endMinute;
  int? get endMinute => _$this._endMinute;
  set endMinute(int? endMinute) => _$this._endMinute = endMinute;

  CustomerCodesDtoOutputCodesInnerHoursBuilder() {
    CustomerCodesDtoOutputCodesInnerHours._defaults(this);
  }

  CustomerCodesDtoOutputCodesInnerHoursBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startMinute = $v.startMinute;
      _endMinute = $v.endMinute;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCodesDtoOutputCodesInnerHours other) {
    _$v = other as _$CustomerCodesDtoOutputCodesInnerHours;
  }

  @override
  void update(
    void Function(CustomerCodesDtoOutputCodesInnerHoursBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCodesDtoOutputCodesInnerHours build() => _build();

  _$CustomerCodesDtoOutputCodesInnerHours _build() {
    final _$result =
        _$v ??
        _$CustomerCodesDtoOutputCodesInnerHours._(
          startMinute: BuiltValueNullFieldError.checkNotNull(
            startMinute,
            r'CustomerCodesDtoOutputCodesInnerHours',
            'startMinute',
          ),
          endMinute: BuiltValueNullFieldError.checkNotNull(
            endMinute,
            r'CustomerCodesDtoOutputCodesInnerHours',
            'endMinute',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
