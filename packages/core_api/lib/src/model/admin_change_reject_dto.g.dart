// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_reject_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeRejectDto extends AdminChangeRejectDto {
  @override
  final String reason;

  factory _$AdminChangeRejectDto([
    void Function(AdminChangeRejectDtoBuilder)? updates,
  ]) => (AdminChangeRejectDtoBuilder()..update(updates))._build();

  _$AdminChangeRejectDto._({required this.reason}) : super._();
  @override
  AdminChangeRejectDto rebuild(
    void Function(AdminChangeRejectDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeRejectDtoBuilder toBuilder() =>
      AdminChangeRejectDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeRejectDto && reason == other.reason;
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
      r'AdminChangeRejectDto',
    )..add('reason', reason)).toString();
  }
}

class AdminChangeRejectDtoBuilder
    implements Builder<AdminChangeRejectDto, AdminChangeRejectDtoBuilder> {
  _$AdminChangeRejectDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminChangeRejectDtoBuilder() {
    AdminChangeRejectDto._defaults(this);
  }

  AdminChangeRejectDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeRejectDto other) {
    _$v = other as _$AdminChangeRejectDto;
  }

  @override
  void update(void Function(AdminChangeRejectDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeRejectDto build() => _build();

  _$AdminChangeRejectDto _build() {
    final _$result =
        _$v ??
        _$AdminChangeRejectDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminChangeRejectDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
