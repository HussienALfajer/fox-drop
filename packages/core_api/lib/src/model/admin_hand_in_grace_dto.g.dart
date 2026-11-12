// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_grace_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInGraceDto extends AdminHandInGraceDto {
  @override
  final String reason;

  factory _$AdminHandInGraceDto([
    void Function(AdminHandInGraceDtoBuilder)? updates,
  ]) => (AdminHandInGraceDtoBuilder()..update(updates))._build();

  _$AdminHandInGraceDto._({required this.reason}) : super._();
  @override
  AdminHandInGraceDto rebuild(
    void Function(AdminHandInGraceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInGraceDtoBuilder toBuilder() =>
      AdminHandInGraceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInGraceDto && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminHandInGraceDto',
    )..add('reason', reason)).toString();
  }
}

class AdminHandInGraceDtoBuilder
    implements Builder<AdminHandInGraceDto, AdminHandInGraceDtoBuilder> {
  _$AdminHandInGraceDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminHandInGraceDtoBuilder() {
    AdminHandInGraceDto._defaults(this);
  }

  AdminHandInGraceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandInGraceDto other) {
    _$v = other as _$AdminHandInGraceDto;
  }

  @override
  void update(void Function(AdminHandInGraceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInGraceDto build() => _build();

  _$AdminHandInGraceDto _build() {
    final _$result =
        _$v ??
        _$AdminHandInGraceDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminHandInGraceDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
