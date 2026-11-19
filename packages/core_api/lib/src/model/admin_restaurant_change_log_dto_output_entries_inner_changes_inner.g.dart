// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_change_log_dto_output_entries_inner_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner
    extends AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner {
  @override
  final String field;
  @override
  final String? before;
  @override
  final String? after;

  factory _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner([
    void Function(
      AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner._({
    required this.field,
    this.before,
    this.after,
  }) : super._();
  @override
  AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner rebuild(
    void Function(
      AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder
  toBuilder() =>
      AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner &&
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
            r'AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner',
          )
          ..add('field', field)
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder
    implements
        Builder<
          AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner,
          AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder
        > {
  _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  String? _before;
  String? get before => _$this._before;
  set before(String? before) => _$this._before = before;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder() {
    AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner._defaults(this);
  }

  AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder get _$this {
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
  void replace(
    AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner other,
  ) {
    _$v = other as _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner;
  }

  @override
  void update(
    void Function(
      AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner build() => _build();

  _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner._(
          field: BuiltValueNullFieldError.checkNotNull(
            field,
            r'AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner',
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
