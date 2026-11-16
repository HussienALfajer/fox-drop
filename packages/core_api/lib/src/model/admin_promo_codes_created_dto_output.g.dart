// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promo_codes_created_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPromoCodesCreatedDtoOutput
    extends AdminPromoCodesCreatedDtoOutput {
  @override
  final BuiltList<AdminPromoCodesDtoOutputCodesInner> codes;

  factory _$AdminPromoCodesCreatedDtoOutput([
    void Function(AdminPromoCodesCreatedDtoOutputBuilder)? updates,
  ]) => (AdminPromoCodesCreatedDtoOutputBuilder()..update(updates))._build();

  _$AdminPromoCodesCreatedDtoOutput._({required this.codes}) : super._();
  @override
  AdminPromoCodesCreatedDtoOutput rebuild(
    void Function(AdminPromoCodesCreatedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPromoCodesCreatedDtoOutputBuilder toBuilder() =>
      AdminPromoCodesCreatedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPromoCodesCreatedDtoOutput && codes == other.codes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminPromoCodesCreatedDtoOutput',
    )..add('codes', codes)).toString();
  }
}

class AdminPromoCodesCreatedDtoOutputBuilder
    implements
        Builder<
          AdminPromoCodesCreatedDtoOutput,
          AdminPromoCodesCreatedDtoOutputBuilder
        > {
  _$AdminPromoCodesCreatedDtoOutput? _$v;

  ListBuilder<AdminPromoCodesDtoOutputCodesInner>? _codes;
  ListBuilder<AdminPromoCodesDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<AdminPromoCodesDtoOutputCodesInner>();
  set codes(ListBuilder<AdminPromoCodesDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  AdminPromoCodesCreatedDtoOutputBuilder() {
    AdminPromoCodesCreatedDtoOutput._defaults(this);
  }

  AdminPromoCodesCreatedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codes = $v.codes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPromoCodesCreatedDtoOutput other) {
    _$v = other as _$AdminPromoCodesCreatedDtoOutput;
  }

  @override
  void update(void Function(AdminPromoCodesCreatedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPromoCodesCreatedDtoOutput build() => _build();

  _$AdminPromoCodesCreatedDtoOutput _build() {
    _$AdminPromoCodesCreatedDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminPromoCodesCreatedDtoOutput._(codes: codes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'codes';
        codes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPromoCodesCreatedDtoOutput',
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
