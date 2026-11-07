// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reason_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReasonOrderDtoOutput extends AdminReasonOrderDtoOutput {
  @override
  final BuiltList<AdminReasonListsDtoOutputListsInnerReasonsInner> reasons;

  factory _$AdminReasonOrderDtoOutput([
    void Function(AdminReasonOrderDtoOutputBuilder)? updates,
  ]) => (AdminReasonOrderDtoOutputBuilder()..update(updates))._build();

  _$AdminReasonOrderDtoOutput._({required this.reasons}) : super._();
  @override
  AdminReasonOrderDtoOutput rebuild(
    void Function(AdminReasonOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReasonOrderDtoOutputBuilder toBuilder() =>
      AdminReasonOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReasonOrderDtoOutput && reasons == other.reasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminReasonOrderDtoOutput',
    )..add('reasons', reasons)).toString();
  }
}

class AdminReasonOrderDtoOutputBuilder
    implements
        Builder<AdminReasonOrderDtoOutput, AdminReasonOrderDtoOutputBuilder> {
  _$AdminReasonOrderDtoOutput? _$v;

  ListBuilder<AdminReasonListsDtoOutputListsInnerReasonsInner>? _reasons;
  ListBuilder<AdminReasonListsDtoOutputListsInnerReasonsInner> get reasons =>
      _$this._reasons ??=
          ListBuilder<AdminReasonListsDtoOutputListsInnerReasonsInner>();
  set reasons(
    ListBuilder<AdminReasonListsDtoOutputListsInnerReasonsInner>? reasons,
  ) => _$this._reasons = reasons;

  AdminReasonOrderDtoOutputBuilder() {
    AdminReasonOrderDtoOutput._defaults(this);
  }

  AdminReasonOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReasonOrderDtoOutput other) {
    _$v = other as _$AdminReasonOrderDtoOutput;
  }

  @override
  void update(void Function(AdminReasonOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReasonOrderDtoOutput build() => _build();

  _$AdminReasonOrderDtoOutput _build() {
    _$AdminReasonOrderDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminReasonOrderDtoOutput._(reasons: reasons.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminReasonOrderDtoOutput',
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
