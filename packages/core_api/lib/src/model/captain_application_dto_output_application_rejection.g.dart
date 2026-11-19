// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_dto_output_application_rejection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationDtoOutputApplicationRejection
    extends CaptainApplicationDtoOutputApplicationRejection {
  @override
  final String reason;
  @override
  final DateTime at;
  @override
  final DateTime reapplyFrom;

  factory _$CaptainApplicationDtoOutputApplicationRejection([
    void Function(CaptainApplicationDtoOutputApplicationRejectionBuilder)?
    updates,
  ]) =>
      (CaptainApplicationDtoOutputApplicationRejectionBuilder()
            ..update(updates))
          ._build();

  _$CaptainApplicationDtoOutputApplicationRejection._({
    required this.reason,
    required this.at,
    required this.reapplyFrom,
  }) : super._();
  @override
  CaptainApplicationDtoOutputApplicationRejection rebuild(
    void Function(CaptainApplicationDtoOutputApplicationRejectionBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationDtoOutputApplicationRejectionBuilder toBuilder() =>
      CaptainApplicationDtoOutputApplicationRejectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationDtoOutputApplicationRejection &&
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
            r'CaptainApplicationDtoOutputApplicationRejection',
          )
          ..add('reason', reason)
          ..add('at', at)
          ..add('reapplyFrom', reapplyFrom))
        .toString();
  }
}

class CaptainApplicationDtoOutputApplicationRejectionBuilder
    implements
        Builder<
          CaptainApplicationDtoOutputApplicationRejection,
          CaptainApplicationDtoOutputApplicationRejectionBuilder
        > {
  _$CaptainApplicationDtoOutputApplicationRejection? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  DateTime? _reapplyFrom;
  DateTime? get reapplyFrom => _$this._reapplyFrom;
  set reapplyFrom(DateTime? reapplyFrom) => _$this._reapplyFrom = reapplyFrom;

  CaptainApplicationDtoOutputApplicationRejectionBuilder() {
    CaptainApplicationDtoOutputApplicationRejection._defaults(this);
  }

  CaptainApplicationDtoOutputApplicationRejectionBuilder get _$this {
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
  void replace(CaptainApplicationDtoOutputApplicationRejection other) {
    _$v = other as _$CaptainApplicationDtoOutputApplicationRejection;
  }

  @override
  void update(
    void Function(CaptainApplicationDtoOutputApplicationRejectionBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationDtoOutputApplicationRejection build() => _build();

  _$CaptainApplicationDtoOutputApplicationRejection _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationDtoOutputApplicationRejection._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainApplicationDtoOutputApplicationRejection',
            'reason',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainApplicationDtoOutputApplicationRejection',
            'at',
          ),
          reapplyFrom: BuiltValueNullFieldError.checkNotNull(
            reapplyFrom,
            r'CaptainApplicationDtoOutputApplicationRejection',
            'reapplyFrom',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
