// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_rejection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputRejection
    extends AdminCaptainApplicationDtoOutputRejection {
  @override
  final String reason;
  @override
  final DateTime at;
  @override
  final DateTime reapplyFrom;

  factory _$AdminCaptainApplicationDtoOutputRejection([
    void Function(AdminCaptainApplicationDtoOutputRejectionBuilder)? updates,
  ]) => (AdminCaptainApplicationDtoOutputRejectionBuilder()..update(updates))
      ._build();

  _$AdminCaptainApplicationDtoOutputRejection._({
    required this.reason,
    required this.at,
    required this.reapplyFrom,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputRejection rebuild(
    void Function(AdminCaptainApplicationDtoOutputRejectionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputRejectionBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputRejectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputRejection &&
        reason == other.reason &&
        at == other.at &&
        reapplyFrom == other.reapplyFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reapplyFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputRejection',
          )
          ..add('reason', reason)
          ..add('at', at)
          ..add('reapplyFrom', reapplyFrom))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputRejectionBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputRejection,
          AdminCaptainApplicationDtoOutputRejectionBuilder
        > {
  _$AdminCaptainApplicationDtoOutputRejection? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  DateTime? _reapplyFrom;
  DateTime? get reapplyFrom => _$this._reapplyFrom;
  set reapplyFrom(DateTime? reapplyFrom) => _$this._reapplyFrom = reapplyFrom;

  AdminCaptainApplicationDtoOutputRejectionBuilder() {
    AdminCaptainApplicationDtoOutputRejection._defaults(this);
  }

  AdminCaptainApplicationDtoOutputRejectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _at = $v.at;
      _reapplyFrom = $v.reapplyFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputRejection other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputRejection;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputRejectionBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputRejection build() => _build();

  _$AdminCaptainApplicationDtoOutputRejection _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputRejection._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainApplicationDtoOutputRejection',
            'reason',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCaptainApplicationDtoOutputRejection',
            'at',
          ),
          reapplyFrom: BuiltValueNullFieldError.checkNotNull(
            reapplyFrom,
            r'AdminCaptainApplicationDtoOutputRejection',
            'reapplyFrom',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
