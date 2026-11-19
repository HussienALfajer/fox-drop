// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_reject_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationRejectDto
    extends AdminCaptainApplicationRejectDto {
  @override
  final String reason;

  factory _$AdminCaptainApplicationRejectDto([
    void Function(AdminCaptainApplicationRejectDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationRejectDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationRejectDto._({required this.reason}) : super._();
  @override
  AdminCaptainApplicationRejectDto rebuild(
    void Function(AdminCaptainApplicationRejectDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationRejectDtoBuilder toBuilder() =>
      AdminCaptainApplicationRejectDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationRejectDto && reason == other.reason;
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
      r'AdminCaptainApplicationRejectDto',
    )..add('reason', reason)).toString();
  }
}

class AdminCaptainApplicationRejectDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationRejectDto,
          AdminCaptainApplicationRejectDtoBuilder
        > {
  _$AdminCaptainApplicationRejectDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainApplicationRejectDtoBuilder() {
    AdminCaptainApplicationRejectDto._defaults(this);
  }

  AdminCaptainApplicationRejectDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationRejectDto other) {
    _$v = other as _$AdminCaptainApplicationRejectDto;
  }

  @override
  void update(void Function(AdminCaptainApplicationRejectDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationRejectDto build() => _build();

  _$AdminCaptainApplicationRejectDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationRejectDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainApplicationRejectDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
