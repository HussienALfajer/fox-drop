// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_handover_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandoverDto extends AdminHandoverDto {
  @override
  final String captainId;
  @override
  final String reason;
  @override
  final bool? captainFault;

  factory _$AdminHandoverDto([
    void Function(AdminHandoverDtoBuilder)? updates,
  ]) => (AdminHandoverDtoBuilder()..update(updates))._build();

  _$AdminHandoverDto._({
    required this.captainId,
    required this.reason,
    this.captainFault,
  }) : super._();
  @override
  AdminHandoverDto rebuild(void Function(AdminHandoverDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminHandoverDtoBuilder toBuilder() =>
      AdminHandoverDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandoverDto &&
        captainId == other.captainId &&
        reason == other.reason &&
        captainFault == other.captainFault;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHandoverDto')
          ..add('captainId', captainId)
          ..add('reason', reason)
          ..add('captainFault', captainFault))
        .toString();
  }
}

class AdminHandoverDtoBuilder
    implements Builder<AdminHandoverDto, AdminHandoverDtoBuilder> {
  _$AdminHandoverDto? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  AdminHandoverDtoBuilder() {
    AdminHandoverDto._defaults(this);
  }

  AdminHandoverDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _reason = $v.reason;
      _captainFault = $v.captainFault;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandoverDto other) {
    _$v = other as _$AdminHandoverDto;
  }

  @override
  void update(void Function(AdminHandoverDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandoverDto build() => _build();

  _$AdminHandoverDto _build() {
    final _$result =
        _$v ??
        _$AdminHandoverDto._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminHandoverDto',
            'captainId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminHandoverDto',
            'reason',
          ),
          captainFault: captainFault,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
