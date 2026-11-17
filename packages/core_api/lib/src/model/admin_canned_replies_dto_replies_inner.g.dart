// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_canned_replies_dto_replies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCannedRepliesDtoRepliesInner
    extends AdminCannedRepliesDtoRepliesInner {
  @override
  final String title;
  @override
  final String body;

  factory _$AdminCannedRepliesDtoRepliesInner([
    void Function(AdminCannedRepliesDtoRepliesInnerBuilder)? updates,
  ]) => (AdminCannedRepliesDtoRepliesInnerBuilder()..update(updates))._build();

  _$AdminCannedRepliesDtoRepliesInner._({
    required this.title,
    required this.body,
  }) : super._();
  @override
  AdminCannedRepliesDtoRepliesInner rebuild(
    void Function(AdminCannedRepliesDtoRepliesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCannedRepliesDtoRepliesInnerBuilder toBuilder() =>
      AdminCannedRepliesDtoRepliesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCannedRepliesDtoRepliesInner &&
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
    return (newBuiltValueToStringHelper(r'AdminCannedRepliesDtoRepliesInner')
          ..add('title', title)
          ..add('body', body))
        .toString();
  }
}

class AdminCannedRepliesDtoRepliesInnerBuilder
    implements
        Builder<
          AdminCannedRepliesDtoRepliesInner,
          AdminCannedRepliesDtoRepliesInnerBuilder
        > {
  _$AdminCannedRepliesDtoRepliesInner? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminCannedRepliesDtoRepliesInnerBuilder() {
    AdminCannedRepliesDtoRepliesInner._defaults(this);
  }

  AdminCannedRepliesDtoRepliesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCannedRepliesDtoRepliesInner other) {
    _$v = other as _$AdminCannedRepliesDtoRepliesInner;
  }

  @override
  void update(
    void Function(AdminCannedRepliesDtoRepliesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCannedRepliesDtoRepliesInner build() => _build();

  _$AdminCannedRepliesDtoRepliesInner _build() {
    final _$result =
        _$v ??
        _$AdminCannedRepliesDtoRepliesInner._(
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'AdminCannedRepliesDtoRepliesInner',
            'title',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminCannedRepliesDtoRepliesInner',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
