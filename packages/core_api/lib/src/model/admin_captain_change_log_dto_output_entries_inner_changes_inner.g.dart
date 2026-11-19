// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_change_log_dto_output_entries_inner_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner
    extends AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner {
  @override
  final String field;
  @override
  final String? before;
  @override
  final String? after;

  factory _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner([
    void Function(
      AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner._({
    required this.field,
    this.before,
    this.after,
  }) : super._();
  @override
  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner rebuild(
    void Function(AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder toBuilder() =>
      AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner &&
        field == other.field &&
        before == other.before &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner',
          )
          ..add('field', field)
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder
    implements
        Builder<
          AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner,
          AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder
        > {
  _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  String? _before;
  String? get before => _$this._before;
  set before(String? before) => _$this._before = before;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder() {
    AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner._defaults(this);
  }

  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _field = $v.field;
      _before = $v.before;
      _after = $v.after;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner other) {
    _$v = other as _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner;
  }

  @override
  void update(
    void Function(
      AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner build() => _build();

  _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner._(
          field: BuiltValueNullFieldError.checkNotNull(
            field,
            r'AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner',
            'field',
          ),
          before: before,
          after: after,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
