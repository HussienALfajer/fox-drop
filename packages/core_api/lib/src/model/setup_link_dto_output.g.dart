// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_link_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetupLinkDtoOutput extends SetupLinkDtoOutput {
  @override
  final String accountId;
  @override
  final String setupToken;
  @override
  final DateTime setupExpiresAt;

  factory _$SetupLinkDtoOutput([
    void Function(SetupLinkDtoOutputBuilder)? updates,
  ]) => (SetupLinkDtoOutputBuilder()..update(updates))._build();

  _$SetupLinkDtoOutput._({
    required this.accountId,
    required this.setupToken,
    required this.setupExpiresAt,
  }) : super._();
  @override
  SetupLinkDtoOutput rebuild(
    void Function(SetupLinkDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SetupLinkDtoOutputBuilder toBuilder() =>
      SetupLinkDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetupLinkDtoOutput &&
        accountId == other.accountId &&
        setupToken == other.setupToken &&
        setupExpiresAt == other.setupExpiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, setupToken.hashCode);
    _$hash = $jc(_$hash, setupExpiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetupLinkDtoOutput')
          ..add('accountId', accountId)
          ..add('setupToken', setupToken)
          ..add('setupExpiresAt', setupExpiresAt))
        .toString();
  }
}

class SetupLinkDtoOutputBuilder
    implements Builder<SetupLinkDtoOutput, SetupLinkDtoOutputBuilder> {
  _$SetupLinkDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _setupToken;
  String? get setupToken => _$this._setupToken;
  set setupToken(String? setupToken) => _$this._setupToken = setupToken;

  DateTime? _setupExpiresAt;
  DateTime? get setupExpiresAt => _$this._setupExpiresAt;
  set setupExpiresAt(DateTime? setupExpiresAt) =>
      _$this._setupExpiresAt = setupExpiresAt;

  SetupLinkDtoOutputBuilder() {
    SetupLinkDtoOutput._defaults(this);
  }

  SetupLinkDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _setupToken = $v.setupToken;
      _setupExpiresAt = $v.setupExpiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetupLinkDtoOutput other) {
    _$v = other as _$SetupLinkDtoOutput;
  }

  @override
  void update(void Function(SetupLinkDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetupLinkDtoOutput build() => _build();

  _$SetupLinkDtoOutput _build() {
    final _$result =
        _$v ??
        _$SetupLinkDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'SetupLinkDtoOutput',
            'accountId',
          ),
          setupToken: BuiltValueNullFieldError.checkNotNull(
            setupToken,
            r'SetupLinkDtoOutput',
            'setupToken',
          ),
          setupExpiresAt: BuiltValueNullFieldError.checkNotNull(
            setupExpiresAt,
            r'SetupLinkDtoOutput',
            'setupExpiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
