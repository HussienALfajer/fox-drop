// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_dto_compensation_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancelDtoCompensationReason
    extends AdminCancelDtoCompensationReason {
  @override
  final String code;
  @override
  final String? note;

  factory _$AdminCancelDtoCompensationReason([
    void Function(AdminCancelDtoCompensationReasonBuilder)? updates,
  ]) => (AdminCancelDtoCompensationReasonBuilder()..update(updates))._build();

  _$AdminCancelDtoCompensationReason._({required this.code, this.note})
    : super._();
  @override
  AdminCancelDtoCompensationReason rebuild(
    void Function(AdminCancelDtoCompensationReasonBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelDtoCompensationReasonBuilder toBuilder() =>
      AdminCancelDtoCompensationReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelDtoCompensationReason &&
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
    return (newBuiltValueToStringHelper(r'AdminCancelDtoCompensationReason')
          ..add('code', code)
          ..add('note', note))
        .toString();
  }
}

class AdminCancelDtoCompensationReasonBuilder
    implements
        Builder<
          AdminCancelDtoCompensationReason,
          AdminCancelDtoCompensationReasonBuilder
        > {
  _$AdminCancelDtoCompensationReason? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCancelDtoCompensationReasonBuilder() {
    AdminCancelDtoCompensationReason._defaults(this);
  }

  AdminCancelDtoCompensationReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelDtoCompensationReason other) {
    _$v = other as _$AdminCancelDtoCompensationReason;
  }

  @override
  void update(void Function(AdminCancelDtoCompensationReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelDtoCompensationReason build() => _build();

  _$AdminCancelDtoCompensationReason _build() {
    final _$result =
        _$v ??
        _$AdminCancelDtoCompensationReason._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCancelDtoCompensationReason',
            'code',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
