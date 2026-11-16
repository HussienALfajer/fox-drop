// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_compensate_dto_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCompensateDtoReason extends AdminCompensateDtoReason {
  @override
  final String code;
  @override
  final String? note;

  factory _$AdminCompensateDtoReason([
    void Function(AdminCompensateDtoReasonBuilder)? updates,
  ]) => (AdminCompensateDtoReasonBuilder()..update(updates))._build();

  _$AdminCompensateDtoReason._({required this.code, this.note}) : super._();
  @override
  AdminCompensateDtoReason rebuild(
    void Function(AdminCompensateDtoReasonBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCompensateDtoReasonBuilder toBuilder() =>
      AdminCompensateDtoReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCompensateDtoReason &&
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
    return (newBuiltValueToStringHelper(r'AdminCompensateDtoReason')
          ..add('code', code)
          ..add('note', note))
        .toString();
  }
}

class AdminCompensateDtoReasonBuilder
    implements
        Builder<AdminCompensateDtoReason, AdminCompensateDtoReasonBuilder> {
  _$AdminCompensateDtoReason? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCompensateDtoReasonBuilder() {
    AdminCompensateDtoReason._defaults(this);
  }

  AdminCompensateDtoReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCompensateDtoReason other) {
    _$v = other as _$AdminCompensateDtoReason;
  }

  @override
  void update(void Function(AdminCompensateDtoReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCompensateDtoReason build() => _build();

  _$AdminCompensateDtoReason _build() {
    final _$result =
        _$v ??
        _$AdminCompensateDtoReason._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCompensateDtoReason',
            'code',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
