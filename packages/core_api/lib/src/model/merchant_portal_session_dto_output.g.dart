// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPortalSessionDtoOutput extends MerchantPortalSessionDtoOutput {
  @override
  final String accountId;
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final String sessionId;

  factory _$MerchantPortalSessionDtoOutput([
    void Function(MerchantPortalSessionDtoOutputBuilder)? updates,
  ]) => (MerchantPortalSessionDtoOutputBuilder()..update(updates))._build();

  _$MerchantPortalSessionDtoOutput._({
    required this.accountId,
    required this.restaurantId,
    required this.name,
    required this.sessionId,
  }) : super._();
  @override
  MerchantPortalSessionDtoOutput rebuild(
    void Function(MerchantPortalSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalSessionDtoOutputBuilder toBuilder() =>
      MerchantPortalSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalSessionDtoOutput &&
        accountId == other.accountId &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPortalSessionDtoOutput')
          ..add('accountId', accountId)
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('sessionId', sessionId))
        .toString();
  }
}

class MerchantPortalSessionDtoOutputBuilder
    implements
        Builder<
          MerchantPortalSessionDtoOutput,
          MerchantPortalSessionDtoOutputBuilder
        > {
  _$MerchantPortalSessionDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  MerchantPortalSessionDtoOutputBuilder() {
    MerchantPortalSessionDtoOutput._defaults(this);
  }

  MerchantPortalSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _sessionId = $v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalSessionDtoOutput other) {
    _$v = other as _$MerchantPortalSessionDtoOutput;
  }

  @override
  void update(void Function(MerchantPortalSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalSessionDtoOutput build() => _build();

  _$MerchantPortalSessionDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantPortalSessionDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'MerchantPortalSessionDtoOutput',
            'accountId',
          ),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'MerchantPortalSessionDtoOutput',
            'restaurantId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantPortalSessionDtoOutput',
            'name',
          ),
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'MerchantPortalSessionDtoOutput',
            'sessionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
