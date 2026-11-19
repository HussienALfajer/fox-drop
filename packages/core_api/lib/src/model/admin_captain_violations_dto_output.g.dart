// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_violations_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainViolationsDtoOutput
    extends AdminCaptainViolationsDtoOutput {
  @override
  final BuiltList<AdminCaptainViolationsDtoOutputViolationsInner> violations;
  @override
  final AdminCaptainViolationsDtoOutputSuggestion suggestion;
  @override
  final AdminCaptainViolationsDtoOutputTypes types;
  @override
  final BuiltList<AdminCaptainViolationsDtoOutputSuspensionsInner> suspensions;

  factory _$AdminCaptainViolationsDtoOutput([
    void Function(AdminCaptainViolationsDtoOutputBuilder)? updates,
  ]) => (AdminCaptainViolationsDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainViolationsDtoOutput._({
    required this.violations,
    required this.suggestion,
    required this.types,
    required this.suspensions,
  }) : super._();
  @override
  AdminCaptainViolationsDtoOutput rebuild(
    void Function(AdminCaptainViolationsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainViolationsDtoOutputBuilder toBuilder() =>
      AdminCaptainViolationsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainViolationsDtoOutput &&
        violations == other.violations &&
        suggestion == other.suggestion &&
        types == other.types &&
        suspensions == other.suspensions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, violations.hashCode);
    _$hash = $jc(_$hash, suggestion.hashCode);
    _$hash = $jc(_$hash, types.hashCode);
    _$hash = $jc(_$hash, suspensions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainViolationsDtoOutput')
          ..add('violations', violations)
          ..add('suggestion', suggestion)
          ..add('types', types)
          ..add('suspensions', suspensions))
        .toString();
  }
}

class AdminCaptainViolationsDtoOutputBuilder
    implements
        Builder<
          AdminCaptainViolationsDtoOutput,
          AdminCaptainViolationsDtoOutputBuilder
        > {
  _$AdminCaptainViolationsDtoOutput? _$v;

  ListBuilder<AdminCaptainViolationsDtoOutputViolationsInner>? _violations;
  ListBuilder<AdminCaptainViolationsDtoOutputViolationsInner> get violations =>
      _$this._violations ??=
          ListBuilder<AdminCaptainViolationsDtoOutputViolationsInner>();
  set violations(
    ListBuilder<AdminCaptainViolationsDtoOutputViolationsInner>? violations,
  ) => _$this._violations = violations;

  AdminCaptainViolationsDtoOutputSuggestionBuilder? _suggestion;
  AdminCaptainViolationsDtoOutputSuggestionBuilder get suggestion =>
      _$this._suggestion ??= AdminCaptainViolationsDtoOutputSuggestionBuilder();
  set suggestion(
    AdminCaptainViolationsDtoOutputSuggestionBuilder? suggestion,
  ) => _$this._suggestion = suggestion;

  AdminCaptainViolationsDtoOutputTypesBuilder? _types;
  AdminCaptainViolationsDtoOutputTypesBuilder get types =>
      _$this._types ??= AdminCaptainViolationsDtoOutputTypesBuilder();
  set types(AdminCaptainViolationsDtoOutputTypesBuilder? types) =>
      _$this._types = types;

  ListBuilder<AdminCaptainViolationsDtoOutputSuspensionsInner>? _suspensions;
  ListBuilder<AdminCaptainViolationsDtoOutputSuspensionsInner>
  get suspensions => _$this._suspensions ??=
      ListBuilder<AdminCaptainViolationsDtoOutputSuspensionsInner>();
  set suspensions(
    ListBuilder<AdminCaptainViolationsDtoOutputSuspensionsInner>? suspensions,
  ) => _$this._suspensions = suspensions;

  AdminCaptainViolationsDtoOutputBuilder() {
    AdminCaptainViolationsDtoOutput._defaults(this);
  }

  AdminCaptainViolationsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _violations = $v.violations.toBuilder();
      _suggestion = $v.suggestion.toBuilder();
      _types = $v.types.toBuilder();
      _suspensions = $v.suspensions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainViolationsDtoOutput other) {
    _$v = other as _$AdminCaptainViolationsDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainViolationsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainViolationsDtoOutput build() => _build();

  _$AdminCaptainViolationsDtoOutput _build() {
    _$AdminCaptainViolationsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainViolationsDtoOutput._(
            violations: violations.build(),
            suggestion: suggestion.build(),
            types: types.build(),
            suspensions: suspensions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'violations';
        violations.build();
        _$failedField = 'suggestion';
        suggestion.build();
        _$failedField = 'types';
        types.build();
        _$failedField = 'suspensions';
        suspensions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainViolationsDtoOutput',
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
