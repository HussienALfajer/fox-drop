// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_accept_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAcceptDto extends AdminAcceptDto {
  @override
  final int prepMin;
  @override
  final String reason;

  factory _$AdminAcceptDto([void Function(AdminAcceptDtoBuilder)? updates]) =>
      (AdminAcceptDtoBuilder()..update(updates))._build();

  _$AdminAcceptDto._({required this.prepMin, required this.reason}) : super._();
  @override
  AdminAcceptDto rebuild(void Function(AdminAcceptDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAcceptDtoBuilder toBuilder() => AdminAcceptDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAcceptDto &&
        prepMin == other.prepMin &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, prepMin.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAcceptDto')
          ..add('prepMin', prepMin)
          ..add('reason', reason))
        .toString();
  }
}

class AdminAcceptDtoBuilder
    implements Builder<AdminAcceptDto, AdminAcceptDtoBuilder> {
  _$AdminAcceptDto? _$v;

  int? _prepMin;
  int? get prepMin => _$this._prepMin;
  set prepMin(int? prepMin) => _$this._prepMin = prepMin;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminAcceptDtoBuilder() {
    AdminAcceptDto._defaults(this);
  }

  AdminAcceptDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _prepMin = $v.prepMin;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAcceptDto other) {
    _$v = other as _$AdminAcceptDto;
  }

  @override
  void update(void Function(AdminAcceptDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAcceptDto build() => _build();

  _$AdminAcceptDto _build() {
    final _$result =
        _$v ??
        _$AdminAcceptDto._(
          prepMin: BuiltValueNullFieldError.checkNotNull(
            prepMin,
            r'AdminAcceptDto',
            'prepMin',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminAcceptDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
