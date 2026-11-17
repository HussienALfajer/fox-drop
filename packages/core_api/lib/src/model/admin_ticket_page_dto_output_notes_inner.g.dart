// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_notes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputNotesInner
    extends AdminTicketPageDtoOutputNotesInner {
  @override
  final String id;
  @override
  final String? authorName;
  @override
  final String body;
  @override
  final DateTime createdAt;

  factory _$AdminTicketPageDtoOutputNotesInner([
    void Function(AdminTicketPageDtoOutputNotesInnerBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputNotesInnerBuilder()..update(updates))._build();

  _$AdminTicketPageDtoOutputNotesInner._({
    required this.id,
    this.authorName,
    required this.body,
    required this.createdAt,
  }) : super._();
  @override
  AdminTicketPageDtoOutputNotesInner rebuild(
    void Function(AdminTicketPageDtoOutputNotesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputNotesInnerBuilder toBuilder() =>
      AdminTicketPageDtoOutputNotesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputNotesInner &&
        id == other.id &&
        authorName == other.authorName &&
        body == other.body &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketPageDtoOutputNotesInner')
          ..add('id', id)
          ..add('authorName', authorName)
          ..add('body', body)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminTicketPageDtoOutputNotesInnerBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputNotesInner,
          AdminTicketPageDtoOutputNotesInnerBuilder
        > {
  _$AdminTicketPageDtoOutputNotesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminTicketPageDtoOutputNotesInnerBuilder() {
    AdminTicketPageDtoOutputNotesInner._defaults(this);
  }

  AdminTicketPageDtoOutputNotesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _authorName = $v.authorName;
      _body = $v.body;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputNotesInner other) {
    _$v = other as _$AdminTicketPageDtoOutputNotesInner;
  }

  @override
  void update(
    void Function(AdminTicketPageDtoOutputNotesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputNotesInner build() => _build();

  _$AdminTicketPageDtoOutputNotesInner _build() {
    final _$result =
        _$v ??
        _$AdminTicketPageDtoOutputNotesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminTicketPageDtoOutputNotesInner',
            'id',
          ),
          authorName: authorName,
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminTicketPageDtoOutputNotesInner',
            'body',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AdminTicketPageDtoOutputNotesInner',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
