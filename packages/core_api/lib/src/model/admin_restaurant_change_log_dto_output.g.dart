// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_change_log_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantChangeLogDtoOutput
    extends AdminRestaurantChangeLogDtoOutput {
  @override
  final BuiltList<AdminRestaurantChangeLogDtoOutputEntriesInner> entries;

  factory _$AdminRestaurantChangeLogDtoOutput([
    void Function(AdminRestaurantChangeLogDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantChangeLogDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantChangeLogDtoOutput._({required this.entries}) : super._();
  @override
  AdminRestaurantChangeLogDtoOutput rebuild(
    void Function(AdminRestaurantChangeLogDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantChangeLogDtoOutputBuilder toBuilder() =>
      AdminRestaurantChangeLogDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantChangeLogDtoOutput &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantChangeLogDtoOutput',
    )..add('entries', entries)).toString();
  }
}

class AdminRestaurantChangeLogDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantChangeLogDtoOutput,
          AdminRestaurantChangeLogDtoOutputBuilder
        > {
  _$AdminRestaurantChangeLogDtoOutput? _$v;

  ListBuilder<AdminRestaurantChangeLogDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminRestaurantChangeLogDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminRestaurantChangeLogDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminRestaurantChangeLogDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminRestaurantChangeLogDtoOutputBuilder() {
    AdminRestaurantChangeLogDtoOutput._defaults(this);
  }

  AdminRestaurantChangeLogDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantChangeLogDtoOutput other) {
    _$v = other as _$AdminRestaurantChangeLogDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantChangeLogDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantChangeLogDtoOutput build() => _build();

  _$AdminRestaurantChangeLogDtoOutput _build() {
    _$AdminRestaurantChangeLogDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantChangeLogDtoOutput._(entries: entries.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantChangeLogDtoOutput',
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
