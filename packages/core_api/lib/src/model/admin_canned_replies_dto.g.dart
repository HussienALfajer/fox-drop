// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_canned_replies_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCannedRepliesDto extends AdminCannedRepliesDto {
  @override
  final BuiltList<AdminCannedRepliesDtoRepliesInner> replies;

  factory _$AdminCannedRepliesDto([
    void Function(AdminCannedRepliesDtoBuilder)? updates,
  ]) => (AdminCannedRepliesDtoBuilder()..update(updates))._build();

  _$AdminCannedRepliesDto._({required this.replies}) : super._();
  @override
  AdminCannedRepliesDto rebuild(
    void Function(AdminCannedRepliesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCannedRepliesDtoBuilder toBuilder() =>
      AdminCannedRepliesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCannedRepliesDto && replies == other.replies;
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
      r'AdminCannedRepliesDto',
    )..add('replies', replies)).toString();
  }
}

class AdminCannedRepliesDtoBuilder
    implements Builder<AdminCannedRepliesDto, AdminCannedRepliesDtoBuilder> {
  _$AdminCannedRepliesDto? _$v;

  ListBuilder<AdminCannedRepliesDtoRepliesInner>? _replies;
  ListBuilder<AdminCannedRepliesDtoRepliesInner> get replies =>
      _$this._replies ??= ListBuilder<AdminCannedRepliesDtoRepliesInner>();
  set replies(ListBuilder<AdminCannedRepliesDtoRepliesInner>? replies) =>
      _$this._replies = replies;

  AdminCannedRepliesDtoBuilder() {
    AdminCannedRepliesDto._defaults(this);
  }

  AdminCannedRepliesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _replies = $v.replies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCannedRepliesDto other) {
    _$v = other as _$AdminCannedRepliesDto;
  }

  @override
  void update(void Function(AdminCannedRepliesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCannedRepliesDto build() => _build();

  _$AdminCannedRepliesDto _build() {
    _$AdminCannedRepliesDto _$result;
    try {
      _$result = _$v ?? _$AdminCannedRepliesDto._(replies: replies.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'replies';
        replies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCannedRepliesDto',
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
