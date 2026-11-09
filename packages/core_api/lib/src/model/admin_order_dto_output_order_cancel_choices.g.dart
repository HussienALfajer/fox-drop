// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_cancel_choices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCancelChoices
    extends AdminOrderDtoOutputOrderCancelChoices {
  @override
  final BuiltList<AdminOrderDtoOutputOrderCancelChoicesReasonsInner> reasons;

  factory _$AdminOrderDtoOutputOrderCancelChoices([
    void Function(AdminOrderDtoOutputOrderCancelChoicesBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCancelChoicesBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCancelChoices._({required this.reasons})
    : super._();
  @override
  AdminOrderDtoOutputOrderCancelChoices rebuild(
    void Function(AdminOrderDtoOutputOrderCancelChoicesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCancelChoicesBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCancelChoicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCancelChoices &&
        reasons == other.reasons;
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
      r'AdminOrderDtoOutputOrderCancelChoices',
    )..add('reasons', reasons)).toString();
  }
}

class AdminOrderDtoOutputOrderCancelChoicesBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCancelChoices,
          AdminOrderDtoOutputOrderCancelChoicesBuilder
        > {
  _$AdminOrderDtoOutputOrderCancelChoices? _$v;

  ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>? _reasons;
  ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner> get reasons =>
      _$this._reasons ??=
          ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>();
  set reasons(
    ListBuilder<AdminOrderDtoOutputOrderCancelChoicesReasonsInner>? reasons,
  ) => _$this._reasons = reasons;

  AdminOrderDtoOutputOrderCancelChoicesBuilder() {
    AdminOrderDtoOutputOrderCancelChoices._defaults(this);
  }

  AdminOrderDtoOutputOrderCancelChoicesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCancelChoices other) {
    _$v = other as _$AdminOrderDtoOutputOrderCancelChoices;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCancelChoicesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCancelChoices build() => _build();

  _$AdminOrderDtoOutputOrderCancelChoices _build() {
    _$AdminOrderDtoOutputOrderCancelChoices _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderCancelChoices._(reasons: reasons.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderCancelChoices',
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
