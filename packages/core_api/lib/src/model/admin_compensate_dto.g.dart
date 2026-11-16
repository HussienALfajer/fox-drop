// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_compensate_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCompensateDto extends AdminCompensateDto {
  @override
  final AdminCancelDtoCompensationValue value;
  @override
  final AdminCancelDtoCompensationReason reason;

  factory _$AdminCompensateDto([
    void Function(AdminCompensateDtoBuilder)? updates,
  ]) => (AdminCompensateDtoBuilder()..update(updates))._build();

  _$AdminCompensateDto._({required this.value, required this.reason})
    : super._();
  @override
  AdminCompensateDto rebuild(
    void Function(AdminCompensateDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCompensateDtoBuilder toBuilder() =>
      AdminCompensateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCompensateDto &&
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
    return (newBuiltValueToStringHelper(r'AdminCompensateDto')
          ..add('value', value)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCompensateDtoBuilder
    implements Builder<AdminCompensateDto, AdminCompensateDtoBuilder> {
  _$AdminCompensateDto? _$v;

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

  AdminCompensateDtoBuilder() {
    AdminCompensateDto._defaults(this);
  }

  AdminCompensateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value.toBuilder();
      _reason = $v.reason.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCompensateDto other) {
    _$v = other as _$AdminCompensateDto;
  }

  @override
  void update(void Function(AdminCompensateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCompensateDto build() => _build();

  _$AdminCompensateDto _build() {
    _$AdminCompensateDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCompensateDto._(value: value.build(), reason: reason.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'value';
        value.build();
        _$failedField = 'reason';
        reason.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCompensateDto',
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
