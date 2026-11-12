// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bulk_hand_in_grace_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBulkHandInGraceAnswerDtoOutput
    extends AdminBulkHandInGraceAnswerDtoOutput {
  @override
  final AdminBulkHandInGraceAnswerDtoOutputGrace grace;
  @override
  final BuiltList<String> captainIds;

  factory _$AdminBulkHandInGraceAnswerDtoOutput([
    void Function(AdminBulkHandInGraceAnswerDtoOutputBuilder)? updates,
  ]) =>
      (AdminBulkHandInGraceAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminBulkHandInGraceAnswerDtoOutput._({
    required this.grace,
    required this.captainIds,
  }) : super._();
  @override
  AdminBulkHandInGraceAnswerDtoOutput rebuild(
    void Function(AdminBulkHandInGraceAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBulkHandInGraceAnswerDtoOutputBuilder toBuilder() =>
      AdminBulkHandInGraceAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBulkHandInGraceAnswerDtoOutput &&
        grace == other.grace &&
        captainIds == other.captainIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, grace.hashCode);
    _$hash = $jc(_$hash, captainIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBulkHandInGraceAnswerDtoOutput')
          ..add('grace', grace)
          ..add('captainIds', captainIds))
        .toString();
  }
}

class AdminBulkHandInGraceAnswerDtoOutputBuilder
    implements
        Builder<
          AdminBulkHandInGraceAnswerDtoOutput,
          AdminBulkHandInGraceAnswerDtoOutputBuilder
        > {
  _$AdminBulkHandInGraceAnswerDtoOutput? _$v;

  AdminBulkHandInGraceAnswerDtoOutputGraceBuilder? _grace;
  AdminBulkHandInGraceAnswerDtoOutputGraceBuilder get grace =>
      _$this._grace ??= AdminBulkHandInGraceAnswerDtoOutputGraceBuilder();
  set grace(AdminBulkHandInGraceAnswerDtoOutputGraceBuilder? grace) =>
      _$this._grace = grace;

  ListBuilder<String>? _captainIds;
  ListBuilder<String> get captainIds =>
      _$this._captainIds ??= ListBuilder<String>();
  set captainIds(ListBuilder<String>? captainIds) =>
      _$this._captainIds = captainIds;

  AdminBulkHandInGraceAnswerDtoOutputBuilder() {
    AdminBulkHandInGraceAnswerDtoOutput._defaults(this);
  }

  AdminBulkHandInGraceAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _grace = $v.grace.toBuilder();
      _captainIds = $v.captainIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBulkHandInGraceAnswerDtoOutput other) {
    _$v = other as _$AdminBulkHandInGraceAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminBulkHandInGraceAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBulkHandInGraceAnswerDtoOutput build() => _build();

  _$AdminBulkHandInGraceAnswerDtoOutput _build() {
    _$AdminBulkHandInGraceAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminBulkHandInGraceAnswerDtoOutput._(
            grace: grace.build(),
            captainIds: captainIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'grace';
        grace.build();
        _$failedField = 'captainIds';
        captainIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminBulkHandInGraceAnswerDtoOutput',
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
