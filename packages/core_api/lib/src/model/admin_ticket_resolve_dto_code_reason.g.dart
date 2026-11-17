// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_resolve_dto_code_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketResolveDtoCodeReason
    extends AdminTicketResolveDtoCodeReason {
  @override
  final String code;
  @override
  final String? note;

  factory _$AdminTicketResolveDtoCodeReason([
    void Function(AdminTicketResolveDtoCodeReasonBuilder)? updates,
  ]) => (AdminTicketResolveDtoCodeReasonBuilder()..update(updates))._build();

  _$AdminTicketResolveDtoCodeReason._({required this.code, this.note})
    : super._();
  @override
  AdminTicketResolveDtoCodeReason rebuild(
    void Function(AdminTicketResolveDtoCodeReasonBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketResolveDtoCodeReasonBuilder toBuilder() =>
      AdminTicketResolveDtoCodeReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketResolveDtoCodeReason &&
        code == other.code &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketResolveDtoCodeReason')
          ..add('code', code)
          ..add('note', note))
        .toString();
  }
}

class AdminTicketResolveDtoCodeReasonBuilder
    implements
        Builder<
          AdminTicketResolveDtoCodeReason,
          AdminTicketResolveDtoCodeReasonBuilder
        > {
  _$AdminTicketResolveDtoCodeReason? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminTicketResolveDtoCodeReasonBuilder() {
    AdminTicketResolveDtoCodeReason._defaults(this);
  }

  AdminTicketResolveDtoCodeReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketResolveDtoCodeReason other) {
    _$v = other as _$AdminTicketResolveDtoCodeReason;
  }

  @override
  void update(void Function(AdminTicketResolveDtoCodeReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketResolveDtoCodeReason build() => _build();

  _$AdminTicketResolveDtoCodeReason _build() {
    final _$result =
        _$v ??
        _$AdminTicketResolveDtoCodeReason._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminTicketResolveDtoCodeReason',
            'code',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
