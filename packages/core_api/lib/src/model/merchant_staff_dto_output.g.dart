// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_staff_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantStaffDtoOutput extends MerchantStaffDtoOutput {
  @override
  final BuiltList<MerchantStaffDtoOutputStaffInner> staff;

  factory _$MerchantStaffDtoOutput([
    void Function(MerchantStaffDtoOutputBuilder)? updates,
  ]) => (MerchantStaffDtoOutputBuilder()..update(updates))._build();

  _$MerchantStaffDtoOutput._({required this.staff}) : super._();
  @override
  MerchantStaffDtoOutput rebuild(
    void Function(MerchantStaffDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStaffDtoOutputBuilder toBuilder() =>
      MerchantStaffDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStaffDtoOutput && staff == other.staff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantStaffDtoOutput',
    )..add('staff', staff)).toString();
  }
}

class MerchantStaffDtoOutputBuilder
    implements Builder<MerchantStaffDtoOutput, MerchantStaffDtoOutputBuilder> {
  _$MerchantStaffDtoOutput? _$v;

  ListBuilder<MerchantStaffDtoOutputStaffInner>? _staff;
  ListBuilder<MerchantStaffDtoOutputStaffInner> get staff =>
      _$this._staff ??= ListBuilder<MerchantStaffDtoOutputStaffInner>();
  set staff(ListBuilder<MerchantStaffDtoOutputStaffInner>? staff) =>
      _$this._staff = staff;

  MerchantStaffDtoOutputBuilder() {
    MerchantStaffDtoOutput._defaults(this);
  }

  MerchantStaffDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staff = $v.staff.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStaffDtoOutput other) {
    _$v = other as _$MerchantStaffDtoOutput;
  }

  @override
  void update(void Function(MerchantStaffDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStaffDtoOutput build() => _build();

  _$MerchantStaffDtoOutput _build() {
    _$MerchantStaffDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantStaffDtoOutput._(staff: staff.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'staff';
        staff.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantStaffDtoOutput',
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
