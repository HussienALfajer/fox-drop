// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_terminate_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationTerminateDto
    extends AdminCaptainApplicationTerminateDto {
  @override
  final String reason;

  factory _$AdminCaptainApplicationTerminateDto([
    void Function(AdminCaptainApplicationTerminateDtoBuilder)? updates,
  ]) =>
      (AdminCaptainApplicationTerminateDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationTerminateDto._({required this.reason}) : super._();
  @override
  AdminCaptainApplicationTerminateDto rebuild(
    void Function(AdminCaptainApplicationTerminateDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationTerminateDtoBuilder toBuilder() =>
      AdminCaptainApplicationTerminateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationTerminateDto &&
        reason == other.reason;
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
      r'AdminCaptainApplicationTerminateDto',
    )..add('reason', reason)).toString();
  }
}

class AdminCaptainApplicationTerminateDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationTerminateDto,
          AdminCaptainApplicationTerminateDtoBuilder
        > {
  _$AdminCaptainApplicationTerminateDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainApplicationTerminateDtoBuilder() {
    AdminCaptainApplicationTerminateDto._defaults(this);
  }

  AdminCaptainApplicationTerminateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationTerminateDto other) {
    _$v = other as _$AdminCaptainApplicationTerminateDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationTerminateDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationTerminateDto build() => _build();

  _$AdminCaptainApplicationTerminateDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationTerminateDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainApplicationTerminateDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
