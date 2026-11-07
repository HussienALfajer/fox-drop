// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_work_rules_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminWorkRulesDto extends AdminWorkRulesDto {
  @override
  final String workRules;

  factory _$AdminWorkRulesDto([
    void Function(AdminWorkRulesDtoBuilder)? updates,
  ]) => (AdminWorkRulesDtoBuilder()..update(updates))._build();

  _$AdminWorkRulesDto._({required this.workRules}) : super._();
  @override
  AdminWorkRulesDto rebuild(void Function(AdminWorkRulesDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminWorkRulesDtoBuilder toBuilder() =>
      AdminWorkRulesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminWorkRulesDto && workRules == other.workRules;
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
      r'AdminWorkRulesDto',
    )..add('workRules', workRules)).toString();
  }
}

class AdminWorkRulesDtoBuilder
    implements Builder<AdminWorkRulesDto, AdminWorkRulesDtoBuilder> {
  _$AdminWorkRulesDto? _$v;

  String? _workRules;
  String? get workRules => _$this._workRules;
  set workRules(String? workRules) => _$this._workRules = workRules;

  AdminWorkRulesDtoBuilder() {
    AdminWorkRulesDto._defaults(this);
  }

  AdminWorkRulesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _workRules = $v.workRules;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminWorkRulesDto other) {
    _$v = other as _$AdminWorkRulesDto;
  }

  @override
  void update(void Function(AdminWorkRulesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminWorkRulesDto build() => _build();

  _$AdminWorkRulesDto _build() {
    final _$result =
        _$v ??
        _$AdminWorkRulesDto._(
          workRules: BuiltValueNullFieldError.checkNotNull(
            workRules,
            r'AdminWorkRulesDto',
            'workRules',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
