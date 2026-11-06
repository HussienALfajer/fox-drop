// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_arrival_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordArrivalDto extends AdminRecordArrivalDto {
  @override
  final String reason;

  factory _$AdminRecordArrivalDto([
    void Function(AdminRecordArrivalDtoBuilder)? updates,
  ]) => (AdminRecordArrivalDtoBuilder()..update(updates))._build();

  _$AdminRecordArrivalDto._({required this.reason}) : super._();
  @override
  AdminRecordArrivalDto rebuild(
    void Function(AdminRecordArrivalDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordArrivalDtoBuilder toBuilder() =>
      AdminRecordArrivalDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordArrivalDto && reason == other.reason;
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
      r'AdminRecordArrivalDto',
    )..add('reason', reason)).toString();
  }
}

class AdminRecordArrivalDtoBuilder
    implements Builder<AdminRecordArrivalDto, AdminRecordArrivalDtoBuilder> {
  _$AdminRecordArrivalDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRecordArrivalDtoBuilder() {
    AdminRecordArrivalDto._defaults(this);
  }

  AdminRecordArrivalDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordArrivalDto other) {
    _$v = other as _$AdminRecordArrivalDto;
  }

  @override
  void update(void Function(AdminRecordArrivalDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordArrivalDto build() => _build();

  _$AdminRecordArrivalDto _build() {
    final _$result =
        _$v ??
        _$AdminRecordArrivalDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRecordArrivalDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
