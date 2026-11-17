// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_signed_out_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerSignedOutDtoOutput
    extends AdminCustomerSignedOutDtoOutput {
  @override
  final int sessionsEnded;

  factory _$AdminCustomerSignedOutDtoOutput([
    void Function(AdminCustomerSignedOutDtoOutputBuilder)? updates,
  ]) => (AdminCustomerSignedOutDtoOutputBuilder()..update(updates))._build();

  _$AdminCustomerSignedOutDtoOutput._({required this.sessionsEnded})
    : super._();
  @override
  AdminCustomerSignedOutDtoOutput rebuild(
    void Function(AdminCustomerSignedOutDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerSignedOutDtoOutputBuilder toBuilder() =>
      AdminCustomerSignedOutDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerSignedOutDtoOutput &&
        sessionsEnded == other.sessionsEnded;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionsEnded.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCustomerSignedOutDtoOutput',
    )..add('sessionsEnded', sessionsEnded)).toString();
  }
}

class AdminCustomerSignedOutDtoOutputBuilder
    implements
        Builder<
          AdminCustomerSignedOutDtoOutput,
          AdminCustomerSignedOutDtoOutputBuilder
        > {
  _$AdminCustomerSignedOutDtoOutput? _$v;

  int? _sessionsEnded;
  int? get sessionsEnded => _$this._sessionsEnded;
  set sessionsEnded(int? sessionsEnded) =>
      _$this._sessionsEnded = sessionsEnded;

  AdminCustomerSignedOutDtoOutputBuilder() {
    AdminCustomerSignedOutDtoOutput._defaults(this);
  }

  AdminCustomerSignedOutDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionsEnded = $v.sessionsEnded;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerSignedOutDtoOutput other) {
    _$v = other as _$AdminCustomerSignedOutDtoOutput;
  }

  @override
  void update(void Function(AdminCustomerSignedOutDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerSignedOutDtoOutput build() => _build();

  _$AdminCustomerSignedOutDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminCustomerSignedOutDtoOutput._(
          sessionsEnded: BuiltValueNullFieldError.checkNotNull(
            sessionsEnded,
            r'AdminCustomerSignedOutDtoOutput',
            'sessionsEnded',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
