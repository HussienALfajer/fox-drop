// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_former_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputFormerCaptain
    extends AdminCaptainApplicationDtoOutputFormerCaptain {
  @override
  final String captainId;
  @override
  final bool earlyExit;

  factory _$AdminCaptainApplicationDtoOutputFormerCaptain([
    void Function(AdminCaptainApplicationDtoOutputFormerCaptainBuilder)?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputFormerCaptainBuilder()..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputFormerCaptain._({
    required this.captainId,
    required this.earlyExit,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputFormerCaptain rebuild(
    void Function(AdminCaptainApplicationDtoOutputFormerCaptainBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputFormerCaptainBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputFormerCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputFormerCaptain &&
        captainId == other.captainId &&
        earlyExit == other.earlyExit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, earlyExit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputFormerCaptain',
          )
          ..add('captainId', captainId)
          ..add('earlyExit', earlyExit))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputFormerCaptainBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputFormerCaptain,
          AdminCaptainApplicationDtoOutputFormerCaptainBuilder
        > {
  _$AdminCaptainApplicationDtoOutputFormerCaptain? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  bool? _earlyExit;
  bool? get earlyExit => _$this._earlyExit;
  set earlyExit(bool? earlyExit) => _$this._earlyExit = earlyExit;

  AdminCaptainApplicationDtoOutputFormerCaptainBuilder() {
    AdminCaptainApplicationDtoOutputFormerCaptain._defaults(this);
  }

  AdminCaptainApplicationDtoOutputFormerCaptainBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _earlyExit = $v.earlyExit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputFormerCaptain other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputFormerCaptain;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputFormerCaptainBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputFormerCaptain build() => _build();

  _$AdminCaptainApplicationDtoOutputFormerCaptain _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputFormerCaptain._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminCaptainApplicationDtoOutputFormerCaptain',
            'captainId',
          ),
          earlyExit: BuiltValueNullFieldError.checkNotNull(
            earlyExit,
            r'AdminCaptainApplicationDtoOutputFormerCaptain',
            'earlyExit',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
