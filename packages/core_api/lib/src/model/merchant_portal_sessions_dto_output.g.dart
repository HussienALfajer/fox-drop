// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_sessions_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPortalSessionsDtoOutput
    extends MerchantPortalSessionsDtoOutput {
  @override
  final BuiltList<MerchantPortalSessionsDtoOutputSessionsInner> sessions;

  factory _$MerchantPortalSessionsDtoOutput([
    void Function(MerchantPortalSessionsDtoOutputBuilder)? updates,
  ]) => (MerchantPortalSessionsDtoOutputBuilder()..update(updates))._build();

  _$MerchantPortalSessionsDtoOutput._({required this.sessions}) : super._();
  @override
  MerchantPortalSessionsDtoOutput rebuild(
    void Function(MerchantPortalSessionsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalSessionsDtoOutputBuilder toBuilder() =>
      MerchantPortalSessionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalSessionsDtoOutput &&
        sessions == other.sessions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantPortalSessionsDtoOutput',
    )..add('sessions', sessions)).toString();
  }
}

class MerchantPortalSessionsDtoOutputBuilder
    implements
        Builder<
          MerchantPortalSessionsDtoOutput,
          MerchantPortalSessionsDtoOutputBuilder
        > {
  _$MerchantPortalSessionsDtoOutput? _$v;

  ListBuilder<MerchantPortalSessionsDtoOutputSessionsInner>? _sessions;
  ListBuilder<MerchantPortalSessionsDtoOutputSessionsInner> get sessions =>
      _$this._sessions ??=
          ListBuilder<MerchantPortalSessionsDtoOutputSessionsInner>();
  set sessions(
    ListBuilder<MerchantPortalSessionsDtoOutputSessionsInner>? sessions,
  ) => _$this._sessions = sessions;

  MerchantPortalSessionsDtoOutputBuilder() {
    MerchantPortalSessionsDtoOutput._defaults(this);
  }

  MerchantPortalSessionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessions = $v.sessions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalSessionsDtoOutput other) {
    _$v = other as _$MerchantPortalSessionsDtoOutput;
  }

  @override
  void update(void Function(MerchantPortalSessionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalSessionsDtoOutput build() => _build();

  _$MerchantPortalSessionsDtoOutput _build() {
    _$MerchantPortalSessionsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPortalSessionsDtoOutput._(sessions: sessions.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sessions';
        sessions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPortalSessionsDtoOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
