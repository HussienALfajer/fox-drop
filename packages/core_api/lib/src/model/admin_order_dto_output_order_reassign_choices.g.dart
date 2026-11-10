// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_reassign_choices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderReassignChoices
    extends AdminOrderDtoOutputOrderReassignChoices {
  @override
  final BuiltList<AdminOrderDtoOutputOrderReassignChoicesReasonsInner> reasons;

  factory _$AdminOrderDtoOutputOrderReassignChoices([
    void Function(AdminOrderDtoOutputOrderReassignChoicesBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderReassignChoicesBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderReassignChoices._({required this.reasons})
    : super._();
  @override
  AdminOrderDtoOutputOrderReassignChoices rebuild(
    void Function(AdminOrderDtoOutputOrderReassignChoicesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderReassignChoicesBuilder toBuilder() =>
      AdminOrderDtoOutputOrderReassignChoicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderReassignChoices &&
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
      r'AdminOrderDtoOutputOrderReassignChoices',
    )..add('reasons', reasons)).toString();
  }
}

class AdminOrderDtoOutputOrderReassignChoicesBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderReassignChoices,
          AdminOrderDtoOutputOrderReassignChoicesBuilder
        > {
  _$AdminOrderDtoOutputOrderReassignChoices? _$v;

  ListBuilder<AdminOrderDtoOutputOrderReassignChoicesReasonsInner>? _reasons;
  ListBuilder<AdminOrderDtoOutputOrderReassignChoicesReasonsInner>
  get reasons => _$this._reasons ??=
      ListBuilder<AdminOrderDtoOutputOrderReassignChoicesReasonsInner>();
  set reasons(
    ListBuilder<AdminOrderDtoOutputOrderReassignChoicesReasonsInner>? reasons,
  ) => _$this._reasons = reasons;

  AdminOrderDtoOutputOrderReassignChoicesBuilder() {
    AdminOrderDtoOutputOrderReassignChoices._defaults(this);
  }

  AdminOrderDtoOutputOrderReassignChoicesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderReassignChoices other) {
    _$v = other as _$AdminOrderDtoOutputOrderReassignChoices;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderReassignChoicesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderReassignChoices build() => _build();

  _$AdminOrderDtoOutputOrderReassignChoices _build() {
    _$AdminOrderDtoOutputOrderReassignChoices _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderReassignChoices._(reasons: reasons.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderReassignChoices',
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
