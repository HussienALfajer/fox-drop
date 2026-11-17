// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_canned_replies_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCannedRepliesDtoOutput extends AdminCannedRepliesDtoOutput {
  @override
  final BuiltList<AdminCannedRepliesDtoOutputRepliesInner> replies;

  factory _$AdminCannedRepliesDtoOutput([
    void Function(AdminCannedRepliesDtoOutputBuilder)? updates,
  ]) => (AdminCannedRepliesDtoOutputBuilder()..update(updates))._build();

  _$AdminCannedRepliesDtoOutput._({required this.replies}) : super._();
  @override
  AdminCannedRepliesDtoOutput rebuild(
    void Function(AdminCannedRepliesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCannedRepliesDtoOutputBuilder toBuilder() =>
      AdminCannedRepliesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCannedRepliesDtoOutput && replies == other.replies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, replies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCannedRepliesDtoOutput',
    )..add('replies', replies)).toString();
  }
}

class AdminCannedRepliesDtoOutputBuilder
    implements
        Builder<
          AdminCannedRepliesDtoOutput,
          AdminCannedRepliesDtoOutputBuilder
        > {
  _$AdminCannedRepliesDtoOutput? _$v;

  ListBuilder<AdminCannedRepliesDtoOutputRepliesInner>? _replies;
  ListBuilder<AdminCannedRepliesDtoOutputRepliesInner> get replies =>
      _$this._replies ??=
          ListBuilder<AdminCannedRepliesDtoOutputRepliesInner>();
  set replies(ListBuilder<AdminCannedRepliesDtoOutputRepliesInner>? replies) =>
      _$this._replies = replies;

  AdminCannedRepliesDtoOutputBuilder() {
    AdminCannedRepliesDtoOutput._defaults(this);
  }

  AdminCannedRepliesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _replies = $v.replies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCannedRepliesDtoOutput other) {
    _$v = other as _$AdminCannedRepliesDtoOutput;
  }

  @override
  void update(void Function(AdminCannedRepliesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCannedRepliesDtoOutput build() => _build();

  _$AdminCannedRepliesDtoOutput _build() {
    _$AdminCannedRepliesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCannedRepliesDtoOutput._(replies: replies.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'replies';
        replies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCannedRepliesDtoOutput',
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
