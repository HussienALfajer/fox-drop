// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_availability_saved_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAvailabilitySavedDtoOutput
    extends MerchantAvailabilitySavedDtoOutput {
  @override
  final MerchantMenuDtoOutputCategoriesInnerSwitchedOff? switchedOff;

  factory _$MerchantAvailabilitySavedDtoOutput([
    void Function(MerchantAvailabilitySavedDtoOutputBuilder)? updates,
  ]) => (MerchantAvailabilitySavedDtoOutputBuilder()..update(updates))._build();

  _$MerchantAvailabilitySavedDtoOutput._({this.switchedOff}) : super._();
  @override
  MerchantAvailabilitySavedDtoOutput rebuild(
    void Function(MerchantAvailabilitySavedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAvailabilitySavedDtoOutputBuilder toBuilder() =>
      MerchantAvailabilitySavedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAvailabilitySavedDtoOutput &&
        switchedOff == other.switchedOff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantAvailabilitySavedDtoOutput',
    )..add('switchedOff', switchedOff)).toString();
  }
}

class MerchantAvailabilitySavedDtoOutputBuilder
    implements
        Builder<
          MerchantAvailabilitySavedDtoOutput,
          MerchantAvailabilitySavedDtoOutputBuilder
        > {
  _$MerchantAvailabilitySavedDtoOutput? _$v;

  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder? _switchedOff;
  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder get switchedOff =>
      _$this._switchedOff ??=
          MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder();
  set switchedOff(
    MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder? switchedOff,
  ) => _$this._switchedOff = switchedOff;

  MerchantAvailabilitySavedDtoOutputBuilder() {
    MerchantAvailabilitySavedDtoOutput._defaults(this);
  }

  MerchantAvailabilitySavedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _switchedOff = $v.switchedOff?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAvailabilitySavedDtoOutput other) {
    _$v = other as _$MerchantAvailabilitySavedDtoOutput;
  }

  @override
  void update(
    void Function(MerchantAvailabilitySavedDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAvailabilitySavedDtoOutput build() => _build();

  _$MerchantAvailabilitySavedDtoOutput _build() {
    _$MerchantAvailabilitySavedDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantAvailabilitySavedDtoOutput._(
            switchedOff: _switchedOff?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'switchedOff';
        _switchedOff?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantAvailabilitySavedDtoOutput',
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
