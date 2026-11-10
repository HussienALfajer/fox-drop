// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_close_item_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCloseItemReportDto extends AdminCloseItemReportDto {
  @override
  final String reason;

  factory _$AdminCloseItemReportDto([
    void Function(AdminCloseItemReportDtoBuilder)? updates,
  ]) => (AdminCloseItemReportDtoBuilder()..update(updates))._build();

  _$AdminCloseItemReportDto._({required this.reason}) : super._();
  @override
  AdminCloseItemReportDto rebuild(
    void Function(AdminCloseItemReportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCloseItemReportDtoBuilder toBuilder() =>
      AdminCloseItemReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCloseItemReportDto && reason == other.reason;
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
      r'AdminCloseItemReportDto',
    )..add('reason', reason)).toString();
  }
}

class AdminCloseItemReportDtoBuilder
    implements
        Builder<AdminCloseItemReportDto, AdminCloseItemReportDtoBuilder> {
  _$AdminCloseItemReportDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCloseItemReportDtoBuilder() {
    AdminCloseItemReportDto._defaults(this);
  }

  AdminCloseItemReportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCloseItemReportDto other) {
    _$v = other as _$AdminCloseItemReportDto;
  }

  @override
  void update(void Function(AdminCloseItemReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCloseItemReportDto build() => _build();

  _$AdminCloseItemReportDto _build() {
    final _$result =
        _$v ??
        _$AdminCloseItemReportDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCloseItemReportDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
