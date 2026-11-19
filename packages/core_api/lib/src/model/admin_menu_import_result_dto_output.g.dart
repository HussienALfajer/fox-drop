// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_import_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuImportResultDtoOutput extends AdminMenuImportResultDtoOutput {
  @override
  final int added;
  @override
  final int changed;
  @override
  final int unchanged;
  @override
  final int categoriesAdded;

  factory _$AdminMenuImportResultDtoOutput([
    void Function(AdminMenuImportResultDtoOutputBuilder)? updates,
  ]) => (AdminMenuImportResultDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuImportResultDtoOutput._({
    required this.added,
    required this.changed,
    required this.unchanged,
    required this.categoriesAdded,
  }) : super._();
  @override
  AdminMenuImportResultDtoOutput rebuild(
    void Function(AdminMenuImportResultDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuImportResultDtoOutputBuilder toBuilder() =>
      AdminMenuImportResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuImportResultDtoOutput &&
        added == other.added &&
        changed == other.changed &&
        unchanged == other.unchanged &&
        categoriesAdded == other.categoriesAdded;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, added.hashCode);
    _$hash = $jc(_$hash, changed.hashCode);
    _$hash = $jc(_$hash, unchanged.hashCode);
    _$hash = $jc(_$hash, categoriesAdded.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuImportResultDtoOutput')
          ..add('added', added)
          ..add('changed', changed)
          ..add('unchanged', unchanged)
          ..add('categoriesAdded', categoriesAdded))
        .toString();
  }
}

class AdminMenuImportResultDtoOutputBuilder
    implements
        Builder<
          AdminMenuImportResultDtoOutput,
          AdminMenuImportResultDtoOutputBuilder
        > {
  _$AdminMenuImportResultDtoOutput? _$v;

  int? _added;
  int? get added => _$this._added;
  set added(int? added) => _$this._added = added;

  int? _changed;
  int? get changed => _$this._changed;
  set changed(int? changed) => _$this._changed = changed;

  int? _unchanged;
  int? get unchanged => _$this._unchanged;
  set unchanged(int? unchanged) => _$this._unchanged = unchanged;

  int? _categoriesAdded;
  int? get categoriesAdded => _$this._categoriesAdded;
  set categoriesAdded(int? categoriesAdded) =>
      _$this._categoriesAdded = categoriesAdded;

  AdminMenuImportResultDtoOutputBuilder() {
    AdminMenuImportResultDtoOutput._defaults(this);
  }

  AdminMenuImportResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _added = $v.added;
      _changed = $v.changed;
      _unchanged = $v.unchanged;
      _categoriesAdded = $v.categoriesAdded;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuImportResultDtoOutput other) {
    _$v = other as _$AdminMenuImportResultDtoOutput;
  }

  @override
  void update(void Function(AdminMenuImportResultDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuImportResultDtoOutput build() => _build();

  _$AdminMenuImportResultDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminMenuImportResultDtoOutput._(
          added: BuiltValueNullFieldError.checkNotNull(
            added,
            r'AdminMenuImportResultDtoOutput',
            'added',
          ),
          changed: BuiltValueNullFieldError.checkNotNull(
            changed,
            r'AdminMenuImportResultDtoOutput',
            'changed',
          ),
          unchanged: BuiltValueNullFieldError.checkNotNull(
            unchanged,
            r'AdminMenuImportResultDtoOutput',
            'unchanged',
          ),
          categoriesAdded: BuiltValueNullFieldError.checkNotNull(
            categoriesAdded,
            r'AdminMenuImportResultDtoOutput',
            'categoriesAdded',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
