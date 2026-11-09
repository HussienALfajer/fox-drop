// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSessionDtoOutput extends CustomerSessionDtoOutput {
  @override
  final String accountId;
  @override
  final String sessionId;

  factory _$CustomerSessionDtoOutput([
    void Function(CustomerSessionDtoOutputBuilder)? updates,
  ]) => (CustomerSessionDtoOutputBuilder()..update(updates))._build();

  _$CustomerSessionDtoOutput._({
    required this.accountId,
    required this.sessionId,
  }) : super._();
  @override
  CustomerSessionDtoOutput rebuild(
    void Function(CustomerSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSessionDtoOutputBuilder toBuilder() =>
      CustomerSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSessionDtoOutput &&
        accountId == other.accountId &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSessionDtoOutput')
          ..add('accountId', accountId)
          ..add('sessionId', sessionId))
        .toString();
  }
}

class CustomerSessionDtoOutputBuilder
    implements
        Builder<CustomerSessionDtoOutput, CustomerSessionDtoOutputBuilder> {
  _$CustomerSessionDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  CustomerSessionDtoOutputBuilder() {
    CustomerSessionDtoOutput._defaults(this);
  }

  CustomerSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _sessionId = $v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSessionDtoOutput other) {
    _$v = other as _$CustomerSessionDtoOutput;
  }

  @override
  void update(void Function(CustomerSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSessionDtoOutput build() => _build();

  _$CustomerSessionDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerSessionDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'CustomerSessionDtoOutput',
            'accountId',
          ),
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'CustomerSessionDtoOutput',
            'sessionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
