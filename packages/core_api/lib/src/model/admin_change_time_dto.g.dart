// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_time_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeTimeDto extends AdminChangeTimeDto {
  @override
  final int addMin;
  @override
  final String? reason;

  factory _$AdminChangeTimeDto([
    void Function(AdminChangeTimeDtoBuilder)? updates,
  ]) => (AdminChangeTimeDtoBuilder()..update(updates))._build();

  _$AdminChangeTimeDto._({required this.addMin, this.reason}) : super._();
  @override
  AdminChangeTimeDto rebuild(
    void Function(AdminChangeTimeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeTimeDtoBuilder toBuilder() =>
      AdminChangeTimeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeTimeDto &&
        addMin == other.addMin &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, addMin.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeTimeDto')
          ..add('addMin', addMin)
          ..add('reason', reason))
        .toString();
  }
}

class AdminChangeTimeDtoBuilder
    implements Builder<AdminChangeTimeDto, AdminChangeTimeDtoBuilder> {
  _$AdminChangeTimeDto? _$v;

  int? _addMin;
  int? get addMin => _$this._addMin;
  set addMin(int? addMin) => _$this._addMin = addMin;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminChangeTimeDtoBuilder() {
    AdminChangeTimeDto._defaults(this);
  }

  AdminChangeTimeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _addMin = $v.addMin;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeTimeDto other) {
    _$v = other as _$AdminChangeTimeDto;
  }

  @override
  void update(void Function(AdminChangeTimeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeTimeDto build() => _build();

  _$AdminChangeTimeDto _build() {
    final _$result =
        _$v ??
        _$AdminChangeTimeDto._(
          addMin: BuiltValueNullFieldError.checkNotNull(
            addMin,
            r'AdminChangeTimeDto',
            'addMin',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
