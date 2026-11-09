// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_work_rules_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminWorkRulesDtoOutput extends AdminWorkRulesDtoOutput {
  @override
  final String workRules;

  factory _$AdminWorkRulesDtoOutput([
    void Function(AdminWorkRulesDtoOutputBuilder)? updates,
  ]) => (AdminWorkRulesDtoOutputBuilder()..update(updates))._build();

  _$AdminWorkRulesDtoOutput._({required this.workRules}) : super._();
  @override
  AdminWorkRulesDtoOutput rebuild(
    void Function(AdminWorkRulesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminWorkRulesDtoOutputBuilder toBuilder() =>
      AdminWorkRulesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminWorkRulesDtoOutput && workRules == other.workRules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, workRules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminWorkRulesDtoOutput',
    )..add('workRules', workRules)).toString();
  }
}

class AdminWorkRulesDtoOutputBuilder
    implements
        Builder<AdminWorkRulesDtoOutput, AdminWorkRulesDtoOutputBuilder> {
  _$AdminWorkRulesDtoOutput? _$v;

  String? _workRules;
  String? get workRules => _$this._workRules;
  set workRules(String? workRules) => _$this._workRules = workRules;

  AdminWorkRulesDtoOutputBuilder() {
    AdminWorkRulesDtoOutput._defaults(this);
  }

  AdminWorkRulesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _workRules = $v.workRules;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminWorkRulesDtoOutput other) {
    _$v = other as _$AdminWorkRulesDtoOutput;
  }

  @override
  void update(void Function(AdminWorkRulesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminWorkRulesDtoOutput build() => _build();

  _$AdminWorkRulesDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminWorkRulesDtoOutput._(
          workRules: BuiltValueNullFieldError.checkNotNull(
            workRules,
            r'AdminWorkRulesDtoOutput',
            'workRules',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
