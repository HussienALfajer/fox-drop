// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_texts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTextsDtoOutput extends AdminTextsDtoOutput {
  @override
  final String workRules;
  @override
  final AdminTextsDtoOutputContact contact;

  factory _$AdminTextsDtoOutput([
    void Function(AdminTextsDtoOutputBuilder)? updates,
  ]) => (AdminTextsDtoOutputBuilder()..update(updates))._build();

  _$AdminTextsDtoOutput._({required this.workRules, required this.contact})
    : super._();
  @override
  AdminTextsDtoOutput rebuild(
    void Function(AdminTextsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTextsDtoOutputBuilder toBuilder() =>
      AdminTextsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTextsDtoOutput &&
        workRules == other.workRules &&
        contact == other.contact;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, workRules.hashCode);
    _$hash = $jc(_$hash, contact.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTextsDtoOutput')
          ..add('workRules', workRules)
          ..add('contact', contact))
        .toString();
  }
}

class AdminTextsDtoOutputBuilder
    implements Builder<AdminTextsDtoOutput, AdminTextsDtoOutputBuilder> {
  _$AdminTextsDtoOutput? _$v;

  String? _workRules;
  String? get workRules => _$this._workRules;
  set workRules(String? workRules) => _$this._workRules = workRules;

  AdminTextsDtoOutputContactBuilder? _contact;
  AdminTextsDtoOutputContactBuilder get contact =>
      _$this._contact ??= AdminTextsDtoOutputContactBuilder();
  set contact(AdminTextsDtoOutputContactBuilder? contact) =>
      _$this._contact = contact;

  AdminTextsDtoOutputBuilder() {
    AdminTextsDtoOutput._defaults(this);
  }

  AdminTextsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _workRules = $v.workRules;
      _contact = $v.contact.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTextsDtoOutput other) {
    _$v = other as _$AdminTextsDtoOutput;
  }

  @override
  void update(void Function(AdminTextsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTextsDtoOutput build() => _build();

  _$AdminTextsDtoOutput _build() {
    _$AdminTextsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTextsDtoOutput._(
            workRules: BuiltValueNullFieldError.checkNotNull(
              workRules,
              r'AdminTextsDtoOutput',
              'workRules',
            ),
            contact: contact.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contact';
        contact.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTextsDtoOutput',
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
