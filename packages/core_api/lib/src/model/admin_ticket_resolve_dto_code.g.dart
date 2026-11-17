// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_resolve_dto_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketResolveDtoCode extends AdminTicketResolveDtoCode {
  @override
  final AdminCancelDtoCompensationValue value;
  @override
  final AdminTicketResolveDtoCodeReason reason;

  factory _$AdminTicketResolveDtoCode([
    void Function(AdminTicketResolveDtoCodeBuilder)? updates,
  ]) => (AdminTicketResolveDtoCodeBuilder()..update(updates))._build();

  _$AdminTicketResolveDtoCode._({required this.value, required this.reason})
    : super._();
  @override
  AdminTicketResolveDtoCode rebuild(
    void Function(AdminTicketResolveDtoCodeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketResolveDtoCodeBuilder toBuilder() =>
      AdminTicketResolveDtoCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketResolveDtoCode &&
        value == other.value &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketResolveDtoCode')
          ..add('value', value)
          ..add('reason', reason))
        .toString();
  }
}

class AdminTicketResolveDtoCodeBuilder
    implements
        Builder<AdminTicketResolveDtoCode, AdminTicketResolveDtoCodeBuilder> {
  _$AdminTicketResolveDtoCode? _$v;

  AdminCancelDtoCompensationValueBuilder? _value;
  AdminCancelDtoCompensationValueBuilder get value =>
      _$this._value ??= AdminCancelDtoCompensationValueBuilder();
  set value(AdminCancelDtoCompensationValueBuilder? value) =>
      _$this._value = value;

  AdminTicketResolveDtoCodeReasonBuilder? _reason;
  AdminTicketResolveDtoCodeReasonBuilder get reason =>
      _$this._reason ??= AdminTicketResolveDtoCodeReasonBuilder();
  set reason(AdminTicketResolveDtoCodeReasonBuilder? reason) =>
      _$this._reason = reason;

  AdminTicketResolveDtoCodeBuilder() {
    AdminTicketResolveDtoCode._defaults(this);
  }

  AdminTicketResolveDtoCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value.toBuilder();
      _reason = $v.reason.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketResolveDtoCode other) {
    _$v = other as _$AdminTicketResolveDtoCode;
  }

  @override
  void update(void Function(AdminTicketResolveDtoCodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketResolveDtoCode build() => _build();

  _$AdminTicketResolveDtoCode _build() {
    _$AdminTicketResolveDtoCode _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketResolveDtoCode._(
            value: value.build(),
            reason: reason.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'value';
        value.build();
        _$failedField = 'reason';
        reason.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketResolveDtoCode',
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
