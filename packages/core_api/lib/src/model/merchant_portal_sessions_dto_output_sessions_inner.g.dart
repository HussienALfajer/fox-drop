// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_sessions_dto_output_sessions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPortalSessionsDtoOutputSessionsInner
    extends MerchantPortalSessionsDtoOutputSessionsInner {
  @override
  final String sessionId;
  @override
  final String ownerName;
  @override
  final String? userAgent;
  @override
  final DateTime signedInAt;
  @override
  final DateTime expiresAt;
  @override
  final bool thisSession;

  factory _$MerchantPortalSessionsDtoOutputSessionsInner([
    void Function(MerchantPortalSessionsDtoOutputSessionsInnerBuilder)? updates,
  ]) => (MerchantPortalSessionsDtoOutputSessionsInnerBuilder()..update(updates))
      ._build();

  _$MerchantPortalSessionsDtoOutputSessionsInner._({
    required this.sessionId,
    required this.ownerName,
    this.userAgent,
    required this.signedInAt,
    required this.expiresAt,
    required this.thisSession,
  }) : super._();
  @override
  MerchantPortalSessionsDtoOutputSessionsInner rebuild(
    void Function(MerchantPortalSessionsDtoOutputSessionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalSessionsDtoOutputSessionsInnerBuilder toBuilder() =>
      MerchantPortalSessionsDtoOutputSessionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalSessionsDtoOutputSessionsInner &&
        sessionId == other.sessionId &&
        ownerName == other.ownerName &&
        userAgent == other.userAgent &&
        signedInAt == other.signedInAt &&
        expiresAt == other.expiresAt &&
        thisSession == other.thisSession;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, ownerName.hashCode);
    _$hash = $jc(_$hash, userAgent.hashCode);
    _$hash = $jc(_$hash, signedInAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, thisSession.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantPortalSessionsDtoOutputSessionsInner',
          )
          ..add('sessionId', sessionId)
          ..add('ownerName', ownerName)
          ..add('userAgent', userAgent)
          ..add('signedInAt', signedInAt)
          ..add('expiresAt', expiresAt)
          ..add('thisSession', thisSession))
        .toString();
  }
}

class MerchantPortalSessionsDtoOutputSessionsInnerBuilder
    implements
        Builder<
          MerchantPortalSessionsDtoOutputSessionsInner,
          MerchantPortalSessionsDtoOutputSessionsInnerBuilder
        > {
  _$MerchantPortalSessionsDtoOutputSessionsInner? _$v;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _ownerName;
  String? get ownerName => _$this._ownerName;
  set ownerName(String? ownerName) => _$this._ownerName = ownerName;

  String? _userAgent;
  String? get userAgent => _$this._userAgent;
  set userAgent(String? userAgent) => _$this._userAgent = userAgent;

  DateTime? _signedInAt;
  DateTime? get signedInAt => _$this._signedInAt;
  set signedInAt(DateTime? signedInAt) => _$this._signedInAt = signedInAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  bool? _thisSession;
  bool? get thisSession => _$this._thisSession;
  set thisSession(bool? thisSession) => _$this._thisSession = thisSession;

  MerchantPortalSessionsDtoOutputSessionsInnerBuilder() {
    MerchantPortalSessionsDtoOutputSessionsInner._defaults(this);
  }

  MerchantPortalSessionsDtoOutputSessionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _ownerName = $v.ownerName;
      _userAgent = $v.userAgent;
      _signedInAt = $v.signedInAt;
      _expiresAt = $v.expiresAt;
      _thisSession = $v.thisSession;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalSessionsDtoOutputSessionsInner other) {
    _$v = other as _$MerchantPortalSessionsDtoOutputSessionsInner;
  }

  @override
  void update(
    void Function(MerchantPortalSessionsDtoOutputSessionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalSessionsDtoOutputSessionsInner build() => _build();

  _$MerchantPortalSessionsDtoOutputSessionsInner _build() {
    final _$result =
        _$v ??
        _$MerchantPortalSessionsDtoOutputSessionsInner._(
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'MerchantPortalSessionsDtoOutputSessionsInner',
            'sessionId',
          ),
          ownerName: BuiltValueNullFieldError.checkNotNull(
            ownerName,
            r'MerchantPortalSessionsDtoOutputSessionsInner',
            'ownerName',
          ),
          userAgent: userAgent,
          signedInAt: BuiltValueNullFieldError.checkNotNull(
            signedInAt,
            r'MerchantPortalSessionsDtoOutputSessionsInner',
            'signedInAt',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MerchantPortalSessionsDtoOutputSessionsInner',
            'expiresAt',
          ),
          thisSession: BuiltValueNullFieldError.checkNotNull(
            thisSession,
            r'MerchantPortalSessionsDtoOutputSessionsInner',
            'thisSession',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
