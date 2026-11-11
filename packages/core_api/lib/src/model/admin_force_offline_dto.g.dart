// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_force_offline_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminForceOfflineDto extends AdminForceOfflineDto {
  @override
  final String reason;

  factory _$AdminForceOfflineDto([
    void Function(AdminForceOfflineDtoBuilder)? updates,
  ]) => (AdminForceOfflineDtoBuilder()..update(updates))._build();

  _$AdminForceOfflineDto._({required this.reason}) : super._();
  @override
  AdminForceOfflineDto rebuild(
    void Function(AdminForceOfflineDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminForceOfflineDtoBuilder toBuilder() =>
      AdminForceOfflineDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminForceOfflineDto && reason == other.reason;
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
      r'AdminForceOfflineDto',
    )..add('reason', reason)).toString();
  }
}

class AdminForceOfflineDtoBuilder
    implements Builder<AdminForceOfflineDto, AdminForceOfflineDtoBuilder> {
  _$AdminForceOfflineDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminForceOfflineDtoBuilder() {
    AdminForceOfflineDto._defaults(this);
  }

  AdminForceOfflineDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminForceOfflineDto other) {
    _$v = other as _$AdminForceOfflineDto;
  }

  @override
  void update(void Function(AdminForceOfflineDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminForceOfflineDto build() => _build();

  _$AdminForceOfflineDto _build() {
    final _$result =
        _$v ??
        _$AdminForceOfflineDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminForceOfflineDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
