// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_compensation_requests_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCompensationRequestsDtoOutput
    extends AdminCompensationRequestsDtoOutput {
  @override
  final BuiltList<AdminOrderCompensationsDtoOutputCompensationsInner> requests;

  factory _$AdminCompensationRequestsDtoOutput([
    void Function(AdminCompensationRequestsDtoOutputBuilder)? updates,
  ]) => (AdminCompensationRequestsDtoOutputBuilder()..update(updates))._build();

  _$AdminCompensationRequestsDtoOutput._({required this.requests}) : super._();
  @override
  AdminCompensationRequestsDtoOutput rebuild(
    void Function(AdminCompensationRequestsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCompensationRequestsDtoOutputBuilder toBuilder() =>
      AdminCompensationRequestsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCompensationRequestsDtoOutput &&
        requests == other.requests;
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
      r'AdminCompensationRequestsDtoOutput',
    )..add('requests', requests)).toString();
  }
}

class AdminCompensationRequestsDtoOutputBuilder
    implements
        Builder<
          AdminCompensationRequestsDtoOutput,
          AdminCompensationRequestsDtoOutputBuilder
        > {
  _$AdminCompensationRequestsDtoOutput? _$v;

  ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>? _requests;
  ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>
  get requests => _$this._requests ??=
      ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>();
  set requests(
    ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>? requests,
  ) => _$this._requests = requests;

  AdminCompensationRequestsDtoOutputBuilder() {
    AdminCompensationRequestsDtoOutput._defaults(this);
  }

  AdminCompensationRequestsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requests = $v.requests.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCompensationRequestsDtoOutput other) {
    _$v = other as _$AdminCompensationRequestsDtoOutput;
  }

  @override
  void update(
    void Function(AdminCompensationRequestsDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCompensationRequestsDtoOutput build() => _build();

  _$AdminCompensationRequestsDtoOutput _build() {
    _$AdminCompensationRequestsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCompensationRequestsDtoOutput._(requests: requests.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requests';
        requests.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCompensationRequestsDtoOutput',
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
