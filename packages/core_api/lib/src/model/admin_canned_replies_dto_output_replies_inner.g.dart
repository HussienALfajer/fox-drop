// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_canned_replies_dto_output_replies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCannedRepliesDtoOutputRepliesInner
    extends AdminCannedRepliesDtoOutputRepliesInner {
  @override
  final String title;
  @override
  final String body;

  factory _$AdminCannedRepliesDtoOutputRepliesInner([
    void Function(AdminCannedRepliesDtoOutputRepliesInnerBuilder)? updates,
  ]) => (AdminCannedRepliesDtoOutputRepliesInnerBuilder()..update(updates))
      ._build();

  _$AdminCannedRepliesDtoOutputRepliesInner._({
    required this.title,
    required this.body,
  }) : super._();
  @override
  AdminCannedRepliesDtoOutputRepliesInner rebuild(
    void Function(AdminCannedRepliesDtoOutputRepliesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCannedRepliesDtoOutputRepliesInnerBuilder toBuilder() =>
      AdminCannedRepliesDtoOutputRepliesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCannedRepliesDtoOutputRepliesInner &&
        title == other.title &&
        body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCannedRepliesDtoOutputRepliesInner',
          )
          ..add('title', title)
          ..add('body', body))
        .toString();
  }
}

class AdminCannedRepliesDtoOutputRepliesInnerBuilder
    implements
        Builder<
          AdminCannedRepliesDtoOutputRepliesInner,
          AdminCannedRepliesDtoOutputRepliesInnerBuilder
        > {
  _$AdminCannedRepliesDtoOutputRepliesInner? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminCannedRepliesDtoOutputRepliesInnerBuilder() {
    AdminCannedRepliesDtoOutputRepliesInner._defaults(this);
  }

  AdminCannedRepliesDtoOutputRepliesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCannedRepliesDtoOutputRepliesInner other) {
    _$v = other as _$AdminCannedRepliesDtoOutputRepliesInner;
  }

  @override
  void update(
    void Function(AdminCannedRepliesDtoOutputRepliesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCannedRepliesDtoOutputRepliesInner build() => _build();

  _$AdminCannedRepliesDtoOutputRepliesInner _build() {
    final _$result =
        _$v ??
        _$AdminCannedRepliesDtoOutputRepliesInner._(
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'AdminCannedRepliesDtoOutputRepliesInner',
            'title',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminCannedRepliesDtoOutputRepliesInner',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
