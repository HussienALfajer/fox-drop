// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_dto_compensation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancelDtoCompensation extends AdminCancelDtoCompensation {
  @override
  final AdminCancelDtoCompensationValue value;
  @override
  final AdminCancelDtoCompensationReason reason;

  factory _$AdminCancelDtoCompensation([
    void Function(AdminCancelDtoCompensationBuilder)? updates,
  ]) => (AdminCancelDtoCompensationBuilder()..update(updates))._build();

  _$AdminCancelDtoCompensation._({required this.value, required this.reason})
    : super._();
  @override
  AdminCancelDtoCompensation rebuild(
    void Function(AdminCancelDtoCompensationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelDtoCompensationBuilder toBuilder() =>
      AdminCancelDtoCompensationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelDtoCompensation &&
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
    return (newBuiltValueToStringHelper(r'AdminCancelDtoCompensation')
          ..add('value', value)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCancelDtoCompensationBuilder
    implements
        Builder<AdminCancelDtoCompensation, AdminCancelDtoCompensationBuilder> {
  _$AdminCancelDtoCompensation? _$v;

  AdminCancelDtoCompensationValueBuilder? _value;
  AdminCancelDtoCompensationValueBuilder get value =>
      _$this._value ??= AdminCancelDtoCompensationValueBuilder();
  set value(AdminCancelDtoCompensationValueBuilder? value) =>
      _$this._value = value;

  AdminCancelDtoCompensationReasonBuilder? _reason;
  AdminCancelDtoCompensationReasonBuilder get reason =>
      _$this._reason ??= AdminCancelDtoCompensationReasonBuilder();
  set reason(AdminCancelDtoCompensationReasonBuilder? reason) =>
      _$this._reason = reason;

  AdminCancelDtoCompensationBuilder() {
    AdminCancelDtoCompensation._defaults(this);
  }

  AdminCancelDtoCompensationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value.toBuilder();
      _reason = $v.reason.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelDtoCompensation other) {
    _$v = other as _$AdminCancelDtoCompensation;
  }

  @override
  void update(void Function(AdminCancelDtoCompensationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelDtoCompensation build() => _build();

  _$AdminCancelDtoCompensation _build() {
    _$AdminCancelDtoCompensation _$result;
    try {
      _$result =
          _$v ??
          _$AdminCancelDtoCompensation._(
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
          r'AdminCancelDtoCompensation',
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
