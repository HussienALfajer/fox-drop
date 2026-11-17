// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_notes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputNotesInner
    extends AdminCustomerDtoOutputNotesInner {
  @override
  final String id;
  @override
  final String body;
  @override
  final String? authorName;
  @override
  final DateTime createdAt;

  factory _$AdminCustomerDtoOutputNotesInner([
    void Function(AdminCustomerDtoOutputNotesInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputNotesInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputNotesInner._({
    required this.id,
    required this.body,
    this.authorName,
    required this.createdAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputNotesInner rebuild(
    void Function(AdminCustomerDtoOutputNotesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputNotesInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputNotesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputNotesInner &&
        id == other.id &&
        body == other.body &&
        authorName == other.authorName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputNotesInner')
          ..add('id', id)
          ..add('body', body)
          ..add('authorName', authorName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminCustomerDtoOutputNotesInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputNotesInner,
          AdminCustomerDtoOutputNotesInnerBuilder
        > {
  _$AdminCustomerDtoOutputNotesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminCustomerDtoOutputNotesInnerBuilder() {
    AdminCustomerDtoOutputNotesInner._defaults(this);
  }

  AdminCustomerDtoOutputNotesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _body = $v.body;
      _authorName = $v.authorName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputNotesInner other) {
    _$v = other as _$AdminCustomerDtoOutputNotesInner;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputNotesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputNotesInner build() => _build();

  _$AdminCustomerDtoOutputNotesInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputNotesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputNotesInner',
            'id',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminCustomerDtoOutputNotesInner',
            'body',
          ),
          authorName: authorName,
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AdminCustomerDtoOutputNotesInner',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
