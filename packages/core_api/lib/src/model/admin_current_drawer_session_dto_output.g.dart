// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_current_drawer_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCurrentDrawerSessionDtoOutput
    extends AdminCurrentDrawerSessionDtoOutput {
  @override
  final AdminCurrentDrawerSessionDtoOutputSession? session;
  @override
  final BuiltList<String> currencies;

  factory _$AdminCurrentDrawerSessionDtoOutput([
    void Function(AdminCurrentDrawerSessionDtoOutputBuilder)? updates,
  ]) => (AdminCurrentDrawerSessionDtoOutputBuilder()..update(updates))._build();

  _$AdminCurrentDrawerSessionDtoOutput._({
    this.session,
    required this.currencies,
  }) : super._();
  @override
  AdminCurrentDrawerSessionDtoOutput rebuild(
    void Function(AdminCurrentDrawerSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCurrentDrawerSessionDtoOutputBuilder toBuilder() =>
      AdminCurrentDrawerSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCurrentDrawerSessionDtoOutput &&
        session == other.session &&
        currencies == other.currencies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, session.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCurrentDrawerSessionDtoOutput')
          ..add('session', session)
          ..add('currencies', currencies))
        .toString();
  }
}

class AdminCurrentDrawerSessionDtoOutputBuilder
    implements
        Builder<
          AdminCurrentDrawerSessionDtoOutput,
          AdminCurrentDrawerSessionDtoOutputBuilder
        > {
  _$AdminCurrentDrawerSessionDtoOutput? _$v;

  AdminCurrentDrawerSessionDtoOutputSessionBuilder? _session;
  AdminCurrentDrawerSessionDtoOutputSessionBuilder get session =>
      _$this._session ??= AdminCurrentDrawerSessionDtoOutputSessionBuilder();
  set session(AdminCurrentDrawerSessionDtoOutputSessionBuilder? session) =>
      _$this._session = session;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  AdminCurrentDrawerSessionDtoOutputBuilder() {
    AdminCurrentDrawerSessionDtoOutput._defaults(this);
  }

  AdminCurrentDrawerSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _session = $v.session?.toBuilder();
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCurrentDrawerSessionDtoOutput other) {
    _$v = other as _$AdminCurrentDrawerSessionDtoOutput;
  }

  @override
  void update(
    void Function(AdminCurrentDrawerSessionDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCurrentDrawerSessionDtoOutput build() => _build();

  _$AdminCurrentDrawerSessionDtoOutput _build() {
    _$AdminCurrentDrawerSessionDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCurrentDrawerSessionDtoOutput._(
            session: _session?.build(),
            currencies: currencies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'session';
        _session?.build();
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCurrentDrawerSessionDtoOutput',
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
