// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reason_lists_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReasonListsDtoOutput extends AdminReasonListsDtoOutput {
  @override
  final BuiltList<AdminReasonListsDtoOutputListsInner> lists;

  factory _$AdminReasonListsDtoOutput([
    void Function(AdminReasonListsDtoOutputBuilder)? updates,
  ]) => (AdminReasonListsDtoOutputBuilder()..update(updates))._build();

  _$AdminReasonListsDtoOutput._({required this.lists}) : super._();
  @override
  AdminReasonListsDtoOutput rebuild(
    void Function(AdminReasonListsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReasonListsDtoOutputBuilder toBuilder() =>
      AdminReasonListsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReasonListsDtoOutput && lists == other.lists;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lists.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminReasonListsDtoOutput',
    )..add('lists', lists)).toString();
  }
}

class AdminReasonListsDtoOutputBuilder
    implements
        Builder<AdminReasonListsDtoOutput, AdminReasonListsDtoOutputBuilder> {
  _$AdminReasonListsDtoOutput? _$v;

  ListBuilder<AdminReasonListsDtoOutputListsInner>? _lists;
  ListBuilder<AdminReasonListsDtoOutputListsInner> get lists =>
      _$this._lists ??= ListBuilder<AdminReasonListsDtoOutputListsInner>();
  set lists(ListBuilder<AdminReasonListsDtoOutputListsInner>? lists) =>
      _$this._lists = lists;

  AdminReasonListsDtoOutputBuilder() {
    AdminReasonListsDtoOutput._defaults(this);
  }

  AdminReasonListsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lists = $v.lists.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReasonListsDtoOutput other) {
    _$v = other as _$AdminReasonListsDtoOutput;
  }

  @override
  void update(void Function(AdminReasonListsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReasonListsDtoOutput build() => _build();

  _$AdminReasonListsDtoOutput _build() {
    _$AdminReasonListsDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminReasonListsDtoOutput._(lists: lists.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lists';
        lists.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminReasonListsDtoOutput',
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
