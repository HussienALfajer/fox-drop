// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_close_drawer_session_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCloseDrawerSessionDto extends AdminCloseDrawerSessionDto {
  @override
  final BuiltList<AdminOpenDrawerSessionDtoFloatsInner> counted;
  @override
  final String? note;

  factory _$AdminCloseDrawerSessionDto([
    void Function(AdminCloseDrawerSessionDtoBuilder)? updates,
  ]) => (AdminCloseDrawerSessionDtoBuilder()..update(updates))._build();

  _$AdminCloseDrawerSessionDto._({required this.counted, this.note})
    : super._();
  @override
  AdminCloseDrawerSessionDto rebuild(
    void Function(AdminCloseDrawerSessionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCloseDrawerSessionDtoBuilder toBuilder() =>
      AdminCloseDrawerSessionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCloseDrawerSessionDto &&
        counted == other.counted &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, counted.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCloseDrawerSessionDto')
          ..add('counted', counted)
          ..add('note', note))
        .toString();
  }
}

class AdminCloseDrawerSessionDtoBuilder
    implements
        Builder<AdminCloseDrawerSessionDto, AdminCloseDrawerSessionDtoBuilder> {
  _$AdminCloseDrawerSessionDto? _$v;

  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? _counted;
  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner> get counted =>
      _$this._counted ??= ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>();
  set counted(ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? counted) =>
      _$this._counted = counted;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCloseDrawerSessionDtoBuilder() {
    AdminCloseDrawerSessionDto._defaults(this);
  }

  AdminCloseDrawerSessionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _counted = $v.counted.toBuilder();
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCloseDrawerSessionDto other) {
    _$v = other as _$AdminCloseDrawerSessionDto;
  }

  @override
  void update(void Function(AdminCloseDrawerSessionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCloseDrawerSessionDto build() => _build();

  _$AdminCloseDrawerSessionDto _build() {
    _$AdminCloseDrawerSessionDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCloseDrawerSessionDto._(counted: counted.build(), note: note);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counted';
        counted.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCloseDrawerSessionDto',
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
