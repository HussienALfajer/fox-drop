// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_requests_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeRequestsDtoOutput extends AdminChangeRequestsDtoOutput {
  @override
  final BuiltList<AdminChangeRequestRowOutput> requests;

  factory _$AdminChangeRequestsDtoOutput([
    void Function(AdminChangeRequestsDtoOutputBuilder)? updates,
  ]) => (AdminChangeRequestsDtoOutputBuilder()..update(updates))._build();

  _$AdminChangeRequestsDtoOutput._({required this.requests}) : super._();
  @override
  AdminChangeRequestsDtoOutput rebuild(
    void Function(AdminChangeRequestsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeRequestsDtoOutputBuilder toBuilder() =>
      AdminChangeRequestsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeRequestsDtoOutput && requests == other.requests;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requests.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminChangeRequestsDtoOutput',
    )..add('requests', requests)).toString();
  }
}

class AdminChangeRequestsDtoOutputBuilder
    implements
        Builder<
          AdminChangeRequestsDtoOutput,
          AdminChangeRequestsDtoOutputBuilder
        > {
  _$AdminChangeRequestsDtoOutput? _$v;

  ListBuilder<AdminChangeRequestRowOutput>? _requests;
  ListBuilder<AdminChangeRequestRowOutput> get requests =>
      _$this._requests ??= ListBuilder<AdminChangeRequestRowOutput>();
  set requests(ListBuilder<AdminChangeRequestRowOutput>? requests) =>
      _$this._requests = requests;

  AdminChangeRequestsDtoOutputBuilder() {
    AdminChangeRequestsDtoOutput._defaults(this);
  }

  AdminChangeRequestsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requests = $v.requests.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeRequestsDtoOutput other) {
    _$v = other as _$AdminChangeRequestsDtoOutput;
  }

  @override
  void update(void Function(AdminChangeRequestsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeRequestsDtoOutput build() => _build();

  _$AdminChangeRequestsDtoOutput _build() {
    _$AdminChangeRequestsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminChangeRequestsDtoOutput._(requests: requests.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requests';
        requests.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminChangeRequestsDtoOutput',
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
