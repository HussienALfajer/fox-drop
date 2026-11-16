// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_exchange_rate_history_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminExchangeRateHistoryDtoOutput
    extends AdminExchangeRateHistoryDtoOutput {
  @override
  final BuiltList<AdminExchangeRateHistoryDtoOutputVersionsInner> versions;

  factory _$AdminExchangeRateHistoryDtoOutput([
    void Function(AdminExchangeRateHistoryDtoOutputBuilder)? updates,
  ]) => (AdminExchangeRateHistoryDtoOutputBuilder()..update(updates))._build();

  _$AdminExchangeRateHistoryDtoOutput._({required this.versions}) : super._();
  @override
  AdminExchangeRateHistoryDtoOutput rebuild(
    void Function(AdminExchangeRateHistoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExchangeRateHistoryDtoOutputBuilder toBuilder() =>
      AdminExchangeRateHistoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExchangeRateHistoryDtoOutput &&
        versions == other.versions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminExchangeRateHistoryDtoOutput',
    )..add('versions', versions)).toString();
  }
}

class AdminExchangeRateHistoryDtoOutputBuilder
    implements
        Builder<
          AdminExchangeRateHistoryDtoOutput,
          AdminExchangeRateHistoryDtoOutputBuilder
        > {
  _$AdminExchangeRateHistoryDtoOutput? _$v;

  ListBuilder<AdminExchangeRateHistoryDtoOutputVersionsInner>? _versions;
  ListBuilder<AdminExchangeRateHistoryDtoOutputVersionsInner> get versions =>
      _$this._versions ??=
          ListBuilder<AdminExchangeRateHistoryDtoOutputVersionsInner>();
  set versions(
    ListBuilder<AdminExchangeRateHistoryDtoOutputVersionsInner>? versions,
  ) => _$this._versions = versions;

  AdminExchangeRateHistoryDtoOutputBuilder() {
    AdminExchangeRateHistoryDtoOutput._defaults(this);
  }

  AdminExchangeRateHistoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versions = $v.versions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExchangeRateHistoryDtoOutput other) {
    _$v = other as _$AdminExchangeRateHistoryDtoOutput;
  }

  @override
  void update(
    void Function(AdminExchangeRateHistoryDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminExchangeRateHistoryDtoOutput build() => _build();

  _$AdminExchangeRateHistoryDtoOutput _build() {
    _$AdminExchangeRateHistoryDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminExchangeRateHistoryDtoOutput._(versions: versions.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'versions';
        versions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminExchangeRateHistoryDtoOutput',
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
