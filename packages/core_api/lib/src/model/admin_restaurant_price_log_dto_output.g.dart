// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_price_log_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantPriceLogDtoOutput
    extends AdminRestaurantPriceLogDtoOutput {
  @override
  final BuiltList<AdminRestaurantPriceLogDtoOutputEntriesInner> entries;

  factory _$AdminRestaurantPriceLogDtoOutput([
    void Function(AdminRestaurantPriceLogDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantPriceLogDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantPriceLogDtoOutput._({required this.entries}) : super._();
  @override
  AdminRestaurantPriceLogDtoOutput rebuild(
    void Function(AdminRestaurantPriceLogDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantPriceLogDtoOutputBuilder toBuilder() =>
      AdminRestaurantPriceLogDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantPriceLogDtoOutput &&
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
      r'AdminRestaurantPriceLogDtoOutput',
    )..add('entries', entries)).toString();
  }
}

class AdminRestaurantPriceLogDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantPriceLogDtoOutput,
          AdminRestaurantPriceLogDtoOutputBuilder
        > {
  _$AdminRestaurantPriceLogDtoOutput? _$v;

  ListBuilder<AdminRestaurantPriceLogDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminRestaurantPriceLogDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminRestaurantPriceLogDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminRestaurantPriceLogDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminRestaurantPriceLogDtoOutputBuilder() {
    AdminRestaurantPriceLogDtoOutput._defaults(this);
  }

  AdminRestaurantPriceLogDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantPriceLogDtoOutput other) {
    _$v = other as _$AdminRestaurantPriceLogDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantPriceLogDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantPriceLogDtoOutput build() => _build();

  _$AdminRestaurantPriceLogDtoOutput _build() {
    _$AdminRestaurantPriceLogDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminRestaurantPriceLogDtoOutput._(entries: entries.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantPriceLogDtoOutput',
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
