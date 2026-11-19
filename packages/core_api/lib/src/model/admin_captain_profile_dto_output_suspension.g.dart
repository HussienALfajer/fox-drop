// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_suspension.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputSuspension
    extends AdminCaptainProfileDtoOutputSuspension {
  @override
  final String reason;
  @override
  final DateTime? until;

  factory _$AdminCaptainProfileDtoOutputSuspension([
    void Function(AdminCaptainProfileDtoOutputSuspensionBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputSuspensionBuilder()..update(updates))
      ._build();

  _$AdminCaptainProfileDtoOutputSuspension._({required this.reason, this.until})
    : super._();
  @override
  AdminCaptainProfileDtoOutputSuspension rebuild(
    void Function(AdminCaptainProfileDtoOutputSuspensionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputSuspensionBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputSuspensionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputSuspension &&
        reason == other.reason &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainProfileDtoOutputSuspension',
          )
          ..add('reason', reason)
          ..add('until', until))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputSuspensionBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputSuspension,
          AdminCaptainProfileDtoOutputSuspensionBuilder
        > {
  _$AdminCaptainProfileDtoOutputSuspension? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  AdminCaptainProfileDtoOutputSuspensionBuilder() {
    AdminCaptainProfileDtoOutputSuspension._defaults(this);
  }

  AdminCaptainProfileDtoOutputSuspensionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputSuspension other) {
    _$v = other as _$AdminCaptainProfileDtoOutputSuspension;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputSuspensionBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputSuspension build() => _build();

  _$AdminCaptainProfileDtoOutputSuspension _build() {
    final _$result =
        _$v ??
        _$AdminCaptainProfileDtoOutputSuspension._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainProfileDtoOutputSuspension',
            'reason',
          ),
          until: until,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
